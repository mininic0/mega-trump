import XCTest
import SpriteKit
@testable import FlappyDon

final class ObstacleNodeTests: XCTestCase {
    
    var obstacleNode: ObstacleNode!
    let testScreenHeight: CGFloat = 800
    let testGapSize: CGFloat = 200
    let testGapCenterY: CGFloat = 400
    
    override func setUp() {
        super.setUp()
        obstacleNode = ObstacleNode()
    }
    
    override func tearDown() {
        obstacleNode = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInitialization() {
        XCTAssertNotNil(obstacleNode, "ObstacleNode should initialize")
        XCTAssertEqual(obstacleNode.children.count, 3, "Should have 3 children (top tower, bottom tower, score trigger)")
        XCTAssertEqual(obstacleNode.gapSize, 0, "Initial gap size should be 0")
        XCTAssertEqual(obstacleNode.gapCenterY, 0, "Initial gap center Y should be 0")
        XCTAssertFalse(obstacleNode.hasBeenPassed, "Should not be marked as passed initially")
    }
    
    func testChildrenZPositions() {
        XCTAssertEqual(obstacleNode.children[0].zPosition, 5, "Top tower should have z-position 5")
        XCTAssertEqual(obstacleNode.children[1].zPosition, 5, "Bottom tower should have z-position 5")
        XCTAssertEqual(obstacleNode.children[2].zPosition, 5, "Score trigger should have z-position 5")
    }
    
    // MARK: - Setup Tests
    
    func testSetupConfiguresProperties() {
        // When: Setting up the obstacle
        obstacleNode.setup(gapSize: testGapSize, gapCenterY: testGapCenterY, screenHeight: testScreenHeight)
        
        // Then: Properties should be configured
        XCTAssertEqual(obstacleNode.gapSize, testGapSize, "Gap size should be set")
        XCTAssertEqual(obstacleNode.gapCenterY, testGapCenterY, "Gap center Y should be set")
        XCTAssertFalse(obstacleNode.hasBeenPassed, "Should not be marked as passed after setup")
    }
    
    func testSetupConfiguresTowerSizes() {
        // When: Setting up the obstacle
        obstacleNode.setup(gapSize: testGapSize, gapCenterY: testGapCenterY, screenHeight: testScreenHeight)
        
        // Then: Tower sizes should be calculated correctly
        let gapTop = testGapCenterY + testGapSize / 2
        let gapBottom = testGapCenterY - testGapSize / 2
        let expectedTopHeight = testScreenHeight - gapTop
        let expectedBottomHeight = gapBottom
        
        let topTower = obstacleNode.children[0] as! SKSpriteNode
        let bottomTower = obstacleNode.children[1] as! SKSpriteNode
        
        XCTAssertEqual(topTower.size.width, 80, "Top tower width should be 80")
        XCTAssertEqual(topTower.size.height, expectedTopHeight, accuracy: 0.01, "Top tower height should match calculation")
        XCTAssertEqual(bottomTower.size.width, 80, "Bottom tower width should be 80")
        XCTAssertEqual(bottomTower.size.height, expectedBottomHeight, accuracy: 0.01, "Bottom tower height should match calculation")
    }
    
    func testSetupConfiguresTowerPositions() {
        // When: Setting up the obstacle
        obstacleNode.setup(gapSize: testGapSize, gapCenterY: testGapCenterY, screenHeight: testScreenHeight)
        
        // Then: Tower positions should be calculated correctly
        let gapTop = testGapCenterY + testGapSize / 2
        let gapBottom = testGapCenterY - testGapSize / 2
        let topTowerHeight = testScreenHeight - gapTop
        let bottomTowerHeight = gapBottom
        
        let topTower = obstacleNode.children[0] as! SKSpriteNode
        let bottomTower = obstacleNode.children[1] as! SKSpriteNode
        
        XCTAssertEqual(topTower.position.x, 0, "Top tower X should be 0")
        XCTAssertEqual(topTower.position.y, gapTop + topTowerHeight / 2, accuracy: 0.01, "Top tower Y should be positioned correctly")
        XCTAssertEqual(bottomTower.position.x, 0, "Bottom tower X should be 0")
        XCTAssertEqual(bottomTower.position.y, bottomTowerHeight / 2, accuracy: 0.01, "Bottom tower Y should be positioned correctly")
    }
    
    func testSetupWithDifferentGapSizes() {
        // Test with small gap
        obstacleNode.setup(gapSize: 100, gapCenterY: 400, screenHeight: testScreenHeight)
        XCTAssertEqual(obstacleNode.gapSize, 100, "Should handle small gap size")
        
        // Test with large gap
        obstacleNode.setup(gapSize: 300, gapCenterY: 400, screenHeight: testScreenHeight)
        XCTAssertEqual(obstacleNode.gapSize, 300, "Should handle large gap size")
    }
    
    func testSetupWithDifferentGapCenters() {
        // Test with low gap center
        obstacleNode.setup(gapSize: testGapSize, gapCenterY: 200, screenHeight: testScreenHeight)
        XCTAssertEqual(obstacleNode.gapCenterY, 200, "Should handle low gap center")
        
        // Test with high gap center
        obstacleNode.setup(gapSize: testGapSize, gapCenterY: 600, screenHeight: testScreenHeight)
        XCTAssertEqual(obstacleNode.gapCenterY, 600, "Should handle high gap center")
    }
    
    // MARK: - Physics Body Tests
    
    func testTopTowerPhysicsBody() {
        // When: Setting up the obstacle
        obstacleNode.setup(gapSize: testGapSize, gapCenterY: testGapCenterY, screenHeight: testScreenHeight)
        
        // Then: Top tower should have correct physics body
        let topTower = obstacleNode.children[0] as! SKSpriteNode
        XCTAssertNotNil(topTower.physicsBody, "Top tower should have physics body")
        XCTAssertFalse(topTower.physicsBody!.isDynamic, "Top tower should not be dynamic")
        XCTAssertEqual(topTower.physicsBody!.categoryBitMask, 0x1 << 1, "Top tower should have obstacle category")
        XCTAssertEqual(topTower.physicsBody!.contactTestBitMask, 0x1 << 0, "Top tower should test contact with trump")
        XCTAssertEqual(topTower.physicsBody!.collisionBitMask, 0, "Top tower should have no collision")
    }
    
    func testBottomTowerPhysicsBody() {
        // When: Setting up the obstacle
        obstacleNode.setup(gapSize: testGapSize, gapCenterY: testGapCenterY, screenHeight: testScreenHeight)
        
        // Then: Bottom tower should have correct physics body
        let bottomTower = obstacleNode.children[1] as! SKSpriteNode
        XCTAssertNotNil(bottomTower.physicsBody, "Bottom tower should have physics body")
        XCTAssertFalse(bottomTower.physicsBody!.isDynamic, "Bottom tower should not be dynamic")
        XCTAssertEqual(bottomTower.physicsBody!.categoryBitMask, 0x1 << 1, "Bottom tower should have obstacle category")
        XCTAssertEqual(bottomTower.physicsBody!.contactTestBitMask, 0x1 << 0, "Bottom tower should test contact with trump")
        XCTAssertEqual(bottomTower.physicsBody!.collisionBitMask, 0, "Bottom tower should have no collision")
    }
    
    func testScoreTriggerPhysicsBody() {
        // When: Setting up the obstacle
        obstacleNode.setup(gapSize: testGapSize, gapCenterY: testGapCenterY, screenHeight: testScreenHeight)
        
        // Then: Score trigger should have correct physics body
        let scoreTrigger = obstacleNode.children[2]
        XCTAssertNotNil(scoreTrigger.physicsBody, "Score trigger should have physics body")
        XCTAssertFalse(scoreTrigger.physicsBody!.isDynamic, "Score trigger should not be dynamic")
        XCTAssertEqual(scoreTrigger.physicsBody!.categoryBitMask, 0x1 << 4, "Score trigger should have score category")
        XCTAssertEqual(scoreTrigger.physicsBody!.contactTestBitMask, 0x1 << 0, "Score trigger should test contact with trump")
        XCTAssertEqual(scoreTrigger.physicsBody!.collisionBitMask, 0, "Score trigger should have no collision")
    }
    
    func testScoreTriggerSize() {
        // When: Setting up the obstacle
        obstacleNode.setup(gapSize: testGapSize, gapCenterY: testGapCenterY, screenHeight: testScreenHeight)
        
        // Then: Score trigger should span full screen height
        let scoreTrigger = obstacleNode.children[2]
        XCTAssertEqual(scoreTrigger.position.y, testScreenHeight / 2, "Score trigger should be centered vertically")
        
        // Physics body size should be 4 points wide and full screen height
        let physicsBodySize = scoreTrigger.physicsBody!.area
        XCTAssertGreaterThan(physicsBodySize, 0, "Score trigger should have non-zero area")
    }
    
    func testScoreTriggerUserData() {
        // When: Setting up the obstacle
        obstacleNode.setup(gapSize: testGapSize, gapCenterY: testGapCenterY, screenHeight: testScreenHeight)
        
        // Then: Score trigger should have userData with scored flag
        let scoreTrigger = obstacleNode.children[2]
        XCTAssertNotNil(scoreTrigger.userData, "Score trigger should have userData")
        XCTAssertEqual(scoreTrigger.userData?["scored"] as? Bool, false, "Score trigger should not be scored initially")
    }
    
    // MARK: - Styling Tests
    
    func testGoldStyling() {
        // When: Setting up the obstacle
        obstacleNode.setup(gapSize: testGapSize, gapCenterY: testGapCenterY, screenHeight: testScreenHeight)
        
        // Then: Towers should have gold color
        let topTower = obstacleNode.children[0] as! SKSpriteNode
        let bottomTower = obstacleNode.children[1] as! SKSpriteNode
        
        let expectedGoldColor = UIColor(red: 0.85, green: 0.65, blue: 0.13, alpha: 1.0)
        
        XCTAssertEqual(topTower.color, expectedGoldColor, "Top tower should have gold color")
        XCTAssertEqual(bottomTower.color, expectedGoldColor, "Bottom tower should have gold color")
        XCTAssertEqual(topTower.colorBlendFactor, 1.0, "Top tower should have full color blend")
        XCTAssertEqual(bottomTower.colorBlendFactor, 1.0, "Bottom tower should have full color blend")
    }
    
    // MARK: - Reset Tests
    
    func testReset() {
        // Given: An obstacle that has been set up and passed
        obstacleNode.setup(gapSize: testGapSize, gapCenterY: testGapCenterY, screenHeight: testScreenHeight)
        obstacleNode.markAsPassed()
        obstacleNode.position = CGPoint(x: 100, y: 50)
        
        // When: Resetting the obstacle
        obstacleNode.reset()
        
        // Then: State should be reset
        XCTAssertFalse(obstacleNode.hasBeenPassed, "Should not be marked as passed after reset")
        XCTAssertEqual(obstacleNode.position, .zero, "Position should be reset to zero")
        
        let scoreTrigger = obstacleNode.children[2]
        XCTAssertEqual(scoreTrigger.userData?["scored"] as? Bool, false, "Score trigger userData should be reset")
    }
    
    func testResetPreservesSetupConfiguration() {
        // Given: An obstacle that has been set up
        obstacleNode.setup(gapSize: testGapSize, gapCenterY: testGapCenterY, screenHeight: testScreenHeight)
        let originalGapSize = obstacleNode.gapSize
        let originalGapCenterY = obstacleNode.gapCenterY
        
        // When: Resetting the obstacle
        obstacleNode.reset()
        
        // Then: Setup configuration should be preserved
        XCTAssertEqual(obstacleNode.gapSize, originalGapSize, "Gap size should be preserved")
        XCTAssertEqual(obstacleNode.gapCenterY, originalGapCenterY, "Gap center Y should be preserved")
    }
    
    // MARK: - Mark As Passed Tests
    
    func testMarkAsPassed() {
        // Given: An obstacle that has been set up
        obstacleNode.setup(gapSize: testGapSize, gapCenterY: testGapCenterY, screenHeight: testScreenHeight)
        
        // When: Marking as passed
        obstacleNode.markAsPassed()
        
        // Then: Should be marked as passed
        XCTAssertTrue(obstacleNode.hasBeenPassed, "Should be marked as passed")
        
        let scoreTrigger = obstacleNode.children[2]
        XCTAssertEqual(scoreTrigger.userData?["scored"] as? Bool, true, "Score trigger userData should be updated")
    }
    
    func testMarkAsPassedMultipleTimes() {
        // Given: An obstacle that has been set up
        obstacleNode.setup(gapSize: testGapSize, gapCenterY: testGapCenterY, screenHeight: testScreenHeight)
        
        // When: Marking as passed multiple times
        obstacleNode.markAsPassed()
        obstacleNode.markAsPassed()
        obstacleNode.markAsPassed()
        
        // Then: Should remain marked as passed
        XCTAssertTrue(obstacleNode.hasBeenPassed, "Should remain marked as passed")
    }
    
    // MARK: - Edge Case Tests
    
    func testSetupWithMinimumGapSize() {
        // When: Setting up with very small gap
        obstacleNode.setup(gapSize: 50, gapCenterY: testGapCenterY, screenHeight: testScreenHeight)
        
        // Then: Should handle minimum gap size
        XCTAssertEqual(obstacleNode.gapSize, 50, "Should handle minimum gap size")
        
        let topTower = obstacleNode.children[0] as! SKSpriteNode
        let bottomTower = obstacleNode.children[1] as! SKSpriteNode
        
        XCTAssertGreaterThan(topTower.size.height, 0, "Top tower should have positive height")
        XCTAssertGreaterThan(bottomTower.size.height, 0, "Bottom tower should have positive height")
    }
    
    func testSetupWithMaximumGapSize() {
        // When: Setting up with very large gap
        obstacleNode.setup(gapSize: 400, gapCenterY: testGapCenterY, screenHeight: testScreenHeight)
        
        // Then: Should handle maximum gap size
        XCTAssertEqual(obstacleNode.gapSize, 400, "Should handle maximum gap size")
        
        let topTower = obstacleNode.children[0] as! SKSpriteNode
        let bottomTower = obstacleNode.children[1] as! SKSpriteNode
        
        XCTAssertGreaterThan(topTower.size.height, 0, "Top tower should have positive height")
        XCTAssertGreaterThan(bottomTower.size.height, 0, "Bottom tower should have positive height")
    }
    
    func testSetupWithGapAtTopOfScreen() {
        // When: Setting up with gap near top of screen
        let highGapCenter = testScreenHeight - 100
        obstacleNode.setup(gapSize: testGapSize, gapCenterY: highGapCenter, screenHeight: testScreenHeight)
        
        // Then: Should handle gap at top
        XCTAssertEqual(obstacleNode.gapCenterY, highGapCenter, "Should handle high gap center")
        
        let topTower = obstacleNode.children[0] as! SKSpriteNode
        XCTAssertGreaterThanOrEqual(topTower.size.height, 0, "Top tower should have non-negative height")
    }
    
    func testSetupWithGapAtBottomOfScreen() {
        // When: Setting up with gap near bottom of screen
        let lowGapCenter: CGFloat = 100
        obstacleNode.setup(gapSize: testGapSize, gapCenterY: lowGapCenter, screenHeight: testScreenHeight)
        
        // Then: Should handle gap at bottom
        XCTAssertEqual(obstacleNode.gapCenterY, lowGapCenter, "Should handle low gap center")
        
        let bottomTower = obstacleNode.children[1] as! SKSpriteNode
        XCTAssertGreaterThanOrEqual(bottomTower.size.height, 0, "Bottom tower should have non-negative height")
    }
}
