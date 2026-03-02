import Foundation

class GameManager {
    static let shared = GameManager()
    
    private let highScoreKey = "HighScore"
    
    private(set) var currentState: GameState = .menu
    private(set) var currentScore: Int = 0
    private(set) var highScore: Int = 0
    private(set) var isGameActive: Bool = false
    
    private init() {
        loadHighScore()
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
            saveHighScore()
        }
    }
    
    func incrementScore() {
        guard isGameActive else { return }
        currentScore += 1
    }
    
    func resetGame() {
        currentState = .menu
        currentScore = 0
        isGameActive = false
    }
    
    private func loadHighScore() {
        highScore = UserDefaults.standard.integer(forKey: highScoreKey)
    }
    
    private func saveHighScore() {
        UserDefaults.standard.set(highScore, forKey: highScoreKey)
    }
}
