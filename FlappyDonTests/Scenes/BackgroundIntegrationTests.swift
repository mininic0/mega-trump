import XCTest
import SpriteKit
@testable import FlappyDon

final class BackgroundIntegrationTests: XCTestCase {
    
    var gameScene: GameScene!
    var testView: SKView!
    
    override func setUp() {
        super.setUp()
        testView = SKView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        gameScene = GameScene(size: CGSize(width: 375, height: 667))
    }
    
    override func tearDown() {
        gameScene = nil
        testView = nil
        super.tearDown()
    }
    
    // MARK: - Scene Setup Integration Tests
    
    func testBackgroundLayersAddedToSceneOnSetup() {
        // When: Scene is presented
        testView.presentScene(gameScene)
        
        // Give scene time to setup
        let expectation = XCTestExpectation(description: "Scene setup")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
        // Then: Background layers should be present in scene
        let backgroundLayers = gameScene.children.filter { $0.zPosition < 0 }
        XCTAssertGreaterThanOrEqual(backgroundLayers.count, 3, 
                                   "Scene should have at least 3 background layers")
    }
    
    func testBackgroundLayersBehindGameplayElements() {
        // When: Scene is setup
        testView.presentScene(gameScene)
        
        let expectation = XCTestExpectation(description: "Scene setup")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
        // Then: All background layers should have negative z-positions
        let backgroundLayers = gameScene.children.filter { $0.zPosition < 0 }
        for layer in backgroundLayers {
            XCTAssertLessThan(layer.zPosition, 0, 
                            "Background layers should be behind gameplay (z < 0)")
        }
    }
    
    func testBackgroundLayersOrderedCorrectly() {
        // When: Scene is setup
        testView.presentScene(gameScene)
        
        let expectation = XCTestExpectation(description: "Scene setup")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
        // Then: Layers should be ordered from far to near
        let backgroundLayers = gameScene.children.filter { $0.zPosition < 0 }
            .sorted { $0.zPosition < $1.zPosition }
        
        if backgroundLayers.count >= 3 {
            // Sky (far) should be furthest back
            XCTAssertEqual(backgroundLayers[0].zPosition, -100, 
                          "Sky layer should be at z-position -100")
            // City (mid) should be in middle
            XCTAssertEqual(backgroundLayers[1].zPosition, -50, 
                          "City layer should be at z-position -50")
            // Ground (near) should be closest
            XCTAssertEqual(backgroundLayers[2].zPosition, -10, 
                          "Ground layer should be at z-position -10")
        }
    }
    
    // MARK: - Game State Integration Tests
    
    func testBackgroundStartsScrollingWhenGameStarts() {
        // Given: A scene with background
        testView.presentScene(gameScene)
        
        var setupExpectation = XCTestExpectation(description: "Scene setup")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            setupExpectation.fulfill()
        }
        wait(for: [setupExpectation], timeout: 1.0)
        
        // Capture initial position
        let skyLayer = gameScene.children.first { $0.zPosition == -100 }
        let initialPosition = skyLayer?.children.first?.position.x ?? 0
        
        // When: Game starts
        GameManager.shared.startGame()
        
        // Simulate game loop updates
        for i in 0..<10 {
            gameScene.update(TimeInterval(i) * 0.016 + 0.016)
        }
        
        // Then: Background should be scrolling
        let finalPosition = skyLayer?.children.first?.position.x ?? 0
        XCTAssertLessThan(finalPosition, initialPosition, 
                         "Background should scroll when game starts")
    }
    
    func testBackgroundStopsScrollingOnGameOver() {
        // Given: A game in progress with scrolling background
        testView.presentScene(gameScene)
        
        var setupExpectation = XCTestExpectation(description: "Scene setup")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            setupExpectation.fulfill()
        }
        wait(for: [setupExpectation], timeout: 1.0)
        
        GameManager.shared.startGame()
        
        // Scroll for a bit
        for i in 0..<10 {
            gameScene.update(TimeInterval(i) * 0.016 + 0.016)
        }
        
        // When: Game ends
        GameManager.shared.endGame()
        
        // Capture position after game over
        let skyLayer = gameScene.children.first { $0.zPosition == -100 }
        let positionAfterGameOver = skyLayer?.children.first?.position.x ?? 0
        
        // Continue updating
        for i in 10..<20 {
            gameScene.update(TimeInterval(i) * 0.016 + 0.016)
        }
        
        // Then: Background should not move
        let finalPosition = skyLayer?.children.first?.position.x ?? 0
        XCTAssertEqual(finalPosition, positionAfterGameOver, accuracy: 0.1,
                      "Background should stop scrolling when game ends")
    }
    
    func testBackgroundResetsOnGameReset() {
        // Given: A game that has been playing with scrolled background
        testView.presentScene(gameScene)
        
        var setupExpectation = XCTestExpectation(description: "Scene setup")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            setupExpectation.fulfill()
        }
        wait(for: [setupExpectation], timeout: 1.0)
        
        GameManager.shared.startGame()
        
        // Scroll significantly
        for i in 0..<50 {
            gameScene.update(TimeInterval(i) * 0.016 + 0.016)
        }
        
        // When: Game is reset
        gameScene.resetGame()
        
        // Then: Background should return to initial positions
        let skyLayer = gameScene.children.first { $0.zPosition == -100 }
        let cityLayer = gameScene.children.first { $0.zPosition == -50 }
        let groundLayer = gameScene.children.first { $0.zPosition == -10 }
        
        let skyNode1 = skyLayer?.children.first
        let cityNode1 = cityLayer?.children.first
        let groundNode1 = groundLayer?.children.first
        
        // Check that nodes are back at initial positions
        XCTAssertEqual(skyNode1?.position.x, gameScene.size.width / 2, accuracy: 1.0,
                      "Sky should reset to initial position")
        XCTAssertEqual(cityNode1?.position.x, gameScene.size.width / 2, accuracy: 1.0,
                      "City should reset to initial position")
        XCTAssertEqual(groundNode1?.position.x, gameScene.size.width / 2, accuracy: 1.0,
                      "Ground should reset to initial position")
    }
    
    // MARK: - Update Loop Integration Tests
    
    func testBackgroundUpdatesInSceneUpdateLoop() {
        // Given: A scene with active game
        testView.presentScene(gameScene)
        
        var setupExpectation = XCTestExpectation(description: "Scene setup")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            setupExpectation.fulfill()
        }
        wait(for: [setupExpectation], timeout: 1.0)
        
        GameManager.shared.startGame()
        
        let groundLayer = gameScene.children.first { $0.zPosition == -10 }
        let initialPosition = groundLayer?.children.first?.position.x ?? 0
        
        // When: Scene update is called multiple times
        var currentTime: TimeInterval = 0
        for _ in 0..<60 {
            currentTime += 0.016 // ~60 FPS
            gameScene.update(currentTime)
        }
        
        // Then: Background should have scrolled
        let finalPosition = groundLayer?.children.first?.position.x ?? 0
        let distance = abs(finalPosition - initialPosition)
        
        XCTAssertGreaterThan(distance, 0, "Background should scroll during update loop")
        
        // Verify reasonable scroll distance (60 frames at ~150 points/sec)
        let expectedDistance = 150.0 * (60.0 * 0.016)
        XCTAssertEqual(distance, expectedDistance, accuracy: 20.0,
                      "Background should scroll expected distance")
    }
    
    func testBackgroundScrollingConsistentAcrossFrames() {
        // Given: A scene with active game
        testView.presentScene(gameScene)
        
        var setupExpectation = XCTestExpectation(description: "Scene setup")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            setupExpectation.fulfill()
        }
        wait(for: [setupExpectation], timeout: 1.0)
        
        GameManager.shared.startGame()
        
        let groundLayer = gameScene.children.first { $0.zPosition == -10 }
        
        // When: Measuring scroll distance over multiple frames
        var distances: [CGFloat] = []
        var previousPosition = groundLayer?.children.first?.position.x ?? 0
        
        var currentTime: TimeInterval = 0
        for _ in 0..<30 {
            currentTime += 0.016
            gameScene.update(currentTime)
            
            let currentPosition = groundLayer?.children.first?.position.x ?? 0
            let distance = abs(currentPosition - previousPosition)
            distances.append(distance)
            previousPosition = currentPosition
        }
        
        // Then: Scroll distances should be consistent (within tolerance)
        let averageDistance = distances.reduce(0, +) / CGFloat(distances.count)
        
        for distance in distances {
            XCTAssertEqual(distance, averageDistance, accuracy: 1.0,
                          "Scroll distance should be consistent across frames")
        }
    }
    
    // MARK: - Visual Hierarchy Integration Tests
    
    func testBackgroundDoesNotObscurePhysicsBoundaries() {
        // Given: A scene with background and physics boundaries
        testView.presentScene(gameScene)
        
        var setupExpectation = XCTestExpectation(description: "Scene setup")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            setupExpectation.fulfill()
        }
        wait(for: [setupExpectation], timeout: 1.0)
        
        // Then: Physics boundaries should be at z-position >= 0
        let physicsNodes = gameScene.children.filter { $0.physicsBody != nil }
        
        for node in physicsNodes {
            XCTAssertGreaterThanOrEqual(node.zPosition, 0,
                                       "Physics nodes should be at or above z-position 0")
        }
    }
    
    func testBackgroundLayersDoNotInterfereWithPhysics() {
        // Given: A scene with background
        testView.presentScene(gameScene)
        
        var setupExpectation = XCTestExpectation(description: "Scene setup")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            setupExpectation.fulfill()
        }
        wait(for: [setupExpectation], timeout: 1.0)
        
        // Then: Background layers should not have physics bodies
        let backgroundLayers = gameScene.children.filter { $0.zPosition < 0 }
        
        for layer in backgroundLayers {
            XCTAssertNil(layer.physicsBody, 
                        "Background layers should not have physics bodies")
            
            // Check children too
            for child in layer.children {
                XCTAssertNil(child.physicsBody,
                           "Background layer children should not have physics bodies")
            }
        }
    }
    
    // MARK: - Performance Integration Tests
    
    func testBackgroundScrollingDoesNotDegradePerformance() {
        // Given: A scene with scrolling background
        testView.presentScene(gameScene)
        
        var setupExpectation = XCTestExpectation(description: "Scene setup")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            setupExpectation.fulfill()
        }
        wait(for: [setupExpectation], timeout: 1.0)
        
        GameManager.shared.startGame()
        
        // When: Measuring update performance with background scrolling
        measure {
            var currentTime: TimeInterval = 0
            for _ in 0..<100 {
                currentTime += 0.016
                gameScene.update(currentTime)
            }
        }
        
        // Then: Performance should be acceptable (measured by XCTest)
    }
    
    // MARK: - Multi-Layer Coordination Tests
    
    func testAllLayersScrollSimultaneously() {
        // Given: A scene with active game
        testView.presentScene(gameScene)
        
        var setupExpectation = XCTestExpectation(description: "Scene setup")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            setupExpectation.fulfill()
        }
        wait(for: [setupExpectation], timeout: 1.0)
        
        GameManager.shared.startGame()
        
        // Capture initial positions
        let skyLayer = gameScene.children.first { $0.zPosition == -100 }
        let cityLayer = gameScene.children.first { $0.zPosition == -50 }
        let groundLayer = gameScene.children.first { $0.zPosition == -10 }
        
        let skyInitial = skyLayer?.children.first?.position.x ?? 0
        let cityInitial = cityLayer?.children.first?.position.x ?? 0
        let groundInitial = groundLayer?.children.first?.position.x ?? 0
        
        // When: Scene updates
        var currentTime: TimeInterval = 0
        for _ in 0..<30 {
            currentTime += 0.016
            gameScene.update(currentTime)
        }
        
        // Then: All layers should have moved
        let skyFinal = skyLayer?.children.first?.position.x ?? 0
        let cityFinal = cityLayer?.children.first?.position.x ?? 0
        let groundFinal = groundLayer?.children.first?.position.x ?? 0
        
        XCTAssertLessThan(skyFinal, skyInitial, "Sky layer should scroll")
        XCTAssertLessThan(cityFinal, cityInitial, "City layer should scroll")
        XCTAssertLessThan(groundFinal, groundInitial, "Ground layer should scroll")
    }
    
    func testParallaxEffectVisibleInScene() {
        // Given: A scene with active game
        testView.presentScene(gameScene)
        
        var setupExpectation = XCTestExpectation(description: "Scene setup")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            setupExpectation.fulfill()
        }
        wait(for: [setupExpectation], timeout: 1.0)
        
        GameManager.shared.startGame()
        
        // Capture initial positions
        let skyLayer = gameScene.children.first { $0.zPosition == -100 }
        let cityLayer = gameScene.children.first { $0.zPosition == -50 }
        let groundLayer = gameScene.children.first { $0.zPosition == -10 }
        
        let skyInitial = skyLayer?.children.first?.position.x ?? 0
        let cityInitial = cityLayer?.children.first?.position.x ?? 0
        let groundInitial = groundLayer?.children.first?.position.x ?? 0
        
        // When: Scene updates for 1 second
        var currentTime: TimeInterval = 0
        for _ in 0..<60 {
            currentTime += 0.016
            gameScene.update(currentTime)
        }
        
        // Then: Layers should move at different speeds (parallax effect)
        let skyDistance = abs((skyLayer?.children.first?.position.x ?? 0) - skyInitial)
        let cityDistance = abs((cityLayer?.children.first?.position.x ?? 0) - cityInitial)
        let groundDistance = abs((groundLayer?.children.first?.position.x ?? 0) - groundInitial)
        
        XCTAssertLessThan(skyDistance, cityDistance, 
                         "Sky should move slower than city (parallax)")
        XCTAssertLessThan(cityDistance, groundDistance, 
                         "City should move slower than ground (parallax)")
    }
}
