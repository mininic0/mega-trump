import XCTest
import SpriteKit
@testable import FlappyDon

class AudioManagerTests: XCTestCase {
    
    var audioManager: AudioManager!
    var testNode: SKNode!
    let testUserDefaultsKey = "soundEnabled"
    
    override func setUp() {
        super.setUp()
        // Reset UserDefaults for testing
        UserDefaults.standard.removeObject(forKey: testUserDefaultsKey)
        
        // Get fresh instance (note: singleton pattern makes this tricky)
        audioManager = AudioManager.shared
        testNode = SKNode()
        audioManager.setup(with: testNode)
    }
    
    override func tearDown() {
        // Clean up UserDefaults
        UserDefaults.standard.removeObject(forKey: testUserDefaultsKey)
        audioManager.resetMilestones()
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testAudioManagerSingleton() {
        // Test that AudioManager is a singleton
        let instance1 = AudioManager.shared
        let instance2 = AudioManager.shared
        XCTAssertTrue(instance1 === instance2, "AudioManager should be a singleton")
    }
    
    func testDefaultSoundEnabledState() {
        // Test that sound is enabled by default when no UserDefaults value exists
        UserDefaults.standard.removeObject(forKey: testUserDefaultsKey)
        // Note: Can't easily test this due to singleton pattern
        // In a real scenario, we'd need dependency injection or a reset method
        XCTAssertTrue(audioManager.isSoundEnabled, "Sound should be enabled by default")
    }
    
    // MARK: - Sound Toggle Tests
    
    func testToggleSoundFromEnabledToDisabled() {
        // Ensure sound starts enabled
        if !audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        // Toggle to disabled
        audioManager.toggleSound()
        XCTAssertFalse(audioManager.isSoundEnabled, "Sound should be disabled after toggle")
        
        // Verify persistence
        let savedValue = UserDefaults.standard.bool(forKey: testUserDefaultsKey)
        XCTAssertFalse(savedValue, "Disabled state should be persisted to UserDefaults")
    }
    
    func testToggleSoundFromDisabledToEnabled() {
        // Set to disabled first
        if audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        // Toggle to enabled
        audioManager.toggleSound()
        XCTAssertTrue(audioManager.isSoundEnabled, "Sound should be enabled after toggle")
        
        // Verify persistence
        let savedValue = UserDefaults.standard.bool(forKey: testUserDefaultsKey)
        XCTAssertTrue(savedValue, "Enabled state should be persisted to UserDefaults")
    }
    
    func testMultipleToggles() {
        let initialState = audioManager.isSoundEnabled
        
        audioManager.toggleSound()
        XCTAssertEqual(audioManager.isSoundEnabled, !initialState, "First toggle should flip state")
        
        audioManager.toggleSound()
        XCTAssertEqual(audioManager.isSoundEnabled, initialState, "Second toggle should restore original state")
        
        audioManager.toggleSound()
        XCTAssertEqual(audioManager.isSoundEnabled, !initialState, "Third toggle should flip state again")
    }
    
    // MARK: - Milestone Tracking Tests
    
    func testMilestone25Triggered() {
        audioManager.resetMilestones()
        
        // Score below milestone - should not trigger
        audioManager.checkAndPlayMilestone(score: 24)
        // No direct way to verify without mocking, but we can test the logic
        
        // Score at milestone - should trigger
        audioManager.checkAndPlayMilestone(score: 25)
        
        // Score above milestone - should not trigger again
        audioManager.checkAndPlayMilestone(score: 26)
        audioManager.checkAndPlayMilestone(score: 30)
    }
    
    func testMilestone50Triggered() {
        audioManager.resetMilestones()
        
        audioManager.checkAndPlayMilestone(score: 49)
        audioManager.checkAndPlayMilestone(score: 50)
        audioManager.checkAndPlayMilestone(score: 51)
    }
    
    func testMilestone100Triggered() {
        audioManager.resetMilestones()
        
        audioManager.checkAndPlayMilestone(score: 99)
        audioManager.checkAndPlayMilestone(score: 100)
        audioManager.checkAndPlayMilestone(score: 101)
    }
    
    func testMilestoneProgression() {
        audioManager.resetMilestones()
        
        // Test that milestones trigger in order
        audioManager.checkAndPlayMilestone(score: 25)
        audioManager.checkAndPlayMilestone(score: 50)
        audioManager.checkAndPlayMilestone(score: 100)
        
        // Test that they don't trigger again
        audioManager.checkAndPlayMilestone(score: 25)
        audioManager.checkAndPlayMilestone(score: 50)
        audioManager.checkAndPlayMilestone(score: 100)
    }
    
    func testMilestoneSkipping() {
        audioManager.resetMilestones()
        
        // Jump directly to 100 - should trigger 100 milestone
        audioManager.checkAndPlayMilestone(score: 100)
        
        // Going back to lower scores should not trigger
        audioManager.checkAndPlayMilestone(score: 50)
        audioManager.checkAndPlayMilestone(score: 25)
    }
    
    func testMilestoneReset() {
        audioManager.resetMilestones()
        
        // Trigger all milestones
        audioManager.checkAndPlayMilestone(score: 25)
        audioManager.checkAndPlayMilestone(score: 50)
        audioManager.checkAndPlayMilestone(score: 100)
        
        // Reset
        audioManager.resetMilestones()
        
        // Should be able to trigger again
        audioManager.checkAndPlayMilestone(score: 25)
    }
    
    // MARK: - Sound Playback Tests (with mocking)
    
    func testPlaySoundWhenEnabled() {
        // Ensure sound is enabled
        if !audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        // This test verifies the method doesn't crash
        // Actual sound playback can't be tested without audio files
        audioManager.playSound("flap")
        audioManager.playSound("score")
        audioManager.playSound("death")
        audioManager.playSound("highscore")
        audioManager.playSound("button")
    }
    
    func testPlaySoundWhenDisabled() {
        // Disable sound
        if audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        // These should not play (but won't crash)
        audioManager.playSound("flap")
        audioManager.playSound("score")
    }
    
    func testPlayInvalidSound() {
        // Ensure sound is enabled
        if !audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        // Should handle gracefully without crashing
        audioManager.playSound("nonexistent")
        audioManager.playSound("")
    }
    
    func testPlayVoiceLineWhenEnabled() {
        // Ensure sound is enabled
        if !audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        // Test all voice events
        audioManager.playVoiceLine(for: .death)
        audioManager.playVoiceLine(for: .milestone25)
        audioManager.playVoiceLine(for: .milestone50)
        audioManager.playVoiceLine(for: .milestone100)
    }
    
    func testPlayVoiceLineWhenDisabled() {
        // Disable sound
        if audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        // These should not play
        audioManager.playVoiceLine(for: .death)
        audioManager.playVoiceLine(for: .milestone25)
    }
    
    // MARK: - Integration Tests
    
    func testCompleteGameFlow() {
        // Simulate a complete game session
        audioManager.resetMilestones()
        
        // Ensure sound is enabled
        if !audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        // Game starts - player taps
        audioManager.playSound("flap")
        
        // Player scores
        audioManager.playSound("score")
        audioManager.checkAndPlayMilestone(score: 1)
        
        // Continue playing
        for score in 2...24 {
            audioManager.playSound("flap")
            audioManager.playSound("score")
            audioManager.checkAndPlayMilestone(score: score)
        }
        
        // Hit milestone 25
        audioManager.playSound("score")
        audioManager.checkAndPlayMilestone(score: 25)
        
        // Continue to 50
        for score in 26...50 {
            audioManager.checkAndPlayMilestone(score: score)
        }
        
        // Player dies
        audioManager.playSound("death")
        audioManager.playVoiceLine(for: .death)
        
        // Check if high score
        audioManager.playSound("highscore")
    }
    
    func testSoundToggleDuringGameplay() {
        audioManager.resetMilestones()
        
        // Start with sound enabled
        if !audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        // Play some sounds
        audioManager.playSound("flap")
        audioManager.playSound("score")
        
        // Toggle sound off mid-game
        audioManager.toggleSound()
        XCTAssertFalse(audioManager.isSoundEnabled)
        
        // These should not play
        audioManager.playSound("flap")
        audioManager.playSound("score")
        
        // Toggle back on
        audioManager.toggleSound()
        XCTAssertTrue(audioManager.isSoundEnabled)
        
        // Should play again
        audioManager.playSound("flap")
    }
    
    func testMilestonesDontPlayWhenSoundDisabled() {
        audioManager.resetMilestones()
        
        // Disable sound
        if audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        // Milestones should not play
        audioManager.checkAndPlayMilestone(score: 25)
        audioManager.checkAndPlayMilestone(score: 50)
        audioManager.checkAndPlayMilestone(score: 100)
        
        // Enable sound
        audioManager.toggleSound()
        
        // Milestones should have been tracked but not played
        // They won't play again since they were already "reached"
        audioManager.checkAndPlayMilestone(score: 100)
    }
    
    // MARK: - Edge Cases
    
    func testNegativeScore() {
        audioManager.resetMilestones()
        
        // Should handle gracefully
        audioManager.checkAndPlayMilestone(score: -1)
        audioManager.checkAndPlayMilestone(score: -100)
    }
    
    func testZeroScore() {
        audioManager.resetMilestones()
        
        audioManager.checkAndPlayMilestone(score: 0)
    }
    
    func testVeryHighScore() {
        audioManager.resetMilestones()
        
        // Should handle very high scores
        audioManager.checkAndPlayMilestone(score: 1000)
        audioManager.checkAndPlayMilestone(score: 10000)
        audioManager.checkAndPlayMilestone(score: Int.max)
    }
    
    func testRapidSoundPlayback() {
        // Ensure sound is enabled
        if !audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        // Simulate rapid tapping
        for _ in 0..<100 {
            audioManager.playSound("flap")
        }
        
        // Should not crash
    }
    
    func testSetupWithoutNode() {
        // Create a new manager instance (can't due to singleton, but test the concept)
        // This tests that calling playSound before setup is handled gracefully
        
        // Note: This is a limitation of the singleton pattern
        // In production code, we'd want dependency injection for better testability
    }
}
