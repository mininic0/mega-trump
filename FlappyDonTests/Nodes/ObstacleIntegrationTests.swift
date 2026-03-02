import XCTest
import SpriteKit
@testable import FlappyDon

final class ObstacleIntegrationTests: XCTestCase {
    
    var obstacleManager: ObstacleManager!
    var testScene: SKScene!
    
    override func setUp() {
        super.setUp()
        testScene = SKScene(size: CGSize(width: 375, height: 667))
        obstacleManager = ObstacleManager(scene: testScene)
    }
    
    override func tearDown() {
        obstacleManager.reset()
        testScene.removeAllChildren()
        obstacleManager = nil
        testScene = nil
        super.tearDown()
    }
    
    // MARK: - Complete Lifecycle Integration Tests
    
    func testCompleteObstacleLifecycle() {
        // Test the complete lifecycle: spawn -> scroll -> remove -> reuse
        
        // Phase 1: Initial delay
        obstacleManager.update(deltaTime: 2.0, currentScore: 0)
        XCTAssertEqual(obstacleManager.getActiveObstacles().count, 0, "No obstacles during initial delay")
        
        // Phase 2: First spawn
        obstacleManager.update(deltaTime: 2.6, currentScore: 0)
        XCTAssertEqual(obstacleManager.getActiveObstacles().count, 1, "First obstacle spawned")
        
        let firstObstacle = obstacleManager.getActiveObstacles().first!
        let firstObstacleReference = Unmanaged.passUnretained(firstObstacle).toOpaque()
        let initialX = firstObstacle.position.x
        
        XCTAssertGreaterThan(initialX, testScene.size.width, "Obstacle spawns off right edge")
        XCTAssertGreaterThan(firstObstacle.gapSize, 0, "Obstacle has valid gap size")
        XCTAssertGreaterThan(firstObstacle.gapCenterY, 0, "Obstacle has valid gap center")
        XCTAssertFalse(firstObstacle.hasBeenPassed, "Obstacle not marked as passed initially")
        
        // Phase 3: Scrolling
        for _ in 0..<10 {
            obstacleManager.update(deltaTime: 0.1, currentScore: 0)
        }
        
        XCTAssertLessThan(firstObstacle.position.x, initialX, "Obstacle scrolls left")
        XCTAssertEqual(obstacleManager.getActiveObstacles().count, 1, "Obstacle still active while onscreen")
        
        // Phase 4: Move offscreen
        firstObstacle.position.x = -100
        obstacleManager.update(deltaTime: 0.1, currentScore: 0)
        
        XCTAssertEqual(obstacleManager.getActiveObstacles().count, 0, "Obstacle removed when offscreen")
        XCTAssertEqual(testScene.children.count, 0, "Obstacle removed from scene")
        
        // Phase 5: Reuse from pool
        obstacleManager.update(deltaTime: 2.6, currentScore: 0)
        
        let reusedObstacle = obstacleManager.getActiveObstacles().first!
        let reusedObstacleReference = Unmanaged.passUnretained(reusedObstacle).toOpaque()
        
        XCTAssertEqual(firstObstacleReference, reusedObstacleReference, "Obstacle reused from pool")
        XCTAssertFalse(reusedObstacle.hasBeenPassed, "Reused obstacle is reset")
        XCTAssertGreaterThan(reusedObstacle.position.x, testScene.size.width, "Reused obstacle spawns at right edge")
    }
    
    func testMultipleObstaclesScrollingTogether() {
        // Test multiple obstacles spawning and scrolling in coordination
        
        // Spawn multiple obstacles
        obstacleManager.update(deltaTime: 2.0, currentScore: 0)
        obstacleManager.update(deltaTime: 2.6, currentScore: 0) // First obstacle
        obstacleManager.update(deltaTime: 2.6, currentScore: 0) // Second obstacle
        obstacleManager.update(deltaTime: 2.6, currentScore: 0) // Third obstacle
        
        XCTAssertEqual(obstacleManager.getActiveObstacles().count, 3, "Three obstacles spawned")
        
        let obstacles = obstacleManager.getActiveObstacles()
        let initialPositions = obstacles.map { $0.position.x }
        
        // Verify spacing between obstacles
        XCTAssertLessThan(obstacles[1].position.x, obstacles[0].position.x, "Second obstacle is left of first")
        XCTAssertLessThan(obstacles[2].position.x, obstacles[1].position.x, "Third obstacle is left of second")
        
        // Scroll all obstacles
        obstacleManager.update(deltaTime: 1.0, currentScore: 0)
        
        // Verify all moved by same amount
        for (index, obstacle) in obstacles.enumerated() {
            let expectedX = initialPositions[index] - 150
            XCTAssertEqual(obstacle.position.x, expectedX, accuracy: 0.1, "All obstacles scroll at same speed")
        }
        
        // Verify relative spacing maintained
        XCTAssertLessThan(obstacles[1].position.x, obstacles[0].position.x, "Spacing maintained after scrolling")
        XCTAssertLessThan(obstacles[2].position.x, obstacles[1].position.x, "Spacing maintained after scrolling")
    }
    
    func testDifficultyProgressionDuringGameplay() {
        // Test difficulty changes as score increases during gameplay
        
        // Start at easy difficulty (score 0-10)
        obstacleManager.update(deltaTime: 2.0, currentScore: 0)
        obstacleManager.update(deltaTime: 2.6, currentScore: 5)
        
        let easyObstacle = obstacleManager.getActiveObstacles().first!
        XCTAssertEqual(easyObstacle.gapSize, 200, "Easy difficulty gap size")
        
        let easyInitialX = easyObstacle.position.x
        obstacleManager.update(deltaTime: 1.0, currentScore: 5)
        let easySpeed = easyInitialX - easyObstacle.position.x
        XCTAssertEqual(easySpeed, 150, accuracy: 0.1, "Easy difficulty scroll speed")
        
        // Progress to medium difficulty (score 11-25)
        obstacleManager.reset()
        obstacleManager.update(deltaTime: 2.0, currentScore: 15)
        obstacleManager.update(deltaTime: 2.6, currentScore: 15)
        
        let mediumObstacle = obstacleManager.getActiveObstacles().first!
        XCTAssertEqual(mediumObstacle.gapSize, 160, "Medium difficulty gap size")
        
        let mediumInitialX = mediumObstacle.position.x
        obstacleManager.update(deltaTime: 1.0, currentScore: 15)
        let mediumSpeed = mediumInitialX - mediumObstacle.position.x
        XCTAssertEqual(mediumSpeed, 200, accuracy: 0.1, "Medium difficulty scroll speed")
        
        // Progress to hard difficulty (score 26-50)
        obstacleManager.reset()
        obstacleManager.update(deltaTime: 2.0, currentScore: 35)
        obstacleManager.update(deltaTime: 2.6, currentScore: 35)
        
        let hardObstacle = obstacleManager.getActiveObstacles().first!
        XCTAssertEqual(hardObstacle.gapSize, 130, "Hard difficulty gap size")
        
        let hardInitialX = hardObstacle.position.x
        obstacleManager.update(deltaTime: 1.0, currentScore: 35)
        let hardSpeed = hardInitialX - hardObstacle.position.x
        XCTAssertEqual(hardSpeed, 250, accuracy: 0.1, "Hard difficulty scroll speed")
        
        // Progress to very hard difficulty (score 51+)
        obstacleManager.reset()
        obstacleManager.update(deltaTime: 2.0, currentScore: 60)
        obstacleManager.update(deltaTime: 2.6, currentScore: 60)
        
        let veryHardObstacle = obstacleManager.getActiveObstacles().first!
        XCTAssertEqual(veryHardObstacle.gapSize, 110, "Very hard difficulty gap size")
        
        let veryHardInitialX = veryHardObstacle.position.x
        obstacleManager.update(deltaTime: 1.0, currentScore: 60)
        let veryHardSpeed = veryHardInitialX - veryHardObstacle.position.x
        XCTAssertEqual(veryHardSpeed, 300, accuracy: 0.1, "Very hard difficulty scroll speed")
    }
    
    func testObstaclePoolingUnderLoad() {
        // Test object pooling with rapid spawning and removal
        
        obstacleManager.update(deltaTime: 2.0, currentScore: 0)
        
        var spawnedObstacleReferences: [UnsafeRawPointer] = []
        
        // Spawn and remove obstacles rapidly
        for _ in 0..<20 {
            obstacleManager.update(deltaTime: 2.6, currentScore: 0)
            
            if let obstacle = obstacleManager.getActiveObstacles().first {
                let reference = Unmanaged.passUnretained(obstacle).toOpaque()
                spawnedObstacleReferences.append(reference)
                
                // Move offscreen and remove
                obstacle.position.x = -100
                obstacleManager.update(deltaTime: 0.1, currentScore: 0)
            }
        }
        
        // Verify that obstacles were reused (should see repeated references)
        let uniqueReferences = Set(spawnedObstacleReferences)
        XCTAssertLessThan(uniqueReferences.count, 20, "Obstacles should be reused from pool")
        XCTAssertGreaterThan(uniqueReferences.count, 0, "Should have created some obstacles")
        XCTAssertLessThanOrEqual(uniqueReferences.count, 10, "Should not create excessive obstacles")
    }
    
    func testObstacleNodeAndManagerIntegration() {
        // Test that ObstacleNode and ObstacleManager work together correctly
        
        obstacleManager.update(deltaTime: 2.0, currentScore: 0)
        obstacleManager.update(deltaTime: 2.6, currentScore: 0)
        
        let obstacle = obstacleManager.getActiveObstacles().first!
        
        // Verify ObstacleNode is properly configured by ObstacleManager
        XCTAssertNotNil(obstacle.parent, "Obstacle should be added to scene")
        XCTAssertEqual(obstacle.parent, testScene, "Obstacle parent should be test scene")
        XCTAssertEqual(obstacle.children.count, 3, "Obstacle should have 3 children")
        
        // Verify physics bodies are set up
        let topTower = obstacle.children[0] as! SKSpriteNode
        let bottomTower = obstacle.children[1] as! SKSpriteNode
        let scoreTrigger = obstacle.children[2]
        
        XCTAssertNotNil(topTower.physicsBody, "Top tower should have physics body")
        XCTAssertNotNil(bottomTower.physicsBody, "Bottom tower should have physics body")
        XCTAssertNotNil(scoreTrigger.physicsBody, "Score trigger should have physics body")
        
        // Verify gap configuration
        XCTAssertGreaterThan(obstacle.gapSize, 0, "Gap size should be positive")
        XCTAssertGreaterThan(obstacle.gapCenterY, 0, "Gap center should be positive")
        
        // Test marking as passed
        obstacle.markAsPassed()
        XCTAssertTrue(obstacle.hasBeenPassed, "Obstacle should be marked as passed")
        
        // Test reset through manager
        obstacleManager.reset()
        XCTAssertNil(obstacle.parent, "Obstacle should be removed from scene after reset")
    }
    
    func testContinuousGameplaySimulation() {
        // Simulate continuous gameplay with spawning, scrolling, and removal
        
        obstacleManager.update(deltaTime: 2.0, currentScore: 0)
        
        var totalObstaclesSpawned = 0
        var totalObstaclesRemoved = 0
        var maxActiveObstacles = 0
        
        // Simulate 30 seconds of gameplay
        for i in 0..<300 {
            let deltaTime = 0.1
            let currentScore = i / 30 // Score increases every 3 seconds
            
            let beforeCount = obstacleManager.getActiveObstacles().count
            obstacleManager.update(deltaTime: deltaTime, currentScore: currentScore)
            let afterCount = obstacleManager.getActiveObstacles().count
            
            if afterCount > beforeCount {
                totalObstaclesSpawned += (afterCount - beforeCount)
            } else if afterCount < beforeCount {
                totalObstaclesRemoved += (beforeCount - afterCount)
            }
            
            maxActiveObstacles = max(maxActiveObstacles, afterCount)
            
            // Manually remove obstacles that scroll far offscreen
            for obstacle in obstacleManager.getActiveObstacles() {
                if obstacle.position.x < -200 {
                    obstacle.position.x = -100 // Trigger removal
                }
            }
        }
        
        XCTAssertGreaterThan(totalObstaclesSpawned, 0, "Obstacles should spawn during gameplay")
        XCTAssertGreaterThan(totalObstaclesRemoved, 0, "Obstacles should be removed during gameplay")
        XCTAssertGreaterThan(maxActiveObstacles, 0, "Should have active obstacles during gameplay")
        XCTAssertLessThan(maxActiveObstacles, 15, "Should not have excessive active obstacles")
    }
    
    func testResetAndRestart() {
        // Test that reset properly clears state for a new game
        
        // First game session
        obstacleManager.update(deltaTime: 2.0, currentScore: 0)
        obstacleManager.update(deltaTime: 2.6, currentScore: 0)
        obstacleManager.update(deltaTime: 2.6, currentScore: 0)
        
        XCTAssertEqual(obstacleManager.getActiveObstacles().count, 2, "Two obstacles in first session")
        
        // Reset
        obstacleManager.reset()
        
        XCTAssertEqual(obstacleManager.getActiveObstacles().count, 0, "No obstacles after reset")
        XCTAssertEqual(testScene.children.count, 0, "Scene cleared after reset")
        
        // Second game session
        obstacleManager.update(deltaTime: 2.0, currentScore: 0)
        XCTAssertEqual(obstacleManager.getActiveObstacles().count, 0, "Initial delay restored")
        
        obstacleManager.update(deltaTime: 2.6, currentScore: 0)
        XCTAssertEqual(obstacleManager.getActiveObstacles().count, 1, "Obstacles spawn in second session")
        
        let obstacle = obstacleManager.getActiveObstacles().first!
        XCTAssertEqual(obstacle.gapSize, 200, "Difficulty reset to easy")
        XCTAssertFalse(obstacle.hasBeenPassed, "Obstacle state is fresh")
    }
    
    func testObstacleSpacingConsistency() {
        // Test that obstacles maintain consistent spacing
        
        obstacleManager.update(deltaTime: 2.0, currentScore: 0)
        
        // Spawn three obstacles
        obstacleManager.update(deltaTime: 2.6, currentScore: 0)
        let firstX = obstacleManager.getActiveObstacles().last!.position.x
        
        obstacleManager.update(deltaTime: 2.6, currentScore: 0)
        let secondX = obstacleManager.getActiveObstacles().last!.position.x
        
        obstacleManager.update(deltaTime: 2.6, currentScore: 0)
        let thirdX = obstacleManager.getActiveObstacles().last!.position.x
        
        // Calculate spacing
        let spacing1 = firstX - secondX
        let spacing2 = secondX - thirdX
        
        // Spacing should be consistent (scroll speed * spawn interval)
        // At score 0: speed = 150, interval = 2.5, expected spacing = 375
        let expectedSpacing: CGFloat = 150 * 2.5
        
        XCTAssertEqual(spacing1, expectedSpacing, accuracy: 10, "First spacing should match expected")
        XCTAssertEqual(spacing2, expectedSpacing, accuracy: 10, "Second spacing should match expected")
        XCTAssertEqual(spacing1, spacing2, accuracy: 1, "Spacing should be consistent")
    }
    
    func testObstacleGapVariation() {
        // Test that obstacles have varying gap positions
        
        obstacleManager.update(deltaTime: 2.0, currentScore: 0)
        
        var gapCenters: [CGFloat] = []
        
        // Spawn multiple obstacles
        for _ in 0..<10 {
            obstacleManager.update(deltaTime: 2.6, currentScore: 0)
            if let obstacle = obstacleManager.getActiveObstacles().last {
                gapCenters.append(obstacle.gapCenterY)
            }
        }
        
        // Verify variation in gap positions
        let uniqueGapCenters = Set(gapCenters)
        XCTAssertGreaterThan(uniqueGapCenters.count, 5, "Should have varied gap positions")
        
        // Verify all gaps are within valid range
        let minValidGap: CGFloat = 200 / 2 + 80 // gapSize/2 + safeMargin
        let maxValidGap: CGFloat = testScene.size.height - 200 / 2 - 80
        
        for gapCenter in gapCenters {
            XCTAssertGreaterThanOrEqual(gapCenter, minValidGap, "Gap should be above minimum")
            XCTAssertLessThanOrEqual(gapCenter, maxValidGap, "Gap should be below maximum")
        }
    }
}
