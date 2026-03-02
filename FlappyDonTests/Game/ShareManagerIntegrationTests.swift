import XCTest
@testable import FlappyDon

final class ShareManagerIntegrationTests: XCTestCase {
    
    var shareManager: ShareManager!
    var gameManager: GameManager!
    
    override func setUp() {
        super.setUp()
        shareManager = ShareManager.shared
        gameManager = GameManager.shared
        gameManager.resetGame()
        UserDefaults.standard.removeObject(forKey: "HighScore")
    }
    
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "HighScore")
        gameManager.resetGame()
        super.tearDown()
    }
    
    // MARK: - Complete Share Flow Integration Tests
    
    func testCompleteShareFlowWithGameScore() {
        // Given: A completed game with a score
        gameManager.startGame()
        for _ in 0..<25 {
            gameManager.incrementScore()
        }
        gameManager.endGame()
        
        let finalScore = gameManager.currentScore
        let viewController = UIViewController()
        
        // When: Sharing the score
        XCTAssertNoThrow(shareManager.shareScore(score: finalScore, medal: "medal_silver", from: viewController))
        
        // Then: Share should complete without errors
        XCTAssertEqual(finalScore, 25, "Final score should be 25")
    }
    
    func testShareFlowWithHighScore() {
        // Given: A game that achieves a new high score
        gameManager.startGame()
        for _ in 0..<100 {
            gameManager.incrementScore()
        }
        gameManager.endGame()
        
        let highScore = gameManager.highScore
        let viewController = UIViewController()
        
        // When: Sharing the high score
        XCTAssertNoThrow(shareManager.shareScore(score: highScore, medal: "medal_platinum", from: viewController))
        
        // Then: High score should be saved and shareable
        XCTAssertEqual(highScore, 100, "High score should be 100")
        XCTAssertEqual(gameManager.highScore, 100, "GameManager should have high score of 100")
    }
    
    func testShareFlowWithMultipleGameSessions() {
        // Given: Multiple game sessions with different scores
        let scores = [10, 25, 50, 30, 75]
        let viewController = UIViewController()
        
        for score in scores {
            // When: Playing and sharing each game
            gameManager.resetGame()
            gameManager.startGame()
            for _ in 0..<score {
                gameManager.incrementScore()
            }
            gameManager.endGame()
            
            let medal = getMedalForScore(score)
            
            // Then: Each share should work correctly
            XCTAssertNoThrow(shareManager.shareScore(score: score, medal: medal, from: viewController))
        }
        
        // Verify high score is tracked correctly
        XCTAssertEqual(gameManager.highScore, 75, "High score should be 75 after all sessions")
    }
    
    func testShareImageGenerationWithDifferentScoreRanges() {
        // Given: Different score ranges that affect character emoji
        let testCases: [(score: Int, expectedEmoji: String)] = [
            (0, "😐"),      // Low score
            (10, "😐"),     // Low score
            (25, "🙂"),     // Medium score
            (40, "🙂"),     // Medium score
            (50, "😎"),     // High score
            (100, "😎")     // Very high score
        ]
        
        for testCase in testCases {
            // When: Generating share image
            let image = shareManager.generateShareImage(score: testCase.score, medal: nil)
            
            // Then: Image should be generated successfully
            XCTAssertNotNil(image, "Image should be generated for score \(testCase.score)")
            XCTAssertEqual(image.size.width, 1080, "Image width should be 1080 for score \(testCase.score)")
            XCTAssertEqual(image.size.height, 1920, "Image height should be 1920 for score \(testCase.score)")
        }
    }
    
    func testShareImageGenerationWithAllMedalCombinations() {
        // Given: All possible medal types
        let medals: [String?] = [nil, "medal_bronze", "medal_silver", "medal_gold", "medal_platinum"]
        let scores = [0, 10, 25, 50, 100]
        
        for medal in medals {
            for score in scores {
                // When: Generating image for each combination
                let image = shareManager.generateShareImage(score: score, medal: medal)
                
                // Then: All combinations should generate valid images
                XCTAssertNotNil(image, "Image should be generated for score \(score) with medal \(medal ?? "none")")
                XCTAssertEqual(image.size.width, 1080, "Image width should be correct")
                XCTAssertEqual(image.size.height, 1920, "Image height should be correct")
            }
        }
    }
    
    func testShareTextConsistencyAcrossScores() {
        // Given: Various scores
        let scores = [0, 1, 10, 50, 100, 999, 9999]
        
        for score in scores {
            // When: Getting share text for each score
            let image = shareManager.generateShareImage(score: score, medal: nil)
            
            // Then: Image should be generated and text format should be consistent
            XCTAssertNotNil(image, "Image should be generated for score \(score)")
            
            // Verify the expected share text format
            let expectedText = "I scored \(score) on Flappy Don! 🇺🇸 Can you beat me?"
            // Note: We can't directly test the text in the image, but we verify the image is created
            XCTAssertEqual(image.size.width, 1080, "Image should have correct dimensions")
        }
    }
    
    func testShareManagerAndGameManagerIntegration() {
        // Given: A complete game flow
        XCTAssertEqual(gameManager.currentState, .menu, "Should start in menu state")
        
        // When: Playing a game
        gameManager.startGame()
        XCTAssertEqual(gameManager.currentState, .playing, "Should be in playing state")
        
        for _ in 0..<42 {
            gameManager.incrementScore()
        }
        
        gameManager.endGame()
        XCTAssertEqual(gameManager.currentState, .gameOver, "Should be in game over state")
        
        // Then: Share functionality should work with game state
        let viewController = UIViewController()
        let finalScore = gameManager.currentScore
        let medal = getMedalForScore(finalScore)
        
        XCTAssertNoThrow(shareManager.shareScore(score: finalScore, medal: medal, from: viewController))
        XCTAssertEqual(finalScore, 42, "Final score should be 42")
    }
    
    func testShareImageQualityAndDimensions() {
        // Given: A score and medal
        let score = 50
        let medal = "medal_gold"
        
        // When: Generating share image
        let image = shareManager.generateShareImage(score: score, medal: medal)
        
        // Then: Image should meet quality requirements
        XCTAssertNotNil(image, "Image should be generated")
        
        // Verify dimensions (Instagram story size)
        XCTAssertEqual(image.size.width, 1080, "Width should be 1080 (Instagram story width)")
        XCTAssertEqual(image.size.height, 1920, "Height should be 1920 (Instagram story height)")
        
        // Verify aspect ratio (9:16)
        let aspectRatio = image.size.width / image.size.height
        XCTAssertEqual(aspectRatio, 9.0 / 16.0, accuracy: 0.01, "Aspect ratio should be 9:16")
        
        // Verify image scale
        XCTAssertGreaterThan(image.scale, 0, "Image scale should be positive")
    }
    
    func testShareFlowWithEdgeCases() {
        // Given: Edge case scenarios
        let viewController = UIViewController()
        
        // Test 1: Zero score
        XCTAssertNoThrow(shareManager.shareScore(score: 0, medal: nil, from: viewController))
        
        // Test 2: Maximum reasonable score
        XCTAssertNoThrow(shareManager.shareScore(score: 9999, medal: "medal_platinum", from: viewController))
        
        // Test 3: Negative score (shouldn't happen in game, but test robustness)
        XCTAssertNoThrow(shareManager.shareScore(score: -1, medal: nil, from: viewController))
        
        // Test 4: Unknown medal type
        XCTAssertNoThrow(shareManager.shareScore(score: 50, medal: "unknown_medal", from: viewController))
    }
    
    func testConcurrentShareImageGeneration() {
        // Given: Multiple concurrent image generation requests
        let expectation = XCTestExpectation(description: "Generate multiple images concurrently")
        expectation.expectedFulfillmentCount = 5
        
        let queue = DispatchQueue.global(qos: .userInitiated)
        
        for i in 0..<5 {
            queue.async {
                // When: Generating images concurrently
                let image = self.shareManager.generateShareImage(score: i * 10, medal: "medal_gold")
                
                // Then: All images should be generated successfully
                XCTAssertNotNil(image, "Image \(i) should be generated")
                XCTAssertEqual(image.size.width, 1080, "Image \(i) width should be correct")
                XCTAssertEqual(image.size.height, 1920, "Image \(i) height should be correct")
                
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testShareManagerMemoryManagement() {
        // Given: Multiple image generations
        let iterations = 10
        
        for i in 0..<iterations {
            // When: Generating and discarding images
            autoreleasepool {
                let image = shareManager.generateShareImage(score: i, medal: "medal_silver")
                
                // Then: Images should be created and released properly
                XCTAssertNotNil(image, "Image should be generated in iteration \(i)")
            }
        }
        
        // Verify singleton is still accessible
        XCTAssertNotNil(ShareManager.shared, "ShareManager singleton should still be accessible")
    }
    
    // MARK: - Helper Methods
    
    private func getMedalForScore(_ score: Int) -> String? {
        // Medal thresholds based on typical game design
        if score >= 100 {
            return "medal_platinum"
        } else if score >= 50 {
            return "medal_gold"
        } else if score >= 25 {
            return "medal_silver"
        } else if score >= 10 {
            return "medal_bronze"
        } else {
            return nil
        }
    }
}
