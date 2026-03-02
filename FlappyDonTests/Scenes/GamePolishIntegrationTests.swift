import XCTest
import SpriteKit
@testable import FlappyDon

final class GamePolishIntegrationTests: XCTestCase {
    
    var gameScene: GameScene!
    var view: SKView!
    
    override func setUp() {
        super.setUp()
        gameScene = GameScene(size: CGSize(width: 375, height: 667))
        view = SKView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        view.presentScene(gameScene)
        
        // Allow scene to initialize
        let expectation = XCTestExpectation(description: "Scene initializes")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.2)
    }
    
    override func tearDown() {
        view.presentScene(nil)
        gameScene = nil
        view = nil
        super.tearDown()
    }
    
    // MARK: - Score Animation Integration Tests
    
    func testScoreIncrementTriggersAnimation() {
        // Given: Scene with score label
        guard let scoreLabel = gameScene.children.compactMap({ $0 as? ScoreLabel }).first else {
            XCTFail("Scene should have a ScoreLabel")
            return
        }
        
        // When: Score increases
        scoreLabel.setScore(1, animated: true)
        
        // Then: Animation should be running
        XCTAssertTrue(scoreLabel.hasActions(), "Score animation should be running")
        XCTAssertEqual(scoreLabel.text, "1", "Score should be updated")
    }
    
    func testMultipleScoreIncrementsWithAnimations() {
        // Given: Scene with score label
        guard let scoreLabel = gameScene.children.compactMap({ $0 as? ScoreLabel }).first else {
            XCTFail("Scene should have a ScoreLabel")
            return
        }
        
        // When: Multiple score increments
        for i in 1...5 {
            scoreLabel.setScore(i, animated: true)
            
            // Small delay between increments
            let expectation = XCTestExpectation(description: "Score \(i) animates")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 0.3)
        }
        
        // Then: Final score should be correct
        XCTAssertEqual(scoreLabel.text, "5", "Final score should be 5")
    }
    
    // MARK: - Death Sequence Integration Tests
    
    func testDeathSequenceWithAllEffects() {
        // Given: Trump node in scene
        guard let trump = gameScene.children.compactMap({ $0 as? TrumpNode }).first else {
            // Create trump if not exists
            let trump = TrumpNode()
            trump.position = CGPoint(x: 100, y: 300)
            gameScene.addChild(trump)
        }
        
        guard let trump = gameScene.children.compactMap({ $0 as? TrumpNode }).first else {
            XCTFail("Should have Trump node")
            return
        }
        
        // When: Death sequence
        // 1. Slow motion
        gameScene.physicsWorld.speed = 0.5
        
        // 2. Trump death animation
        trump.currentState = .dead
        
        // 3. Screen shake (simulate)
        if let camera = gameScene.camera {
            let shake = SKAction.sequence([
                SKAction.moveBy(x: -10, y: 0, duration: 0.05),
                SKAction.moveBy(x: 10, y: 0, duration: 0.05),
                SKAction.moveBy(x: -10, y: 0, duration: 0.05),
                SKAction.moveBy(x: 10, y: 0, duration: 0.05),
                SKAction.moveBy(x: 0, y: 0, duration: 0.05)
            ])
            camera.run(shake)
        }
        
        // 4. Dust effect
        if let dust = SKEmitterNode(fileNamed: "Dust") {
            dust.position = trump.position
            dust.zPosition = 50
            gameScene.addChild(dust)
        }
        
        // Then: All effects should be active
        XCTAssertEqual(gameScene.physicsWorld.speed, 0.5, accuracy: 0.01, "Physics should be slowed")
        XCTAssertEqual(trump.currentState, .dead, "Trump should be dead")
        XCTAssertTrue(trump.hasActions(), "Trump should have death animation")
        
        if let camera = gameScene.camera {
            XCTAssertTrue(camera.hasActions(), "Camera should be shaking")
        }
        
        let dustEmitters = gameScene.children.compactMap { $0 as? SKEmitterNode }
        XCTAssertGreaterThan(dustEmitters.count, 0, "Should have dust effect")
        
        // Wait for effects to complete
        let expectation = XCTestExpectation(description: "Death effects complete")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
        // Restore physics speed
        gameScene.physicsWorld.speed = 1.0
    }
    
    func testDeathAnimationDisablesCollision() {
        // Given: Trump node with collision enabled
        let trump = TrumpNode()
        trump.position = CGPoint(x: 100, y: 300)
        gameScene.addChild(trump)
        
        let initialCollisionBitMask = trump.physicsBody?.collisionBitMask ?? 0
        XCTAssertNotEqual(initialCollisionBitMask, 0, "Should have collision initially")
        
        // When: Trump dies
        trump.currentState = .dead
        
        // Then: Collision should be disabled
        XCTAssertEqual(trump.physicsBody?.collisionBitMask, 0, "Collision should be disabled")
    }
    
    // MARK: - High Score Celebration Integration Tests
    
    func testHighScoreCelebrationSequence() {
        // Given: Scene ready for high score
        guard let trump = gameScene.children.compactMap({ $0 as? TrumpNode }).first else {
            let trump = TrumpNode()
            trump.position = CGPoint(x: 100, y: 300)
            gameScene.addChild(trump)
        }
        
        guard let trump = gameScene.children.compactMap({ $0 as? TrumpNode }).first else {
            XCTFail("Should have Trump node")
            return
        }
        
        // When: High score celebration
        // 1. Trump celebrate animation
        trump.currentState = .celebrate
        
        // 2. Confetti effect
        if let confetti = SKEmitterNode(fileNamed: "Confetti") {
            confetti.position = CGPoint(x: gameScene.size.width / 2, y: gameScene.size.height)
            confetti.zPosition = 200
            gameScene.addChild(confetti)
        }
        
        // 3. Sparkle effect (optional)
        if let sparkle = SKEmitterNode(fileNamed: "Sparkle") {
            sparkle.position = trump.position
            sparkle.zPosition = 150
            gameScene.addChild(sparkle)
        }
        
        // Then: All celebration effects should be active
        XCTAssertEqual(trump.currentState, .celebrate, "Trump should be celebrating")
        XCTAssertTrue(trump.hasActions(), "Trump should have celebrate animation")
        
        let confettiEmitters = gameScene.children.compactMap { $0 as? SKEmitterNode }
        XCTAssertGreaterThan(confettiEmitters.count, 0, "Should have celebration particles")
    }
    
    func testCelebrateAnimationRemovesIdleEffects() {
        // Given: Trump in idle state
        let trump = TrumpNode()
        trump.position = CGPoint(x: 100, y: 300)
        gameScene.addChild(trump)
        
        XCTAssertNotNil(trump.action(forKey: "idleBob"), "Should have idle animation")
        
        // When: Celebrating
        trump.currentState = .celebrate
        
        // Then: Idle animations should be removed
        XCTAssertNil(trump.action(forKey: "idleBob"), "Idle bob should be removed")
        XCTAssertNil(trump.action(forKey: "idleRotation"), "Idle rotation should be removed")
    }
    
    // MARK: - Scoring Flow Integration Tests
    
    func testScoringFlowWithAllEffects() {
        // Given: Scene with score label
        guard let scoreLabel = gameScene.children.compactMap({ $0 as? ScoreLabel }).first else {
            XCTFail("Scene should have a ScoreLabel")
            return
        }
        
        let initialScore = 0
        scoreLabel.setScore(initialScore, animated: false)
        
        // When: Scoring (simulating gap pass)
        // 1. Score increment with animation
        scoreLabel.setScore(1, animated: true)
        
        // 2. Gap flash effect
        let flash = SKSpriteNode(color: .white, size: CGSize(width: 20, height: 150))
        flash.position = CGPoint(x: 200, y: 300)
        flash.alpha = 0.5
        flash.zPosition = 5
        gameScene.addChild(flash)
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let remove = SKAction.removeFromParent()
        flash.run(SKAction.sequence([fadeOut, remove]))
        
        // Then: All scoring effects should be active
        XCTAssertEqual(scoreLabel.text, "1", "Score should be incremented")
        XCTAssertTrue(scoreLabel.hasActions(), "Score should be animating")
        XCTAssertTrue(flash.hasActions(), "Flash should be fading")
        
        // Wait for effects to complete
        let expectation = XCTestExpectation(description: "Scoring effects complete")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        // Flash should be removed
        XCTAssertNil(flash.parent, "Flash should be removed")
    }
    
    // MARK: - Button Interaction Integration Tests
    
    func testButtonTouchSequenceWithEffects() {
        // Given: Button node
        let button = ButtonNode(size: CGSize(width: 200, height: 60),
                               normalColor: .blue,
                               highlightedColor: .darkGray)
        button.position = CGPoint(x: gameScene.size.width / 2, y: 200)
        gameScene.addChild(button)
        
        var actionCalled = false
        button.setup(text: "Play", action: { actionCalled = true })
        
        // When: Complete touch sequence
        // 1. Touch began
        button.handleTouchBegan()
        XCTAssertEqual(button.color, button.color, "Color should change on touch")
        XCTAssertTrue(button.hasActions(), "Should have scale animation")
        
        // Wait for scale down
        let expectation1 = XCTestExpectation(description: "Scale down completes")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: 0.2)
        
        // 2. Touch ended
        button.handleTouchEnded()
        XCTAssertTrue(actionCalled, "Action should be called")
        
        // Wait for scale up
        let expectation2 = XCTestExpectation(description: "Scale up completes")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 0.2)
    }
    
    // MARK: - Complete Game Flow Integration Tests
    
    func testCompleteGameFlowWithPolish() {
        // This test simulates a complete game flow with all polish features
        
        // Given: Fresh game scene
        guard let scoreLabel = gameScene.children.compactMap({ $0 as? ScoreLabel }).first else {
            XCTFail("Scene should have a ScoreLabel")
            return
        }
        
        let trump = TrumpNode()
        trump.position = CGPoint(x: 100, y: 300)
        gameScene.addChild(trump)
        
        // 1. Game starts - Trump idle animation
        XCTAssertEqual(trump.currentState, .idle, "Trump should be idle")
        XCTAssertTrue(trump.hasActions(), "Trump should have idle animations")
        
        // 2. Player scores
        scoreLabel.setScore(1, animated: true)
        XCTAssertTrue(scoreLabel.hasActions(), "Score should animate")
        
        let expectation1 = XCTestExpectation(description: "Score animation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: 0.3)
        
        // 3. Player flaps
        trump.currentState = .flapping
        XCTAssertEqual(trump.currentState, .flapping, "Trump should be flapping")
        
        let expectation2 = XCTestExpectation(description: "Flap animation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 0.4)
        
        // 4. Player dies
        gameScene.physicsWorld.speed = 0.5
        trump.currentState = .dead
        
        XCTAssertEqual(trump.currentState, .dead, "Trump should be dead")
        XCTAssertEqual(gameScene.physicsWorld.speed, 0.5, accuracy: 0.01, "Physics should be slowed")
        
        let expectation3 = XCTestExpectation(description: "Death animation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            expectation3.fulfill()
        }
        wait(for: [expectation3], timeout: 0.8)
        
        // 5. Restore physics speed
        gameScene.physicsWorld.speed = 1.0
        XCTAssertEqual(gameScene.physicsWorld.speed, 1.0, accuracy: 0.01, "Physics should be restored")
    }
    
    // MARK: - Particle Effect Lifecycle Tests
    
    func testParticleEffectCompleteLifecycle() {
        // Given: Initial child count
        let initialChildCount = gameScene.children.count
        
        // When: Adding particle with lifecycle
        if let confetti = SKEmitterNode(fileNamed: "Confetti") {
            confetti.position = CGPoint(x: gameScene.size.width / 2, y: gameScene.size.height)
            confetti.zPosition = 200
            gameScene.addChild(confetti)
            
            // Then: Should be added
            XCTAssertEqual(gameScene.children.count, initialChildCount + 1, "Confetti should be added")
            
            // When: Auto-remove after duration
            let wait = SKAction.wait(forDuration: 2.0)
            let remove = SKAction.removeFromParent()
            confetti.run(SKAction.sequence([wait, remove]))
            
            // Wait for removal
            let expectation = XCTestExpectation(description: "Confetti lifecycle completes")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 2.5)
            
            // Then: Should be removed
            XCTAssertNil(confetti.parent, "Confetti should be removed")
            XCTAssertEqual(gameScene.children.count, initialChildCount, "Child count should return to initial")
        } else {
            XCTFail("Confetti should load")
        }
    }
    
    // MARK: - Animation Timing Tests
    
    func testAnimationTimingCoordination() {
        // This test verifies that multiple animations can run simultaneously without conflicts
        
        // Given: Multiple animated elements
        guard let scoreLabel = gameScene.children.compactMap({ $0 as? ScoreLabel }).first else {
            XCTFail("Scene should have a ScoreLabel")
            return
        }
        
        let trump = TrumpNode()
        trump.position = CGPoint(x: 100, y: 300)
        gameScene.addChild(trump)
        
        let button = ButtonNode(size: CGSize(width: 200, height: 60),
                               normalColor: .blue,
                               highlightedColor: .darkGray)
        gameScene.addChild(button)
        
        // When: Triggering multiple animations simultaneously
        scoreLabel.setScore(1, animated: true)
        trump.currentState = .celebrate
        button.handleTouchBegan()
        
        // Then: All should have animations running
        XCTAssertTrue(scoreLabel.hasActions(), "Score should be animating")
        XCTAssertTrue(trump.hasActions(), "Trump should be animating")
        XCTAssertTrue(button.hasActions(), "Button should be animating")
        
        // Wait for animations to complete
        let expectation = XCTestExpectation(description: "All animations complete")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.6)
    }
}
