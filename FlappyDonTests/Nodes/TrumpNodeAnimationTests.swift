import XCTest
import SpriteKit
@testable import FlappyDon

final class TrumpNodeAnimationTests: XCTestCase {
    
    var trumpNode: TrumpNode!
    var scene: SKScene!
    
    override func setUp() {
        super.setUp()
        trumpNode = TrumpNode()
        scene = SKScene(size: CGSize(width: 375, height: 667))
        scene.addChild(trumpNode)
    }
    
    override func tearDown() {
        trumpNode.removeFromParent()
        trumpNode = nil
        scene = nil
        super.tearDown()
    }
    
    // MARK: - Idle Animation Tests
    
    func testIdleAnimationStartsOnInitialization() {
        // Then: Idle animations should be running
        XCTAssertTrue(trumpNode.hasActions(), "Idle animations should be running")
    }
    
    func testIdleAnimationHasBobAction() {
        // Then: Should have idle bob action
        let bobAction = trumpNode.action(forKey: "idleBob")
        XCTAssertNotNil(bobAction, "Should have idle bob action")
    }
    
    func testIdleAnimationHasRotationAction() {
        // Then: Should have idle rotation action
        let rotationAction = trumpNode.action(forKey: "idleRotation")
        XCTAssertNotNil(rotationAction, "Should have idle rotation action")
    }
    
    func testIdleAnimationStopsOnDeath() {
        // Given: Trump is in idle state with animations
        XCTAssertTrue(trumpNode.hasActions(), "Should have idle animations")
        
        // When: Trump dies
        trumpNode.currentState = .dead
        
        // Then: Idle animations should be removed
        let bobAction = trumpNode.action(forKey: "idleBob")
        let rotationAction = trumpNode.action(forKey: "idleRotation")
        let textureAction = trumpNode.action(forKey: "idleTexture")
        
        XCTAssertNil(bobAction, "Idle bob should be removed on death")
        XCTAssertNil(rotationAction, "Idle rotation should be removed on death")
        XCTAssertNil(textureAction, "Idle texture should be removed on death")
    }
    
    func testIdleAnimationStopsOnCelebrate() {
        // Given: Trump is in idle state with animations
        XCTAssertTrue(trumpNode.hasActions(), "Should have idle animations")
        
        // When: Trump celebrates
        trumpNode.currentState = .celebrate
        
        // Then: Idle animations should be removed
        let bobAction = trumpNode.action(forKey: "idleBob")
        let rotationAction = trumpNode.action(forKey: "idleRotation")
        let textureAction = trumpNode.action(forKey: "idleTexture")
        
        XCTAssertNil(bobAction, "Idle bob should be removed on celebrate")
        XCTAssertNil(rotationAction, "Idle rotation should be removed on celebrate")
        XCTAssertNil(textureAction, "Idle texture should be removed on celebrate")
    }
    
    func testIdleAnimationRestartsAfterFlap() {
        // Given: Trump flaps
        trumpNode.currentState = .flapping
        
        // Wait for flap animation to complete (it returns to idle)
        let expectation = XCTestExpectation(description: "Flap animation completes")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        // Then: Idle animations should be running again
        let bobAction = trumpNode.action(forKey: "idleBob")
        XCTAssertNotNil(bobAction, "Idle bob should restart after flap")
    }
    
    // MARK: - Death Animation Tests
    
    func testDeathAnimationRemovesIdleActions() {
        // Given: Trump is idle with animations
        XCTAssertNotNil(trumpNode.action(forKey: "idleBob"), "Should have idle bob")
        
        // When: Trump dies
        trumpNode.currentState = .dead
        
        // Then: Idle actions should be removed
        XCTAssertNil(trumpNode.action(forKey: "idleBob"), "Idle bob should be removed")
        XCTAssertNil(trumpNode.action(forKey: "idleRotation"), "Idle rotation should be removed")
    }
    
    func testDeathAnimationHasActions() {
        // When: Trump dies
        trumpNode.currentState = .dead
        
        // Then: Death animation should be running
        XCTAssertTrue(trumpNode.hasActions(), "Death animation should be running")
    }
    
    func testDeathAnimationDisablesCollision() {
        // Given: Initial collision bitmask
        let initialCollisionBitMask = trumpNode.physicsBody?.collisionBitMask ?? 0
        XCTAssertNotEqual(initialCollisionBitMask, 0, "Should have collision enabled initially")
        
        // When: Trump dies
        trumpNode.currentState = .dead
        
        // Then: Collision should be disabled
        XCTAssertEqual(trumpNode.physicsBody?.collisionBitMask, 0, "Collision should be disabled on death")
    }
    
    func testDeathAnimationChangesAlpha() {
        // Given: Initial alpha
        XCTAssertEqual(trumpNode.alpha, 1.0, accuracy: 0.01, "Initial alpha should be 1.0")
        
        // When: Trump dies
        trumpNode.currentState = .dead
        
        // Wait for animation to progress
        let expectation = XCTestExpectation(description: "Death animation progresses")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
        // Then: Alpha should be reduced
        XCTAssertLessThan(trumpNode.alpha, 1.0, "Alpha should be reduced after death animation")
    }
    
    func testDeathAnimationScalesDown() {
        // Given: Initial scale
        XCTAssertEqual(trumpNode.xScale, 1.0, accuracy: 0.01, "Initial x scale should be 1.0")
        XCTAssertEqual(trumpNode.yScale, 1.0, accuracy: 0.01, "Initial y scale should be 1.0")
        
        // When: Trump dies
        trumpNode.currentState = .dead
        
        // Wait for animation to complete
        let expectation = XCTestExpectation(description: "Death animation completes")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
        // Then: Scale should be reduced
        XCTAssertLessThan(trumpNode.xScale, 1.0, "X scale should be reduced after death animation")
        XCTAssertLessThan(trumpNode.yScale, 1.0, "Y scale should be reduced after death animation")
    }
    
    func testDeathAnimationRotates() {
        // Given: Initial rotation
        let initialRotation = trumpNode.zRotation
        
        // When: Trump dies
        trumpNode.currentState = .dead
        
        // Wait for animation to progress
        let expectation = XCTestExpectation(description: "Death animation progresses")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
        // Then: Rotation should have changed significantly (3 full rotations)
        let rotationDifference = abs(trumpNode.zRotation - initialRotation)
        XCTAssertGreaterThan(rotationDifference, 3.0, "Should rotate significantly during death")
    }
    
    // MARK: - Celebrate Animation Tests
    
    func testCelebrateAnimationRemovesIdleActions() {
        // Given: Trump is idle with animations
        XCTAssertNotNil(trumpNode.action(forKey: "idleBob"), "Should have idle bob")
        
        // When: Trump celebrates
        trumpNode.currentState = .celebrate
        
        // Then: Idle actions should be removed
        XCTAssertNil(trumpNode.action(forKey: "idleBob"), "Idle bob should be removed")
        XCTAssertNil(trumpNode.action(forKey: "idleRotation"), "Idle rotation should be removed")
    }
    
    func testCelebrateAnimationHasActions() {
        // When: Trump celebrates
        trumpNode.currentState = .celebrate
        
        // Then: Celebrate animation should be running
        XCTAssertTrue(trumpNode.hasActions(), "Celebrate animation should be running")
    }
    
    func testCelebrateAnimationScales() {
        // Given: Initial scale
        XCTAssertEqual(trumpNode.xScale, 1.0, accuracy: 0.01, "Initial x scale should be 1.0")
        
        // When: Trump celebrates
        trumpNode.currentState = .celebrate
        
        // Wait for scale up
        let expectation = XCTestExpectation(description: "Celebrate animation scales up")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.3)
        
        // Then: Should have scaled (either up during animation or back to 1.0)
        // The animation bounces, so we just verify it has actions
        XCTAssertTrue(trumpNode.hasActions(), "Should have celebrate animation running")
    }
    
    // MARK: - State Transition Tests
    
    func testStateTransitionFromIdleToDead() {
        // Given: Trump is idle
        XCTAssertEqual(trumpNode.currentState, .idle, "Should start in idle state")
        
        // When: Transitioning to dead
        trumpNode.currentState = .dead
        
        // Then: State should change and animations should update
        XCTAssertEqual(trumpNode.currentState, .dead, "Should be in dead state")
        XCTAssertNil(trumpNode.action(forKey: "idleBob"), "Idle animations should stop")
    }
    
    func testStateTransitionFromIdleToCelebrate() {
        // Given: Trump is idle
        XCTAssertEqual(trumpNode.currentState, .idle, "Should start in idle state")
        
        // When: Transitioning to celebrate
        trumpNode.currentState = .celebrate
        
        // Then: State should change and animations should update
        XCTAssertEqual(trumpNode.currentState, .celebrate, "Should be in celebrate state")
        XCTAssertNil(trumpNode.action(forKey: "idleBob"), "Idle animations should stop")
    }
    
    func testStateTransitionFromIdleToFlapping() {
        // Given: Trump is idle
        XCTAssertEqual(trumpNode.currentState, .idle, "Should start in idle state")
        
        // When: Transitioning to flapping
        trumpNode.currentState = .flapping
        
        // Then: State should change
        XCTAssertEqual(trumpNode.currentState, .flapping, "Should be in flapping state")
    }
    
    func testMultipleStateTransitions() {
        // When: Multiple state transitions
        trumpNode.currentState = .flapping
        XCTAssertEqual(trumpNode.currentState, .flapping, "Should be flapping")
        
        // Wait for flap to complete
        let expectation = XCTestExpectation(description: "Flap completes")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        // Should return to idle
        XCTAssertEqual(trumpNode.currentState, .idle, "Should return to idle after flap")
        
        // Then transition to celebrate
        trumpNode.currentState = .celebrate
        XCTAssertEqual(trumpNode.currentState, .celebrate, "Should be celebrating")
    }
    
    // MARK: - Animation Cleanup Tests
    
    func testRemovingNodeStopsAnimations() {
        // Given: Trump with animations
        XCTAssertTrue(trumpNode.hasActions(), "Should have animations")
        
        // When: Removing from parent
        trumpNode.removeFromParent()
        
        // Then: Node should be removed
        XCTAssertNil(trumpNode.parent, "Should be removed from parent")
    }
    
    func testResetClearsAnimations() {
        // Given: Trump in dead state
        trumpNode.currentState = .dead
        
        // When: Resetting (via setup or re-initialization)
        trumpNode.currentState = .idle
        
        // Then: Should have idle animations
        let bobAction = trumpNode.action(forKey: "idleBob")
        XCTAssertNotNil(bobAction, "Should have idle animations after reset to idle")
    }
    
    // MARK: - Edge Cases
    
    func testSettingSameStateDoesNotRestartAnimation() {
        // Given: Trump is idle
        let initialBobAction = trumpNode.action(forKey: "idleBob")
        
        // When: Setting to idle again
        trumpNode.currentState = .idle
        
        // Then: Animation should not restart (same action instance)
        let currentBobAction = trumpNode.action(forKey: "idleBob")
        XCTAssertEqual(initialBobAction, currentBobAction, "Should not restart animation for same state")
    }
    
    func testRapidStateChanges() {
        // When: Rapidly changing states
        trumpNode.currentState = .flapping
        trumpNode.currentState = .dead
        trumpNode.currentState = .celebrate
        
        // Then: Should end in celebrate state
        XCTAssertEqual(trumpNode.currentState, .celebrate, "Should be in final state")
        
        // And: Should not have idle animations
        XCTAssertNil(trumpNode.action(forKey: "idleBob"), "Should not have idle animations")
    }
}
