import SpriteKit

class ObstacleManager {
    
    private var obstaclePool: [ObstacleNode] = []
    private var activeObstacles: [ObstacleNode] = []
    
    private var spawnTimer: TimeInterval = 0
    private var spawnInterval: TimeInterval = 2.5
    private var initialDelay: TimeInterval = 2.0
    private var hasStarted: Bool = false
    
    private var scrollSpeed: CGFloat = 150
    private var currentGapSize: CGFloat = 200
    
    private let poolSize: Int = 6
    private let towerWidth: CGFloat = 80
    private let safeMargin: CGFloat = 80
    
    private weak var scene: SKScene?
    
    init(scene: SKScene) {
        self.scene = scene
        initializePool()
    }
    
    private func initializePool() {
        for _ in 0..<poolSize {
            let obstacle = ObstacleNode()
            obstaclePool.append(obstacle)
        }
    }
    
    func update(deltaTime: TimeInterval, currentScore: Int) {
        guard let scene = scene else { return }
        
        if !hasStarted {
            spawnTimer += deltaTime
            if spawnTimer >= initialDelay {
                hasStarted = true
                spawnTimer = 0
            }
            return
        }
        
        updateDifficulty(score: currentScore)
        
        spawnTimer += deltaTime
        if spawnTimer >= spawnInterval {
            spawnObstacle()
            spawnTimer = 0
        }
        
        updateObstacles(deltaTime: deltaTime)
        removeOffscreenObstacles()
    }
    
    private func spawnObstacle() {
        guard let scene = scene else { return }
        
        let obstacle: ObstacleNode
        if let pooledObstacle = obstaclePool.first {
            obstacle = pooledObstacle
            obstaclePool.removeFirst()
        } else {
            obstacle = ObstacleNode()
        }
        
        let screenHeight = scene.size.height
        let minY = currentGapSize / 2 + safeMargin
        let maxY = screenHeight - currentGapSize / 2 - safeMargin
        let randomY = CGFloat.random(in: minY...maxY)
        
        obstacle.setup(gapSize: currentGapSize, gapCenterY: randomY, screenHeight: screenHeight)
        obstacle.position = CGPoint(x: scene.size.width + towerWidth / 2, y: 0)
        
        scene.addChild(obstacle)
        activeObstacles.append(obstacle)
    }
    
    private func updateObstacles(deltaTime: TimeInterval) {
        let moveDistance = scrollSpeed * CGFloat(deltaTime)
        
        for obstacle in activeObstacles {
            obstacle.position.x -= moveDistance
        }
    }
    
    private func removeOffscreenObstacles() {
        guard let scene = scene else { return }
        
        var obstaclesToRemove: [ObstacleNode] = []
        
        for obstacle in activeObstacles {
            if obstacle.position.x < -towerWidth {
                obstaclesToRemove.append(obstacle)
            }
        }
        
        for obstacle in obstaclesToRemove {
            obstacle.removeFromParent()
            obstacle.reset()
            obstaclePool.append(obstacle)
            
            if let index = activeObstacles.firstIndex(of: obstacle) {
                activeObstacles.remove(at: index)
            }
        }
    }
    
    private func updateDifficulty(score: Int) {
        let previousGapSize = currentGapSize
        let previousSpeed = scrollSpeed
        
        switch score {
        case 0...10:
            currentGapSize = 200
            scrollSpeed = 150
        case 11...25:
            currentGapSize = 160
            scrollSpeed = 200
        case 26...50:
            currentGapSize = 130
            scrollSpeed = 250
        default:
            currentGapSize = 110
            scrollSpeed = 300
        }
        
        if currentGapSize != previousGapSize || scrollSpeed != previousSpeed {
            smoothTransition(from: previousGapSize, to: currentGapSize, speedFrom: previousSpeed, speedTo: scrollSpeed)
        }
    }
    
    private func smoothTransition(from oldGap: CGFloat, to newGap: CGFloat, speedFrom oldSpeed: CGFloat, speedTo newSpeed: CGFloat) {
        let transitionObstacles = 3
        let gapStep = (newGap - oldGap) / CGFloat(transitionObstacles)
        let speedStep = (newSpeed - oldSpeed) / CGFloat(transitionObstacles)
        
        for (index, obstacle) in activeObstacles.enumerated() {
            if index < transitionObstacles {
                let interpolatedGap = oldGap + gapStep * CGFloat(index)
                let interpolatedSpeed = oldSpeed + speedStep * CGFloat(index)
            }
        }
    }
    
    func reset() {
        for obstacle in activeObstacles {
            obstacle.removeFromParent()
            obstacle.reset()
            obstaclePool.append(obstacle)
        }
        
        activeObstacles.removeAll()
        spawnTimer = 0
        hasStarted = false
        scrollSpeed = 150
        currentGapSize = 200
    }
    
    func getActiveObstacles() -> [ObstacleNode] {
        return activeObstacles
    }
}
