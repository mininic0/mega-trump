import SpriteKit
import AVFoundation

enum VoiceEvent {
    case death
    case milestone25
    case milestone50
    case milestone100
}

class AudioManager {
    static let shared = AudioManager()
    
    private(set) var isSoundEnabled: Bool
    private var soundEffects: [String: SKAction] = [:]
    private var voiceLines: [VoiceEvent: [SKAction]] = [:]
    private var lastMilestoneScore: Int = 0
    private var audioNode: SKNode?
    
    private let soundEnabledKey = "soundEnabled"
    
    private init() {
        isSoundEnabled = UserDefaults.standard.object(forKey: soundEnabledKey) as? Bool ?? true
    }
    
    func setup(with node: SKNode) {
        self.audioNode = node
        preloadSoundEffects()
        preloadVoiceLines()
    }
    
    private func preloadSoundEffects() {
        soundEffects["flap"] = SKAction.playSoundFileNamed("flap.wav", waitForCompletion: false)
        soundEffects["score"] = SKAction.playSoundFileNamed("score.wav", waitForCompletion: false)
        soundEffects["death"] = SKAction.playSoundFileNamed("death.wav", waitForCompletion: false)
        soundEffects["highscore"] = SKAction.playSoundFileNamed("highscore.wav", waitForCompletion: false)
        soundEffects["button"] = SKAction.playSoundFileNamed("button.wav", waitForCompletion: false)
    }
    
    private func preloadVoiceLines() {
        voiceLines[.death] = [
            SKAction.playSoundFileNamed("wrong.wav", waitForCompletion: false),
            SKAction.playSoundFileNamed("sad.wav", waitForCompletion: false),
            SKAction.playSoundFileNamed("fakenews.wav", waitForCompletion: false),
            SKAction.playSoundFileNamed("disaster.wav", waitForCompletion: false)
        ]
        
        voiceLines[.milestone25] = [
            SKAction.playSoundFileNamed("tremendous.wav", waitForCompletion: false)
        ]
        
        voiceLines[.milestone50] = [
            SKAction.playSoundFileNamed("huge.wav", waitForCompletion: false)
        ]
        
        voiceLines[.milestone100] = [
            SKAction.playSoundFileNamed("nobody.wav", waitForCompletion: false)
        ]
    }
    
    func playSound(_ name: String) {
        guard isSoundEnabled else { return }
        guard let action = soundEffects[name] else {
            print("⚠️ AudioManager: Sound effect '\(name)' not found")
            return
        }
        guard let node = audioNode else {
            print("⚠️ AudioManager: Audio node not set. Call setup(with:) first")
            return
        }
        
        node.run(action)
    }
    
    func playVoiceLine(for event: VoiceEvent) {
        guard isSoundEnabled else { return }
        guard let lines = voiceLines[event], !lines.isEmpty else {
            print("⚠️ AudioManager: No voice lines found for event \(event)")
            return
        }
        guard let node = audioNode else {
            print("⚠️ AudioManager: Audio node not set. Call setup(with:) first")
            return
        }
        
        let randomLine = lines.randomElement()!
        node.run(randomLine)
    }
    
    func checkAndPlayMilestone(score: Int) {
        guard isSoundEnabled else { return }
        
        if score >= 100 && lastMilestoneScore < 100 {
            playVoiceLine(for: .milestone100)
            lastMilestoneScore = 100
        } else if score >= 50 && lastMilestoneScore < 50 {
            playVoiceLine(for: .milestone50)
            lastMilestoneScore = 50
        } else if score >= 25 && lastMilestoneScore < 25 {
            playVoiceLine(for: .milestone25)
            lastMilestoneScore = 25
        }
    }
    
    func resetMilestones() {
        lastMilestoneScore = 0
    }
    
    func toggleSound() {
        isSoundEnabled.toggle()
        saveSettings()
    }
    
    private func saveSettings() {
        UserDefaults.standard.set(isSoundEnabled, forKey: soundEnabledKey)
    }
}
