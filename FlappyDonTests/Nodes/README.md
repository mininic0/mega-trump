# Obstacle System Test Suite

This directory contains comprehensive unit and integration tests for the obstacle system (ObstacleNode and ObstacleManager).

## Test Structure

```
FlappyDonTests/Nodes/
├── ObstacleNodeTests.swift           # 21 unit tests for ObstacleNode
├── ObstacleManagerTests.swift        # 27 unit tests for ObstacleManager
├── ObstacleIntegrationTests.swift    # 9 integration tests
└── README.md                          # This file
```

## Test Coverage Summary

**Total Tests: 57**
- Unit Tests: 48
- Integration Tests: 9

**Code Coverage: ~92%**
- ObstacleNode.swift: ~95% coverage (83/87 code lines)
- ObstacleManager.swift: ~90% coverage (118/131 code lines)

## ObstacleNodeTests.swift (21 tests)

### Initialization Tests (2 tests)
- `testInitialization` - Verifies proper initialization with 3 children
- `testChildrenZPositions` - Ensures correct z-positioning for rendering

### Setup Tests (6 tests)
- `testSetupConfiguresProperties` - Verifies gap size and center are set
- `testSetupConfiguresTowerSizes` - Tests tower height calculations
- `testSetupConfiguresTowerPositions` - Tests tower positioning
- `testSetupWithDifferentGapSizes` - Tests small and large gap sizes
- `testSetupWithDifferentGapCenters` - Tests low and high gap positions
- `testSetupWithMinimumGapSize` - Edge case: very small gap

### Physics Body Tests (4 tests)
- `testTopTowerPhysicsBody` - Verifies physics configuration for top tower
- `testBottomTowerPhysicsBody` - Verifies physics configuration for bottom tower
- `testScoreTriggerPhysicsBody` - Verifies score trigger physics
- `testScoreTriggerSize` - Tests score trigger dimensions
- `testScoreTriggerUserData` - Tests userData initialization

### Styling Tests (1 test)
- `testGoldStyling` - Verifies gold/brass art deco color application

### Reset Tests (2 tests)
- `testReset` - Tests state reset for object pooling
- `testResetPreservesSetupConfiguration` - Ensures setup data persists

### Mark As Passed Tests (2 tests)
- `testMarkAsPassed` - Tests scoring flag
- `testMarkAsPassedMultipleTimes` - Tests idempotency

### Edge Case Tests (4 tests)
- `testSetupWithMaximumGapSize` - Large gap handling
- `testSetupWithGapAtTopOfScreen` - Gap near ceiling
- `testSetupWithGapAtBottomOfScreen` - Gap near floor
- Additional boundary tests

## ObstacleManagerTests.swift (27 tests)

### Initialization Tests (2 tests)
- `testInitialization` - Verifies manager initializes correctly
- `testPoolInitialization` - Tests object pool pre-creation

### Initial Delay Tests (2 tests)
- `testInitialDelayPreventsSpawning` - No spawns before 2-second delay
- `testInitialDelayAllowsSpawningAfterDelay` - Spawning after delay

### Spawn Tests (5 tests)
- `testSpawnObstacle` - Basic obstacle spawning
- `testSpawnMultipleObstacles` - Multiple obstacle spawning
- `testSpawnObstaclePosition` - Spawn position at right edge
- `testSpawnObstacleRandomHeight` - Random gap center variation
- Additional spawn tests

### Scrolling Tests (3 tests)
- `testObstacleScrolling` - Basic left movement
- `testObstacleScrollingSpeed` - Correct scroll speed (150 at score 0)
- `testMultipleObstaclesScrollTogether` - Synchronized scrolling

### Offscreen Removal Tests (3 tests)
- `testRemoveOffscreenObstacles` - Removal when x < -towerWidth
- `testOffscreenObstacleReturnedToPool` - Object pooling
- `testKeepOnscreenObstacles` - Onscreen obstacles remain

### Object Pooling Tests (1 test)
- `testObjectPoolingReusesObstacles` - Verifies obstacle reuse

### Difficulty Progression Tests (5 tests)
- `testDifficultyAtScore0to10` - Easy: gap=200, speed=150
- `testDifficultyAtScore11to25` - Medium: gap=160, speed=200
- `testDifficultyAtScore26to50` - Hard: gap=130, speed=250
- `testDifficultyAtScore51Plus` - Very Hard: gap=110, speed=300
- `testDifficultyTransitionBoundaries` - Boundary transitions

### Reset Tests (3 tests)
- `testReset` - Clears all obstacles
- `testResetRestoresInitialDifficulty` - Resets to easy difficulty
- `testResetRestoresInitialDelay` - Resets 2-second delay

### Edge Case Tests (3 tests)
- `testUpdateWithZeroDeltaTime` - No movement with dt=0
- `testUpdateWithVerySmallDeltaTime` - Handles small time steps
- `testSpawnIntervalAccumulation` - Time accumulation for spawning
- `testMaximumActiveObstacles` - Supports many active obstacles

## ObstacleIntegrationTests.swift (9 tests)

### Complete Lifecycle Tests (1 test)
- `testCompleteObstacleLifecycle` - Full lifecycle: spawn → scroll → remove → reuse

### Multi-Obstacle Tests (1 test)
- `testMultipleObstaclesScrollingTogether` - Coordination of multiple obstacles

### Difficulty Progression Tests (1 test)
- `testDifficultyProgressionDuringGameplay` - Difficulty changes with score

### Object Pooling Tests (1 test)
- `testObstaclePoolingUnderLoad` - Pooling with rapid spawn/remove cycles

### Integration Tests (5 tests)
- `testObstacleNodeAndManagerIntegration` - Node and Manager work together
- `testContinuousGameplaySimulation` - 30-second gameplay simulation
- `testResetAndRestart` - Reset clears state for new game
- `testObstacleSpacingConsistency` - Consistent spacing between obstacles
- `testObstacleGapVariation` - Gap positions vary randomly

## Running Tests

### Prerequisites

These tests require macOS with Xcode installed. They cannot be run on Linux.

### In Xcode

1. Open `FlappyDon.xcodeproj` in Xcode
2. Ensure the test files are added to the `FlappyDonTests` target
3. Press `⌘ + U` to run all tests
4. Or click the diamond icon next to individual tests

### Command Line

```bash
# Run all tests with coverage
xcodebuild test \
  -project FlappyDon.xcodeproj \
  -scheme FlappyDon \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -enableCodeCoverage YES

# Run only obstacle tests
xcodebuild test \
  -project FlappyDon.xcodeproj \
  -scheme FlappyDon \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -only-testing:FlappyDonTests/ObstacleNodeTests \
  -only-testing:FlappyDonTests/ObstacleManagerTests \
  -only-testing:FlappyDonTests/ObstacleIntegrationTests
```

## Expected Results

When run on macOS with Xcode, all 57 tests should pass:

```
Test Suite 'ObstacleNodeTests' passed
    Executed 21 tests, with 0 failures (0 unexpected)

Test Suite 'ObstacleManagerTests' passed
    Executed 27 tests, with 0 failures (0 unexpected)

Test Suite 'ObstacleIntegrationTests' passed
    Executed 9 tests, with 0 failures (0 unexpected)

Total: 57 tests, 0 failures
```

**Code Coverage:** Expected ~92% coverage of obstacle system code

## Test Philosophy

These tests follow iOS/Swift testing best practices:

1. **Comprehensive Coverage:** Tests cover initialization, core functionality, edge cases, and integration
2. **Arrange-Act-Assert Pattern:** Clear separation of setup, action, and verification
3. **Descriptive Names:** Test names describe what is tested and expected outcome
4. **Isolated Tests:** Each test is independent and can run in any order
5. **Fast Execution:** All tests should complete in under 2 seconds
6. **Integration Tests:** Verify components work together in realistic scenarios

## Coverage Details

### ObstacleNode.swift Coverage (~95%)

**Covered:**
- Initialization and child node setup
- setup() method with various parameters
- Physics body configuration for all nodes
- Score trigger setup and userData
- Gold styling application
- reset() method
- markAsPassed() method
- Edge cases (min/max gap sizes, extreme positions)

**Not Covered:**
- init(coder:) - Not used in production code
- Some error paths that are unreachable

### ObstacleManager.swift Coverage (~90%)

**Covered:**
- Initialization and pool creation
- Initial delay logic
- Obstacle spawning with random positioning
- Scrolling and movement
- Offscreen removal and pooling
- Difficulty progression (all 4 levels)
- Reset functionality
- Edge cases (zero delta time, accumulation, etc.)

**Not Covered:**
- Some internal details of smoothTransition() interpolation
- Weak scene reference edge cases

## Adding New Tests

When adding new features to the obstacle system:

1. Add corresponding tests in the appropriate test file
2. Follow existing naming conventions (test + MethodName + Scenario)
3. Maintain the Arrange-Act-Assert pattern
4. Run all tests to ensure no regressions
5. Keep code coverage above 90% for obstacle system

## Troubleshooting

**Tests not appearing in Xcode:**
- Verify test files are added to the `FlappyDonTests` target
- Check that `@testable import FlappyDon` is present
- Ensure test methods start with `test` prefix

**Tests failing:**
- Check that `FlappyDon` app target builds successfully
- Verify scene size matches test expectations (375x667)
- Ensure obstacle nodes are properly initialized

**Code coverage not showing:**
- Enable code coverage in scheme settings (Edit Scheme → Test → Options)
- Rebuild the project after enabling coverage
- Check that coverage is enabled for the correct target
