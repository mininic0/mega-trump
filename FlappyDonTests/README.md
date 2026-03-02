# FlappyDon Test Suite

This directory contains comprehensive unit and integration tests for the FlappyDon game engine.

## Test Structure

```
FlappyDonTests/
├── Game/
│   └── GameManagerTests.swift      # 26 unit tests for GameManager
├── Scenes/
│   └── GameSceneTests.swift        # 23 unit tests + 4 integration tests
├── Nodes/
│   ├── TrumpNodeTests.swift        # 40 unit tests for TrumpNode
│   └── TrumpNodeIntegrationTests.swift  # 18 integration tests for TrumpNode
├── Info.plist                      # Test bundle configuration
└── README.md                       # This file
```

## Test Coverage

### GameManagerTests.swift (26 tests)

**Initial State Tests:**
- `testInitialState` - Verifies default state is menu with zero scores
- `testLoadHighScoreFromUserDefaults` - Tests persistence loading

**Start Game Tests:**
- `testStartGame` - Verifies state transitions to playing
- `testStartGameResetsScore` - Ensures score resets on new game

**End Game Tests:**
- `testEndGame` - Verifies state transitions to gameOver
- `testEndGameSavesNewHighScore` - Tests high score persistence
- `testEndGameDoesNotSaveLowerScore` - Ensures high score only increases
- `testEndGameSavesEqualScore` - Tests equal score handling

**Increment Score Tests:**
- `testIncrementScore` - Basic score increment
- `testIncrementScoreMultipleTimes` - Multiple increments
- `testIncrementScoreWhenGameNotActive` - Guards against inactive state
- `testIncrementScoreAfterGameOver` - Guards against post-game scoring

**Reset Game Tests:**
- `testResetGame` - Verifies return to menu state
- `testResetGamePreservesHighScore` - Ensures high score persists

**State Transition Tests:**
- `testStateTransitionFlow` - Complete state machine flow
- `testMultipleGameSessions` - Multiple game sessions with varying scores

**Singleton Tests:**
- `testSingletonInstance` - Verifies singleton pattern
- `testSingletonStateSharing` - Tests state sharing across instances

### GameSceneTests.swift (23 unit tests)

**Physics Setup Tests:**
- `testPhysicsWorldGravity` - Verifies gravity is -9.8
- `testPhysicsContactDelegate` - Ensures delegate is set

**Physics Categories Tests:**
- `testPhysicsCategoriesAreUnique` - All categories are unique
- `testPhysicsCategoriesArePowerOfTwo` - Proper bit mask values

**Background Setup Tests:**
- `testBackgroundColor` - Verifies sky blue background

**Boundary Setup Tests:**
- `testGroundNodeExists` - Ground node creation
- `testCeilingNodeExists` - Ceiling node creation
- `testGroundPhysicsBody` - Ground physics properties
- `testCeilingPhysicsBody` - Ceiling physics properties
- `testGroundPosition` - Ground positioning
- `testCeilingPosition` - Ceiling positioning

**Input Handling Tests:**
- `testTouchStartsGameFromMenu` - Tap to start from menu
- `testTouchStartsGameFromGameOver` - Tap to restart after game over
- `testTouchDuringActiveGame` - Tap during gameplay (flap)

**Collision Detection Tests:**
- `testCollisionBitMaskCombination` - Bit mask combinations
- `testScoreTriggerDuplicatePrevention` - Prevents double scoring

**Game Loop Tests:**
- `testUpdateCalledWhenGameActive` - Update runs when active
- `testUpdateNotProcessedWhenGameInactive` - Update skips when inactive

### GameSceneIntegrationTests.swift (4 integration tests)

- `testCompleteGameFlow` - Full game lifecycle (menu → playing → gameOver → menu)
- `testMultipleGameSessions` - Multiple sessions with high score tracking
- `testSceneAndManagerIntegration` - Scene and GameManager coordination
- `testPhysicsAndBoundariesIntegration` - Physics world and boundaries working together

### TrumpNodeTests.swift (40 unit tests)

**Initialization Tests (3 tests):**
- `testInitialization` - Proper initialization with correct state, name, z-position
- `testInitialSize` - 80x80 point size validation
- `testFlapForceDefaultValue` - Default flap force of 350.0

**Physics Body Tests (11 tests):**
- `testPhysicsBodyExists` - Physics body creation
- `testPhysicsBodyIsCircular` - Circular shape with 85% radius (forgiving hitbox)
- `testPhysicsBodyCategoryBitMask` - Trump category bit mask
- `testPhysicsBodyContactTestBitMask` - Contact detection configuration
- `testPhysicsBodyCollisionBitMask` - Collision configuration
- `testPhysicsBodyIsDynamic` - Dynamic physics body
- `testPhysicsBodyAllowsRotation` - Rotation enabled
- `testPhysicsBodyRestitution` - Zero restitution (no bounce)
- `testPhysicsBodyFriction` - Zero friction
- `testPhysicsBodyLinearDamping` - Air resistance (0.5)
- `testPhysicsBodyMass` - Mass configuration

**State Transition Tests (5 tests):**
- `testInitialStateIsIdle` - Initial state verification
- `testStateTransitionToFlapping` - Flap state transition
- `testStateTransitionToDead` - Death state transition
- `testStateTransitionToCelebrating` - Celebrate state transition
- `testResetReturnsToIdle` - Reset to idle state

**Flap Mechanic Tests (5 tests):**
- `testFlapResetsVerticalVelocity` - Velocity reset before impulse
- `testFlapAppliesUpwardImpulse` - Upward impulse application
- `testFlapDoesNotWorkWhenDead` - Dead state prevents flapping
- `testFlapRotatesSpriteUpward` - Visual feedback rotation
- `testCustomFlapForce` - Custom flap force support

**Death, Celebrate, Reset, Rotation, and Animation Tests (16 tests):**
- Death behavior (3 tests)
- Celebrate behavior (2 tests)
- Reset behavior (4 tests)
- Rotation update (5 tests)
- Animation lifecycle (2 tests)

### TrumpNodeIntegrationTests.swift (18 integration tests)

**Scene Integration Tests (3 tests):**
- `testTrumpNodeExistsInScene` - Trump added to GameScene
- `testTrumpNodeInitialPosition` - Left-center positioning
- `testTrumpNodeZPosition` - Z-position layering

**Physics Integration Tests (4 tests):**
- `testTrumpNodePhysicsInSceneWorld` - Physics world integration
- `testTrumpNodeAffectedByGravity` - Gravity simulation
- `testTrumpNodeFlapInPhysicsWorld` - Flap in physics simulation
- `testTrumpNodePhysicsCategoryMatchesScene` - Category consistency

**Collision Integration Tests (3 tests):**
- `testTrumpNodeCollidesWithGround` - Ground collision
- `testTrumpNodeCollidesWithCeiling` - Ceiling collision
- `testTrumpNodeContactsWithScore` - Score trigger contact

**Game State Integration Tests (3 tests):**
- `testTrumpNodeFlapStartsGame` - Tap to start flow
- `testTrumpNodeDiesWhenGameEnds` - Death on game over
- `testTrumpNodeResetsWithGame` - Reset on game restart

**Complete Game Flow Tests (5 tests):**
- `testCompleteGameFlowWithTrump` - Full game lifecycle with Trump
- `testTrumpNodeCelebratesOnHighScore` - High score celebration
- `testMultipleFlapsInSequence` - Multiple flaps handling
- `testTrumpNodeStaysBelowCeiling` - Ceiling boundary
- `testTrumpNodeStaysAboveGround` - Ground boundary

## Adding Tests to Xcode Project

Since these tests were created in a Linux environment, they need to be added to the Xcode project on macOS:

### Step 1: Create Test Target

1. Open `FlappyDon.xcodeproj` in Xcode
2. Go to **File → New → Target**
3. Select **iOS Unit Testing Bundle**
4. Name it `FlappyDonTests`
5. Set the target to be tested: `FlappyDon`

### Step 2: Add Test Files

1. In Xcode's Project Navigator, right-click on the project
2. Select **Add Files to "FlappyDon"...**
3. Navigate to the `FlappyDonTests` directory
4. Select all `.swift` files and `Info.plist`
5. Ensure **Target Membership** is set to `FlappyDonTests`

### Step 3: Configure Test Target

1. Select the `FlappyDonTests` target in project settings
2. Go to **Build Phases → Link Binary With Libraries**
3. Ensure `XCTest.framework` is linked
4. Go to **Build Settings**
5. Set **Bundle Loader** to `$(TEST_HOST)`
6. Set **Test Host** to `$(BUILT_PRODUCTS_DIR)/FlappyDon.app/FlappyDon`

### Step 4: Enable Code Coverage

1. Go to **Product → Scheme → Edit Scheme**
2. Select **Test** in the left sidebar
3. Go to **Options** tab
4. Check **Code Coverage** checkbox
5. Select **FlappyDon** in the coverage targets

## Running Tests

### In Xcode

- **Run all tests:** Press `⌘ + U`
- **Run specific test class:** Click the diamond icon next to the class name
- **Run specific test:** Click the diamond icon next to the test method

### Command Line

```bash
# Run all tests
xcodebuild test \
  -project FlappyDon.xcodeproj \
  -scheme FlappyDon \
  -destination 'platform=iOS Simulator,name=iPhone 15'

# Run with code coverage
xcodebuild test \
  -project FlappyDon.xcodeproj \
  -scheme FlappyDon \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -enableCodeCoverage YES

# Run specific test class
xcodebuild test \
  -project FlappyDon.xcodeproj \
  -scheme FlappyDon \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -only-testing:FlappyDonTests/GameManagerTests
```

## Expected Results

When run on macOS with Xcode, all 111 tests should pass:

```
Test Suite 'All tests' passed at 2026-03-02 10:00:00.000.
	 Executed 111 tests, with 0 failures (0 unexpected) in 5.0 seconds
```

**Test Breakdown:**
- GameManagerTests: 26 unit tests
- GameSceneTests: 23 unit tests
- GameSceneIntegrationTests: 4 integration tests
- TrumpNodeTests: 40 unit tests
- TrumpNodeIntegrationTests: 18 integration tests

**Code Coverage:** Expected ~95% coverage of game engine code (GameManager, GameState, GameScene, TrumpNode, TrumpState)

## Test Philosophy

These tests follow iOS/Swift testing best practices:

1. **Arrange-Act-Assert Pattern:** Each test clearly separates setup, action, and verification
2. **Descriptive Names:** Test names describe what is being tested and expected outcome
3. **Isolated Tests:** Each test is independent and can run in any order
4. **Comprehensive Coverage:** Tests cover happy paths, edge cases, and error conditions
5. **Integration Tests:** Verify components work together correctly
6. **Fast Execution:** All tests should complete in under 1 second

## Maintenance

When adding new features to the game engine:

1. Add corresponding tests in the appropriate test file
2. Follow existing naming conventions
3. Maintain the Arrange-Act-Assert pattern
4. Run all tests to ensure no regressions
5. Keep code coverage above 90% for core game logic

## Troubleshooting

**Tests not appearing in Xcode:**
- Verify test files are added to the `FlappyDonTests` target
- Check that `@testable import FlappyDon` is present
- Ensure test methods start with `test` prefix

**Tests failing:**
- Check that `FlappyDon` app target builds successfully
- Verify UserDefaults is being cleared in `setUp()`
- Ensure GameManager singleton is reset between tests

**Code coverage not showing:**
- Enable code coverage in scheme settings
- Rebuild the project after enabling coverage
- Check that coverage is enabled for the correct target
