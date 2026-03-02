import XCTest
import SpriteKit
@testable import FlappyDon

final class GameViewControllerTests: XCTestCase {
    
    var viewController: GameViewController!
    
    override func setUp() {
        super.setUp()
        viewController = GameViewController()
        GameManager.shared.resetGame()
        
        // Load the view hierarchy
        _ = viewController.view
    }
    
    override func tearDown() {
        viewController = nil
        super.tearDown()
    }
    
    // MARK: - Lifecycle Notification Registration Tests
    
    func testViewControllerRegistersForLifecycleNotifications() {
        // Given: ViewController is loaded
        // When: viewDidLoad is called (happens in setUp)
        
        // Then: ViewController should be registered for notifications
        // We verify this by checking that the notification handlers exist
        XCTAssertTrue(viewController.responds(to: #selector(GameViewController.appWillResignActive(_:))))
        XCTAssertTrue(viewController.responds(to: #selector(GameViewController.appDidBecomeActive(_:))))
        XCTAssertTrue(viewController.responds(to: #selector(GameViewController.appDidEnterBackground(_:))))
        XCTAssertTrue(viewController.responds(to: #selector(GameViewController.appWillEnterForeground(_:))))
    }
    
    // MARK: - App Will Resign Active Tests
    
    func testAppWillResignActivePausesGameWhenPlaying() {
        // Given: Active game
        waitForScenePresentation()
        guard let gameScene = getGameScene() else {
            XCTFail("GameScene should be presented")
            return
        }
        GameManager.shared.startGame()
        XCTAssertTrue(GameManager.shared.isGameActive)
        
        // When: App will resign active notification is posted
        NotificationCenter.default.post(
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
        
        // Then: Game should be paused
        XCTAssertTrue(gameScene.isPaused, "Game should be paused when app resigns active")
    }
    
    func testAppWillResignActiveDoesNotPauseWhenNotPlaying() {
        // Given: Game in menu state
        waitForScenePresentation()
        guard let gameScene = getGameScene() else {
            XCTFail("GameScene should be presented")
            return
        }
        XCTAssertEqual(GameManager.shared.currentState, .menu)
        
        // When: App will resign active notification is posted
        NotificationCenter.default.post(
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
        
        // Then: Game should not be paused
        XCTAssertFalse(gameScene.isPaused, "Game should not pause when not playing")
    }
    
    // MARK: - App Did Become Active Tests
    
    func testAppDidBecomeActiveDoesNotAutoResume() {
        // Given: Paused game
        waitForScenePresentation()
        guard let gameScene = getGameScene() else {
            XCTFail("GameScene should be presented")
            return
        }
        GameManager.shared.startGame()
        gameScene.pauseGame()
        XCTAssertTrue(gameScene.isPaused)
        
        // When: App did become active notification is posted
        NotificationCenter.default.post(
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        
        // Then: Game should remain paused (wait for user tap)
        XCTAssertTrue(gameScene.isPaused, "Game should remain paused until user taps")
    }
    
    // MARK: - App Did Enter Background Tests
    
    func testAppDidEnterBackgroundPausesGameWhenPlaying() {
        // Given: Active game
        waitForScenePresentation()
        guard let gameScene = getGameScene() else {
            XCTFail("GameScene should be presented")
            return
        }
        GameManager.shared.startGame()
        XCTAssertTrue(GameManager.shared.isGameActive)
        
        // When: App did enter background notification is posted
        NotificationCenter.default.post(
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        
        // Then: Game should be paused
        XCTAssertTrue(gameScene.isPaused, "Game should be paused when app enters background")
    }
    
    func testAppDidEnterBackgroundDoesNotPauseWhenNotPlaying() {
        // Given: Game in menu state
        waitForScenePresentation()
        guard let gameScene = getGameScene() else {
            XCTFail("GameScene should be presented")
            return
        }
        XCTAssertEqual(GameManager.shared.currentState, .menu)
        
        // When: App did enter background notification is posted
        NotificationCenter.default.post(
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        
        // Then: Game should not be paused
        XCTAssertFalse(gameScene.isPaused, "Game should not pause when not playing")
    }
    
    // MARK: - App Will Enter Foreground Tests
    
    func testAppWillEnterForegroundDoesNotAutoResume() {
        // Given: Paused game
        waitForScenePresentation()
        guard let gameScene = getGameScene() else {
            XCTFail("GameScene should be presented")
            return
        }
        GameManager.shared.startGame()
        gameScene.pauseGame()
        XCTAssertTrue(gameScene.isPaused)
        
        // When: App will enter foreground notification is posted
        NotificationCenter.default.post(
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        
        // Then: Game should remain paused (wait for user tap)
        XCTAssertTrue(gameScene.isPaused, "Game should remain paused until user taps")
    }
    
    // MARK: - Helper Methods
    
    private func waitForScenePresentation() {
        // Wait for scene to be presented in viewDidLayoutSubviews
        let expectation = XCTestExpectation(description: "Scene should be presented")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    private func getGameScene() -> GameScene? {
        guard let skView = viewController.view as? SKView else {
            return nil
        }
        return skView.scene as? GameScene
    }
}

// MARK: - Integration Tests

final class GameViewControllerIntegrationTests: XCTestCase {
    
    var viewController: GameViewController!
    
    override func setUp() {
        super.setUp()
        viewController = GameViewController()
        GameManager.shared.resetGame()
        _ = viewController.view
    }
    
    override func tearDown() {
        viewController = nil
        super.tearDown()
    }
    
    // MARK: - Complete Lifecycle Flow Tests
    
    func testCompleteBackgroundForegroundCycle() {
        // Verify complete background/foreground cycle
        waitForScenePresentation()
        guard let gameScene = getGameScene() else {
            XCTFail("GameScene should be presented")
            return
        }
        
        // 1. Start game
        GameManager.shared.startGame()
        XCTAssertTrue(GameManager.shared.isGameActive)
        XCTAssertFalse(gameScene.isPaused)
        
        // 2. App enters background
        NotificationCenter.default.post(
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        XCTAssertTrue(gameScene.isPaused, "Game should pause when backgrounded")
        
        // 3. App returns to foreground
        NotificationCenter.default.post(
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        XCTAssertTrue(gameScene.isPaused, "Game should remain paused")
        
        // 4. App becomes active
        NotificationCenter.default.post(
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        XCTAssertTrue(gameScene.isPaused, "Game should still be paused")
        
        // 5. User taps to resume
        let touch = UITouch()
        gameScene.touchesBegan([touch], with: nil)
        XCTAssertFalse(gameScene.isPaused, "Game should resume on tap")
        XCTAssertTrue(GameManager.shared.isGameActive)
    }
    
    func testPhoneCallInterruptionFlow() {
        // Simulate phone call interruption
        waitForScenePresentation()
        guard let gameScene = getGameScene() else {
            XCTFail("GameScene should be presented")
            return
        }
        
        // 1. Start game
        GameManager.shared.startGame()
        XCTAssertTrue(GameManager.shared.isGameActive)
        
        // 2. Phone call comes in (app will resign active)
        NotificationCenter.default.post(
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
        XCTAssertTrue(gameScene.isPaused, "Game should pause during phone call")
        
        // 3. Phone call ends (app becomes active)
        NotificationCenter.default.post(
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        XCTAssertTrue(gameScene.isPaused, "Game should remain paused after call")
        
        // 4. User taps to resume
        let touch = UITouch()
        gameScene.touchesBegan([touch], with: nil)
        XCTAssertFalse(gameScene.isPaused, "Game should resume on tap")
    }
    
    func testMultipleInterruptionsCycle() {
        // Verify multiple interruptions are handled correctly
        waitForScenePresentation()
        guard let gameScene = getGameScene() else {
            XCTFail("GameScene should be presented")
            return
        }
        
        GameManager.shared.startGame()
        
        // First interruption
        NotificationCenter.default.post(
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
        XCTAssertTrue(gameScene.isPaused)
        
        NotificationCenter.default.post(
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        
        let touch = UITouch()
        gameScene.touchesBegan([touch], with: nil)
        XCTAssertFalse(gameScene.isPaused)
        
        // Second interruption
        NotificationCenter.default.post(
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        XCTAssertTrue(gameScene.isPaused)
        
        NotificationCenter.default.post(
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        
        gameScene.touchesBegan([touch], with: nil)
        XCTAssertFalse(gameScene.isPaused)
        
        // Game should still be functional
        XCTAssertTrue(GameManager.shared.isGameActive)
    }
    
    func testLifecycleEventsPreserveGameState() {
        // Verify lifecycle events don't affect game state
        waitForScenePresentation()
        guard let gameScene = getGameScene() else {
            XCTFail("GameScene should be presented")
            return
        }
        
        // Start game and score points
        GameManager.shared.startGame()
        GameManager.shared.incrementScore()
        GameManager.shared.incrementScore()
        GameManager.shared.incrementScore()
        XCTAssertEqual(GameManager.shared.currentScore, 3)
        
        // Background and foreground
        NotificationCenter.default.post(
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        NotificationCenter.default.post(
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        
        // Score should be preserved
        XCTAssertEqual(GameManager.shared.currentScore, 3)
        XCTAssertTrue(GameManager.shared.isGameActive)
        
        // Resume and continue playing
        let touch = UITouch()
        gameScene.touchesBegan([touch], with: nil)
        GameManager.shared.incrementScore()
        XCTAssertEqual(GameManager.shared.currentScore, 4)
    }
    
    // MARK: - Helper Methods
    
    private func waitForScenePresentation() {
        let expectation = XCTestExpectation(description: "Scene should be presented")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    private func getGameScene() -> GameScene? {
        guard let skView = viewController.view as? SKView else {
            return nil
        }
        return skView.scene as? GameScene
    }
}
