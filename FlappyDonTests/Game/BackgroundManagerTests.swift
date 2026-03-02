import XCTest
import SpriteKit
@testable import FlappyDon

final class BackgroundManagerTests: XCTestCase {
    
    var backgroundManager: BackgroundManager!
    var testScene: SKScene!
    
    override func setUp() {
        super.setUp()
        backgroundManager = BackgroundManager()
        testScene = SKScene(size: CGSize(width: 375, height: 667))
    }
    
    override func tearDown() {
        backgroundManager = nil
        testScene = nil
        super.tearDown()
    }
    
    // MARK: - Setup Tests
    
    func testSetupCreatesAllLayers() {
        // When: Setting up the background manager
        backgroundManager.setup(in: testScene)
        
        // Then: All layers should be added to the scene
        let childCount = testScene.children.count
        XCTAssertEqual(childCount, 3, "Scene should have 3 layers (sky, city, ground)")
    }
    
    func testSetupCreatesLayersWithCorrectZPositions() {
        // When: Setting up the background manager
        backgroundManager.setup(in: testScene)
        
        // Then: Layers should have correct z-positions for depth
        let layers = testScene.children.sorted { $0.zPosition < $1.zPosition }
        XCTAssertEqual(layers[0].zPosition, -100, "Sky layer should be at z-position -100 (furthest)")
        XCTAssertEqual(layers[1].zPosition, -50, "City layer should be at z-position -50 (middle)")
        XCTAssertEqual(layers[2].zPosition, -10, "Ground layer should be at z-position -10 (nearest)")
    }
    
    func testSetupCreatesDualNodesForEachLayer() {
        // When: Setting up the background manager
        backgroundManager.setup(in: testScene)
        
        // Then: Each layer should have 2 child nodes for seamless scrolling
        for layer in testScene.children {
            XCTAssertEqual(layer.children.count, 2, "Each layer should have 2 nodes for seamless looping")
        }
    }
    
    // MARK: - Scrolling Control Tests
    
    func testStartScrolling() {
        // Given: A setup background manager
        backgroundManager.setup(in: testScene)
        
        // When: Starting scrolling
        backgroundManager.startScrolling()
        
        // Then: Scrolling should be active (verified by update behavior)
        let skyLayer = testScene.children.first { $0.zPosition == -100 }
        let initialPosition = skyLayer?.children.first?.position.x ?? 0
        
        backgroundManager.update(deltaTime: 0.1)
        
        let newPosition = skyLayer?.children.first?.position.x ?? 0
        XCTAssertLessThan(newPosition, initialPosition, "Nodes should move left when scrolling is active")
    }
    
    func testStopScrolling() {
        // Given: A scrolling background
        backgroundManager.setup(in: testScene)
        backgroundManager.startScrolling()
        
        // When: Stopping scrolling
        backgroundManager.stopScrolling()
        
        // Then: Nodes should not move during update
        let skyLayer = testScene.children.first { $0.zPosition == -100 }
        let initialPosition = skyLayer?.children.first?.position.x ?? 0
        
        backgroundManager.update(deltaTime: 0.1)
        
        let newPosition = skyLayer?.children.first?.position.x ?? 0
        XCTAssertEqual(newPosition, initialPosition, "Nodes should not move when scrolling is stopped")
    }
    
    func testUpdateDoesNothingWhenNotScrolling() {
        // Given: A background manager that hasn't started scrolling
        backgroundManager.setup(in: testScene)
        
        // When: Calling update without starting scrolling
        let skyLayer = testScene.children.first { $0.zPosition == -100 }
        let initialPosition = skyLayer?.children.first?.position.x ?? 0
        
        backgroundManager.update(deltaTime: 0.1)
        
        // Then: Positions should remain unchanged
        let newPosition = skyLayer?.children.first?.position.x ?? 0
        XCTAssertEqual(newPosition, initialPosition, "Update should not move nodes when scrolling is not active")
    }
    
    // MARK: - Parallax Speed Tests
    
    func testParallaxSpeedDifferences() {
        // Given: A scrolling background
        backgroundManager.setup(in: testScene)
        backgroundManager.startScrolling()
        
        // Capture initial positions
        let skyLayer = testScene.children.first { $0.zPosition == -100 }
        let cityLayer = testScene.children.first { $0.zPosition == -50 }
        let groundLayer = testScene.children.first { $0.zPosition == -10 }
        
        let skyInitial = skyLayer?.children.first?.position.x ?? 0
        let cityInitial = cityLayer?.children.first?.position.x ?? 0
        let groundInitial = groundLayer?.children.first?.position.x ?? 0
        
        // When: Updating for a fixed time
        backgroundManager.update(deltaTime: 1.0)
        
        // Then: Each layer should move at different speeds
        let skyFinal = skyLayer?.children.first?.position.x ?? 0
        let cityFinal = cityLayer?.children.first?.position.x ?? 0
        let groundFinal = groundLayer?.children.first?.position.x ?? 0
        
        let skyDistance = abs(skyFinal - skyInitial)
        let cityDistance = abs(cityFinal - cityInitial)
        let groundDistance = abs(groundFinal - groundInitial)
        
        // Sky should move slowest (0.2x), city medium (0.5x), ground fastest (1.0x)
        XCTAssertLessThan(skyDistance, cityDistance, "Sky should move slower than city")
        XCTAssertLessThan(cityDistance, groundDistance, "City should move slower than ground")
        
        // Verify approximate speed ratios
        let expectedSkySpeed = groundDistance * 0.2
        let expectedCitySpeed = groundDistance * 0.5
        
        XCTAssertEqual(skyDistance, expectedSkySpeed, accuracy: 1.0, "Sky should move at 0.2x ground speed")
        XCTAssertEqual(cityDistance, expectedCitySpeed, accuracy: 1.0, "City should move at 0.5x ground speed")
    }
    
    // MARK: - Seamless Looping Tests
    
    func testSeamlessLoopingResetPosition() {
        // Given: A scrolling background
        backgroundManager.setup(in: testScene)
        backgroundManager.startScrolling()
        
        let groundLayer = testScene.children.first { $0.zPosition == -10 }
        guard let node1 = groundLayer?.children.first,
              let node2 = groundLayer?.children.last else {
            XCTFail("Ground layer should have two nodes")
            return
        }
        
        // When: Updating long enough for a node to scroll off-screen
        // Ground moves at 150 points/sec, scene width is 375, so ~3 seconds to scroll off
        for _ in 0..<40 {
            backgroundManager.update(deltaTime: 0.1)
        }
        
        // Then: Nodes should have been repositioned for seamless looping
        // Both nodes should still be visible or just off-screen
        let node1X = node1.position.x
        let node2X = node2.position.x
        
        // One node should be ahead of the other by approximately screen width
        let distance = abs(node1X - node2X)
        XCTAssertEqual(distance, testScene.size.width, accuracy: 10.0, 
                      "Nodes should be separated by screen width for seamless looping")
    }
    
    func testBothNodesScrollTogether() {
        // Given: A scrolling background
        backgroundManager.setup(in: testScene)
        backgroundManager.startScrolling()
        
        let skyLayer = testScene.children.first { $0.zPosition == -100 }
        guard let node1 = skyLayer?.children.first,
              let node2 = skyLayer?.children.last else {
            XCTFail("Sky layer should have two nodes")
            return
        }
        
        let initialDistance = abs(node1.position.x - node2.position.x)
        
        // When: Updating multiple times
        for _ in 0..<10 {
            backgroundManager.update(deltaTime: 0.1)
        }
        
        // Then: Distance between nodes should remain constant
        let finalDistance = abs(node1.position.x - node2.position.x)
        XCTAssertEqual(finalDistance, initialDistance, accuracy: 0.1, 
                      "Nodes should maintain constant distance while scrolling")
    }
    
    // MARK: - Reset Tests
    
    func testResetRestoresInitialPositions() {
        // Given: A background that has been scrolling
        backgroundManager.setup(in: testScene)
        backgroundManager.startScrolling()
        
        // Scroll for a while
        for _ in 0..<20 {
            backgroundManager.update(deltaTime: 0.1)
        }
        
        // When: Resetting the background
        backgroundManager.reset()
        
        // Then: All nodes should return to initial positions
        let skyLayer = testScene.children.first { $0.zPosition == -100 }
        let cityLayer = testScene.children.first { $0.zPosition == -50 }
        let groundLayer = testScene.children.first { $0.zPosition == -10 }
        
        // Sky nodes
        let skyNode1 = skyLayer?.children.first
        let skyNode2 = skyLayer?.children.last
        XCTAssertEqual(skyNode1?.position.x, testScene.size.width / 2, accuracy: 0.1)
        XCTAssertEqual(skyNode2?.position.x, testScene.size.width * 1.5, accuracy: 0.1)
        
        // City nodes
        let cityNode1 = cityLayer?.children.first
        let cityNode2 = cityLayer?.children.last
        XCTAssertEqual(cityNode1?.position.x, testScene.size.width / 2, accuracy: 0.1)
        XCTAssertEqual(cityNode2?.position.x, testScene.size.width * 1.5, accuracy: 0.1)
        
        // Ground nodes
        let groundNode1 = groundLayer?.children.first
        let groundNode2 = groundLayer?.children.last
        XCTAssertEqual(groundNode1?.position.x, testScene.size.width / 2, accuracy: 0.1)
        XCTAssertEqual(groundNode2?.position.x, testScene.size.width * 1.5, accuracy: 0.1)
    }
    
    func testResetStopsScrolling() {
        // Given: A scrolling background
        backgroundManager.setup(in: testScene)
        backgroundManager.startScrolling()
        
        // When: Resetting
        backgroundManager.reset()
        
        // Then: Scrolling should be stopped
        let skyLayer = testScene.children.first { $0.zPosition == -100 }
        let initialPosition = skyLayer?.children.first?.position.x ?? 0
        
        backgroundManager.update(deltaTime: 0.1)
        
        let newPosition = skyLayer?.children.first?.position.x ?? 0
        XCTAssertEqual(newPosition, initialPosition, "Scrolling should be stopped after reset")
    }
    
    // MARK: - Layer Content Tests
    
    func testSkyLayerContainsClouds() {
        // When: Setting up the background
        backgroundManager.setup(in: testScene)
        
        // Then: Sky segments should contain cloud sprites
        let skyLayer = testScene.children.first { $0.zPosition == -100 }
        let skySegment = skyLayer?.children.first
        
        // Each sky segment should have a background + clouds (at least 2 children)
        let childCount = skySegment?.children.count ?? 0
        XCTAssertGreaterThan(childCount, 1, "Sky segment should contain background and clouds")
    }
    
    func testCityLayerContainsBuildings() {
        // When: Setting up the background
        backgroundManager.setup(in: testScene)
        
        // Then: City segments should contain building sprites
        let cityLayer = testScene.children.first { $0.zPosition == -50 }
        let citySegment = cityLayer?.children.first as? SKSpriteNode
        
        XCTAssertNotNil(citySegment, "City segment should be a sprite node")
        
        // City segment should have buildings as children (if using fallback)
        // or be a single sprite (if texture loaded)
        let hasChildren = (citySegment?.children.count ?? 0) > 0
        let hasSize = (citySegment?.size.width ?? 0) > 0
        
        XCTAssertTrue(hasChildren || hasSize, "City segment should have buildings or texture")
    }
    
    func testGroundLayerHasCorrectHeight() {
        // When: Setting up the background
        backgroundManager.setup(in: testScene)
        
        // Then: Ground segments should have appropriate height (50-80 points per spec)
        let groundLayer = testScene.children.first { $0.zPosition == -10 }
        let groundSegment = groundLayer?.children.first as? SKSpriteNode
        
        let groundHeight = groundSegment?.size.height ?? 0
        XCTAssertGreaterThanOrEqual(groundHeight, 50, "Ground height should be at least 50 points")
        XCTAssertLessThanOrEqual(groundHeight, 80, "Ground height should be at most 80 points")
    }
    
    // MARK: - Performance Tests
    
    func testUpdatePerformance() {
        // Given: A scrolling background
        backgroundManager.setup(in: testScene)
        backgroundManager.startScrolling()
        
        // When: Measuring update performance
        measure {
            for _ in 0..<100 {
                backgroundManager.update(deltaTime: 0.016) // ~60 FPS
            }
        }
        
        // Then: Updates should be fast enough for 60 FPS
        // XCTest will report if performance is poor
    }
    
    // MARK: - Edge Case Tests
    
    func testUpdateWithZeroDeltaTime() {
        // Given: A scrolling background
        backgroundManager.setup(in: testScene)
        backgroundManager.startScrolling()
        
        let skyLayer = testScene.children.first { $0.zPosition == -100 }
        let initialPosition = skyLayer?.children.first?.position.x ?? 0
        
        // When: Updating with zero delta time
        backgroundManager.update(deltaTime: 0.0)
        
        // Then: Positions should not change
        let newPosition = skyLayer?.children.first?.position.x ?? 0
        XCTAssertEqual(newPosition, initialPosition, "Zero delta time should not move nodes")
    }
    
    func testUpdateWithLargeDeltaTime() {
        // Given: A scrolling background
        backgroundManager.setup(in: testScene)
        backgroundManager.startScrolling()
        
        // When: Updating with large delta time (frame skip scenario)
        backgroundManager.update(deltaTime: 1.0)
        
        // Then: Should handle gracefully without crashes
        // Nodes should still be in valid positions
        let groundLayer = testScene.children.first { $0.zPosition == -10 }
        let node1 = groundLayer?.children.first
        let node2 = groundLayer?.children.last
        
        XCTAssertNotNil(node1?.position.x, "Node 1 should have valid position")
        XCTAssertNotNil(node2?.position.x, "Node 2 should have valid position")
    }
    
    func testMultipleResets() {
        // Given: A background manager
        backgroundManager.setup(in: testScene)
        
        // When: Resetting multiple times
        backgroundManager.startScrolling()
        backgroundManager.update(deltaTime: 0.5)
        backgroundManager.reset()
        
        backgroundManager.startScrolling()
        backgroundManager.update(deltaTime: 0.5)
        backgroundManager.reset()
        
        backgroundManager.startScrolling()
        backgroundManager.update(deltaTime: 0.5)
        backgroundManager.reset()
        
        // Then: Should handle multiple resets without issues
        let skyLayer = testScene.children.first { $0.zPosition == -100 }
        let skyNode1 = skyLayer?.children.first
        
        XCTAssertEqual(skyNode1?.position.x, testScene.size.width / 2, accuracy: 0.1,
                      "Position should be reset correctly after multiple resets")
    }
    
    func testSetupOnDifferentSceneSizes() {
        // Given: Scenes of different sizes
        let smallScene = SKScene(size: CGSize(width: 320, height: 568))
        let largeScene = SKScene(size: CGSize(width: 414, height: 896))
        
        // When: Setting up on different scenes
        let manager1 = BackgroundManager()
        manager1.setup(in: smallScene)
        
        let manager2 = BackgroundManager()
        manager2.setup(in: largeScene)
        
        // Then: Both should create appropriate layers
        XCTAssertEqual(smallScene.children.count, 3, "Small scene should have 3 layers")
        XCTAssertEqual(largeScene.children.count, 3, "Large scene should have 3 layers")
    }
}
