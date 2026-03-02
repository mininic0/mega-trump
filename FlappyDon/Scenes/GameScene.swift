import SpriteKit

class GameScene: SKScene {
    
    private var score = 0
    
    override func didMove(to view: SKView) {
        setupPhysics()
        setupBackground()
    }
    
    private func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0, dy: -5.0)
        physicsWorld.contactDelegate = self
    }
    
    private func setupBackground() {
        backgroundColor = SKColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0)
    }
    
    func gameOver() {
        let gameOverScene = GameOverScene(size: size, score: score)
        let transition = SKTransition.fade(withDuration: 0.3)
        view?.presentScene(gameOverScene, transition: transition)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
    }
}
