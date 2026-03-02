import SpriteKit

class ObstacleNode: SKNode {
    
    private let topTower: SKSpriteNode
    private let bottomTower: SKSpriteNode
    private let scoreTrigger: SKNode
    
    private(set) var gapSize: CGFloat = 0
    private(set) var gapCenterY: CGFloat = 0
    private(set) var hasBeenPassed: Bool = false
    
    private let towerWidth: CGFloat = 80
    
    override init() {
        topTower = SKSpriteNode(color: .systemYellow, size: CGSize(width: 80, height: 1))
        bottomTower = SKSpriteNode(color: .systemYellow, size: CGSize(width: 80, height: 1))
        scoreTrigger = SKNode()
        
        super.init()
        
        addChild(topTower)
        addChild(bottomTower)
        addChild(scoreTrigger)
        
        topTower.zPosition = 5
        bottomTower.zPosition = 5
        scoreTrigger.zPosition = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(gapSize: CGFloat, gapCenterY: CGFloat, screenHeight: CGFloat) {
        self.gapSize = gapSize
        self.gapCenterY = gapCenterY
        self.hasBeenPassed = false
        
        let gapTop = gapCenterY + gapSize / 2
        let gapBottom = gapCenterY - gapSize / 2
        
        let topTowerHeight = screenHeight - gapTop
        let bottomTowerHeight = gapBottom
        
        topTower.size = CGSize(width: towerWidth, height: topTowerHeight)
        topTower.position = CGPoint(x: 0, y: gapTop + topTowerHeight / 2)
        
        bottomTower.size = CGSize(width: towerWidth, height: bottomTowerHeight)
        bottomTower.position = CGPoint(x: 0, y: bottomTowerHeight / 2)
        
        setupPhysicsBodies(screenHeight: screenHeight)
        setupScoreTrigger(screenHeight: screenHeight)
        
        applyGoldStyling()
    }
    
    private func setupPhysicsBodies(screenHeight: CGFloat) {
        topTower.physicsBody = SKPhysicsBody(rectangleOf: topTower.size)
        topTower.physicsBody?.isDynamic = false
        topTower.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
        topTower.physicsBody?.contactTestBitMask = PhysicsCategory.trump
        topTower.physicsBody?.collisionBitMask = 0
        
        bottomTower.physicsBody = SKPhysicsBody(rectangleOf: bottomTower.size)
        bottomTower.physicsBody?.isDynamic = false
        bottomTower.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
        bottomTower.physicsBody?.contactTestBitMask = PhysicsCategory.trump
        bottomTower.physicsBody?.collisionBitMask = 0
    }
    
    private func setupScoreTrigger(screenHeight: CGFloat) {
        let triggerWidth: CGFloat = 4
        let triggerSize = CGSize(width: triggerWidth, height: screenHeight)
        
        scoreTrigger.position = CGPoint(x: 0, y: screenHeight / 2)
        scoreTrigger.physicsBody = SKPhysicsBody(rectangleOf: triggerSize)
        scoreTrigger.physicsBody?.isDynamic = false
        scoreTrigger.physicsBody?.categoryBitMask = PhysicsCategory.score
        scoreTrigger.physicsBody?.contactTestBitMask = PhysicsCategory.trump
        scoreTrigger.physicsBody?.collisionBitMask = 0
        
        scoreTrigger.userData = ["scored": false]
    }
    
    private func applyGoldStyling() {
        let goldColor = UIColor(red: 0.85, green: 0.65, blue: 0.13, alpha: 1.0)
        topTower.color = goldColor
        bottomTower.color = goldColor
        
        topTower.colorBlendFactor = 1.0
        bottomTower.colorBlendFactor = 1.0
        
        let shadowOffset: CGFloat = 3
        topTower.shadowCastBitMask = 1
        bottomTower.shadowCastBitMask = 1
    }
    
    func reset() {
        hasBeenPassed = false
        scoreTrigger.userData = ["scored": false]
        position = .zero
    }
    
    func markAsPassed() {
        hasBeenPassed = true
        scoreTrigger.userData = ["scored": true]
    }
}

private struct PhysicsCategory {
    static let trump: UInt32 = 0x1 << 0
    static let obstacle: UInt32 = 0x1 << 1
    static let score: UInt32 = 0x1 << 4
}
