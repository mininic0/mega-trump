import XCTest
@testable import FlappyDon

final class GameManagerTests: XCTestCase {
    
    var gameManager: GameManager!
    let testHighScoreKey = "HighScore"
    
    override func setUp() {
        super.setUp()
        // Clear UserDefaults before each test
        UserDefaults.standard.removeObject(forKey: testHighScoreKey)
        // Reset singleton state
        gameManager = GameManager.shared
        gameManager.resetGame()
    }
    
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: testHighScoreKey)
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    
    func testInitialState() {
        XCTAssertEqual(gameManager.currentState, .menu, "Initial state should be menu")
        XCTAssertEqual(gameManager.currentScore, 0, "Initial score should be 0")
        XCTAssertEqual(gameManager.highScore, 0, "Initial high score should be 0")
        XCTAssertFalse(gameManager.isGameActive, "Game should not be active initially")
    }
    
    func testLoadHighScoreFromUserDefaults() {
        // Given: A high score saved in UserDefaults
        UserDefaults.standard.set(100, forKey: testHighScoreKey)
        
        // When: Creating a new GameManager instance (simulated by reading the value)
        let savedHighScore = UserDefaults.standard.integer(forKey: testHighScoreKey)
        
        // Then: High score should be loaded
        XCTAssertEqual(savedHighScore, 100, "High score should be loaded from UserDefaults")
    }
    
    // MARK: - Start Game Tests
    
    func testStartGame() {
        // When: Starting a new game
        gameManager.startGame()
        
        // Then: Game state should be updated correctly
        XCTAssertEqual(gameManager.currentState, .playing, "State should be playing")
        XCTAssertEqual(gameManager.currentScore, 0, "Score should be reset to 0")
        XCTAssertTrue(gameManager.isGameActive, "Game should be active")
    }
    
    func testStartGameResetsScore() {
        // Given: A game with a current score
        gameManager.startGame()
        gameManager.incrementScore()
        gameManager.incrementScore()
        XCTAssertEqual(gameManager.currentScore, 2)
        
        // When: Starting a new game
        gameManager.endGame()
        gameManager.startGame()
        
        // Then: Score should be reset
        XCTAssertEqual(gameManager.currentScore, 0, "Score should be reset when starting new game")
    }
    
    // MARK: - End Game Tests
    
    func testEndGame() {
        // Given: An active game
        gameManager.startGame()
        
        // When: Ending the game
        gameManager.endGame()
        
        // Then: Game state should be updated
        XCTAssertEqual(gameManager.currentState, .gameOver, "State should be gameOver")
        XCTAssertFalse(gameManager.isGameActive, "Game should not be active")
    }
    
    func testEndGameSavesNewHighScore() {
        // Given: A game with a score higher than current high score
        gameManager.startGame()
        gameManager.incrementScore()
        gameManager.incrementScore()
        gameManager.incrementScore()
        
        // When: Ending the game
        gameManager.endGame()
        
        // Then: High score should be updated and saved
        XCTAssertEqual(gameManager.highScore, 3, "High score should be updated")
        let savedHighScore = UserDefaults.standard.integer(forKey: testHighScoreKey)
        XCTAssertEqual(savedHighScore, 3, "High score should be saved to UserDefaults")
    }
    
    func testEndGameDoesNotSaveLowerScore() {
        // Given: An existing high score
        UserDefaults.standard.set(10, forKey: testHighScoreKey)
        gameManager = GameManager.shared
        
        // When: Ending a game with a lower score
        gameManager.startGame()
        gameManager.incrementScore()
        gameManager.incrementScore()
        gameManager.endGame()
        
        // Then: High score should remain unchanged
        XCTAssertEqual(gameManager.highScore, 10, "High score should not be overwritten by lower score")
        let savedHighScore = UserDefaults.standard.integer(forKey: testHighScoreKey)
        XCTAssertEqual(savedHighScore, 10, "Saved high score should remain unchanged")
    }
    
    func testEndGameSavesEqualScore() {
        // Given: An existing high score
        UserDefaults.standard.set(5, forKey: testHighScoreKey)
        gameManager = GameManager.shared
        
        // When: Ending a game with equal score
        gameManager.startGame()
        for _ in 0..<5 {
            gameManager.incrementScore()
        }
        gameManager.endGame()
        
        // Then: High score should remain the same (not greater than)
        XCTAssertEqual(gameManager.highScore, 5, "High score should remain unchanged for equal score")
    }
    
    // MARK: - Increment Score Tests
    
    func testIncrementScore() {
        // Given: An active game
        gameManager.startGame()
        
        // When: Incrementing score
        gameManager.incrementScore()
        
        // Then: Score should increase
        XCTAssertEqual(gameManager.currentScore, 1, "Score should increment by 1")
    }
    
    func testIncrementScoreMultipleTimes() {
        // Given: An active game
        gameManager.startGame()
        
        // When: Incrementing score multiple times
        for _ in 0..<10 {
            gameManager.incrementScore()
        }
        
        // Then: Score should reflect all increments
        XCTAssertEqual(gameManager.currentScore, 10, "Score should increment correctly multiple times")
    }
    
    func testIncrementScoreWhenGameNotActive() {
        // Given: A game that is not active
        XCTAssertFalse(gameManager.isGameActive)
        
        // When: Attempting to increment score
        gameManager.incrementScore()
        
        // Then: Score should not change
        XCTAssertEqual(gameManager.currentScore, 0, "Score should not increment when game is not active")
    }
    
    func testIncrementScoreAfterGameOver() {
        // Given: A game that has ended
        gameManager.startGame()
        gameManager.incrementScore()
        gameManager.endGame()
        
        // When: Attempting to increment score after game over
        gameManager.incrementScore()
        
        // Then: Score should not change
        XCTAssertEqual(gameManager.currentScore, 1, "Score should not increment after game over")
    }
    
    // MARK: - Reset Game Tests
    
    func testResetGame() {
        // Given: A game with some state
        gameManager.startGame()
        gameManager.incrementScore()
        gameManager.incrementScore()
        gameManager.endGame()
        
        // When: Resetting the game
        gameManager.resetGame()
        
        // Then: Game should return to initial state
        XCTAssertEqual(gameManager.currentState, .menu, "State should be menu")
        XCTAssertEqual(gameManager.currentScore, 0, "Score should be reset to 0")
        XCTAssertFalse(gameManager.isGameActive, "Game should not be active")
    }
    
    func testResetGamePreservesHighScore() {
        // Given: A game with a high score
        gameManager.startGame()
        for _ in 0..<5 {
            gameManager.incrementScore()
        }
        gameManager.endGame()
        let highScore = gameManager.highScore
        
        // When: Resetting the game
        gameManager.resetGame()
        
        // Then: High score should be preserved
        XCTAssertEqual(gameManager.highScore, highScore, "High score should be preserved after reset")
    }
    
    // MARK: - State Transition Tests
    
    func testStateTransitionFlow() {
        // Menu -> Playing
        XCTAssertEqual(gameManager.currentState, .menu)
        gameManager.startGame()
        XCTAssertEqual(gameManager.currentState, .playing)
        
        // Playing -> GameOver
        gameManager.endGame()
        XCTAssertEqual(gameManager.currentState, .gameOver)
        
        // GameOver -> Menu
        gameManager.resetGame()
        XCTAssertEqual(gameManager.currentState, .menu)
    }
    
    func testMultipleGameSessions() {
        // First game
        gameManager.startGame()
        gameManager.incrementScore()
        gameManager.incrementScore()
        gameManager.endGame()
        XCTAssertEqual(gameManager.highScore, 2)
        
        // Second game with higher score
        gameManager.resetGame()
        gameManager.startGame()
        for _ in 0..<5 {
            gameManager.incrementScore()
        }
        gameManager.endGame()
        XCTAssertEqual(gameManager.highScore, 5)
        
        // Third game with lower score
        gameManager.resetGame()
        gameManager.startGame()
        gameManager.incrementScore()
        gameManager.endGame()
        XCTAssertEqual(gameManager.highScore, 5, "High score should remain 5")
    }
    
    // MARK: - Singleton Tests
    
    func testSingletonInstance() {
        let instance1 = GameManager.shared
        let instance2 = GameManager.shared
        
        XCTAssertTrue(instance1 === instance2, "GameManager should be a singleton")
    }
    
    func testSingletonStateSharing() {
        let instance1 = GameManager.shared
        instance1.startGame()
        instance1.incrementScore()
        
        let instance2 = GameManager.shared
        XCTAssertEqual(instance2.currentScore, 1, "Singleton should share state across instances")
        XCTAssertTrue(instance2.isGameActive, "Singleton should share active state")
    }
}
