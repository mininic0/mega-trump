import SpriteKit
import UIKit

class TrumpNode: SKSpriteNode {
    
    // MARK: - Properties
    
    var currentState: TrumpState = .idle {
        didSet {
            if oldValue != currentState {
                handleStateChange()
            }
        }
    }
    
    var flapForce: CGFloat = 350.0
    
    private var idleTextures: [SKTexture] = []
    private var flapTextures: [SKTexture] = []
    private var deadTexture: SKTexture?
    private var celebrateTexture: SKTexture?
    
    private let characterRadius: CGFloat = 40.0
    private var idleAnimation: SKAction?
    private var isAnimating = false
    
    // MARK: - Initialization
    
    init() {
        super.init(texture: nil, color: .clear, size: CGSize(width: characterRadius * 2, height: characterRadius * 2))
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup
    
    func setup() {
        loadTextures()
        setupVisual()
        setupPhysics()
        startIdleAnimation()
    }
    
    private func loadTextures() {
        // Try to load actual textures, fall back to placeholder if not available
        if let idle1 = SKTexture(imageNamed: "trump_idle_1") as SKTexture?,
           let idle2 = SKTexture(imageNamed: "trump_idle_2") as SKTexture? {
            idleTextures = [idle1, idle2]
        }
        
        if let flap1 = SKTexture(imageNamed: "trump_flap_1") as SKTexture?,
           let flap2 = SKTexture(imageNamed: "trump_flap_2") as SKTexture? {
            flapTextures = [flap1, flap2]
        }
        
        deadTexture = SKTexture(imageNamed: "trump_dead")
        celebrateTexture = SKTexture(imageNamed: "trump_celebrate")
        
        // If no textures loaded, create placeholder
        if idleTextures.isEmpty {
            createPlaceholderVisual()
        } else {
            texture = idleTextures[0]
        }
    }
    
    private func setupVisual() {
        name = "trump"
        zPosition = 10
        
        // Set initial texture if available
        if !idleTextures.isEmpty {
            texture = idleTextures[0]
        }
    }
    
    private func createPlaceholderVisual() {
        // Create a circular placeholder with orange color (Trump's signature color)
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: characterRadius * 2, height: characterRadius * 2))
        let image = renderer.image { context in
            // Draw orange circle for head
            UIColor.orange.setFill()
            let headRect = CGRect(x: 0, y: 0, width: characterRadius * 2, height: characterRadius * 2)
            context.cgContext.fillEllipse(in: headRect)
            
            // Draw yellow "hair" swoop on top
            UIColor.yellow.setFill()
            let hairPath = UIBezierPath()
            hairPath.move(to: CGPoint(x: characterRadius * 0.5, y: characterRadius * 0.3))
            hairPath.addQuadCurve(to: CGPoint(x: characterRadius * 1.8, y: characterRadius * 0.2),
                                 controlPoint: CGPoint(x: characterRadius * 1.5, y: -characterRadius * 0.3))
            hairPath.addLine(to: CGPoint(x: characterRadius * 1.5, y: characterRadius * 0.5))
            hairPath.close()
            hairPath.fill()
            
            // Draw simple face features
            UIColor.white.setFill()
            // Eyes
            let leftEye = CGRect(x: characterRadius * 0.6, y: characterRadius * 1.1, width: 8, height: 8)
            let rightEye = CGRect(x: characterRadius * 1.3, y: characterRadius * 1.1, width: 8, height: 8)
            context.cgContext.fillEllipse(in: leftEye)
            context.cgContext.fillEllipse(in: rightEye)
            
            // Pupils
            UIColor.black.setFill()
            let leftPupil = CGRect(x: characterRadius * 0.65, y: characterRadius * 1.15, width: 4, height: 4)
            let rightPupil = CGRect(x: characterRadius * 1.35, y: characterRadius * 1.15, width: 4, height: 4)
            context.cgContext.fillEllipse(in: leftPupil)
            context.cgContext.fillEllipse(in: rightPupil)
        }
        
        texture = SKTexture(image: image)
    }
    
    private func setupPhysics() {
        // Create circular physics body with 85% of visual size for forgiving hitbox
        let physicsRadius = characterRadius * 0.85
        physicsBody = SKPhysicsBody(circleOfRadius: physicsRadius)
        
        guard let physicsBody = physicsBody else { return }
        
        // Configure physics properties
        physicsBody.categoryBitMask = PhysicsCategory.trump
        physicsBody.contactTestBitMask = PhysicsCategory.obstacle | PhysicsCategory.ground | PhysicsCategory.ceiling | PhysicsCategory.score
        physicsBody.collisionBitMask = PhysicsCategory.ground | PhysicsCategory.ceiling
        
        physicsBody.isDynamic = true
        physicsBody.allowsRotation = true
        physicsBody.restitution = 0
        physicsBody.friction = 0
        physicsBody.linearDamping = 0.5
        physicsBody.mass = 1.0
    }
    
    // MARK: - Physics Categories
    
    private struct PhysicsCategory {
        static let trump: UInt32 = 0x1 << 0
        static let obstacle: UInt32 = 0x1 << 1
        static let ground: UInt32 = 0x1 << 2
        static let ceiling: UInt32 = 0x1 << 3
        static let score: UInt32 = 0x1 << 4
    }
    
    // MARK: - State Management
    
    private func handleStateChange() {
        removeAllActions()
        
        switch currentState {
        case .idle:
            startIdleAnimation()
        case .flapping:
            break // Flap animation is handled in flap() method
        case .dead:
            playDeathAnimation()
        case .celebrating:
            playCelebrateAnimation()
        }
    }
    
    // MARK: - Actions
    
    func flap() {
        guard currentState != .dead else { return }
        
        // Reset vertical velocity and apply upward impulse
        physicsBody?.velocity.dy = 0
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: flapForce))
        
        // Rotate sprite upward for visual feedback
        let rotateUp = SKAction.rotate(toAngle: -0.3, duration: 0.1)
        run(rotateUp)
        
        // Play flap animation
        playFlapAnimation()
        
        // Trigger haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        currentState = .flapping
    }
    
    func die() {
        guard currentState != .dead else { return }
        currentState = .dead
    }
    
    func celebrate() {
        guard currentState != .dead else { return }
        currentState = .celebrating
    }
    
    func reset() {
        removeAllActions()
        physicsBody?.velocity = CGVector.zero
        physicsBody?.angularVelocity = 0
        zRotation = 0
        alpha = 1.0
        
        if !idleTextures.isEmpty {
            texture = idleTextures[0]
        }
        
        currentState = .idle
        startIdleAnimation()
    }
    
    // MARK: - Animations
    
    private func startIdleAnimation() {
        guard !isAnimating else { return }
        isAnimating = true
        
        // Gentle bobbing motion
        let moveUp = SKAction.moveBy(x: 0, y: 8, duration: 0.5)
        moveUp.timingMode = .easeInEaseOut
        let moveDown = SKAction.moveBy(x: 0, y: -8, duration: 0.5)
        moveDown.timingMode = .easeInEaseOut
        let bobSequence = SKAction.sequence([moveUp, moveDown])
        let bobForever = SKAction.repeatForever(bobSequence)
        
        run(bobForever, withKey: "idleBob")
        
        // Texture animation if available
        if idleTextures.count > 1 {
            let textureAnimation = SKAction.animate(with: idleTextures, timePerFrame: 0.5)
            let textureForever = SKAction.repeatForever(textureAnimation)
            run(textureForever, withKey: "idleTexture")
        }
    }
    
    private func playFlapAnimation() {
        removeAction(forKey: "flapAnimation")
        
        if !flapTextures.isEmpty {
            // Quick texture swap for surprised expression
            let flapAction = SKAction.animate(with: flapTextures, timePerFrame: 0.075)
            let returnToIdle = SKAction.run { [weak self] in
                guard let self = self else { return }
                if !self.idleTextures.isEmpty {
                    self.texture = self.idleTextures[0]
                }
                self.currentState = .idle
            }
            let sequence = SKAction.sequence([flapAction, returnToIdle])
            run(sequence, withKey: "flapAnimation")
        } else {
            // Placeholder animation - hair wiggle
            let wiggleLeft = SKAction.rotate(byAngle: 0.1, duration: 0.075)
            let wiggleRight = SKAction.rotate(byAngle: -0.2, duration: 0.075)
            let wiggleBack = SKAction.rotate(byAngle: 0.1, duration: 0.075)
            let wiggleSequence = SKAction.sequence([wiggleLeft, wiggleRight, wiggleBack])
            let returnToIdle = SKAction.run { [weak self] in
                self?.currentState = .idle
            }
            let sequence = SKAction.sequence([wiggleSequence, returnToIdle])
            run(sequence, withKey: "flapAnimation")
        }
    }
    
    private func playDeathAnimation() {
        isAnimating = false
        removeAction(forKey: "idleBob")
        removeAction(forKey: "idleTexture")
        
        // Change to dead texture if available
        if let deadTexture = deadTexture {
            texture = deadTexture
        }
        
        // Tumble and fall
        let tumble = SKAction.rotate(byAngle: .pi * 2, duration: 0.4)
        let fadeOut = SKAction.fadeAlpha(to: 0.7, duration: 0.4)
        let group = SKAction.group([tumble, fadeOut])
        
        run(group)
        
        // Disable physics interaction
        physicsBody?.collisionBitMask = 0
    }
    
    private func playCelebrateAnimation() {
        removeAction(forKey: "idleBob")
        removeAction(forKey: "idleTexture")
        
        // Change to celebrate texture if available
        if let celebrateTexture = celebrateTexture {
            texture = celebrateTexture
        }
        
        // Big grin animation with bounce
        let scaleUp = SKAction.scale(to: 1.2, duration: 0.25)
        scaleUp.timingMode = .easeOut
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.25)
        scaleDown.timingMode = .easeIn
        let bounce = SKAction.sequence([scaleUp, scaleDown])
        
        run(bounce) { [weak self] in
            self?.currentState = .idle
        }
        
        // Optional: Add sparkle particle effect
        addSparkleEffect()
    }
    
    private func addSparkleEffect() {
        let sparkle = SKEmitterNode()
        sparkle.particleTexture = SKTexture(imageNamed: "spark")
        sparkle.particleBirthRate = 50
        sparkle.numParticlesToEmit = 20
        sparkle.particleLifetime = 0.5
        sparkle.particleScale = 0.1
        sparkle.particleScaleRange = 0.05
        sparkle.particleAlpha = 1.0
        sparkle.particleAlphaSpeed = -2.0
        sparkle.particleColor = .yellow
        sparkle.particleColorBlendFactor = 1.0
        sparkle.particleBlendMode = .add
        sparkle.position = CGPoint.zero
        
        addChild(sparkle)
        
        let wait = SKAction.wait(forDuration: 0.5)
        let remove = SKAction.removeFromParent()
        sparkle.run(SKAction.sequence([wait, remove]))
    }
    
    // MARK: - Update
    
    func updateRotation() {
        guard currentState != .dead, let velocity = physicsBody?.velocity.dy else { return }
        
        // Rotate based on vertical velocity
        // Clamp rotation between -30° and +30°
        let maxRotation: CGFloat = .pi / 6  // 30 degrees
        let minRotation: CGFloat = -.pi / 6  // -30 degrees
        
        // Map velocity to rotation (-500 to 500 velocity -> -30° to 30°)
        let velocityRange: CGFloat = 500
        let normalizedVelocity = max(-velocityRange, min(velocityRange, velocity))
        let targetRotation = (normalizedVelocity / velocityRange) * maxRotation
        
        // Clamp to min/max
        let clampedRotation = max(minRotation, min(maxRotation, -targetRotation))
        
        // Smooth rotation
        let rotateAction = SKAction.rotate(toAngle: clampedRotation, duration: 0.1)
        rotateAction.timingMode = .easeOut
        run(rotateAction, withKey: "velocityRotation")
    }
}
