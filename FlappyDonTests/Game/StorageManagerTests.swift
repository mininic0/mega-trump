import XCTest
@testable import FlappyDon

final class StorageManagerTests: XCTestCase {
    
    var storageManager: StorageManager!
    let testHighScoreKey = "flappydon.highScore"
    let testSoundEnabledKey = "flappydon.soundEnabled"
    
    override func setUp() {
        super.setUp()
        storageManager = StorageManager.shared
        // Clear UserDefaults before each test
        UserDefaults.standard.removeObject(forKey: testHighScoreKey)
        UserDefaults.standard.removeObject(forKey: testSoundEnabledKey)
        UserDefaults.standard.synchronize()
    }
    
    override func tearDown() {
        // Clean up after each test
        UserDefaults.standard.removeObject(forKey: testHighScoreKey)
        UserDefaults.standard.removeObject(forKey: testSoundEnabledKey)
        UserDefaults.standard.synchronize()
        super.tearDown()
    }
    
    // MARK: - Singleton Tests
    
    func testSingletonInstance() {
        let instance1 = StorageManager.shared
        let instance2 = StorageManager.shared
        
        XCTAssertTrue(instance1 === instance2, "StorageManager should be a singleton")
    }
    
    // MARK: - High Score Tests
    
    func testLoadHighScoreReturnsZeroWhenNotSet() {
        // When: Loading high score without setting it first
        let highScore = storageManager.loadHighScore()
        
        // Then: Should return 0 (default for integer)
        XCTAssertEqual(highScore, 0, "High score should default to 0 when not set")
    }
    
    func testSaveAndLoadHighScore() {
        // Given: A high score to save
        let scoreToSave = 42
        
        // When: Saving and loading the high score
        storageManager.saveHighScore(scoreToSave)
        let loadedScore = storageManager.loadHighScore()
        
        // Then: Loaded score should match saved score
        XCTAssertEqual(loadedScore, scoreToSave, "Loaded high score should match saved score")
    }
    
    func testSaveHighScorePersistsToUserDefaults() {
        // Given: A high score to save
        let scoreToSave = 100
        
        // When: Saving the high score
        storageManager.saveHighScore(scoreToSave)
        
        // Then: Should be persisted in UserDefaults
        let persistedScore = UserDefaults.standard.integer(forKey: testHighScoreKey)
        XCTAssertEqual(persistedScore, scoreToSave, "High score should be persisted to UserDefaults")
    }
    
    func testSaveHighScoreOverwritesPreviousValue() {
        // Given: An existing high score
        storageManager.saveHighScore(50)
        XCTAssertEqual(storageManager.loadHighScore(), 50)
        
        // When: Saving a new high score
        storageManager.saveHighScore(75)
        
        // Then: New score should overwrite the old one
        XCTAssertEqual(storageManager.loadHighScore(), 75, "New high score should overwrite previous value")
    }
    
    func testSaveHighScoreWithZero() {
        // Given: A non-zero high score
        storageManager.saveHighScore(100)
        
        // When: Saving zero as high score
        storageManager.saveHighScore(0)
        
        // Then: Should save zero correctly
        XCTAssertEqual(storageManager.loadHighScore(), 0, "Should be able to save zero as high score")
    }
    
    func testSaveHighScoreWithLargeNumber() {
        // Given: A very large score
        let largeScore = 999999
        
        // When: Saving the large score
        storageManager.saveHighScore(largeScore)
        
        // Then: Should handle large numbers correctly
        XCTAssertEqual(storageManager.loadHighScore(), largeScore, "Should handle large high scores")
    }
    
    // MARK: - Sound Settings Tests
    
    func testLoadSoundEnabledDefaultsToTrue() {
        // When: Loading sound setting without setting it first (first launch)
        let soundEnabled = storageManager.loadSoundEnabled()
        
        // Then: Should default to true (sound on by default)
        XCTAssertTrue(soundEnabled, "Sound should be enabled by default on first launch")
    }
    
    func testSaveAndLoadSoundEnabledTrue() {
        // Given: Sound enabled setting
        let soundEnabled = true
        
        // When: Saving and loading the setting
        storageManager.saveSoundEnabled(soundEnabled)
        let loadedSetting = storageManager.loadSoundEnabled()
        
        // Then: Loaded setting should match saved setting
        XCTAssertTrue(loadedSetting, "Loaded sound setting should match saved setting")
    }
    
    func testSaveAndLoadSoundEnabledFalse() {
        // Given: Sound disabled setting
        let soundEnabled = false
        
        // When: Saving and loading the setting
        storageManager.saveSoundEnabled(soundEnabled)
        let loadedSetting = storageManager.loadSoundEnabled()
        
        // Then: Loaded setting should match saved setting
        XCTAssertFalse(loadedSetting, "Loaded sound setting should match saved setting")
    }
    
    func testSaveSoundEnabledPersistsToUserDefaults() {
        // Given: A sound setting to save
        let soundEnabled = false
        
        // When: Saving the sound setting
        storageManager.saveSoundEnabled(soundEnabled)
        
        // Then: Should be persisted in UserDefaults
        let persistedSetting = UserDefaults.standard.bool(forKey: testSoundEnabledKey)
        XCTAssertEqual(persistedSetting, soundEnabled, "Sound setting should be persisted to UserDefaults")
    }
    
    func testSaveSoundEnabledOverwritesPreviousValue() {
        // Given: An existing sound setting
        storageManager.saveSoundEnabled(true)
        XCTAssertTrue(storageManager.loadSoundEnabled())
        
        // When: Saving a new sound setting
        storageManager.saveSoundEnabled(false)
        
        // Then: New setting should overwrite the old one
        XCTAssertFalse(storageManager.loadSoundEnabled(), "New sound setting should overwrite previous value")
    }
    
    func testToggleSoundSettingMultipleTimes() {
        // When: Toggling sound setting multiple times
        storageManager.saveSoundEnabled(true)
        XCTAssertTrue(storageManager.loadSoundEnabled())
        
        storageManager.saveSoundEnabled(false)
        XCTAssertFalse(storageManager.loadSoundEnabled())
        
        storageManager.saveSoundEnabled(true)
        XCTAssertTrue(storageManager.loadSoundEnabled())
        
        // Then: Each toggle should be persisted correctly
        XCTAssertTrue(storageManager.loadSoundEnabled(), "Sound setting should persist through multiple toggles")
    }
    
    // MARK: - Debug Helper Tests
    
    #if DEBUG
    func testResetAllDataClearsHighScore() {
        // Given: A saved high score
        storageManager.saveHighScore(100)
        XCTAssertEqual(storageManager.loadHighScore(), 100)
        
        // When: Resetting all data
        storageManager.resetAllData()
        
        // Then: High score should be cleared (return to default 0)
        XCTAssertEqual(storageManager.loadHighScore(), 0, "High score should be cleared after reset")
    }
    
    func testResetAllDataClearsSoundSetting() {
        // Given: A saved sound setting
        storageManager.saveSoundEnabled(false)
        XCTAssertFalse(storageManager.loadSoundEnabled())
        
        // When: Resetting all data
        storageManager.resetAllData()
        
        // Then: Sound setting should be cleared (return to default true)
        XCTAssertTrue(storageManager.loadSoundEnabled(), "Sound setting should return to default after reset")
    }
    
    func testResetAllDataClearsAllData() {
        // Given: Saved high score and sound setting
        storageManager.saveHighScore(250)
        storageManager.saveSoundEnabled(false)
        
        // When: Resetting all data
        storageManager.resetAllData()
        
        // Then: All data should be cleared
        XCTAssertEqual(storageManager.loadHighScore(), 0, "High score should be cleared")
        XCTAssertTrue(storageManager.loadSoundEnabled(), "Sound setting should return to default")
    }
    #endif
    
    // MARK: - Data Persistence Tests
    
    func testDataPersistsAcrossMultipleReads() {
        // Given: Saved data
        storageManager.saveHighScore(123)
        storageManager.saveSoundEnabled(false)
        
        // When: Reading multiple times
        let score1 = storageManager.loadHighScore()
        let score2 = storageManager.loadHighScore()
        let sound1 = storageManager.loadSoundEnabled()
        let sound2 = storageManager.loadSoundEnabled()
        
        // Then: Data should be consistent across reads
        XCTAssertEqual(score1, score2, "High score should be consistent across reads")
        XCTAssertEqual(sound1, sound2, "Sound setting should be consistent across reads")
        XCTAssertEqual(score1, 123)
        XCTAssertFalse(sound1)
    }
    
    func testIndependentDataStorage() {
        // When: Saving different values for high score and sound
        storageManager.saveHighScore(50)
        storageManager.saveSoundEnabled(true)
        
        // Then: Each value should be stored independently
        XCTAssertEqual(storageManager.loadHighScore(), 50)
        XCTAssertTrue(storageManager.loadSoundEnabled())
        
        // When: Changing only high score
        storageManager.saveHighScore(100)
        
        // Then: Sound setting should remain unchanged
        XCTAssertEqual(storageManager.loadHighScore(), 100)
        XCTAssertTrue(storageManager.loadSoundEnabled(), "Sound setting should not be affected by high score changes")
    }
}
