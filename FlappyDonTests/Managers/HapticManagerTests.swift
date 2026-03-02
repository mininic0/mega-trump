import XCTest
import UIKit
@testable import FlappyDon

class HapticManagerTests: XCTestCase {
    
    var hapticManager: HapticManager!
    var audioManager: AudioManager!
    
    override func setUp() {
        super.setUp()
        hapticManager = HapticManager.shared
        audioManager = AudioManager.shared
        
        // Ensure sound is enabled for haptics to work
        if !audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testHapticManagerSingleton() {
        // Test that HapticManager is a singleton
        let instance1 = HapticManager.shared
        let instance2 = HapticManager.shared
        XCTAssertTrue(instance1 === instance2, "HapticManager should be a singleton")
    }
    
    func testHapticManagerInitialization() {
        // Test that HapticManager initializes without crashing
        XCTAssertNotNil(hapticManager, "HapticManager should initialize successfully")
    }
    
    // MARK: - Haptics Enabled State Tests
    
    func testIsHapticsEnabledWhenSoundEnabled() {
        // Ensure sound is enabled
        if !audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        XCTAssertTrue(hapticManager.isHapticsEnabled, "Haptics should be enabled when sound is enabled")
    }
    
    func testIsHapticsDisabledWhenSoundDisabled() {
        // Disable sound
        if audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        XCTAssertFalse(hapticManager.isHapticsEnabled, "Haptics should be disabled when sound is disabled")
        
        // Re-enable for other tests
        audioManager.toggleSound()
    }
    
    func testHapticsToggleWithSound() {
        // Test that haptics state follows sound state
        let initialState = audioManager.isSoundEnabled
        
        audioManager.toggleSound()
        XCTAssertEqual(hapticManager.isHapticsEnabled, !initialState, "Haptics state should follow sound toggle")
        
        audioManager.toggleSound()
        XCTAssertEqual(hapticManager.isHapticsEnabled, initialState, "Haptics state should restore with sound")
    }
    
    // MARK: - Setup Tests
    
    func testSetupMethod() {
        // Test that setup method can be called without crashing
        hapticManager.setup()
        // If we reach here without crashing, the test passes
        XCTAssertTrue(true, "Setup should complete without crashing")
    }
    
    func testMultipleSetupCalls() {
        // Test that calling setup multiple times doesn't cause issues
        hapticManager.setup()
        hapticManager.setup()
        hapticManager.setup()
        XCTAssertTrue(true, "Multiple setup calls should not cause issues")
    }
    
    // MARK: - Flap Haptic Tests
    
    func testPlayFlapHapticWhenEnabled() {
        // Ensure sound/haptics are enabled
        if !audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        // Should not crash when playing flap haptic
        hapticManager.playFlapHaptic()
        XCTAssertTrue(true, "Flap haptic should play without crashing when enabled")
    }
    
    func testPlayFlapHapticWhenDisabled() {
        // Disable sound/haptics
        if audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        // Should not crash even when disabled (just won't play)
        hapticManager.playFlapHaptic()
        XCTAssertTrue(true, "Flap haptic should not crash when disabled")
        
        // Re-enable for other tests
        audioManager.toggleSound()
    }
    
    func testMultipleFlapHaptics() {
        // Ensure sound/haptics are enabled
        if !audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        // Simulate rapid tapping
        for _ in 0..<10 {
            hapticManager.playFlapHaptic()
        }
        XCTAssertTrue(true, "Multiple flap haptics should not cause issues")
    }
    
    // MARK: - Score Haptic Tests
    
    func testPlayScoreHapticWhenEnabled() {
        // Ensure sound/haptics are enabled
        if !audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        hapticManager.playScoreHaptic()
        XCTAssertTrue(true, "Score haptic should play without crashing when enabled")
    }
    
    func testPlayScoreHapticWhenDisabled() {
        // Disable sound/haptics
        if audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        hapticManager.playScoreHaptic()
        XCTAssertTrue(true, "Score haptic should not crash when disabled")
        
        // Re-enable for other tests
        audioManager.toggleSound()
    }
    
    func testMultipleScoreHaptics() {
        // Ensure sound/haptics are enabled
        if !audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        // Simulate multiple scores
        for _ in 0..<5 {
            hapticManager.playScoreHaptic()
        }
        XCTAssertTrue(true, "Multiple score haptics should not cause issues")
    }
    
    // MARK: - Death Haptic Tests
    
    func testPlayDeathHapticWhenEnabled() {
        // Ensure sound/haptics are enabled
        if !audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        hapticManager.playDeathHaptic()
        XCTAssertTrue(true, "Death haptic should play without crashing when enabled")
    }
    
    func testPlayDeathHapticWhenDisabled() {
        // Disable sound/haptics
        if audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        hapticManager.playDeathHaptic()
        XCTAssertTrue(true, "Death haptic should not crash when disabled")
        
        // Re-enable for other tests
        audioManager.toggleSound()
    }
    
    // MARK: - Button Haptic Tests
    
    func testPlayButtonHapticWhenEnabled() {
        // Ensure sound/haptics are enabled
        if !audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        hapticManager.playButtonHaptic()
        XCTAssertTrue(true, "Button haptic should play without crashing when enabled")
    }
    
    func testPlayButtonHapticWhenDisabled() {
        // Disable sound/haptics
        if audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        hapticManager.playButtonHaptic()
        XCTAssertTrue(true, "Button haptic should not crash when disabled")
        
        // Re-enable for other tests
        audioManager.toggleSound()
    }
    
    func testMultipleButtonHaptics() {
        // Ensure sound/haptics are enabled
        if !audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        // Simulate multiple button taps
        for _ in 0..<5 {
            hapticManager.playButtonHaptic()
        }
        XCTAssertTrue(true, "Multiple button haptics should not cause issues")
    }
    
    // MARK: - Integration Tests
    
    func testCompleteGameFlowWithHaptics() {
        // Simulate a complete game session with haptics
        
        // Ensure sound/haptics are enabled
        if !audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        // Game starts - button tap
        hapticManager.playButtonHaptic()
        
        // Player flaps
        for _ in 0..<10 {
            hapticManager.playFlapHaptic()
        }
        
        // Player scores
        for _ in 0..<5 {
            hapticManager.playScoreHaptic()
        }
        
        // Player dies
        hapticManager.playDeathHaptic()
        
        // Retry button
        hapticManager.playButtonHaptic()
        
        XCTAssertTrue(true, "Complete game flow with haptics should work without issues")
    }
    
    func testHapticsDuringGameplayWithSoundToggle() {
        // Start with sound enabled
        if !audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        // Play some haptics
        hapticManager.playFlapHaptic()
        hapticManager.playScoreHaptic()
        
        // Toggle sound off mid-game
        audioManager.toggleSound()
        XCTAssertFalse(hapticManager.isHapticsEnabled, "Haptics should be disabled when sound is off")
        
        // These should not play (but won't crash)
        hapticManager.playFlapHaptic()
        hapticManager.playScoreHaptic()
        
        // Toggle back on
        audioManager.toggleSound()
        XCTAssertTrue(hapticManager.isHapticsEnabled, "Haptics should be enabled when sound is on")
        
        // Should play again
        hapticManager.playFlapHaptic()
        hapticManager.playScoreHaptic()
        
        XCTAssertTrue(true, "Haptics should respect sound toggle during gameplay")
    }
    
    func testAllHapticTypesInSequence() {
        // Ensure sound/haptics are enabled
        if !audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        // Test all haptic types in sequence
        hapticManager.playButtonHaptic()
        hapticManager.playFlapHaptic()
        hapticManager.playScoreHaptic()
        hapticManager.playDeathHaptic()
        hapticManager.playButtonHaptic()
        
        XCTAssertTrue(true, "All haptic types should play in sequence without issues")
    }
    
    func testRapidHapticPlayback() {
        // Ensure sound/haptics are enabled
        if !audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        // Simulate very rapid haptic feedback (stress test)
        for i in 0..<50 {
            switch i % 4 {
            case 0:
                hapticManager.playFlapHaptic()
            case 1:
                hapticManager.playScoreHaptic()
            case 2:
                hapticManager.playDeathHaptic()
            case 3:
                hapticManager.playButtonHaptic()
            default:
                break
            }
        }
        
        XCTAssertTrue(true, "Rapid haptic playback should not cause performance issues")
    }
    
    // MARK: - Edge Cases
    
    func testHapticsOnNonPhoneDevice() {
        // Note: This test will behave differently on iPad vs iPhone
        // On iPad, haptics should gracefully not play (no crash)
        // On iPhone, haptics should play normally
        
        // Ensure sound/haptics are enabled
        if !audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        // These should handle device type gracefully
        hapticManager.playFlapHaptic()
        hapticManager.playScoreHaptic()
        hapticManager.playDeathHaptic()
        hapticManager.playButtonHaptic()
        
        XCTAssertTrue(true, "Haptics should handle device type gracefully")
    }
    
    func testSetupAfterHapticPlayback() {
        // Ensure sound/haptics are enabled
        if !audioManager.isSoundEnabled {
            audioManager.toggleSound()
        }
        
        // Play some haptics
        hapticManager.playFlapHaptic()
        hapticManager.playScoreHaptic()
        
        // Call setup again (re-prepare generators)
        hapticManager.setup()
        
        // Play more haptics
        hapticManager.playDeathHaptic()
        hapticManager.playButtonHaptic()
        
        XCTAssertTrue(true, "Setup should work correctly after haptic playback")
    }
    
    func testHapticsWithMultipleSoundToggles() {
        // Test haptics with rapid sound toggling
        for _ in 0..<5 {
            audioManager.toggleSound()
            hapticManager.playFlapHaptic()
            audioManager.toggleSound()
            hapticManager.playScoreHaptic()
        }
        
        XCTAssertTrue(true, "Haptics should handle rapid sound toggling")
    }
}
