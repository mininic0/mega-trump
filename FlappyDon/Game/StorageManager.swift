import Foundation

class StorageManager {
    static let shared = StorageManager()
    
    private enum Keys {
        static let highScore = "flappydon.highScore"
        static let soundEnabled = "flappydon.soundEnabled"
    }
    
    private init() {}
    
    // MARK: - High Score
    
    func saveHighScore(_ score: Int) {
        UserDefaults.standard.set(score, forKey: Keys.highScore)
        UserDefaults.standard.synchronize()
    }
    
    func loadHighScore() -> Int {
        return UserDefaults.standard.integer(forKey: Keys.highScore)
    }
    
    // MARK: - Sound Settings
    
    func saveSoundEnabled(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: Keys.soundEnabled)
        UserDefaults.standard.synchronize()
    }
    
    func loadSoundEnabled() -> Bool {
        if UserDefaults.standard.object(forKey: Keys.soundEnabled) == nil {
            return true
        }
        return UserDefaults.standard.bool(forKey: Keys.soundEnabled)
    }
    
    // MARK: - Debug Helpers
    
    #if DEBUG
    func resetAllData() {
        UserDefaults.standard.removeObject(forKey: Keys.highScore)
        UserDefaults.standard.removeObject(forKey: Keys.soundEnabled)
        UserDefaults.standard.synchronize()
    }
    #endif
}
