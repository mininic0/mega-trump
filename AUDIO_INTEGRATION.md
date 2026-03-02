# Audio System Integration Guide

## Overview
This guide explains how to integrate the AudioManager into game components.

## AudioManager Setup

### 1. Initialize in GameScene
```swift
class GameScene: SKScene {
    override func didMove(to view: SKView) {
        // Setup audio manager with scene as audio node
        AudioManager.shared.setup(with: self)
        
        // ... rest of setup
    }
}
```

## Integration Points

### 2. TrumpNode - Flap Sound
**File**: `TrumpNode.swift` (to be created)

```swift
class TrumpNode: SKSpriteNode {
    func flap() {
        // Apply physics impulse
        physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: 300))
        
        // Play flap sound
        AudioManager.shared.playSound("flap")
        
        // Animation, etc.
    }
}
```

### 3. GameManager - Score Sound
**File**: `GameManager.swift` (to be created)

```swift
class GameManager {
    private(set) var score: Int = 0
    
    func incrementScore() {
        score += 1
        
        // Play score sound
        AudioManager.shared.playSound("score")
        
        // Check for milestone voice lines
        AudioManager.shared.checkAndPlayMilestone(score: score)
        
        // Update UI, etc.
    }
    
    func resetGame() {
        score = 0
        AudioManager.shared.resetMilestones()
        // ... rest of reset logic
    }
}
```

### 4. GameScene - Death Sounds
**File**: `GameScene.swift`

```swift
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        // Detect collision with pipe or ground
        if isGameOver {
            return
        }
        
        // Play death sound effect
        AudioManager.shared.playSound("death")
        
        // Play random death voice line
        AudioManager.shared.playVoiceLine(for: .death)
        
        // Handle game over logic
        handleGameOver()
    }
}
```

### 5. GameOverScene - High Score Sound
**File**: `GameOverScene.swift` (to be created)

```swift
class GameOverScene: SKScene {
    func displayScore(current: Int, highScore: Int) {
        let isNewHighScore = current > highScore
        
        if isNewHighScore {
            // Play high score jingle
            AudioManager.shared.playSound("highscore")
            
            // Show "NEW HIGH SCORE!" animation
            showHighScoreAnimation()
        }
        
        // Display scores
    }
}
```

### 6. ButtonNode - Button Tap Sound
**File**: `ButtonNode.swift` (to be created)

```swift
class ButtonNode: SKSpriteNode {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Play button sound
        AudioManager.shared.playSound("button")
        
        // Handle button action
        handleTap()
    }
}
```

### 7. MenuScene - Sound Toggle
**File**: `MenuScene.swift` (to be created)

```swift
class MenuScene: SKScene {
    private var soundToggleButton: ButtonNode!
    
    func setupSoundToggle() {
        soundToggleButton = ButtonNode(imageNamed: "soundIcon")
        soundToggleButton.onTap = { [weak self] in
            AudioManager.shared.toggleSound()
            self?.updateSoundIcon()
        }
        
        updateSoundIcon()
    }
    
    private func updateSoundIcon() {
        let iconName = AudioManager.shared.isSoundEnabled ? "soundOn" : "soundOff"
        soundToggleButton.texture = SKTexture(imageNamed: iconName)
    }
}
```

## Best Practices

### Preloading
- Call `AudioManager.shared.setup(with:)` once in GameScene's `didMove(to:)`
- Pass the scene itself as the audio node
- This preloads all sounds and sets up the playback node

### Milestone Tracking
- Call `AudioManager.shared.checkAndPlayMilestone(score:)` every time score increases
- The AudioManager handles tracking which milestones have been played
- Call `AudioManager.shared.resetMilestones()` when starting a new game

### Sound Toggle
- The toggle state persists automatically via UserDefaults
- Check `AudioManager.shared.isSoundEnabled` to update UI icons
- No need to manually save/load settings

### Error Handling
- AudioManager logs warnings if sounds are missing
- Game continues to function even if audio files are not present
- Useful for development before audio assets are ready

## Testing Checklist

### Sound Effects
- [ ] Flap sound plays on every tap during gameplay
- [ ] Score sound plays when passing through pipes
- [ ] Death sound plays on collision
- [ ] High score jingle plays only on NEW high score
- [ ] Button sound plays on all menu button taps

### Voice Lines
- [ ] Random death voice line plays on each death
- [ ] Different death lines play across multiple deaths
- [ ] "Tremendous!" plays at score 25 (once per game)
- [ ] "This is huge!" plays at score 50 (once per game)
- [ ] "Nobody plays better than me!" plays at score 100 (once per game)
- [ ] Milestone voice lines don't repeat in same game session

### Settings Persistence
- [ ] Sound toggle works in menu
- [ ] Sound setting persists after app restart
- [ ] All sounds respect the enabled/disabled state
- [ ] UI icon updates to reflect sound state

### Edge Cases
- [ ] Rapid tapping doesn't cause audio glitches
- [ ] Multiple sounds can play simultaneously
- [ ] Sounds don't block game logic
- [ ] Missing audio files don't crash the app
- [ ] Milestone voice lines work correctly when skipping scores (e.g., 24 → 26)

## Performance Notes

### Memory
- All sounds are preloaded at launch (~2 MB total)
- Sounds remain in memory for instant playback
- No loading delays during gameplay

### CPU
- `waitForCompletion: false` prevents blocking
- Sounds play asynchronously
- Minimal impact on frame rate

### Audio Mixing
- SpriteKit handles mixing multiple sounds automatically
- No manual audio session management needed
- Works with system audio (music apps, etc.)

## Troubleshooting

### Sound Not Playing
1. Check audio files are in Xcode project
2. Verify files have Target Membership checked
3. Check file names match exactly (case-sensitive)
4. Verify `setup(with:)` was called
5. Check `isSoundEnabled` is true

### Wrong Sound Playing
1. Verify file names in AudioManager match actual files
2. Check for typos in `playSound()` calls
3. Use Xcode debugger to verify sound name strings

### Milestone Voice Lines Not Playing
1. Check `checkAndPlayMilestone()` is called on score increment
2. Verify `resetMilestones()` is called on new game
3. Check score thresholds (25, 50, 100)
4. Verify voice line files exist

### Settings Not Persisting
1. Check UserDefaults key matches ("soundEnabled")
2. Verify `saveSettings()` is called in `toggleSound()`
3. Test on device (not just simulator)

## Future Enhancements

### Volume Controls (Post-V1)
```swift
// Add to AudioManager
var soundEffectsVolume: Float = 1.0
var voiceLinesVolume: Float = 1.0

func playSound(_ name: String, volume: Float? = nil) {
    let vol = volume ?? soundEffectsVolume
    // Adjust SKAction volume
}
```

### Audio Ducking (Post-V1)
```swift
// Lower voice lines when sound effects play
func playSound(_ name: String) {
    if isVoiceLinePlaying {
        duckVoiceLineVolume()
    }
    // Play sound
}
```

### Background Music (Post-V1)
```swift
// Use AVAudioPlayer for looping background music
var backgroundMusicPlayer: AVAudioPlayer?

func playBackgroundMusic() {
    // Setup looping music
}
```
