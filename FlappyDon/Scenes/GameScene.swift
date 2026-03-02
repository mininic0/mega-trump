import SpriteKit
import UIKit

class GameScene: SKScene {
    
    private var score = 0
    // Physics categories
    struct PhysicsCategory {
        static let trump: UInt32 = 0x1 << 0
        static let obstacle: UInt32 = 0x1 << 1
        static let ground: UInt32 = 0x1 << 2
        static let ceiling: UInt32 = 0x1 << 3
        static let score: UInt32 = 0x1 << 4
    }
    
    private var groundNode: SKNode?
    private var ceilingNode: SKNode?
    private var trumpNode: TrumpNode?
    private var scoreLabel: ScoreLabel?
    private let gameManager = GameManager.shared
    private var gameCamera: SKCameraNode?
    
    override func didMove(to view: SKView) {
        setupPhysics()
        setupBackground()
        setupCamera()
        setupBoundaries()
        setupTrump()
        setupScoreLabel()
    }
    
    private func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
    }
    
    private func setupBackground() {
        backgroundColor = SKColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0)
    }
    
    private func setupCamera() {
        let camera = SKCameraNode()
        camera.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(camera)
        self.camera = camera
        gameCamera = camera
    }
    
    private func setupScoreLabel() {
        let labelPosition = CGPoint(x: size.width / 2, y: size.height - 60)
        scoreLabel = ScoreLabel(position: labelPosition)
        if let scoreLabel = scoreLabel {
            addChild(scoreLabel)
        }
    }
    
    func gameOver() {
        let gameOverScene = GameOverScene(size: size, score: score)
        let transition = SKTransition.fade(withDuration: 0.3)
        view?.presentScene(gameOverScene, transition: transition)
    }
    
    private func setupBoundaries() {
        let groundHeight: CGFloat = 50
        let ground = SKNode()
        ground.position = CGPoint(x: 0, y: groundHeight / 2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width * 2, height: groundHeight))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
        ground.physicsBody?.contactTestBitMask = PhysicsCategory.trump
        ground.physicsBody?.collisionBitMask = PhysicsCategory.trump
        addChild(ground)
        groundNode = ground
        
        let ceiling = SKNode()
        ceiling.position = CGPoint(x: 0, y: size.height)
        ceiling.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width * 2, height: 1))
        ceiling.physicsBody?.isDynamic = false
        ceiling.physicsBody?.categoryBitMask = PhysicsCategory.ceiling
        ceiling.physicsBody?.contactTestBitMask = PhysicsCategory.trump
        ceiling.physicsBody?.collisionBitMask = PhysicsCategory.trump
        addChild(ceiling)
        ceilingNode = ceiling
    }
    
    private func setupTrump() {
        let trump = TrumpNode()
        trump.position = CGPoint(x: size.width * 0.25, y: size.height * 0.5)
        addChild(trump)
        trumpNode = trump
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard gameManager.isGameActive else {
            if gameManager.currentState == .menu || gameManager.currentState == .gameOver {
                gameManager.startGame()
            }
            return
        }
        
        handleFlap()
    }
    
    private func handleFlap() {
        trumpNode?.flap()
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard gameManager.isGameActive else { return }
        
        checkBounds()
        updateScrollingElements()
    }
    
    private func checkBounds() {
        trumpNode?.updateRotation()
    }
    
    private func updateScrollingElements() {
        // Scrolling logic will be implemented when obstacles are added
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.trump | PhysicsCategory.obstacle {
            handleGameOver()
        } else if collision == PhysicsCategory.trump | PhysicsCategory.ground {
            handleGameOver()
        } else if collision == PhysicsCategory.trump | PhysicsCategory.ceiling {
            handleGameOver()
        } else if collision == PhysicsCategory.trump | PhysicsCategory.score {
            handleScoreTrigger(contact: contact)
        }
    }
    
    private func handleGameOver() {
        guard gameManager.isGameActive else { return }
        
        triggerDeathEffects()
        
        trumpNode?.die()
        gameManager.endGame()
        
        let wait = SKAction.wait(forDuration: 0.5)
        let transition = SKAction.run { [weak self] in
            guard let self = self else { return }
            self.gameOver()
        }
        run(SKAction.sequence([wait, transition]))
    }
    
    private func triggerDeathEffects() {
        shakeScreen()
        
        physicsWorld.speed = 0.5
        
        let wait = SKAction.wait(forDuration: 0.1)
        let normalSpeed = SKAction.run { [weak self] in
            self?.physicsWorld.speed = 1.0
        }
        run(SKAction.sequence([wait, normalSpeed]))
        
        let heavyFeedback = UIImpactFeedbackGenerator(style: .heavy)
        heavyFeedback.impactOccurred()
        
        AudioManager.shared.playSound("death")
        
        if let trumpPosition = trumpNode?.position {
            showDustEffect(at: trumpPosition)
        }
    }
    
    private func shakeScreen() {
        guard let camera = gameCamera else { return }
        
        let shake = SKAction.sequence([
            SKAction.moveBy(x: -10, y: 0, duration: 0.05),
            SKAction.moveBy(x: 10, y: 0, duration: 0.05),
            SKAction.moveBy(x: -10, y: 0, duration: 0.05),
            SKAction.moveBy(x: 10, y: 0, duration: 0.05),
            SKAction.moveBy(x: 0, y: 0, duration: 0.05)
        ])
        camera.run(shake)
    }
    
    private func showDustEffect(at position: CGPoint) {
        if let dust = SKEmitterNode(fileNamed: "Dust") {
            dust.position = position
            dust.zPosition = 50
            addChild(dust)
            
            let wait = SKAction.wait(forDuration: 0.5)
            let remove = SKAction.removeFromParent()
            dust.run(SKAction.sequence([wait, remove]))
        }
    }
    
    private func handleScoreTrigger(contact: SKPhysicsContact) {
        guard gameManager.isGameActive else { return }
        
        let scoreBody = contact.bodyA.categoryBitMask == PhysicsCategory.score ? contact.bodyA : contact.bodyB
        
        if let scoreNode = scoreBody.node, scoreNode.userData?["scored"] as? Bool != true {
            scoreNode.userData = ["scored": true]
            score += 1
            gameManager.incrementScore()
            
            scoreLabel?.setScore(score, animated: true)
            
            let successFeedback = UIImpactFeedbackGenerator(style: .light)
            successFeedback.impactOccurred()
            
            AudioManager.shared.playSound("score")
            
            showGapFlash(at: scoreNode.position)
            
            checkForNewHighScore()
        }
    }
    
    private func showGapFlash(at position: CGPoint) {
        let flash = SKSpriteNode(color: .white, size: CGSize(width: 20, height: 150))
        flash.position = position
        flash.alpha = 0.5
        flash.zPosition = 5
        addChild(flash)
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let remove = SKAction.removeFromParent()
        flash.run(SKAction.sequence([fadeOut, remove]))
    }
    
    private func checkForNewHighScore() {
        if score > gameManager.highScore && score > 0 {
            showNewHighScoreEffects()
        }
    }
    
    private func showNewHighScoreEffects() {
        showConfetti()
        
        trumpNode?.celebrate()
        
        AudioManager.shared.playSound("highscore")
        
        let successFeedback = UINotificationFeedbackGenerator()
        successFeedback.notificationOccurred(.success)
    }
    
    private func showConfetti() {
        if let confetti = SKEmitterNode(fileNamed: "Confetti") {
            confetti.position = CGPoint(x: size.width / 2, y: size.height)
            confetti.zPosition = 200
            addChild(confetti)
            
            let wait = SKAction.wait(forDuration: 2.0)
            let remove = SKAction.removeFromParent()
            confetti.run(SKAction.sequence([wait, remove]))
        }
    }
}
