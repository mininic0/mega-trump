# Managers

This directory contains singleton manager classes that handle cross-cutting concerns throughout the app.

## AudioManager

**File**: `AudioManager.swift`

Manages all audio playback including sound effects and voice lines.

### Features
- Singleton pattern for global access
- Preloads all audio files at app launch
- Supports sound effects (flap, score, death, highscore, button)
- Supports voice lines with random selection (death reactions, milestone celebrations)
- Tracks milestone progress (25, 50, 100 points)
- Persists sound enabled/disabled state via UserDefaults
- Non-blocking audio playback

### Quick Start

```swift
// In GameScene.didMove(to:)
AudioManager.shared.setup(with: self)

// Play sound effect
AudioManager.shared.playSound("flap")

// Play random voice line
AudioManager.shared.playVoiceLine(for: .death)

// Check for milestone and play voice line
AudioManager.shared.checkAndPlayMilestone(score: currentScore)

// Toggle sound on/off
AudioManager.shared.toggleSound()

// Reset milestone tracking for new game
AudioManager.shared.resetMilestones()
```

### Documentation
- **Audio Assets**: See `/AUDIO_ASSETS.md` for required audio files
- **Integration Guide**: See `/AUDIO_INTEGRATION.md` for detailed integration examples

### Status
✅ **Implementation Complete** - Ready for integration when game components are created

⏳ **Pending**: Audio asset files need to be added to project
