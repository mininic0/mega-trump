import XCTest
import SpriteKit
@testable import FlappyDon

final class ButtonNodeTests: XCTestCase {
    
    var buttonNode: ButtonNode!
    var scene: SKScene!
    let normalColor = UIColor.blue
    let highlightedColor = UIColor.darkGray
    
    override func setUp() {
        super.setUp()
        let size = CGSize(width: 200, height: 60)
        buttonNode = ButtonNode(size: size, normalColor: normalColor, highlightedColor: highlightedColor)
        scene = SKScene(size: CGSize(width: 375, height: 667))
        scene.addChild(buttonNode)
    }
    
    override func tearDown() {
        buttonNode.removeFromParent()
        buttonNode = nil
        scene = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInitialization() {
        // Then: ButtonNode should be properly initialized
        XCTAssertNotNil(buttonNode, "ButtonNode should be initialized")
        XCTAssertEqual(buttonNode.size.width, 200, accuracy: 0.1, "Width should be 200")
        XCTAssertEqual(buttonNode.size.height, 60, accuracy: 0.1, "Height should be 60")
    }
    
    func testInitialColor() {
        // Then: Initial color should be normal color
        XCTAssertEqual(buttonNode.color, normalColor, "Initial color should be normal color")
    }
    
    func testLabelExists() {
        // Then: Label child node should exist
        let labels = buttonNode.children.compactMap { $0 as? SKLabelNode }
        XCTAssertEqual(labels.count, 1, "Should have exactly one label")
    }
    
    func testLabelProperties() {
        // Then: Label should have correct properties
        guard let label = buttonNode.children.first as? SKLabelNode else {
            XCTFail("First child should be a label")
            return
        }
        
        XCTAssertEqual(label.fontName, "AvenirNext-Bold", "Font should be AvenirNext-Bold")
        XCTAssertEqual(label.fontSize, 28, accuracy: 0.1, "Font size should be 28")
        XCTAssertEqual(label.fontColor, .white, "Font color should be white")
        XCTAssertEqual(label.verticalAlignmentMode, .center, "Vertical alignment should be center")
        XCTAssertEqual(label.horizontalAlignmentMode, .center, "Horizontal alignment should be center")
    }
    
    // MARK: - Setup Tests
    
    func testSetupText() {
        // When: Setting up button with text
        var actionCalled = false
        buttonNode.setup(text: "Play", action: { actionCalled = true })
        
        // Then: Label text should be set
        guard let label = buttonNode.children.first as? SKLabelNode else {
            XCTFail("First child should be a label")
            return
        }
        
        XCTAssertEqual(label.text, "Play", "Label text should be 'Play'")
    }
    
    func testSetupAction() {
        // When: Setting up button with action
        var actionCalled = false
        buttonNode.setup(text: "Start", action: { actionCalled = true })
        
        // Then: Action should be stored
        XCTAssertNotNil(buttonNode.action, "Action should be set")
    }
    
    // MARK: - Touch Began Tests
    
    func testHandleTouchBeganChangesColor() {
        // When: Touch begins
        buttonNode.handleTouchBegan()
        
        // Then: Color should change to highlighted
        XCTAssertEqual(buttonNode.color, highlightedColor, "Color should change to highlighted")
    }
    
    func testHandleTouchBeganScalesDown() {
        // When: Touch begins
        buttonNode.handleTouchBegan()
        
        // Then: Scale animation should be running
        XCTAssertTrue(buttonNode.hasActions(), "Scale animation should be running")
    }
    
    func testHandleTouchBeganMultipleTimes() {
        // When: Touch begins multiple times
        buttonNode.handleTouchBegan()
        buttonNode.handleTouchBegan()
        
        // Then: Color should still be highlighted
        XCTAssertEqual(buttonNode.color, highlightedColor, "Color should remain highlighted")
    }
    
    // MARK: - Touch Ended Tests
    
    func testHandleTouchEndedRestoresColor() {
        // Given: Touch has begun
        buttonNode.handleTouchBegan()
        
        // When: Touch ends
        buttonNode.handleTouchEnded()
        
        // Then: Color should restore to normal
        XCTAssertEqual(buttonNode.color, normalColor, "Color should restore to normal")
    }
    
    func testHandleTouchEndedScalesUp() {
        // Given: Touch has begun
        buttonNode.handleTouchBegan()
        
        // When: Touch ends
        buttonNode.handleTouchEnded()
        
        // Then: Scale animation should be running
        XCTAssertTrue(buttonNode.hasActions(), "Scale animation should be running")
    }
    
    func testHandleTouchEndedTriggersAction() {
        // Given: Button with action
        var actionCalled = false
        buttonNode.setup(text: "Test", action: { actionCalled = true })
        
        // When: Touch ends
        buttonNode.handleTouchEnded()
        
        // Then: Action should be called
        XCTAssertTrue(actionCalled, "Action should be triggered")
    }
    
    func testHandleTouchEndedWithoutAction() {
        // Given: Button without action setup
        // (action is nil)
        
        // When: Touch ends
        // Then: Should not crash
        XCTAssertNoThrow(buttonNode.handleTouchEnded(), "Should handle nil action gracefully")
    }
    
    // MARK: - Touch Cancelled Tests
    
    func testHandleTouchCancelledRestoresColor() {
        // Given: Touch has begun
        buttonNode.handleTouchBegan()
        
        // When: Touch is cancelled
        buttonNode.handleTouchCancelled()
        
        // Then: Color should restore to normal
        XCTAssertEqual(buttonNode.color, normalColor, "Color should restore to normal")
    }
    
    func testHandleTouchCancelledScalesUp() {
        // Given: Touch has begun
        buttonNode.handleTouchBegan()
        
        // When: Touch is cancelled
        buttonNode.handleTouchCancelled()
        
        // Then: Scale animation should be running
        XCTAssertTrue(buttonNode.hasActions(), "Scale animation should be running")
    }
    
    func testHandleTouchCancelledDoesNotTriggerAction() {
        // Given: Button with action
        var actionCalled = false
        buttonNode.setup(text: "Test", action: { actionCalled = true })
        buttonNode.handleTouchBegan()
        
        // When: Touch is cancelled
        buttonNode.handleTouchCancelled()
        
        // Then: Action should NOT be called
        XCTAssertFalse(actionCalled, "Action should not be triggered on cancel")
    }
    
    // MARK: - Touch Sequence Tests
    
    func testCompleteTouchSequence() {
        // Given: Button with action
        var actionCalled = false
        buttonNode.setup(text: "Complete", action: { actionCalled = true })
        
        // When: Complete touch sequence
        buttonNode.handleTouchBegan()
        XCTAssertEqual(buttonNode.color, highlightedColor, "Should be highlighted during touch")
        
        buttonNode.handleTouchEnded()
        XCTAssertEqual(buttonNode.color, normalColor, "Should restore color after touch")
        XCTAssertTrue(actionCalled, "Action should be called")
    }
    
    func testCancelledTouchSequence() {
        // Given: Button with action
        var actionCalled = false
        buttonNode.setup(text: "Cancel", action: { actionCalled = true })
        
        // When: Touch sequence with cancellation
        buttonNode.handleTouchBegan()
        XCTAssertEqual(buttonNode.color, highlightedColor, "Should be highlighted during touch")
        
        buttonNode.handleTouchCancelled()
        XCTAssertEqual(buttonNode.color, normalColor, "Should restore color after cancel")
        XCTAssertFalse(actionCalled, "Action should not be called on cancel")
    }
    
    // MARK: - Animation Duration Tests
    
    func testTouchBeganAnimationDuration() {
        // When: Touch begins
        buttonNode.handleTouchBegan()
        
        // Then: Animation should be running
        XCTAssertTrue(buttonNode.hasActions(), "Animation should start immediately")
    }
    
    func testTouchEndedAnimationDuration() {
        // Given: Touch began
        buttonNode.handleTouchBegan()
        
        // When: Touch ends
        buttonNode.handleTouchEnded()
        
        // Then: Animation should be running
        XCTAssertTrue(buttonNode.hasActions(), "Animation should start immediately")
    }
    
    // MARK: - Edge Cases
    
    func testMultipleSetupCalls() {
        // When: Setting up button multiple times
        var firstActionCalled = false
        var secondActionCalled = false
        
        buttonNode.setup(text: "First", action: { firstActionCalled = true })
        buttonNode.setup(text: "Second", action: { secondActionCalled = true })
        
        // Then: Latest setup should be active
        guard let label = buttonNode.children.first as? SKLabelNode else {
            XCTFail("First child should be a label")
            return
        }
        
        XCTAssertEqual(label.text, "Second", "Label should show latest text")
        
        buttonNode.handleTouchEnded()
        XCTAssertFalse(firstActionCalled, "First action should not be called")
        XCTAssertTrue(secondActionCalled, "Second action should be called")
    }
    
    func testEmptyText() {
        // When: Setting up with empty text
        buttonNode.setup(text: "", action: {})
        
        // Then: Label should have empty text
        guard let label = buttonNode.children.first as? SKLabelNode else {
            XCTFail("First child should be a label")
            return
        }
        
        XCTAssertEqual(label.text, "", "Label should accept empty text")
    }
}
