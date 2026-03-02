import XCTest
import SpriteKit
@testable import FlappyDon

final class TrumpNodeIntegrationTests: XCTestCase {
    
    var scene: GameScene!
    var view: SKView!
    var trumpNode: TrumpNode!
    
    override func setUp() {
        super.setUp()
        scene = GameScene(size: CGSize(width: 375, height: 667))
        view = SKView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        GameManager.shared.resetGame()
        
        // Present scene to initialize physics
        view.presentScene(scene)
        scene.didMove(to: view)
        
        // Find trump node in scene
        trumpNode = scene.children.compactMap { $0 as? TrumpNode }.first
    }
    
    override func tearDown() {
        trumpNode = nil
        scene = nil
        view = nil
        super.tearDown()
    }
    
    // MARK: - Scene Integration Tests
    
    func testTrumpNodeExistsInScene() {
        // Then: Trump node should be added to scene
        XCTAssertNotNil(trumpNode, "Trump node should exist in GameScene")
    }
    
    func testTrumpNodeInitialPosition() {
        // Then: Trump should be positioned at left-center of screen
        guard let trump = trumpNode else {
            XCTFail("Trump node should exist")
            return
        }
        
        let expectedX = scene.size.width * 0.25
        let expectedY = scene.size.height * 0.5
        
        XCTAssertEqual(trump.position.x, expectedX, accuracy: 10.0, "Trump X position should be at 25% of screen width")
        XCTAssertEqual(trump.position.y, expectedY, accuracy: 10.0, "Trump Y position should be at 50% of screen height")
    }
    
    func testTrumpNodeZPosition() {
        // Then: Trump should be above background but below UI
        guard let trump = trumpNode else {
            XCTFail("Trump node should exist")
            return
        }
        
        XCTAssertEqual(trump.zPosition, 10, "Trump z-position should be 10")
    }
    
    // MARK: - Physics Integration Tests
    
    func testTrumpNodePhysicsInSceneWorld() {
        // Then: Trump's physics body should be part of scene's physics world
        guard let trump = trumpNode else {
            XCTFail("Trump node should exist")
            return
        }
        
        XCTAssertNotNil(trump.physicsBody, "Trump should have physics body")
        XCTAssertTrue(trump.physicsBody?.isDynamic ?? false, "Trump should be dynamic")
    }
    
    func testTrumpNodeAffectedByGravity() {
        // Given: Trump node in scene with gravity
        guard let trump = trumpNode else {
            XCTFail("Trump node should exist")
            return
        }
        
        let initialY = trump.position.y
        
        // When: Physics simulation runs
        GameManager.shared.startGame()
        for _ in 0..<60 {  // Simulate 1 second at 60fps
            scene.update(1.0/60.0)
        }
        
        // Then: Trump should fall due to gravity
        XCTAssertLessThan(trump.position.y, initialY, "Trump should fall due to gravity")
    }
    
    func testTrumpNodeFlapInPhysicsWorld() {
        // Given: Active game with trump falling
        guard let trump = trumpNode else {
            XCTFail("Trump node should exist")
            return
        }
        
        GameManager.shared.startGame()
        
        // Let trump fall a bit
        for _ in 0..<30 {
            scene.update(1.0/60.0)
        }
        
        let positionBeforeFlap = trump.position.y
        
        // When: Trump flaps
        trump.flap()
        
        // Simulate physics for a short time
        for _ in 0..<10 {
            scene.update(1.0/60.0)
        }
        
        // Then: Trump should move upward
        XCTAssertGreaterThan(trump.position.y, positionBeforeFlap, "Trump should rise after flapping")
    }
    
    func testTrumpNodePhysicsCategoryMatchesScene() {
        // Then: Trump's physics categories should match GameScene categories
        guard let trump = trumpNode else {
            XCTFail("Trump node should exist")
            return
        }
        
        XCTAssertEqual(trump.physicsBody?.categoryBitMask, GameScene.PhysicsCategory.trump, "Trump category should match scene definition")
    }
    
    // MARK: - Collision Integration Tests
    
    func testTrumpNodeCollidesWithGround() {
        // Given: Trump node and ground in scene
        guard let trump = trumpNode else {
            XCTFail("Trump node should exist")
            return
        }
        
        let groundNode = scene.children.first { $0.physicsBody?.categoryBitMask == GameScene.PhysicsCategory.ground }
        XCTAssertNotNil(groundNode, "Ground should exist in scene")
        
        // Then: Trump should be configured to collide with ground
        let groundCategory = GameScene.PhysicsCategory.ground
        XCTAssertTrue((trump.physicsBody?.collisionBitMask ?? 0) & groundCategory != 0, "Trump should collide with ground")
        XCTAssertTrue((trump.physicsBody?.contactTestBitMask ?? 0) & groundCategory != 0, "Trump should test contact with ground")
    }
    
    func testTrumpNodeCollidesWithCeiling() {
        // Given: Trump node and ceiling in scene
        guard let trump = trumpNode else {
            XCTFail("Trump node should exist")
            return
        }
        
        let ceilingNode = scene.children.first { $0.physicsBody?.categoryBitMask == GameScene.PhysicsCategory.ceiling }
        XCTAssertNotNil(ceilingNode, "Ceiling should exist in scene")
        
        // Then: Trump should be configured to collide with ceiling
        let ceilingCategory = GameScene.PhysicsCategory.ceiling
        XCTAssertTrue((trump.physicsBody?.collisionBitMask ?? 0) & ceilingCategory != 0, "Trump should collide with ceiling")
        XCTAssertTrue((trump.physicsBody?.contactTestBitMask ?? 0) & ceilingCategory != 0, "Trump should test contact with ceiling")
    }
    
    func testTrumpNodeContactsWithScore() {
        // Given: Trump node in scene
        guard let trump = trumpNode else {
            XCTFail("Trump node should exist")
            return
        }
        
        // Then: Trump should be configured to detect score triggers
        let scoreCategory = GameScene.PhysicsCategory.score
        XCTAssertTrue((trump.physicsBody?.contactTestBitMask ?? 0) & scoreCategory != 0, "Trump should test contact with score triggers")
        XCTAssertFalse((trump.physicsBody?.collisionBitMask ?? 0) & scoreCategory != 0, "Trump should NOT collide with score triggers")
    }
    
    // MARK: - Game State Integration Tests
    
    func testTrumpNodeFlapStartsGame() {
        // Given: Scene in menu state
        XCTAssertEqual(GameManager.shared.currentState, .menu)
        guard let trump = trumpNode else {
            XCTFail("Trump node should exist")
            return
        }
        
        // When: User taps to flap
        let touch = UITouch()
        scene.touchesBegan([touch], with: nil)
        
        // Then: Game should start and trump should flap
        XCTAssertEqual(GameManager.shared.currentState, .playing)
        XCTAssertTrue(GameManager.shared.isGameActive)
    }
    
    func testTrumpNodeDiesWhenGameEnds() {
        // Given: Active game
        guard let trump = trumpNode else {
            XCTFail("Trump node should exist")
            return
        }
        
        GameManager.shared.startGame()
        XCTAssertEqual(trump.currentState, .idle)
        
        // When: Game ends
        GameManager.shared.endGame()
        
        // Simulate collision that triggers death
        trump.die()
        
        // Then: Trump should be dead
        XCTAssertEqual(trump.currentState, .dead)
    }
    
    func testTrumpNodeResetsWithGame() {
        // Given: Dead trump
        guard let trump = trumpNode else {
            XCTFail("Trump node should exist")
            return
        }
        
        GameManager.shared.startGame()
        trump.die()
        GameManager.shared.endGame()
        XCTAssertEqual(trump.currentState, .dead)
        
        // When: Game resets
        GameManager.shared.resetGame()
        trump.reset()
        
        // Then: Trump should be back to idle
        XCTAssertEqual(trump.currentState, .idle)
        XCTAssertEqual(trump.zRotation, 0, accuracy: 0.01, "Rotation should be reset")
    }
    
    // MARK: - Animation Integration Tests
    
    func testTrumpNodeAnimatesInScene() {
        // Given: Trump node in scene
        guard let trump = trumpNode else {
            XCTFail("Trump node should exist")
            return
        }
        
        // Then: Idle animation should be running
        XCTAssertNotNil(trump.action(forKey: "idleBob"), "Idle animation should be active in scene")
    }
    
    func testTrumpNodeRotationUpdatesInGameLoop() {
        // Given: Active game with trump falling
        guard let trump = trumpNode else {
            XCTFail("Trump node should exist")
            return
        }
        
        GameManager.shared.startGame()
        
        // Let trump fall to build up velocity
        for _ in 0..<30 {
            scene.update(1.0/60.0)
        }
        
        // When: Update rotation is called (should be called in game loop)
        trump.updateRotation()
        
        // Wait for rotation action
        let expectation = XCTestExpectation(description: "Rotation should update")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            // Then: Trump should be rotated based on velocity
            XCTAssertNotEqual(trump.zRotation, 0, "Trump should rotate based on velocity")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    // MARK: - Complete Game Flow Integration Tests
    
    func testCompleteGameFlowWithTrump() {
        // Given: Scene with trump in menu state
        guard let trump = trumpNode else {
            XCTFail("Trump node should exist")
            return
        }
        
        XCTAssertEqual(GameManager.shared.currentState, .menu)
        XCTAssertEqual(trump.currentState, .idle)
        
        // When: Game starts
        let touch = UITouch()
        scene.touchesBegan([touch], with: nil)
        
        // Then: Game is playing
        XCTAssertEqual(GameManager.shared.currentState, .playing)
        
        // When: Trump flaps during game
        trump.flap()
        XCTAssertEqual(trump.currentState, .flapping)
        
        // When: Trump dies
        trump.die()
        GameManager.shared.endGame()
        
        // Then: Game is over and trump is dead
        XCTAssertEqual(GameManager.shared.currentState, .gameOver)
        XCTAssertEqual(trump.currentState, .dead)
        
        // When: Game resets
        GameManager.shared.resetGame()
        trump.reset()
        
        // Then: Back to menu with idle trump
        XCTAssertEqual(GameManager.shared.currentState, .menu)
        XCTAssertEqual(trump.currentState, .idle)
    }
    
    func testTrumpNodeCelebratesOnHighScore() {
        // Given: Trump in scene
        guard let trump = trumpNode else {
            XCTFail("Trump node should exist")
            return
        }
        
        GameManager.shared.startGame()
        
        // When: Player achieves high score
        GameManager.shared.incrementScore()
        GameManager.shared.incrementScore()
        GameManager.shared.incrementScore()
        
        // Trigger celebration
        trump.celebrate()
        
        // Then: Trump should be celebrating
        XCTAssertEqual(trump.currentState, .celebrating)
    }
    
    func testMultipleFlapsInSequence() {
        // Given: Active game
        guard let trump = trumpNode else {
            XCTFail("Trump node should exist")
            return
        }
        
        GameManager.shared.startGame()
        
        // When: Multiple flaps in sequence
        trump.flap()
        
        // Simulate some time
        for _ in 0..<5 {
            scene.update(1.0/60.0)
        }
        
        trump.flap()
        
        for _ in 0..<5 {
            scene.update(1.0/60.0)
        }
        
        trump.flap()
        
        // Then: Trump should still be functional
        XCTAssertNotNil(trump.physicsBody, "Physics body should still exist")
        XCTAssertGreaterThan(trump.physicsBody?.velocity.dy ?? 0, 0, "Should have upward velocity after last flap")
    }
    
    // MARK: - Physics Boundary Integration Tests
    
    func testTrumpNodeStaysBelowCeiling() {
        // Given: Trump flapping repeatedly
        guard let trump = trumpNode else {
            XCTFail("Trump node should exist")
            return
        }
        
        GameManager.shared.startGame()
        
        // When: Trump flaps many times
        for _ in 0..<10 {
            trump.flap()
            for _ in 0..<3 {
                scene.update(1.0/60.0)
            }
        }
        
        // Then: Trump should not exceed ceiling
        XCTAssertLessThan(trump.position.y, scene.size.height, "Trump should not go above ceiling")
    }
    
    func testTrumpNodeStaysAboveGround() {
        // Given: Trump falling
        guard let trump = trumpNode else {
            XCTFail("Trump node should exist")
            return
        }
        
        GameManager.shared.startGame()
        
        // When: Trump falls for extended time
        for _ in 0..<120 {  // 2 seconds
            scene.update(1.0/60.0)
        }
        
        // Then: Trump should not go below ground (ground is at y=0 or slightly above)
        XCTAssertGreaterThan(trump.position.y, -100, "Trump should not fall far below ground")
    }
}
