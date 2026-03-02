import Foundation

class GameManager {
    static let shared = GameManager()
    
    private(set) var currentState: GameState = .menu
    private(set) var currentScore: Int = 0
    private(set) var highScore: Int = 0
    private(set) var isGameActive: Bool = false
    
    private init() {
        highScore = StorageManager.shared.loadHighScore()
    }
    
    func startGame() {
        currentState = .playing
        currentScore = 0
        isGameActive = true
    }
    
    func endGame() {
        currentState = .gameOver
        isGameActive = false
        
        if currentScore > highScore {
            highScore = currentScore
            StorageManager.shared.saveHighScore(highScore)
        }
    }
    
    func incrementScore() {
        guard isGameActive else { return }
        currentScore += 1
        
        if currentScore > highScore {
            highScore = currentScore
            StorageManager.shared.saveHighScore(highScore)
        }
    }
    
    func resetGame() {
        currentState = .menu
        currentScore = 0
        isGameActive = false
    }
}
