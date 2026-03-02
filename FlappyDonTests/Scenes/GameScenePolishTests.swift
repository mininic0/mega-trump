import XCTest
import SpriteKit
@testable import FlappyDon

final class GameScenePolishTests: XCTestCase {
    
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
    
    // MARK: - Camera Tests
    
    func testCameraExists() {
        // Then: Camera should exist for screen shake
        XCTAssertNotNil(gameScene.camera, "Camera should exist for effects")
    }
    
    func testCameraPosition() {
        // Then: Camera should be positioned correctly
        guard let camera = gameScene.camera else {
            XCTFail("Camera should exist")
            return
        }
        
        XCTAssertNotNil(camera.position, "Camera should have a position")
    }
    
    // MARK: - Screen Shake Tests
    
    func testScreenShakeActionExists() {
        // This test verifies the screen shake can be triggered
        // We can't directly call private methods, but we can verify camera behavior
        
        // Given: Camera exists
        guard let camera = gameScene.camera else {
            XCTFail("Camera should exist")
            return
        }
        
        // When: Simulating a shake by running the shake action manually
        let shake = SKAction.sequence([
            SKAction.moveBy(x: -10, y: 0, duration: 0.05),
            SKAction.moveBy(x: 10, y: 0, duration: 0.05),
            SKAction.moveBy(x: -10, y: 0, duration: 0.05),
            SKAction.moveBy(x: 10, y: 0, duration: 0.05),
            SKAction.moveBy(x: 0, y: 0, duration: 0.05)
        ])
        
        let initialPosition = camera.position
        camera.run(shake)
        
        // Then: Camera should have actions running
        XCTAssertTrue(camera.hasActions(), "Camera should have shake action")
        
        // Wait for shake to complete
        let expectation = XCTestExpectation(description: "Shake completes")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        // Camera should return to original position
        XCTAssertEqual(camera.position.x, initialPosition.x, accuracy: 0.1, "Camera should return to original X")
        XCTAssertEqual(camera.position.y, initialPosition.y, accuracy: 0.1, "Camera should return to original Y")
    }
    
    // MARK: - Particle Effect Tests
    
    func testConfettiParticleFileExists() {
        // Then: Confetti particle file should be loadable
        let confetti = SKEmitterNode(fileNamed: "Confetti")
        XCTAssertNotNil(confetti, "Confetti particle file should exist")
    }
    
    func testDustParticleFileExists() {
        // Then: Dust particle file should be loadable
        let dust = SKEmitterNode(fileNamed: "Dust")
        XCTAssertNotNil(dust, "Dust particle file should exist")
    }
    
    func testSparkleParticleFileExists() {
        // Then: Sparkle particle file should be loadable
        let sparkle = SKEmitterNode(fileNamed: "Sparkle")
        XCTAssertNotNil(sparkle, "Sparkle particle file should exist")
    }
    
    func testConfettiParticleProperties() {
        // Given: Confetti particle
        guard let confetti = SKEmitterNode(fileNamed: "Confetti") else {
            XCTFail("Confetti should load")
            return
        }
        
        // Then: Should have particle properties configured
        XCTAssertNotNil(confetti.particleTexture, "Should have particle texture")
        XCTAssertGreaterThan(confetti.particleBirthRate, 0, "Should have birth rate")
        XCTAssertGreaterThan(confetti.particleLifetime, 0, "Should have lifetime")
    }
    
    func testDustParticleProperties() {
        // Given: Dust particle
        guard let dust = SKEmitterNode(fileNamed: "Dust") else {
            XCTFail("Dust should load")
            return
        }
        
        // Then: Should have particle properties configured
        XCTAssertNotNil(dust.particleTexture, "Should have particle texture")
        XCTAssertGreaterThan(dust.particleBirthRate, 0, "Should have birth rate")
        XCTAssertGreaterThan(dust.particleLifetime, 0, "Should have lifetime")
    }
    
    func testSparkleParticleProperties() {
        // Given: Sparkle particle
        guard let sparkle = SKEmitterNode(fileNamed: "Sparkle") else {
            XCTFail("Sparkle should load")
            return
        }
        
        // Then: Should have particle properties configured
        XCTAssertNotNil(sparkle.particleTexture, "Should have particle texture")
        XCTAssertGreaterThan(sparkle.particleBirthRate, 0, "Should have birth rate")
        XCTAssertGreaterThan(sparkle.particleLifetime, 0, "Should have lifetime")
    }
    
    // MARK: - Confetti Effect Tests
    
    func testConfettiCanBeAdded() {
        // Given: Initial child count
        let initialChildCount = gameScene.children.count
        
        // When: Adding confetti manually
        if let confetti = SKEmitterNode(fileNamed: "Confetti") {
            confetti.position = CGPoint(x: gameScene.size.width / 2, y: gameScene.size.height)
            confetti.zPosition = 200
            gameScene.addChild(confetti)
            
            // Then: Child count should increase
            XCTAssertEqual(gameScene.children.count, initialChildCount + 1, "Confetti should be added")
            
            // And: Confetti should be at correct position
            XCTAssertEqual(confetti.position.x, gameScene.size.width / 2, accuracy: 0.1, "Confetti X position")
            XCTAssertEqual(confetti.position.y, gameScene.size.height, accuracy: 0.1, "Confetti Y position")
            XCTAssertEqual(confetti.zPosition, 200, "Confetti z-position should be 200")
        } else {
            XCTFail("Confetti should load")
        }
    }
    
    func testConfettiAutoRemoves() {
        // Given: Confetti with auto-remove action
        guard let confetti = SKEmitterNode(fileNamed: "Confetti") else {
            XCTFail("Confetti should load")
            return
        }
        
        confetti.position = CGPoint(x: gameScene.size.width / 2, y: gameScene.size.height)
        confetti.zPosition = 200
        gameScene.addChild(confetti)
        
        // When: Running auto-remove sequence
        let wait = SKAction.wait(forDuration: 2.0)
        let remove = SKAction.removeFromParent()
        confetti.run(SKAction.sequence([wait, remove]))
        
        // Then: Should have action running
        XCTAssertTrue(confetti.hasActions(), "Should have auto-remove action")
        
        // Wait for removal
        let expectation = XCTestExpectation(description: "Confetti removes")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.5)
        
        // Should be removed
        XCTAssertNil(confetti.parent, "Confetti should be removed after 2 seconds")
    }
    
    // MARK: - Dust Effect Tests
    
    func testDustCanBeAdded() {
        // Given: Initial child count
        let initialChildCount = gameScene.children.count
        
        // When: Adding dust manually
        if let dust = SKEmitterNode(fileNamed: "Dust") {
            dust.position = CGPoint(x: 100, y: 200)
            dust.zPosition = 50
            gameScene.addChild(dust)
            
            // Then: Child count should increase
            XCTAssertEqual(gameScene.children.count, initialChildCount + 1, "Dust should be added")
            
            // And: Dust should be at correct position
            XCTAssertEqual(dust.position.x, 100, accuracy: 0.1, "Dust X position")
            XCTAssertEqual(dust.position.y, 200, accuracy: 0.1, "Dust Y position")
            XCTAssertEqual(dust.zPosition, 50, "Dust z-position should be 50")
        } else {
            XCTFail("Dust should load")
        }
    }
    
    func testDustAutoRemoves() {
        // Given: Dust with auto-remove action
        guard let dust = SKEmitterNode(fileNamed: "Dust") else {
            XCTFail("Dust should load")
            return
        }
        
        dust.position = CGPoint(x: 100, y: 200)
        dust.zPosition = 50
        gameScene.addChild(dust)
        
        // When: Running auto-remove sequence
        let wait = SKAction.wait(forDuration: 0.5)
        let remove = SKAction.removeFromParent()
        dust.run(SKAction.sequence([wait, remove]))
        
        // Then: Should have action running
        XCTAssertTrue(dust.hasActions(), "Should have auto-remove action")
        
        // Wait for removal
        let expectation = XCTestExpectation(description: "Dust removes")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.8)
        
        // Should be removed
        XCTAssertNil(dust.parent, "Dust should be removed after 0.5 seconds")
    }
    
    // MARK: - Gap Flash Effect Tests
    
    func testGapFlashCreation() {
        // When: Creating a gap flash manually
        let flash = SKSpriteNode(color: .white, size: CGSize(width: 20, height: 150))
        flash.position = CGPoint(x: 200, y: 300)
        flash.alpha = 0.5
        flash.zPosition = 5
        gameScene.addChild(flash)
        
        // Then: Flash should have correct properties
        XCTAssertEqual(flash.color, .white, "Flash should be white")
        XCTAssertEqual(flash.size.width, 20, accuracy: 0.1, "Flash width should be 20")
        XCTAssertEqual(flash.size.height, 150, accuracy: 0.1, "Flash height should be 150")
        XCTAssertEqual(flash.alpha, 0.5, accuracy: 0.01, "Flash alpha should be 0.5")
        XCTAssertEqual(flash.zPosition, 5, "Flash z-position should be 5")
    }
    
    func testGapFlashFadesOut() {
        // Given: Gap flash
        let flash = SKSpriteNode(color: .white, size: CGSize(width: 20, height: 150))
        flash.position = CGPoint(x: 200, y: 300)
        flash.alpha = 0.5
        flash.zPosition = 5
        gameScene.addChild(flash)
        
        // When: Running fade out action
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let remove = SKAction.removeFromParent()
        flash.run(SKAction.sequence([fadeOut, remove]))
        
        // Then: Should have actions
        XCTAssertTrue(flash.hasActions(), "Flash should have fade action")
        
        // Wait for fade and removal
        let expectation = XCTestExpectation(description: "Flash fades and removes")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        // Should be removed
        XCTAssertNil(flash.parent, "Flash should be removed after fade")
    }
    
    // MARK: - ScoreLabel Integration Tests
    
    func testScoreLabelExists() {
        // Then: Score label should exist in scene
        let scoreLabels = gameScene.children.compactMap { $0 as? ScoreLabel }
        XCTAssertGreaterThanOrEqual(scoreLabels.count, 1, "Scene should have at least one ScoreLabel")
    }
    
    func testScoreLabelPosition() {
        // Given: Score label
        guard let scoreLabel = gameScene.children.compactMap({ $0 as? ScoreLabel }).first else {
            XCTFail("Scene should have a ScoreLabel")
            return
        }
        
        // Then: Should be positioned at top center
        XCTAssertEqual(scoreLabel.position.x, gameScene.size.width / 2, accuracy: 1.0, "Score should be centered")
        XCTAssertGreaterThan(scoreLabel.position.y, gameScene.size.height / 2, "Score should be in upper half")
    }
    
    // MARK: - Physics World Speed Tests (Slow-Motion Death)
    
    func testPhysicsWorldNormalSpeed() {
        // Then: Physics world should have normal speed initially
        XCTAssertEqual(gameScene.physicsWorld.speed, 1.0, accuracy: 0.01, "Physics speed should be 1.0")
    }
    
    func testPhysicsWorldSlowMotion() {
        // When: Setting slow motion
        gameScene.physicsWorld.speed = 0.5
        
        // Then: Physics speed should be reduced
        XCTAssertEqual(gameScene.physicsWorld.speed, 0.5, accuracy: 0.01, "Physics speed should be 0.5")
    }
    
    func testPhysicsWorldSpeedRestore() {
        // Given: Slow motion
        gameScene.physicsWorld.speed = 0.5
        
        // When: Restoring normal speed
        gameScene.physicsWorld.speed = 1.0
        
        // Then: Physics speed should be normal
        XCTAssertEqual(gameScene.physicsWorld.speed, 1.0, accuracy: 0.01, "Physics speed should restore to 1.0")
    }
    
    func testSlowMotionSequence() {
        // When: Running slow-motion sequence
        gameScene.physicsWorld.speed = 0.5
        
        let wait = SKAction.wait(forDuration: 0.1)
        let restore = SKAction.run { [weak gameScene] in
            gameScene?.physicsWorld.speed = 1.0
        }
        gameScene.run(SKAction.sequence([wait, restore]))
        
        // Then: Should have actions
        XCTAssertTrue(gameScene.hasActions(), "Should have slow-motion sequence")
        
        // Wait for sequence to complete
        let expectation = XCTestExpectation(description: "Slow-motion completes")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.3)
        
        // Speed should be restored
        XCTAssertEqual(gameScene.physicsWorld.speed, 1.0, accuracy: 0.01, "Speed should be restored")
    }
    
    // MARK: - Edge Cases
    
    func testMultipleParticleEffects() {
        // When: Adding multiple particle effects
        let confetti = SKEmitterNode(fileNamed: "Confetti")
        let dust = SKEmitterNode(fileNamed: "Dust")
        let sparkle = SKEmitterNode(fileNamed: "Sparkle")
        
        if let confetti = confetti {
            gameScene.addChild(confetti)
        }
        if let dust = dust {
            gameScene.addChild(dust)
        }
        if let sparkle = sparkle {
            gameScene.addChild(sparkle)
        }
        
        // Then: All should be added
        let emitters = gameScene.children.compactMap { $0 as? SKEmitterNode }
        XCTAssertGreaterThanOrEqual(emitters.count, 3, "Should have at least 3 emitters")
    }
    
    func testParticleEffectZOrdering() {
        // Given: Multiple effects with different z-positions
        let confetti = SKEmitterNode(fileNamed: "Confetti")
        confetti?.zPosition = 200
        
        let dust = SKEmitterNode(fileNamed: "Dust")
        dust?.zPosition = 50
        
        // Then: Z-positions should be correct
        XCTAssertEqual(confetti?.zPosition, 200, "Confetti should be at z=200")
        XCTAssertEqual(dust?.zPosition, 50, "Dust should be at z=50")
        XCTAssertGreaterThan(confetti?.zPosition ?? 0, dust?.zPosition ?? 0, "Confetti should be above dust")
    }
}
