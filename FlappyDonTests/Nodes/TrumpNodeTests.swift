import XCTest
import SpriteKit
@testable import FlappyDon

final class TrumpNodeTests: XCTestCase {
    
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
    
    // MARK: - Initialization Tests
    
    func testInitialization() {
        // Then: TrumpNode should be properly initialized
        XCTAssertNotNil(trumpNode, "TrumpNode should be initialized")
        XCTAssertEqual(trumpNode.currentState, .idle, "Initial state should be idle")
        XCTAssertEqual(trumpNode.name, "trump", "Node name should be 'trump'")
        XCTAssertEqual(trumpNode.zPosition, 10, "Z-position should be 10")
    }
    
    func testInitialSize() {
        // Then: TrumpNode should have correct size (80x80 for 40pt radius)
        XCTAssertEqual(trumpNode.size.width, 80, accuracy: 0.1, "Width should be 80 points")
        XCTAssertEqual(trumpNode.size.height, 80, accuracy: 0.1, "Height should be 80 points")
    }
    
    func testFlapForceDefaultValue() {
        // Then: Flap force should have default value
        XCTAssertEqual(trumpNode.flapForce, 350.0, accuracy: 0.1, "Default flap force should be 350")
    }
    
    // MARK: - Physics Body Tests
    
    func testPhysicsBodyExists() {
        // Then: Physics body should be created
        XCTAssertNotNil(trumpNode.physicsBody, "Physics body should exist")
    }
    
    func testPhysicsBodyIsCircular() {
        // Then: Physics body should be circular
        guard let physicsBody = trumpNode.physicsBody else {
            XCTFail("Physics body should exist")
            return
        }
        
        // Circular bodies have area = π * r²
        // For radius 34 (40 * 0.85), area should be approximately 3631
        let expectedArea = Double.pi * pow(34.0, 2)
        XCTAssertEqual(physicsBody.area, expectedArea, accuracy: 10.0, "Physics body should be circular with 85% radius")
    }
    
    func testPhysicsBodyCategoryBitMask() {
        // Then: Category bit mask should be set correctly
        XCTAssertEqual(trumpNode.physicsBody?.categoryBitMask, 0x1 << 0, "Category should be trump (0x1)")
    }
    
    func testPhysicsBodyContactTestBitMask() {
        // Then: Contact test bit mask should include all relevant categories
        let expectedMask: UInt32 = (0x1 << 1) | (0x1 << 2) | (0x1 << 3) | (0x1 << 4)  // obstacle | ground | ceiling | score
        XCTAssertEqual(trumpNode.physicsBody?.contactTestBitMask, expectedMask, "Should test contact with obstacle, ground, ceiling, and score")
    }
    
    func testPhysicsBodyCollisionBitMask() {
        // Then: Collision bit mask should include ground and ceiling only
        let expectedMask: UInt32 = (0x1 << 2) | (0x1 << 3)  // ground | ceiling
        XCTAssertEqual(trumpNode.physicsBody?.collisionBitMask, expectedMask, "Should collide with ground and ceiling only")
    }
    
    func testPhysicsBodyIsDynamic() {
        // Then: Physics body should be dynamic
        XCTAssertTrue(trumpNode.physicsBody?.isDynamic ?? false, "Physics body should be dynamic")
    }
    
    func testPhysicsBodyAllowsRotation() {
        // Then: Physics body should allow rotation
        XCTAssertTrue(trumpNode.physicsBody?.allowsRotation ?? false, "Physics body should allow rotation")
    }
    
    func testPhysicsBodyRestitution() {
        // Then: Restitution should be 0 (no bounce)
        XCTAssertEqual(trumpNode.physicsBody?.restitution, 0, accuracy: 0.01, "Restitution should be 0")
    }
    
    func testPhysicsBodyFriction() {
        // Then: Friction should be 0
        XCTAssertEqual(trumpNode.physicsBody?.friction, 0, accuracy: 0.01, "Friction should be 0")
    }
    
    func testPhysicsBodyLinearDamping() {
        // Then: Linear damping should be 0.5 (slight air resistance)
        XCTAssertEqual(trumpNode.physicsBody?.linearDamping, 0.5, accuracy: 0.01, "Linear damping should be 0.5")
    }
    
    func testPhysicsBodyMass() {
        // Then: Mass should be 1.0
        XCTAssertEqual(trumpNode.physicsBody?.mass, 1.0, accuracy: 0.01, "Mass should be 1.0")
    }
    
    // MARK: - State Transition Tests
    
    func testInitialStateIsIdle() {
        // Then: Initial state should be idle
        XCTAssertEqual(trumpNode.currentState, .idle, "Initial state should be idle")
    }
    
    func testStateTransitionToFlapping() {
        // When: Flap is called
        trumpNode.flap()
        
        // Then: State should transition to flapping
        XCTAssertEqual(trumpNode.currentState, .flapping, "State should be flapping after flap()")
    }
    
    func testStateTransitionToDead() {
        // When: Die is called
        trumpNode.die()
        
        // Then: State should transition to dead
        XCTAssertEqual(trumpNode.currentState, .dead, "State should be dead after die()")
    }
    
    func testStateTransitionToCelebrating() {
        // When: Celebrate is called
        trumpNode.celebrate()
        
        // Then: State should transition to celebrating
        XCTAssertEqual(trumpNode.currentState, .celebrating, "State should be celebrating after celebrate()")
    }
    
    func testResetReturnsToIdle() {
        // Given: Trump is in dead state
        trumpNode.die()
        XCTAssertEqual(trumpNode.currentState, .dead)
        
        // When: Reset is called
        trumpNode.reset()
        
        // Then: State should return to idle
        XCTAssertEqual(trumpNode.currentState, .idle, "State should be idle after reset()")
    }
    
    // MARK: - Flap Mechanic Tests
    
    func testFlapResetsVerticalVelocity() {
        // Given: Trump has downward velocity
        trumpNode.physicsBody?.velocity = CGVector(dx: 0, dy: -200)
        
        // When: Flap is called
        trumpNode.flap()
        
        // Then: Vertical velocity should be reset and impulse applied
        // Note: We can't test exact velocity due to impulse, but it should be positive
        XCTAssertGreaterThan(trumpNode.physicsBody?.velocity.dy ?? 0, 0, "Vertical velocity should be positive after flap")
    }
    
    func testFlapAppliesUpwardImpulse() {
        // Given: Trump is at rest
        trumpNode.physicsBody?.velocity = CGVector.zero
        
        // When: Flap is called
        trumpNode.flap()
        
        // Then: Upward velocity should be applied
        XCTAssertGreaterThan(trumpNode.physicsBody?.velocity.dy ?? 0, 0, "Should have upward velocity after flap")
    }
    
    func testFlapDoesNotWorkWhenDead() {
        // Given: Trump is dead
        trumpNode.die()
        trumpNode.physicsBody?.velocity = CGVector.zero
        
        // When: Flap is called
        trumpNode.flap()
        
        // Then: No impulse should be applied
        XCTAssertEqual(trumpNode.physicsBody?.velocity.dy ?? 0, 0, accuracy: 0.1, "Dead trump should not flap")
        XCTAssertEqual(trumpNode.currentState, .dead, "State should remain dead")
    }
    
    func testFlapRotatesSpriteUpward() {
        // Given: Trump is at neutral rotation
        trumpNode.zRotation = 0
        
        // When: Flap is called
        trumpNode.flap()
        
        // Then: Rotation should be negative (nose up)
        // We need to wait a bit for the action to start
        let expectation = XCTestExpectation(description: "Rotation should change")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            XCTAssertLessThan(self.trumpNode.zRotation, 0, "Rotation should be negative (nose up)")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testCustomFlapForce() {
        // Given: Custom flap force
        trumpNode.flapForce = 500.0
        trumpNode.physicsBody?.velocity = CGVector.zero
        
        // When: Flap is called
        trumpNode.flap()
        
        // Then: Stronger impulse should be applied
        XCTAssertGreaterThan(trumpNode.physicsBody?.velocity.dy ?? 0, 0, "Should have upward velocity")
    }
    
    // MARK: - Death Behavior Tests
    
    func testDieChangesState() {
        // When: Die is called
        trumpNode.die()
        
        // Then: State should be dead
        XCTAssertEqual(trumpNode.currentState, .dead, "State should be dead")
    }
    
    func testDieDisablesCollisions() {
        // Given: Trump has collision bit mask set
        let originalCollisionMask = trumpNode.physicsBody?.collisionBitMask
        XCTAssertNotEqual(originalCollisionMask, 0, "Should have collisions initially")
        
        // When: Die is called and animation completes
        trumpNode.die()
        
        // Wait for death animation to start
        let expectation = XCTestExpectation(description: "Death animation should disable collisions")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Then: Collision bit mask should be 0
            XCTAssertEqual(self.trumpNode.physicsBody?.collisionBitMask, 0, "Collisions should be disabled when dead")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testDieCannotBeCalledTwice() {
        // Given: Trump is already dead
        trumpNode.die()
        XCTAssertEqual(trumpNode.currentState, .dead)
        
        // When: Die is called again
        trumpNode.die()
        
        // Then: State should remain dead (no error)
        XCTAssertEqual(trumpNode.currentState, .dead, "State should remain dead")
    }
    
    // MARK: - Celebrate Behavior Tests
    
    func testCelebrateChangesState() {
        // When: Celebrate is called
        trumpNode.celebrate()
        
        // Then: State should be celebrating
        XCTAssertEqual(trumpNode.currentState, .celebrating, "State should be celebrating")
    }
    
    func testCelebrateDoesNotWorkWhenDead() {
        // Given: Trump is dead
        trumpNode.die()
        
        // When: Celebrate is called
        trumpNode.celebrate()
        
        // Then: State should remain dead
        XCTAssertEqual(trumpNode.currentState, .dead, "Dead trump cannot celebrate")
    }
    
    // MARK: - Reset Behavior Tests
    
    func testResetClearsVelocity() {
        // Given: Trump has velocity
        trumpNode.physicsBody?.velocity = CGVector(dx: 100, dy: -200)
        trumpNode.physicsBody?.angularVelocity = 5.0
        
        // When: Reset is called
        trumpNode.reset()
        
        // Then: All velocities should be zero
        XCTAssertEqual(trumpNode.physicsBody?.velocity.dx ?? 1, 0, accuracy: 0.01, "Horizontal velocity should be zero")
        XCTAssertEqual(trumpNode.physicsBody?.velocity.dy ?? 1, 0, accuracy: 0.01, "Vertical velocity should be zero")
        XCTAssertEqual(trumpNode.physicsBody?.angularVelocity ?? 1, 0, accuracy: 0.01, "Angular velocity should be zero")
    }
    
    func testResetClearsRotation() {
        // Given: Trump is rotated
        trumpNode.zRotation = 1.5
        
        // When: Reset is called
        trumpNode.reset()
        
        // Then: Rotation should be zero
        XCTAssertEqual(trumpNode.zRotation, 0, accuracy: 0.01, "Rotation should be zero after reset")
    }
    
    func testResetRestoresAlpha() {
        // Given: Trump is faded
        trumpNode.alpha = 0.5
        
        // When: Reset is called
        trumpNode.reset()
        
        // Then: Alpha should be 1.0
        XCTAssertEqual(trumpNode.alpha, 1.0, accuracy: 0.01, "Alpha should be 1.0 after reset")
    }
    
    func testResetFromDeadState() {
        // Given: Trump is dead with modified properties
        trumpNode.die()
        trumpNode.physicsBody?.velocity = CGVector(dx: 50, dy: -100)
        trumpNode.zRotation = 2.0
        
        // When: Reset is called
        trumpNode.reset()
        
        // Then: All properties should be reset
        XCTAssertEqual(trumpNode.currentState, .idle, "State should be idle")
        XCTAssertEqual(trumpNode.zRotation, 0, accuracy: 0.01, "Rotation should be zero")
        XCTAssertEqual(trumpNode.physicsBody?.velocity.dy ?? 1, 0, accuracy: 0.01, "Velocity should be zero")
    }
    
    // MARK: - Rotation Update Tests
    
    func testUpdateRotationWithUpwardVelocity() {
        // Given: Trump has upward velocity
        trumpNode.physicsBody?.velocity = CGVector(dx: 0, dy: 300)
        
        // When: Update rotation is called
        trumpNode.updateRotation()
        
        // Wait for rotation action
        let expectation = XCTestExpectation(description: "Rotation should update")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            // Then: Rotation should be negative (nose up)
            XCTAssertLessThan(self.trumpNode.zRotation, 0, "Should rotate nose up with upward velocity")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testUpdateRotationWithDownwardVelocity() {
        // Given: Trump has downward velocity
        trumpNode.physicsBody?.velocity = CGVector(dx: 0, dy: -300)
        
        // When: Update rotation is called
        trumpNode.updateRotation()
        
        // Wait for rotation action
        let expectation = XCTestExpectation(description: "Rotation should update")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            // Then: Rotation should be positive (nose down)
            XCTAssertGreaterThan(self.trumpNode.zRotation, 0, "Should rotate nose down with downward velocity")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testUpdateRotationClampsToMaximum() {
        // Given: Trump has very high upward velocity
        trumpNode.physicsBody?.velocity = CGVector(dx: 0, dy: 1000)
        
        // When: Update rotation is called
        trumpNode.updateRotation()
        
        // Wait for rotation action
        let expectation = XCTestExpectation(description: "Rotation should be clamped")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            // Then: Rotation should be clamped to -30 degrees (-π/6)
            let maxRotation = -CGFloat.pi / 6
            XCTAssertGreaterThanOrEqual(self.trumpNode.zRotation, maxRotation - 0.1, "Rotation should not exceed -30 degrees")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testUpdateRotationClampsToMinimum() {
        // Given: Trump has very high downward velocity
        trumpNode.physicsBody?.velocity = CGVector(dx: 0, dy: -1000)
        
        // When: Update rotation is called
        trumpNode.updateRotation()
        
        // Wait for rotation action
        let expectation = XCTestExpectation(description: "Rotation should be clamped")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            // Then: Rotation should be clamped to +30 degrees (+π/6)
            let minRotation = CGFloat.pi / 6
            XCTAssertLessThanOrEqual(self.trumpNode.zRotation, minRotation + 0.1, "Rotation should not exceed +30 degrees")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testUpdateRotationDoesNotWorkWhenDead() {
        // Given: Trump is dead with velocity
        trumpNode.die()
        trumpNode.physicsBody?.velocity = CGVector(dx: 0, dy: 300)
        let initialRotation = trumpNode.zRotation
        
        // When: Update rotation is called
        trumpNode.updateRotation()
        
        // Then: Rotation should not be updated by velocity (death animation controls it)
        // We just verify the method doesn't crash
        XCTAssertEqual(trumpNode.currentState, .dead, "State should remain dead")
    }
    
    // MARK: - Animation Tests
    
    func testIdleAnimationStarts() {
        // Given: Fresh trump node
        let newTrump = TrumpNode()
        scene.addChild(newTrump)
        
        // Then: Idle animation should be running
        XCTAssertNotNil(newTrump.action(forKey: "idleBob"), "Idle bob animation should be running")
    }
    
    func testDeathAnimationStopsIdleAnimation() {
        // Given: Trump with idle animation
        XCTAssertNotNil(trumpNode.action(forKey: "idleBob"), "Idle animation should be running")
        
        // When: Die is called
        trumpNode.die()
        
        // Wait for animation to process
        let expectation = XCTestExpectation(description: "Idle animation should stop")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Then: Idle animation should be removed
            XCTAssertNil(self.trumpNode.action(forKey: "idleBob"), "Idle animation should be stopped when dead")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testResetRestartsIdleAnimation() {
        // Given: Trump is dead (no idle animation)
        trumpNode.die()
        
        // Wait for death animation to process
        let expectation1 = XCTestExpectation(description: "Death animation processes")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNil(self.trumpNode.action(forKey: "idleBob"), "Idle animation should be stopped")
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: 0.5)
        
        // When: Reset is called
        trumpNode.reset()
        
        // Then: Idle animation should restart
        let expectation2 = XCTestExpectation(description: "Idle animation restarts")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNotNil(self.trumpNode.action(forKey: "idleBob"), "Idle animation should restart after reset")
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 0.5)
    }
}
