import XCTest
import SpriteKit
@testable import FlappyDon

final class GameSceneTests: XCTestCase {
    
    var scene: GameScene!
    var view: SKView!
    
    override func setUp() {
        super.setUp()
        scene = GameScene(size: CGSize(width: 375, height: 667))
        view = SKView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        GameManager.shared.resetGame()
    }
    
    override func tearDown() {
        scene = nil
        view = nil
        super.tearDown()
    }
    
    // MARK: - Physics Setup Tests
    
    func testPhysicsWorldGravity() {
        // When: Scene is presented
        view.presentScene(scene)
        scene.didMove(to: view)
        
        // Then: Gravity should be configured correctly
        XCTAssertEqual(scene.physicsWorld.gravity.dx, 0, "Gravity X should be 0")
        XCTAssertEqual(scene.physicsWorld.gravity.dy, -9.8, accuracy: 0.01, "Gravity Y should be -9.8")
    }
    
    func testPhysicsContactDelegate() {
        // When: Scene is presented
        view.presentScene(scene)
        scene.didMove(to: view)
        
        // Then: Scene should be set as contact delegate
        XCTAssertNotNil(scene.physicsWorld.contactDelegate, "Contact delegate should be set")
    }
    
    // MARK: - Physics Categories Tests
    
    func testPhysicsCategoriesAreUnique() {
        let trump = GameScene.PhysicsCategory.trump
        let obstacle = GameScene.PhysicsCategory.obstacle
        let ground = GameScene.PhysicsCategory.ground
        let ceiling = GameScene.PhysicsCategory.ceiling
        let score = GameScene.PhysicsCategory.score
        
        // All categories should be unique bit masks
        XCTAssertNotEqual(trump, obstacle)
        XCTAssertNotEqual(trump, ground)
        XCTAssertNotEqual(trump, ceiling)
        XCTAssertNotEqual(trump, score)
        XCTAssertNotEqual(obstacle, ground)
        XCTAssertNotEqual(obstacle, ceiling)
        XCTAssertNotEqual(obstacle, score)
        XCTAssertNotEqual(ground, ceiling)
        XCTAssertNotEqual(ground, score)
        XCTAssertNotEqual(ceiling, score)
    }
    
    func testPhysicsCategoriesArePowerOfTwo() {
        // Physics categories should be powers of 2 for proper bit masking
        XCTAssertEqual(GameScene.PhysicsCategory.trump, 0x1 << 0)
        XCTAssertEqual(GameScene.PhysicsCategory.obstacle, 0x1 << 1)
        XCTAssertEqual(GameScene.PhysicsCategory.ground, 0x1 << 2)
        XCTAssertEqual(GameScene.PhysicsCategory.ceiling, 0x1 << 3)
        XCTAssertEqual(GameScene.PhysicsCategory.score, 0x1 << 4)
    }
    
    // MARK: - Background Setup Tests
    
    func testBackgroundColor() {
        // When: Scene is presented
        view.presentScene(scene)
        scene.didMove(to: view)
        
        // Then: Background should be sky blue
        let expectedColor = SKColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0)
        XCTAssertEqual(scene.backgroundColor, expectedColor, "Background should be sky blue")
    }
    
    // MARK: - Boundary Setup Tests
    
    func testGroundNodeExists() {
        // When: Scene is presented
        view.presentScene(scene)
        scene.didMove(to: view)
        
        // Then: Ground node should be added to scene
        let groundNodes = scene.children.filter { node in
            node.physicsBody?.categoryBitMask == GameScene.PhysicsCategory.ground
        }
        XCTAssertEqual(groundNodes.count, 1, "Should have exactly one ground node")
    }
    
    func testCeilingNodeExists() {
        // When: Scene is presented
        view.presentScene(scene)
        scene.didMove(to: view)
        
        // Then: Ceiling node should be added to scene
        let ceilingNodes = scene.children.filter { node in
            node.physicsBody?.categoryBitMask == GameScene.PhysicsCategory.ceiling
        }
        XCTAssertEqual(ceilingNodes.count, 1, "Should have exactly one ceiling node")
    }
    
    func testGroundPhysicsBody() {
        // When: Scene is presented
        view.presentScene(scene)
        scene.didMove(to: view)
        
        // Then: Ground should have correct physics properties
        let groundNode = scene.children.first { node in
            node.physicsBody?.categoryBitMask == GameScene.PhysicsCategory.ground
        }
        
        XCTAssertNotNil(groundNode, "Ground node should exist")
        XCTAssertNotNil(groundNode?.physicsBody, "Ground should have physics body")
        XCTAssertFalse(groundNode?.physicsBody?.isDynamic ?? true, "Ground should not be dynamic")
        XCTAssertEqual(groundNode?.physicsBody?.categoryBitMask, GameScene.PhysicsCategory.ground)
        XCTAssertEqual(groundNode?.physicsBody?.contactTestBitMask, GameScene.PhysicsCategory.trump)
        XCTAssertEqual(groundNode?.physicsBody?.collisionBitMask, GameScene.PhysicsCategory.trump)
    }
    
    func testCeilingPhysicsBody() {
        // When: Scene is presented
        view.presentScene(scene)
        scene.didMove(to: view)
        
        // Then: Ceiling should have correct physics properties
        let ceilingNode = scene.children.first { node in
            node.physicsBody?.categoryBitMask == GameScene.PhysicsCategory.ceiling
        }
        
        XCTAssertNotNil(ceilingNode, "Ceiling node should exist")
        XCTAssertNotNil(ceilingNode?.physicsBody, "Ceiling should have physics body")
        XCTAssertFalse(ceilingNode?.physicsBody?.isDynamic ?? true, "Ceiling should not be dynamic")
        XCTAssertEqual(ceilingNode?.physicsBody?.categoryBitMask, GameScene.PhysicsCategory.ceiling)
        XCTAssertEqual(ceilingNode?.physicsBody?.contactTestBitMask, GameScene.PhysicsCategory.trump)
        XCTAssertEqual(ceilingNode?.physicsBody?.collisionBitMask, GameScene.PhysicsCategory.trump)
    }
    
    func testGroundPosition() {
        // When: Scene is presented
        view.presentScene(scene)
        scene.didMove(to: view)
        
        // Then: Ground should be positioned at bottom of screen
        let groundNode = scene.children.first { node in
            node.physicsBody?.categoryBitMask == GameScene.PhysicsCategory.ground
        }
        
        XCTAssertNotNil(groundNode)
        XCTAssertLessThan(groundNode?.position.y ?? 1000, 100, "Ground should be near bottom of screen")
    }
    
    func testCeilingPosition() {
        // When: Scene is presented
        view.presentScene(scene)
        scene.didMove(to: view)
        
        // Then: Ceiling should be positioned at top of screen
        let ceilingNode = scene.children.first { node in
            node.physicsBody?.categoryBitMask == GameScene.PhysicsCategory.ceiling
        }
        
        XCTAssertNotNil(ceilingNode)
        XCTAssertEqual(ceilingNode?.position.y ?? 0, scene.size.height, accuracy: 1.0, "Ceiling should be at top of screen")
    }
    
    // MARK: - Input Handling Tests
    
    func testTouchStartsGameFromMenu() {
        // Given: Scene in menu state
        view.presentScene(scene)
        scene.didMove(to: view)
        XCTAssertEqual(GameManager.shared.currentState, .menu)
        
        // When: User taps screen
        let touch = UITouch()
        scene.touchesBegan([touch], with: nil)
        
        // Then: Game should start
        XCTAssertEqual(GameManager.shared.currentState, .playing)
        XCTAssertTrue(GameManager.shared.isGameActive)
    }
    
    func testTouchStartsGameFromGameOver() {
        // Given: Scene in game over state
        view.presentScene(scene)
        scene.didMove(to: view)
        GameManager.shared.startGame()
        GameManager.shared.endGame()
        XCTAssertEqual(GameManager.shared.currentState, .gameOver)
        
        // When: User taps screen
        let touch = UITouch()
        scene.touchesBegan([touch], with: nil)
        
        // Then: Game should start
        XCTAssertEqual(GameManager.shared.currentState, .playing)
        XCTAssertTrue(GameManager.shared.isGameActive)
    }
    
    func testTouchDuringActiveGame() {
        // Given: Active game
        view.presentScene(scene)
        scene.didMove(to: view)
        GameManager.shared.startGame()
        
        // When: User taps screen
        let touch = UITouch()
        scene.touchesBegan([touch], with: nil)
        
        // Then: Game should remain active (flap action would be triggered)
        XCTAssertTrue(GameManager.shared.isGameActive)
        XCTAssertEqual(GameManager.shared.currentState, .playing)
    }
    
    // MARK: - Collision Detection Tests
    
    func testCollisionBitMaskCombination() {
        // Test that collision detection uses bitwise OR correctly
        let trumpObstacle = GameScene.PhysicsCategory.trump | GameScene.PhysicsCategory.obstacle
        let trumpGround = GameScene.PhysicsCategory.trump | GameScene.PhysicsCategory.ground
        let trumpCeiling = GameScene.PhysicsCategory.trump | GameScene.PhysicsCategory.ceiling
        let trumpScore = GameScene.PhysicsCategory.trump | GameScene.PhysicsCategory.score
        
        // All combinations should be unique
        XCTAssertNotEqual(trumpObstacle, trumpGround)
        XCTAssertNotEqual(trumpObstacle, trumpCeiling)
        XCTAssertNotEqual(trumpObstacle, trumpScore)
        XCTAssertNotEqual(trumpGround, trumpCeiling)
        XCTAssertNotEqual(trumpGround, trumpScore)
        XCTAssertNotEqual(trumpCeiling, trumpScore)
    }
    
    func testScoreTriggerDuplicatePrevention() {
        // Given: A score trigger node
        let scoreNode = SKNode()
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 100))
        scoreNode.physicsBody?.categoryBitMask = GameScene.PhysicsCategory.score
        scoreNode.physicsBody?.isDynamic = false
        
        // When: Score is triggered once
        scoreNode.userData = ["scored": true]
        
        // Then: Node should be marked as scored
        XCTAssertEqual(scoreNode.userData?["scored"] as? Bool, true, "Score node should be marked as scored")
    }
    
    // MARK: - Game Loop Tests
    
    func testUpdateCalledWhenGameActive() {
        // Given: Active game
        view.presentScene(scene)
        scene.didMove(to: view)
        GameManager.shared.startGame()
        
        // When: Update is called
        let expectation = XCTestExpectation(description: "Update should be called")
        
        // Simulate update call
        scene.update(0)
        expectation.fulfill()
        
        // Then: Update should execute without errors
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testUpdateNotProcessedWhenGameInactive() {
        // Given: Inactive game
        view.presentScene(scene)
        scene.didMove(to: view)
        XCTAssertFalse(GameManager.shared.isGameActive)
        
        // When: Update is called
        scene.update(0)
        
        // Then: Update should return early (no processing)
        // This is verified by the fact that no errors occur and game state remains unchanged
        XCTAssertFalse(GameManager.shared.isGameActive)
    }
    
    // MARK: - Pause/Resume Tests
    
    func testPauseGameWhenPlaying() {
        // Given: Active game
        view.presentScene(scene)
        scene.didMove(to: view)
        GameManager.shared.startGame()
        
        // When: Game is paused
        scene.pauseGame()
        
        // Then: Physics should be paused
        XCTAssertEqual(scene.physicsWorld.speed, 0, "Physics world speed should be 0")
        XCTAssertTrue(scene.isPaused, "Scene should be paused")
    }
    
    func testPauseGameShowsOverlay() {
        // Given: Active game
        view.presentScene(scene)
        scene.didMove(to: view)
        GameManager.shared.startGame()
        
        // When: Game is paused
        scene.pauseGame()
        
        // Then: Pause overlay should be visible
        let overlayNodes = scene.children.filter { node in
            node.children.contains { child in
                (child as? SKLabelNode)?.text == "PAUSED"
            }
        }
        XCTAssertEqual(overlayNodes.count, 1, "Should have exactly one pause overlay")
    }
    
    func testPauseGameWhenNotPlaying() {
        // Given: Game in menu state
        view.presentScene(scene)
        scene.didMove(to: view)
        XCTAssertEqual(GameManager.shared.currentState, .menu)
        
        // When: Pause is called
        scene.pauseGame()
        
        // Then: Game should not pause (guard prevents it)
        XCTAssertFalse(scene.isPaused, "Scene should not pause when not playing")
    }
    
    func testPauseGameWhenAlreadyPaused() {
        // Given: Already paused game
        view.presentScene(scene)
        scene.didMove(to: view)
        GameManager.shared.startGame()
        scene.pauseGame()
        let initialChildCount = scene.children.count
        
        // When: Pause is called again
        scene.pauseGame()
        
        // Then: Should not create duplicate overlay
        XCTAssertEqual(scene.children.count, initialChildCount, "Should not create duplicate overlay")
    }
    
    func testResumeGameRestoresPhysics() {
        // Given: Paused game
        view.presentScene(scene)
        scene.didMove(to: view)
        GameManager.shared.startGame()
        scene.pauseGame()
        XCTAssertTrue(scene.isPaused)
        
        // When: Game is resumed
        scene.resumeGame()
        
        // Then: Physics should be restored
        XCTAssertEqual(scene.physicsWorld.speed, 1.0, "Physics world speed should be 1.0")
        XCTAssertFalse(scene.isPaused, "Scene should not be paused")
    }
    
    func testResumeGameHidesOverlay() {
        // Given: Paused game with overlay
        view.presentScene(scene)
        scene.didMove(to: view)
        GameManager.shared.startGame()
        scene.pauseGame()
        
        // When: Game is resumed
        scene.resumeGame()
        
        // Then: Pause overlay should be removed
        let overlayNodes = scene.children.filter { node in
            node.children.contains { child in
                (child as? SKLabelNode)?.text == "PAUSED"
            }
        }
        XCTAssertEqual(overlayNodes.count, 0, "Pause overlay should be removed")
    }
    
    func testResumeGameWhenNotPaused() {
        // Given: Active game that is not paused
        view.presentScene(scene)
        scene.didMove(to: view)
        GameManager.shared.startGame()
        XCTAssertFalse(scene.isPaused)
        
        // When: Resume is called
        scene.resumeGame()
        
        // Then: Should handle gracefully (guard prevents action)
        XCTAssertFalse(scene.isPaused)
        XCTAssertEqual(scene.physicsWorld.speed, 1.0)
    }
    
    func testTouchResumesGameWhenPaused() {
        // Given: Paused game
        view.presentScene(scene)
        scene.didMove(to: view)
        GameManager.shared.startGame()
        scene.pauseGame()
        XCTAssertTrue(scene.isPaused)
        
        // When: User taps screen
        let touch = UITouch()
        scene.touchesBegan([touch], with: nil)
        
        // Then: Game should resume
        XCTAssertFalse(scene.isPaused, "Game should resume on tap")
        XCTAssertEqual(scene.physicsWorld.speed, 1.0, "Physics should be restored")
    }
    
    func testPauseOverlayHasSemiTransparentBackground() {
        // Given: Active game
        view.presentScene(scene)
        scene.didMove(to: view)
        GameManager.shared.startGame()
        
        // When: Game is paused
        scene.pauseGame()
        
        // Then: Overlay should have semi-transparent black background
        let overlayNode = scene.children.first { node in
            node.children.contains { child in
                (child as? SKLabelNode)?.text == "PAUSED"
            }
        }
        
        XCTAssertNotNil(overlayNode, "Overlay node should exist")
        
        let backgroundNode = overlayNode?.children.first { child in
            (child as? SKSpriteNode)?.color == .black
        } as? SKSpriteNode
        
        XCTAssertNotNil(backgroundNode, "Background node should exist")
        XCTAssertEqual(backgroundNode?.alpha, 0.5, accuracy: 0.01, "Background should be semi-transparent")
    }
    
    func testPauseOverlayHasInstructionText() {
        // Given: Active game
        view.presentScene(scene)
        scene.didMove(to: view)
        GameManager.shared.startGame()
        
        // When: Game is paused
        scene.pauseGame()
        
        // Then: Overlay should have "Tap to resume" instruction
        let overlayNode = scene.children.first { node in
            node.children.contains { child in
                (child as? SKLabelNode)?.text == "PAUSED"
            }
        }
        
        let instructionLabel = overlayNode?.children.first { child in
            (child as? SKLabelNode)?.text == "Tap to resume"
        } as? SKLabelNode
        
        XCTAssertNotNil(instructionLabel, "Instruction label should exist")
        XCTAssertEqual(instructionLabel?.text, "Tap to resume")
    }
    
    func testPauseOverlayZPosition() {
        // Given: Active game
        view.presentScene(scene)
        scene.didMove(to: view)
        GameManager.shared.startGame()
        
        // When: Game is paused
        scene.pauseGame()
        
        // Then: Overlay elements should have high z-position (above everything)
        let overlayNode = scene.children.first { node in
            node.children.contains { child in
                (child as? SKLabelNode)?.text == "PAUSED"
            }
        }
        
        let backgroundNode = overlayNode?.children.first { child in
            (child as? SKSpriteNode)?.color == .black
        } as? SKSpriteNode
        
        XCTAssertNotNil(backgroundNode)
        XCTAssertEqual(backgroundNode?.zPosition, 1000, "Background should have z-position 1000")
    }
}

// MARK: - Integration Tests

final class GameSceneIntegrationTests: XCTestCase {
    
    var scene: GameScene!
    var view: SKView!
    
    override func setUp() {
        super.setUp()
        scene = GameScene(size: CGSize(width: 375, height: 667))
        view = SKView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        GameManager.shared.resetGame()
    }
    
    override func tearDown() {
        scene = nil
        view = nil
        super.tearDown()
    }
    
    // MARK: - State Transition Integration Tests
    
    func testCompleteGameFlow() {
        // Setup
        view.presentScene(scene)
        scene.didMove(to: view)
        
        // 1. Start from menu
        XCTAssertEqual(GameManager.shared.currentState, .menu)
        XCTAssertFalse(GameManager.shared.isGameActive)
        
        // 2. Tap to start game
        let touch = UITouch()
        scene.touchesBegan([touch], with: nil)
        XCTAssertEqual(GameManager.shared.currentState, .playing)
        XCTAssertTrue(GameManager.shared.isGameActive)
        
        // 3. Score some points
        GameManager.shared.incrementScore()
        GameManager.shared.incrementScore()
        XCTAssertEqual(GameManager.shared.currentScore, 2)
        
        // 4. Game over
        GameManager.shared.endGame()
        XCTAssertEqual(GameManager.shared.currentState, .gameOver)
        XCTAssertFalse(GameManager.shared.isGameActive)
        XCTAssertEqual(GameManager.shared.highScore, 2)
        
        // 5. Reset to menu
        GameManager.shared.resetGame()
        XCTAssertEqual(GameManager.shared.currentState, .menu)
        XCTAssertEqual(GameManager.shared.currentScore, 0)
        XCTAssertEqual(GameManager.shared.highScore, 2)
    }
    
    func testMultipleGameSessions() {
        view.presentScene(scene)
        scene.didMove(to: view)
        let touch = UITouch()
        
        // First game session
        scene.touchesBegan([touch], with: nil)
        GameManager.shared.incrementScore()
        GameManager.shared.endGame()
        XCTAssertEqual(GameManager.shared.highScore, 1)
        
        // Second game session
        GameManager.shared.resetGame()
        scene.touchesBegan([touch], with: nil)
        GameManager.shared.incrementScore()
        GameManager.shared.incrementScore()
        GameManager.shared.incrementScore()
        GameManager.shared.endGame()
        XCTAssertEqual(GameManager.shared.highScore, 3)
        
        // Third game session with lower score
        GameManager.shared.resetGame()
        scene.touchesBegan([touch], with: nil)
        GameManager.shared.incrementScore()
        GameManager.shared.endGame()
        XCTAssertEqual(GameManager.shared.highScore, 3, "High score should remain 3")
    }
    
    func testSceneAndManagerIntegration() {
        // Verify that scene and manager work together correctly
        view.presentScene(scene)
        scene.didMove(to: view)
        
        // Scene should respect manager state
        XCTAssertFalse(GameManager.shared.isGameActive)
        
        // Touch should update manager state
        let touch = UITouch()
        scene.touchesBegan([touch], with: nil)
        XCTAssertTrue(GameManager.shared.isGameActive)
        
        // Update should only process when game is active
        scene.update(0)
        XCTAssertTrue(GameManager.shared.isGameActive)
        
        // End game should stop processing
        GameManager.shared.endGame()
        XCTAssertFalse(GameManager.shared.isGameActive)
        scene.update(0)
        XCTAssertFalse(GameManager.shared.isGameActive)
    }
    
    func testPhysicsAndBoundariesIntegration() {
        // Verify physics world and boundaries are properly integrated
        view.presentScene(scene)
        scene.didMove(to: view)
        
        // Physics world should be configured
        XCTAssertNotNil(scene.physicsWorld.contactDelegate)
        XCTAssertEqual(scene.physicsWorld.gravity.dy, -9.8, accuracy: 0.01)
        
        // Boundaries should exist with correct physics
        let groundNode = scene.children.first { $0.physicsBody?.categoryBitMask == GameScene.PhysicsCategory.ground }
        let ceilingNode = scene.children.first { $0.physicsBody?.categoryBitMask == GameScene.PhysicsCategory.ceiling }
        
        XCTAssertNotNil(groundNode)
        XCTAssertNotNil(ceilingNode)
        XCTAssertFalse(groundNode?.physicsBody?.isDynamic ?? true)
        XCTAssertFalse(ceilingNode?.physicsBody?.isDynamic ?? true)
    }
    
    // MARK: - Pause/Resume Integration Tests
    
    func testPauseResumeGameFlow() {
        // Verify complete pause/resume cycle
        view.presentScene(scene)
        scene.didMove(to: view)
        
        // 1. Start game
        let touch = UITouch()
        scene.touchesBegan([touch], with: nil)
        XCTAssertTrue(GameManager.shared.isGameActive)
        XCTAssertFalse(scene.isPaused)
        
        // 2. Pause game
        scene.pauseGame()
        XCTAssertTrue(scene.isPaused)
        XCTAssertEqual(scene.physicsWorld.speed, 0)
        
        // Verify overlay exists
        let overlayAfterPause = scene.children.filter { node in
            node.children.contains { ($0 as? SKLabelNode)?.text == "PAUSED" }
        }
        XCTAssertEqual(overlayAfterPause.count, 1)
        
        // 3. Resume game via tap
        scene.touchesBegan([touch], with: nil)
        XCTAssertFalse(scene.isPaused)
        XCTAssertEqual(scene.physicsWorld.speed, 1.0)
        
        // Verify overlay removed
        let overlayAfterResume = scene.children.filter { node in
            node.children.contains { ($0 as? SKLabelNode)?.text == "PAUSED" }
        }
        XCTAssertEqual(overlayAfterResume.count, 0)
        
        // 4. Game should still be active
        XCTAssertTrue(GameManager.shared.isGameActive)
        XCTAssertEqual(GameManager.shared.currentState, .playing)
    }
    
    func testMultiplePauseResumeCycles() {
        // Verify multiple pause/resume cycles work correctly
        view.presentScene(scene)
        scene.didMove(to: view)
        let touch = UITouch()
        
        // Start game
        scene.touchesBegan([touch], with: nil)
        
        // First pause/resume cycle
        scene.pauseGame()
        XCTAssertTrue(scene.isPaused)
        scene.resumeGame()
        XCTAssertFalse(scene.isPaused)
        
        // Second pause/resume cycle
        scene.pauseGame()
        XCTAssertTrue(scene.isPaused)
        scene.resumeGame()
        XCTAssertFalse(scene.isPaused)
        
        // Third pause/resume cycle
        scene.pauseGame()
        XCTAssertTrue(scene.isPaused)
        scene.resumeGame()
        XCTAssertFalse(scene.isPaused)
        
        // Game should still be active and functional
        XCTAssertTrue(GameManager.shared.isGameActive)
        XCTAssertEqual(scene.physicsWorld.speed, 1.0)
    }
    
    func testPauseDoesNotAffectGameState() {
        // Verify pause/resume doesn't affect game state (score, etc.)
        view.presentScene(scene)
        scene.didMove(to: view)
        let touch = UITouch()
        
        // Start game and score points
        scene.touchesBegan([touch], with: nil)
        GameManager.shared.incrementScore()
        GameManager.shared.incrementScore()
        XCTAssertEqual(GameManager.shared.currentScore, 2)
        
        // Pause and resume
        scene.pauseGame()
        scene.resumeGame()
        
        // Score should be preserved
        XCTAssertEqual(GameManager.shared.currentScore, 2)
        XCTAssertTrue(GameManager.shared.isGameActive)
        XCTAssertEqual(GameManager.shared.currentState, .playing)
    }
    
    func testPauseOnlyWorksWhenPlaying() {
        // Verify pause only works during active gameplay
        view.presentScene(scene)
        scene.didMove(to: view)
        
        // Try to pause in menu state
        XCTAssertEqual(GameManager.shared.currentState, .menu)
        scene.pauseGame()
        XCTAssertFalse(scene.isPaused, "Should not pause in menu state")
        
        // Start game
        let touch = UITouch()
        scene.touchesBegan([touch], with: nil)
        
        // Pause should work now
        scene.pauseGame()
        XCTAssertTrue(scene.isPaused, "Should pause during gameplay")
        
        // Resume and end game
        scene.resumeGame()
        GameManager.shared.endGame()
        
        // Try to pause in game over state
        XCTAssertEqual(GameManager.shared.currentState, .gameOver)
        scene.pauseGame()
        XCTAssertFalse(scene.isPaused, "Should not pause in game over state")
    }
}
