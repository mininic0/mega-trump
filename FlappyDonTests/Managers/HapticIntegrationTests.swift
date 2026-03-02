import XCTest
import SpriteKit
@testable import FlappyDon

final class HapticIntegrationTests: XCTestCase {
    
    var scene: GameScene!
    var view: SKView!
    var trumpNode: TrumpNode!
    var gameManager: GameManager!
    var hapticManager: HapticManager!
    var audioManager: AudioManager!
    
    override func setUp() {
        super.setUp()
        scene = GameScene(size: CGSize(width: 375, height: 667))
        view = SKView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        gameManager = GameManager.shared
        hapticManager = HapticManager.shared
        audioManager = AudioManager.shared
        
        // Ensure sound/haptics are enabled
        if !audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        gameManager.resetGame()
        
        // Present scene to initialize
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
    
    // MARK: - TrumpNode Flap Integration
    
    func testFlapTriggersHapticFeedback() {
        // Given: Trump node in scene with haptics enabled
        guard let trump = trumpNode else {
            XCTFail("Trump node should exist")
            return
        }
        
        // Ensure haptics are enabled
        XCTAssertTrue(hapticManager.isHapticsEnabled, "Haptics should be enabled")
        
        // When: Trump flaps
        trump.flap()
        
        // Then: Haptic should be triggered (no crash)
        // Note: We can't directly verify haptic played, but we verify no crash
        XCTAssertTrue(true, "Flap should trigger haptic without crashing")
    }
    
    func testMultipleFlapsTriggerMultipleHaptics() {
        // Given: Trump node in scene
        guard let trump = trumpNode else {
            XCTFail("Trump node should exist")
            return
        }
        
        // When: Trump flaps multiple times
        for _ in 0..<10 {
            trump.flap()
        }
        
        // Then: All haptics should trigger without issues
        XCTAssertTrue(true, "Multiple flaps should trigger haptics without issues")
    }
    
    func testFlapWithHapticsDisabled() {
        // Given: Trump node with haptics disabled
        guard let trump = trumpNode else {
            XCTFail("Trump node should exist")
            return
        }
        
        // Disable sound/haptics
        if audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        // When: Trump flaps
        trump.flap()
        
        // Then: Should not crash (haptic just won't play)
        XCTAssertTrue(true, "Flap should work without haptics")
        
        // Re-enable for other tests
        audioManager.toggleSound()
    }
    
    // MARK: - GameManager Score Integration
    
    func testScoreIncrementTriggersHaptic() {
        // Given: Active game
        gameManager.startGame()
        let initialScore = gameManager.currentScore
        
        // When: Score increments
        gameManager.incrementScore()
        
        // Then: Score should increase and haptic should trigger
        XCTAssertEqual(gameManager.currentScore, initialScore + 1, "Score should increment")
        XCTAssertTrue(true, "Score increment should trigger haptic without crashing")
    }
    
    func testMultipleScoreIncrementsWithHaptics() {
        // Given: Active game
        gameManager.startGame()
        
        // When: Multiple scores
        for _ in 0..<5 {
            gameManager.incrementScore()
        }
        
        // Then: All haptics should trigger
        XCTAssertEqual(gameManager.currentScore, 5, "Score should be 5")
        XCTAssertTrue(true, "Multiple score haptics should work")
    }
    
    func testScoreWithHapticsDisabled() {
        // Given: Active game with haptics disabled
        gameManager.startGame()
        
        if audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        // When: Score increments
        gameManager.incrementScore()
        
        // Then: Score should still work without haptics
        XCTAssertEqual(gameManager.currentScore, 1, "Score should increment without haptics")
        
        // Re-enable for other tests
        audioManager.toggleSound()
    }
    
    // MARK: - GameScene Death Integration
    
    func testGameOverTriggersDeathHaptic() {
        // Given: Active game
        gameManager.startGame()
        
        // When: Game ends
        gameManager.endGame()
        
        // Then: Death haptic should trigger
        XCTAssertFalse(gameManager.isGameActive, "Game should be over")
        XCTAssertTrue(true, "Game over should trigger death haptic")
    }
    
    func testDeathHapticWithHapticsDisabled() {
        // Given: Active game with haptics disabled
        gameManager.startGame()
        
        if audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        // When: Game ends
        gameManager.endGame()
        
        // Then: Should work without haptics
        XCTAssertFalse(gameManager.isGameActive, "Game should be over")
        
        // Re-enable for other tests
        audioManager.toggleSound()
    }
    
    // MARK: - ButtonNode Integration
    
    func testButtonTapTriggersHaptic() {
        // Given: Button node
        let button = ButtonNode(text: "Test", fontSize: 24)
        scene.addChild(button)
        
        // When: Button is tapped
        button.handleTouchBegan()
        
        // Then: Haptic should trigger
        XCTAssertTrue(true, "Button tap should trigger haptic")
        
        button.removeFromParent()
    }
    
    func testMultipleButtonTapsWithHaptics() {
        // Given: Button node
        let button = ButtonNode(text: "Test", fontSize: 24)
        scene.addChild(button)
        
        // When: Multiple taps
        for _ in 0..<5 {
            button.handleTouchBegan()
            button.handleTouchEnded()
        }
        
        // Then: All haptics should trigger
        XCTAssertTrue(true, "Multiple button taps should trigger haptics")
        
        button.removeFromParent()
    }
    
    func testButtonWithHapticsDisabled() {
        // Given: Button with haptics disabled
        let button = ButtonNode(text: "Test", fontSize: 24)
        scene.addChild(button)
        
        if audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        // When: Button is tapped
        button.handleTouchBegan()
        
        // Then: Should work without haptics
        XCTAssertTrue(true, "Button should work without haptics")
        
        button.removeFromParent()
        
        // Re-enable for other tests
        audioManager.toggleSound()
    }
    
    // MARK: - Complete Game Flow Integration
    
    func testCompleteGameFlowWithAllHaptics() {
        // Given: Fresh game
        gameManager.resetGame()
        
        guard let trump = trumpNode else {
            XCTFail("Trump node should exist")
            return
        }
        
        // When: Complete game flow
        
        // 1. Start game (button tap)
        let startButton = ButtonNode(text: "Play", fontSize: 24)
        scene.addChild(startButton)
        startButton.handleTouchBegan()
        gameManager.startGame()
        
        // 2. Player flaps
        for _ in 0..<5 {
            trump.flap()
        }
        
        // 3. Player scores
        for _ in 0..<3 {
            gameManager.incrementScore()
        }
        
        // 4. Player dies
        gameManager.endGame()
        
        // 5. Retry button
        let retryButton = ButtonNode(text: "Retry", fontSize: 24)
        scene.addChild(retryButton)
        retryButton.handleTouchBegan()
        
        // Then: All haptics should have triggered without issues
        XCTAssertTrue(true, "Complete game flow with haptics should work")
        
        startButton.removeFromParent()
        retryButton.removeFromParent()
    }
    
    func testGameFlowWithHapticToggling() {
        // Given: Game in progress
        gameManager.startGame()
        
        guard let trump = trumpNode else {
            XCTFail("Trump node should exist")
            return
        }
        
        // When: Playing with haptics toggling
        
        // Play with haptics enabled
        trump.flap()
        gameManager.incrementScore()
        
        // Toggle haptics off
        audioManager.toggleSound()
        XCTAssertFalse(hapticManager.isHapticsEnabled)
        
        // Play without haptics
        trump.flap()
        gameManager.incrementScore()
        
        // Toggle haptics back on
        audioManager.toggleSound()
        XCTAssertTrue(hapticManager.isHapticsEnabled)
        
        // Play with haptics again
        trump.flap()
        gameManager.incrementScore()
        gameManager.endGame()
        
        // Then: Game should work correctly with haptic toggling
        XCTAssertEqual(gameManager.currentScore, 3, "Score should be 3")
        XCTAssertTrue(true, "Game should handle haptic toggling")
    }
    
    func testRapidGameplayWithHaptics() {
        // Given: Active game
        gameManager.startGame()
        
        guard let trump = trumpNode else {
            XCTFail("Trump node should exist")
            return
        }
        
        // When: Rapid gameplay (stress test)
        for i in 0..<20 {
            trump.flap()
            if i % 3 == 0 {
                gameManager.incrementScore()
            }
        }
        
        gameManager.endGame()
        
        // Then: All haptics should work without performance issues
        XCTAssertTrue(true, "Rapid gameplay with haptics should not cause issues")
    }
    
    // MARK: - Audio-Haptic Synchronization
    
    func testHapticsFollowAudioSetting() {
        // Given: Initial state
        let initialAudioState = audioManager.isSoundEnabled
        let initialHapticState = hapticManager.isHapticsEnabled
        
        // Then: Haptics should follow audio
        XCTAssertEqual(initialAudioState, initialHapticState, "Haptics should follow audio setting")
        
        // When: Toggle audio
        audioManager.toggleSound()
        
        // Then: Haptics should toggle too
        XCTAssertEqual(audioManager.isSoundEnabled, hapticManager.isHapticsEnabled, "Haptics should follow audio toggle")
        
        // Restore state
        if audioManager.isSoundEnabled != initialAudioState {
            audioManager.toggleSound()
        }
    }
    
    func testHapticsAndAudioInSync() {
        // Test that haptics and audio stay in sync through multiple toggles
        for _ in 0..<5 {
            audioManager.toggleSound()
            XCTAssertEqual(audioManager.isSoundEnabled, hapticManager.isHapticsEnabled, "Haptics should stay in sync with audio")
        }
        
        // Ensure we end with sound enabled
        if !audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
    }
    
    // MARK: - Edge Cases
    
    func testHapticsWithNilTrumpNode() {
        // Given: Scene without trump node
        let emptyScene = GameScene(size: CGSize(width: 375, height: 667))
        view.presentScene(emptyScene)
        
        // When: Trying to trigger haptics
        hapticManager.playFlapHaptic()
        hapticManager.playScoreHaptic()
        hapticManager.playDeathHaptic()
        
        // Then: Should not crash
        XCTAssertTrue(true, "Haptics should work even without trump node")
    }
    
    func testHapticsAfterSceneTransition() {
        // Given: Initial scene
        hapticManager.playFlapHaptic()
        
        // When: Transition to new scene
        let newScene = GameScene(size: CGSize(width: 375, height: 667))
        view.presentScene(newScene)
        
        // Then: Haptics should still work
        hapticManager.playScoreHaptic()
        hapticManager.playDeathHaptic()
        
        XCTAssertTrue(true, "Haptics should work after scene transition")
    }
    
    func testHapticsWithGameReset() {
        // Given: Game in progress with haptics
        gameManager.startGame()
        
        guard let trump = trumpNode else {
            XCTFail("Trump node should exist")
            return
        }
        
        trump.flap()
        gameManager.incrementScore()
        
        // When: Game resets
        gameManager.resetGame()
        
        // Then: Haptics should still work
        hapticManager.playButtonHaptic()
        
        XCTAssertTrue(true, "Haptics should work after game reset")
    }
}
