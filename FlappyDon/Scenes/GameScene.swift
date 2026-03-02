import SpriteKit

class GameScene: SKScene {
    
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
    private let gameManager = GameManager.shared
    
    override func didMove(to view: SKView) {
        setupPhysics()
        setupBackground()
        setupBoundaries()
    }
    
    private func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
    }
    
    private func setupBackground() {
        backgroundColor = SKColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0)
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
        // This will be implemented when Trump character is added
        // For now, this is a placeholder for the flap action
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard gameManager.isGameActive else { return }
        
        checkBounds()
        updateScrollingElements()
    }
    
    private func checkBounds() {
        // Additional bounds checking will be implemented when Trump character is added
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
        gameManager.endGame()
    }
    
    private func handleScoreTrigger(contact: SKPhysicsContact) {
        guard gameManager.isGameActive else { return }
        
        let scoreBody = contact.bodyA.categoryBitMask == PhysicsCategory.score ? contact.bodyA : contact.bodyB
        
        if let scoreNode = scoreBody.node, scoreNode.userData?["scored"] as? Bool != true {
            scoreNode.userData = ["scored": true]
            gameManager.incrementScore()
        }
    }
}
