import XCTest
import SpriteKit
@testable import FlappyDon

final class ScoreLabelTests: XCTestCase {
    
    var scoreLabel: ScoreLabel!
    var scene: SKScene!
    
    override func setUp() {
        super.setUp()
        let position = CGPoint(x: 187.5, y: 600)
        scoreLabel = ScoreLabel(position: position)
        scene = SKScene(size: CGSize(width: 375, height: 667))
        scene.addChild(scoreLabel)
    }
    
    override func tearDown() {
        scoreLabel.removeFromParent()
        scoreLabel = nil
        scene = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInitialization() {
        // Then: ScoreLabel should be properly initialized
        XCTAssertNotNil(scoreLabel, "ScoreLabel should be initialized")
        XCTAssertEqual(scoreLabel.position.x, 187.5, accuracy: 0.1, "X position should be 187.5")
        XCTAssertEqual(scoreLabel.position.y, 600, accuracy: 0.1, "Y position should be 600")
    }
    
    func testInitialFont() {
        // Then: Font should be configured correctly
        XCTAssertEqual(scoreLabel.fontName, "AvenirNext-Bold", "Font should be AvenirNext-Bold")
        XCTAssertEqual(scoreLabel.fontSize, 64, accuracy: 0.1, "Font size should be 64")
        XCTAssertEqual(scoreLabel.fontColor, .white, "Font color should be white")
    }
    
    func testInitialZPosition() {
        // Then: Z-position should be 100 (always visible)
        XCTAssertEqual(scoreLabel.zPosition, 100, "Z-position should be 100")
    }
    
    func testInitialAlignment() {
        // Then: Alignment should be center/top
        XCTAssertEqual(scoreLabel.horizontalAlignmentMode, .center, "Horizontal alignment should be center")
        XCTAssertEqual(scoreLabel.verticalAlignmentMode, .top, "Vertical alignment should be top")
    }
    
    func testInitialText() {
        // Then: Initial text should be "0"
        XCTAssertEqual(scoreLabel.text, "0", "Initial text should be '0'")
    }
    
    // MARK: - Shadow Tests
    
    func testShadowExists() {
        // Then: Shadow child node should exist
        let shadow = scoreLabel.childNode(withName: "shadow")
        XCTAssertNotNil(shadow, "Shadow node should exist")
    }
    
    func testShadowProperties() {
        // Then: Shadow should have correct properties
        guard let shadow = scoreLabel.childNode(withName: "shadow") as? SKLabelNode else {
            XCTFail("Shadow should be an SKLabelNode")
            return
        }
        
        XCTAssertEqual(shadow.fontName, "AvenirNext-Bold", "Shadow font should match")
        XCTAssertEqual(shadow.fontSize, 64, accuracy: 0.1, "Shadow font size should match")
        XCTAssertEqual(shadow.fontColor, .black, "Shadow color should be black")
        XCTAssertEqual(shadow.alpha, 0.3, accuracy: 0.01, "Shadow alpha should be 0.3")
        XCTAssertEqual(shadow.position.x, 3, accuracy: 0.1, "Shadow X offset should be 3")
        XCTAssertEqual(shadow.position.y, -3, accuracy: 0.1, "Shadow Y offset should be -3")
        XCTAssertEqual(shadow.zPosition, -1, "Shadow z-position should be -1")
    }
    
    func testShadowTextMatchesLabel() {
        // Then: Shadow text should match label text
        guard let shadow = scoreLabel.childNode(withName: "shadow") as? SKLabelNode else {
            XCTFail("Shadow should be an SKLabelNode")
            return
        }
        
        XCTAssertEqual(shadow.text, scoreLabel.text, "Shadow text should match label text")
    }
    
    // MARK: - Score Setting Tests
    
    func testSetScoreWithoutAnimation() {
        // When: Setting score without animation
        scoreLabel.setScore(5, animated: false)
        
        // Then: Score should be updated immediately
        XCTAssertEqual(scoreLabel.text, "5", "Score text should be '5'")
    }
    
    func testSetScoreUpdatesText() {
        // When: Setting multiple scores
        scoreLabel.setScore(1, animated: false)
        XCTAssertEqual(scoreLabel.text, "1", "Score should be '1'")
        
        scoreLabel.setScore(10, animated: false)
        XCTAssertEqual(scoreLabel.text, "10", "Score should be '10'")
        
        scoreLabel.setScore(99, animated: false)
        XCTAssertEqual(scoreLabel.text, "99", "Score should be '99'")
    }
    
    func testSetScoreUpdatesShadow() {
        // When: Setting score
        scoreLabel.setScore(7, animated: false)
        
        // Then: Shadow text should also update
        guard let shadow = scoreLabel.childNode(withName: "shadow") as? SKLabelNode else {
            XCTFail("Shadow should exist")
            return
        }
        
        XCTAssertEqual(shadow.text, "7", "Shadow text should match score")
    }
    
    func testSetScoreWithAnimation() {
        // When: Setting score with animation (score increases)
        scoreLabel.setScore(1, animated: true)
        
        // Then: Score should be updated
        XCTAssertEqual(scoreLabel.text, "1", "Score should be updated")
        
        // And: Animation actions should be running
        XCTAssertTrue(scoreLabel.hasActions(), "Score label should have animation actions")
    }
    
    func testSetScoreAnimationOnlyOnIncrease() {
        // Given: Initial score of 5
        scoreLabel.setScore(5, animated: false)
        scoreLabel.removeAllActions()
        
        // When: Setting same score with animation
        scoreLabel.setScore(5, animated: true)
        
        // Then: No animation should run (score didn't increase)
        XCTAssertFalse(scoreLabel.hasActions(), "No animation for same score")
        
        // When: Setting lower score with animation
        scoreLabel.setScore(3, animated: true)
        
        // Then: No animation should run (score decreased)
        XCTAssertFalse(scoreLabel.hasActions(), "No animation for decreased score")
    }
    
    // MARK: - Reset Tests
    
    func testReset() {
        // Given: Score is set to 10
        scoreLabel.setScore(10, animated: false)
        scoreLabel.setScale(1.2)
        scoreLabel.fontColor = .red
        
        // When: Resetting
        scoreLabel.reset()
        
        // Then: Score should be 0
        XCTAssertEqual(scoreLabel.text, "0", "Score should reset to '0'")
        
        // And: Scale should be 1.0
        XCTAssertEqual(scoreLabel.xScale, 1.0, accuracy: 0.01, "X scale should be 1.0")
        XCTAssertEqual(scoreLabel.yScale, 1.0, accuracy: 0.01, "Y scale should be 1.0")
        
        // And: Color should be white
        XCTAssertEqual(scoreLabel.fontColor, .white, "Font color should be white")
    }
    
    func testResetUpdatesShadow() {
        // Given: Score is set to 15
        scoreLabel.setScore(15, animated: false)
        
        // When: Resetting
        scoreLabel.reset()
        
        // Then: Shadow text should also reset
        guard let shadow = scoreLabel.childNode(withName: "shadow") as? SKLabelNode else {
            XCTFail("Shadow should exist")
            return
        }
        
        XCTAssertEqual(shadow.text, "0", "Shadow text should reset to '0'")
    }
    
    // MARK: - Animation Behavior Tests
    
    func testAnimationCreatesScaleAction() {
        // Given: Initial score
        scoreLabel.setScore(0, animated: false)
        scoreLabel.removeAllActions()
        
        // When: Incrementing score with animation
        scoreLabel.setScore(1, animated: true)
        
        // Then: Actions should be running
        XCTAssertTrue(scoreLabel.hasActions(), "Animation actions should be running")
    }
    
    func testMultipleScoreIncrements() {
        // When: Incrementing score multiple times
        for i in 1...5 {
            scoreLabel.setScore(i, animated: true)
        }
        
        // Then: Final score should be correct
        XCTAssertEqual(scoreLabel.text, "5", "Final score should be '5'")
    }
    
    // MARK: - Edge Cases
    
    func testZeroScore() {
        // When: Setting score to 0
        scoreLabel.setScore(0, animated: false)
        
        // Then: Text should be "0"
        XCTAssertEqual(scoreLabel.text, "0", "Score should be '0'")
    }
    
    func testLargeScore() {
        // When: Setting a large score
        scoreLabel.setScore(9999, animated: false)
        
        // Then: Text should display correctly
        XCTAssertEqual(scoreLabel.text, "9999", "Score should be '9999'")
    }
    
    func testNegativeScore() {
        // When: Setting a negative score (edge case)
        scoreLabel.setScore(-5, animated: false)
        
        // Then: Text should display negative number
        XCTAssertEqual(scoreLabel.text, "-5", "Score should be '-5'")
    }
}
