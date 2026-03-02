# FlappyDon Tests

This directory contains unit and integration tests for the FlappyDon game.

## Setup Required

⚠️ **These test files need to be added to the Xcode project before they can run.**

### Adding Tests to Xcode

1. Open `FlappyDon.xcodeproj` in Xcode (macOS required)
2. Create a new test target:
   - File → New → Target
   - Select "iOS Unit Testing Bundle"
   - Name: `FlappyDonTests`
   - Target to be Tested: `FlappyDon`
3. Add test files to the target:
   - Right-click project navigator → "Add Files to FlappyDon..."
   - Select the `FlappyDonTests` folder
   - Ensure "FlappyDonTests" target is checked
   - Click "Add"
4. Configure the test scheme:
   - Product → Scheme → Edit Scheme
   - Select "Test" in the sidebar
   - Check that FlappyDonTests is included
   - Enable code coverage: Test → Options → Code Coverage

## Test Structure

```
FlappyDonTests/
├── README.md (this file)
├── Info.plist (test bundle configuration)
└── Managers/
    └── AudioManagerTests.swift (30+ test cases)
```

## Running Tests

### In Xcode
- Press `⌘ + U` to run all tests
- Press `⌘ + 6` to open Test Navigator
- Click the diamond icon next to individual tests to run them

### Command Line
```bash
xcodebuild test -project FlappyDon.xcodeproj -scheme FlappyDon \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -enableCodeCoverage YES
```

### Run Specific Test Class
```bash
xcodebuild test -project FlappyDon.xcodeproj -scheme FlappyDon \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -only-testing:FlappyDonTests/AudioManagerTests
```

## Current Test Coverage

### AudioManagerTests.swift

Comprehensive test suite for the audio system with 30+ test cases:

**Initialization & Singleton**
- ✅ Singleton pattern verification
- ✅ Default sound enabled state

**Sound Toggle**
- ✅ Toggle from enabled to disabled
- ✅ Toggle from disabled to enabled
- ✅ Multiple consecutive toggles
- ✅ UserDefaults persistence

**Milestone Tracking**
- ✅ Milestone 25, 50, 100 triggering
- ✅ Milestone progression and skipping
- ✅ Milestone reset functionality
- ✅ Prevent milestone retriggering

**Sound Playback**
- ✅ Play sound when enabled/disabled
- ✅ Play voice lines when enabled/disabled
- ✅ Invalid sound handling
- ✅ Random voice line selection

**Integration Tests**
- ✅ Complete game flow simulation
- ✅ Sound toggle during gameplay
- ✅ Milestones with sound disabled

**Edge Cases**
- ✅ Negative scores
- ✅ Zero score
- ✅ Very high scores (Int.max)
- ✅ Rapid sound playback (100 calls)

## Expected Coverage

When executed on macOS with Xcode:
- **AudioManager.swift:** ~85-90% line coverage
- **Logic coverage:** 100% of business logic (toggles, milestones, persistence)
- **Untested:** Actual SKAction sound playback (requires audio files)

## Known Limitations

1. **Singleton Pattern:** Makes test isolation challenging. Consider dependency injection for future refactoring.

2. **Audio Files:** Tests verify logic but cannot test actual sound playback without audio files (which are placeholders per spec).

3. **SKAction Mocking:** Tests don't mock SKAction, so they verify code doesn't crash but not that sounds actually play.

4. **Environment:** Tests require macOS + Xcode + iOS Simulator. Cannot run on Linux/Windows.

## Adding More Tests

When adding new features, create corresponding test files:

```
FlappyDonTests/
├── Managers/
│   ├── AudioManagerTests.swift ✅
│   ├── ScoreManagerTests.swift (future)
│   └── GameManagerTests.swift (future)
├── Nodes/
│   ├── TrumpNodeTests.swift (future)
│   └── ObstacleNodeTests.swift (future)
└── Scenes/
    ├── GameSceneTests.swift (future)
    └── MenuSceneTests.swift (future)
```

Follow the existing test patterns in `AudioManagerTests.swift` for consistency.

## Documentation

For detailed testing information, see:
- [TESTING.md](../TESTING.md) - Complete testing guide
- [AUDIO_INTEGRATION.md](../AUDIO_INTEGRATION.md) - AudioManager integration guide
- [AUDIO_ASSETS.md](../AUDIO_ASSETS.md) - Audio asset specifications
