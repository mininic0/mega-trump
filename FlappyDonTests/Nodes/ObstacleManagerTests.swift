import XCTest
import SpriteKit
@testable import FlappyDon

final class ObstacleManagerTests: XCTestCase {
    
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
    
    // MARK: - Initialization Tests
    
    func testInitialization() {
        XCTAssertNotNil(obstacleManager, "ObstacleManager should initialize")
        XCTAssertEqual(obstacleManager.getActiveObstacles().count, 0, "Should have no active obstacles initially")
    }
    
    func testPoolInitialization() {
        // Pool should be pre-created but not visible
        XCTAssertEqual(testScene.children.count, 0, "Scene should have no children initially")
    }
    
    // MARK: - Initial Delay Tests
    
    func testInitialDelayPreventsSpawning() {
        // When: Updating before initial delay
        obstacleManager.update(deltaTime: 1.0, currentScore: 0)
        
        // Then: No obstacles should spawn
        XCTAssertEqual(obstacleManager.getActiveObstacles().count, 0, "No obstacles should spawn before initial delay")
        XCTAssertEqual(testScene.children.count, 0, "Scene should have no children before initial delay")
    }
    
    func testInitialDelayAllowsSpawningAfterDelay() {
        // When: Updating past initial delay (2 seconds) and spawn interval (2.5 seconds)
        obstacleManager.update(deltaTime: 2.0, currentScore: 0)
        obstacleManager.update(deltaTime: 0.6, currentScore: 0)
        
        // Then: First obstacle should spawn
        XCTAssertGreaterThan(obstacleManager.getActiveObstacles().count, 0, "Obstacles should spawn after initial delay")
    }
    
    // MARK: - Spawn Tests
    
    func testSpawnObstacle() {
        // Given: Initial delay has passed
        obstacleManager.update(deltaTime: 2.0, currentScore: 0)
        
        // When: Spawn interval passes
        obstacleManager.update(deltaTime: 2.6, currentScore: 0)
        
        // Then: Obstacle should be spawned
        XCTAssertEqual(obstacleManager.getActiveObstacles().count, 1, "Should have 1 active obstacle")
        XCTAssertEqual(testScene.children.count, 1, "Scene should have 1 child")
    }
    
    func testSpawnMultipleObstacles() {
        // Given: Initial delay has passed
        obstacleManager.update(deltaTime: 2.0, currentScore: 0)
        
        // When: Multiple spawn intervals pass
        obstacleManager.update(deltaTime: 2.6, currentScore: 0)
        obstacleManager.update(deltaTime: 2.6, currentScore: 0)
        obstacleManager.update(deltaTime: 2.6, currentScore: 0)
        
        // Then: Multiple obstacles should be spawned
        XCTAssertEqual(obstacleManager.getActiveObstacles().count, 3, "Should have 3 active obstacles")
        XCTAssertEqual(testScene.children.count, 3, "Scene should have 3 children")
    }
    
    func testSpawnObstaclePosition() {
        // Given: Initial delay has passed
        obstacleManager.update(deltaTime: 2.0, currentScore: 0)
        
        // When: Spawning an obstacle
        obstacleManager.update(deltaTime: 2.6, currentScore: 0)
        
        // Then: Obstacle should be positioned at right edge
        let obstacle = obstacleManager.getActiveObstacles().first!
        XCTAssertGreaterThan(obstacle.position.x, testScene.size.width, "Obstacle should spawn off right edge")
    }
    
    func testSpawnObstacleRandomHeight() {
        // Given: Initial delay has passed
        obstacleManager.update(deltaTime: 2.0, currentScore: 0)
        
        // When: Spawning multiple obstacles
        obstacleManager.update(deltaTime: 2.6, currentScore: 0)
        obstacleManager.update(deltaTime: 2.6, currentScore: 0)
        obstacleManager.update(deltaTime: 2.6, currentScore: 0)
        
        // Then: Obstacles should have different gap centers (with high probability)
        let obstacles = obstacleManager.getActiveObstacles()
        let gapCenters = obstacles.map { $0.gapCenterY }
        
        // At least one should be different (very high probability with random values)
        let uniqueGapCenters = Set(gapCenters)
        XCTAssertGreaterThan(uniqueGapCenters.count, 1, "Obstacles should have varying gap centers")
    }
    
    // MARK: - Scrolling Tests
    
    func testObstacleScrolling() {
        // Given: An obstacle has been spawned
        obstacleManager.update(deltaTime: 2.0, currentScore: 0)
        obstacleManager.update(deltaTime: 2.6, currentScore: 0)
        
        let obstacle = obstacleManager.getActiveObstacles().first!
        let initialX = obstacle.position.x
        
        // When: Updating with time delta
        obstacleManager.update(deltaTime: 1.0, currentScore: 0)
        
        // Then: Obstacle should move left
        XCTAssertLessThan(obstacle.position.x, initialX, "Obstacle should move left")
    }
    
    func testObstacleScrollingSpeed() {
        // Given: An obstacle has been spawned
        obstacleManager.update(deltaTime: 2.0, currentScore: 0)
        obstacleManager.update(deltaTime: 2.6, currentScore: 0)
        
        let obstacle = obstacleManager.getActiveObstacles().first!
        let initialX = obstacle.position.x
        
        // When: Updating with 1 second delta
        obstacleManager.update(deltaTime: 1.0, currentScore: 0)
        
        // Then: Obstacle should move by scroll speed (150 at score 0)
        let expectedX = initialX - 150
        XCTAssertEqual(obstacle.position.x, expectedX, accuracy: 0.1, "Obstacle should move at correct speed")
    }
    
    func testMultipleObstaclesScrollTogether() {
        // Given: Multiple obstacles have been spawned
        obstacleManager.update(deltaTime: 2.0, currentScore: 0)
        obstacleManager.update(deltaTime: 2.6, currentScore: 0)
        obstacleManager.update(deltaTime: 2.6, currentScore: 0)
        
        let obstacles = obstacleManager.getActiveObstacles()
        let initialPositions = obstacles.map { $0.position.x }
        
        // When: Updating with time delta
        obstacleManager.update(deltaTime: 1.0, currentScore: 0)
        
        // Then: All obstacles should move left by same amount
        for (index, obstacle) in obstacles.enumerated() {
            let expectedX = initialPositions[index] - 150
            XCTAssertEqual(obstacle.position.x, expectedX, accuracy: 0.1, "All obstacles should scroll at same speed")
        }
    }
    
    // MARK: - Offscreen Removal Tests
    
    func testRemoveOffscreenObstacles() {
        // Given: An obstacle has been spawned and moved offscreen
        obstacleManager.update(deltaTime: 2.0, currentScore: 0)
        obstacleManager.update(deltaTime: 2.6, currentScore: 0)
        
        let obstacle = obstacleManager.getActiveObstacles().first!
        obstacle.position.x = -100 // Move offscreen
        
        // When: Updating
        obstacleManager.update(deltaTime: 0.1, currentScore: 0)
        
        // Then: Obstacle should be removed
        XCTAssertEqual(obstacleManager.getActiveObstacles().count, 0, "Offscreen obstacle should be removed")
        XCTAssertEqual(testScene.children.count, 0, "Offscreen obstacle should be removed from scene")
    }
    
    func testOffscreenObstacleReturnedToPool() {
        // Given: An obstacle has been spawned and moved offscreen
        obstacleManager.update(deltaTime: 2.0, currentScore: 0)
        obstacleManager.update(deltaTime: 2.6, currentScore: 0)
        
        let obstacle = obstacleManager.getActiveObstacles().first!
        obstacle.position.x = -100
        
        // When: Removing offscreen obstacle
        obstacleManager.update(deltaTime: 0.1, currentScore: 0)
        
        // Then: Obstacle should be reset (hasBeenPassed should be false)
        XCTAssertFalse(obstacle.hasBeenPassed, "Pooled obstacle should be reset")
        XCTAssertEqual(obstacle.position, .zero, "Pooled obstacle position should be reset")
    }
    
    func testKeepOnscreenObstacles() {
        // Given: An obstacle has been spawned but is still onscreen
        obstacleManager.update(deltaTime: 2.0, currentScore: 0)
        obstacleManager.update(deltaTime: 2.6, currentScore: 0)
        
        let obstacle = obstacleManager.getActiveObstacles().first!
        obstacle.position.x = 100 // Keep onscreen
        
        // When: Updating
        obstacleManager.update(deltaTime: 0.1, currentScore: 0)
        
        // Then: Obstacle should remain
        XCTAssertEqual(obstacleManager.getActiveObstacles().count, 1, "Onscreen obstacle should remain")
    }
    
    // MARK: - Object Pooling Tests
    
    func testObjectPoolingReusesObstacles() {
        // Given: Spawn and remove an obstacle
        obstacleManager.update(deltaTime: 2.0, currentScore: 0)
        obstacleManager.update(deltaTime: 2.6, currentScore: 0)
        
        let firstObstacle = obstacleManager.getActiveObstacles().first!
        let firstObstacleReference = Unmanaged.passUnretained(firstObstacle).toOpaque()
        
        firstObstacle.position.x = -100
        obstacleManager.update(deltaTime: 0.1, currentScore: 0)
        
        // When: Spawning a new obstacle
        obstacleManager.update(deltaTime: 2.6, currentScore: 0)
        
        // Then: Should reuse the same obstacle instance
        let secondObstacle = obstacleManager.getActiveObstacles().first!
        let secondObstacleReference = Unmanaged.passUnretained(secondObstacle).toOpaque()
        
        XCTAssertEqual(firstObstacleReference, secondObstacleReference, "Should reuse obstacle from pool")
    }
    
    // MARK: - Difficulty Progression Tests
    
    func testDifficultyAtScore0to10() {
        // When: Score is 0-10
        obstacleManager.update(deltaTime: 2.0, currentScore: 5)
        obstacleManager.update(deltaTime: 2.6, currentScore: 5)
        
        // Then: Should use easy difficulty
        let obstacle = obstacleManager.getActiveObstacles().first!
        XCTAssertEqual(obstacle.gapSize, 200, "Gap size should be 200 for score 0-10")
        
        // Test scroll speed by measuring movement
        let initialX = obstacle.position.x
        obstacleManager.update(deltaTime: 1.0, currentScore: 5)
        let movedDistance = initialX - obstacle.position.x
        XCTAssertEqual(movedDistance, 150, accuracy: 0.1, "Scroll speed should be 150 for score 0-10")
    }
    
    func testDifficultyAtScore11to25() {
        // When: Score is 11-25
        obstacleManager.update(deltaTime: 2.0, currentScore: 15)
        obstacleManager.update(deltaTime: 2.6, currentScore: 15)
        
        // Then: Should use medium difficulty
        let obstacle = obstacleManager.getActiveObstacles().first!
        XCTAssertEqual(obstacle.gapSize, 160, "Gap size should be 160 for score 11-25")
        
        let initialX = obstacle.position.x
        obstacleManager.update(deltaTime: 1.0, currentScore: 15)
        let movedDistance = initialX - obstacle.position.x
        XCTAssertEqual(movedDistance, 200, accuracy: 0.1, "Scroll speed should be 200 for score 11-25")
    }
    
    func testDifficultyAtScore26to50() {
        // When: Score is 26-50
        obstacleManager.update(deltaTime: 2.0, currentScore: 35)
        obstacleManager.update(deltaTime: 2.6, currentScore: 35)
        
        // Then: Should use hard difficulty
        let obstacle = obstacleManager.getActiveObstacles().first!
        XCTAssertEqual(obstacle.gapSize, 130, "Gap size should be 130 for score 26-50")
        
        let initialX = obstacle.position.x
        obstacleManager.update(deltaTime: 1.0, currentScore: 35)
        let movedDistance = initialX - obstacle.position.x
        XCTAssertEqual(movedDistance, 250, accuracy: 0.1, "Scroll speed should be 250 for score 26-50")
    }
    
    func testDifficultyAtScore51Plus() {
        // When: Score is 51+
        obstacleManager.update(deltaTime: 2.0, currentScore: 60)
        obstacleManager.update(deltaTime: 2.6, currentScore: 60)
        
        // Then: Should use very hard difficulty
        let obstacle = obstacleManager.getActiveObstacles().first!
        XCTAssertEqual(obstacle.gapSize, 110, "Gap size should be 110 for score 51+")
        
        let initialX = obstacle.position.x
        obstacleManager.update(deltaTime: 1.0, currentScore: 60)
        let movedDistance = initialX - obstacle.position.x
        XCTAssertEqual(movedDistance, 300, accuracy: 0.1, "Scroll speed should be 300 for score 51+")
    }
    
    func testDifficultyTransitionBoundaries() {
        // Test boundary at score 10->11
        obstacleManager.update(deltaTime: 2.0, currentScore: 10)
        obstacleManager.update(deltaTime: 2.6, currentScore: 10)
        var obstacle = obstacleManager.getActiveObstacles().first!
        XCTAssertEqual(obstacle.gapSize, 200, "Gap size should be 200 at score 10")
        
        obstacleManager.reset()
        
        obstacleManager.update(deltaTime: 2.0, currentScore: 11)
        obstacleManager.update(deltaTime: 2.6, currentScore: 11)
        obstacle = obstacleManager.getActiveObstacles().first!
        XCTAssertEqual(obstacle.gapSize, 160, "Gap size should be 160 at score 11")
    }
    
    // MARK: - Reset Tests
    
    func testReset() {
        // Given: Multiple obstacles have been spawned
        obstacleManager.update(deltaTime: 2.0, currentScore: 0)
        obstacleManager.update(deltaTime: 2.6, currentScore: 0)
        obstacleManager.update(deltaTime: 2.6, currentScore: 0)
        
        // When: Resetting
        obstacleManager.reset()
        
        // Then: All obstacles should be removed
        XCTAssertEqual(obstacleManager.getActiveObstacles().count, 0, "All obstacles should be removed")
        XCTAssertEqual(testScene.children.count, 0, "Scene should have no children")
    }
    
    func testResetRestoresInitialDifficulty() {
        // Given: Difficulty has increased
        obstacleManager.update(deltaTime: 2.0, currentScore: 50)
        obstacleManager.update(deltaTime: 2.6, currentScore: 50)
        
        // When: Resetting
        obstacleManager.reset()
        
        // Then: Difficulty should be reset to initial values
        obstacleManager.update(deltaTime: 2.0, currentScore: 0)
        obstacleManager.update(deltaTime: 2.6, currentScore: 0)
        
        let obstacle = obstacleManager.getActiveObstacles().first!
        XCTAssertEqual(obstacle.gapSize, 200, "Gap size should be reset to 200")
        
        let initialX = obstacle.position.x
        obstacleManager.update(deltaTime: 1.0, currentScore: 0)
        let movedDistance = initialX - obstacle.position.x
        XCTAssertEqual(movedDistance, 150, accuracy: 0.1, "Scroll speed should be reset to 150")
    }
    
    func testResetRestoresInitialDelay() {
        // Given: Initial delay has passed
        obstacleManager.update(deltaTime: 2.0, currentScore: 0)
        obstacleManager.update(deltaTime: 2.6, currentScore: 0)
        
        // When: Resetting
        obstacleManager.reset()
        
        // Then: Initial delay should be restored
        obstacleManager.update(deltaTime: 1.0, currentScore: 0)
        XCTAssertEqual(obstacleManager.getActiveObstacles().count, 0, "No obstacles should spawn before initial delay")
    }
    
    // MARK: - Edge Case Tests
    
    func testUpdateWithZeroDeltaTime() {
        // Given: Initial delay has passed
        obstacleManager.update(deltaTime: 2.0, currentScore: 0)
        obstacleManager.update(deltaTime: 2.6, currentScore: 0)
        
        let obstacle = obstacleManager.getActiveObstacles().first!
        let initialX = obstacle.position.x
        
        // When: Updating with zero delta time
        obstacleManager.update(deltaTime: 0.0, currentScore: 0)
        
        // Then: Obstacle should not move
        XCTAssertEqual(obstacle.position.x, initialX, "Obstacle should not move with zero delta time")
    }
    
    func testUpdateWithVerySmallDeltaTime() {
        // Given: Initial delay has passed
        obstacleManager.update(deltaTime: 2.0, currentScore: 0)
        obstacleManager.update(deltaTime: 2.6, currentScore: 0)
        
        let obstacle = obstacleManager.getActiveObstacles().first!
        let initialX = obstacle.position.x
        
        // When: Updating with very small delta time
        obstacleManager.update(deltaTime: 0.001, currentScore: 0)
        
        // Then: Obstacle should move very slightly
        let expectedX = initialX - (150 * 0.001)
        XCTAssertEqual(obstacle.position.x, expectedX, accuracy: 0.01, "Obstacle should move slightly")
    }
    
    func testSpawnIntervalAccumulation() {
        // Given: Initial delay has passed
        obstacleManager.update(deltaTime: 2.0, currentScore: 0)
        
        // When: Updating with small increments that accumulate to spawn interval
        obstacleManager.update(deltaTime: 1.0, currentScore: 0)
        XCTAssertEqual(obstacleManager.getActiveObstacles().count, 0, "Should not spawn yet")
        
        obstacleManager.update(deltaTime: 1.0, currentScore: 0)
        XCTAssertEqual(obstacleManager.getActiveObstacles().count, 0, "Should not spawn yet")
        
        obstacleManager.update(deltaTime: 0.6, currentScore: 0)
        
        // Then: Obstacle should spawn after accumulation
        XCTAssertEqual(obstacleManager.getActiveObstacles().count, 1, "Should spawn after accumulated time")
    }
    
    func testMaximumActiveObstacles() {
        // Given: Initial delay has passed
        obstacleManager.update(deltaTime: 2.0, currentScore: 0)
        
        // When: Spawning many obstacles
        for _ in 0..<10 {
            obstacleManager.update(deltaTime: 2.6, currentScore: 0)
        }
        
        // Then: Should be able to spawn multiple obstacles
        XCTAssertEqual(obstacleManager.getActiveObstacles().count, 10, "Should support multiple active obstacles")
    }
}
