import SpriteKit

class GameOverScene: SKScene {
    
    private let finalScore: Int
    private let previousHighScore: Int
    private let isNewHighScore: Bool
    private var retryButton: ButtonNode!
    private var shareButton: ButtonNode!
    private var menuButton: ButtonNode!
    
    init(size: CGSize, score: Int) {
        self.finalScore = score
        self.previousHighScore = UserDefaults.standard.integer(forKey: "HighScore")
        self.isNewHighScore = score > previousHighScore
        
        if isNewHighScore {
            UserDefaults.standard.set(score, forKey: "HighScore")
        }
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupTitle()
        setupScoreDisplay()
        setupMedal()
        setupButtons()
        
        if isNewHighScore {
            showNewHighScoreEffects()
        }
    }
    
    private func setupBackground() {
        backgroundColor = SKColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0)
    }
    
    private func setupTitle() {
        let title = SKLabelNode(fontNamed: "AvenirNext-Bold")
        title.text = "GAME OVER"
        title.fontSize = 44
        title.fontColor = UIColor(red: 0.89, green: 0.11, blue: 0.24, alpha: 1.0) // MAGA Red
        title.position = CGPoint(x: size.width / 2, y: size.height * 0.75)
        title.zPosition = 10
        
        let shadowLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        shadowLabel.text = "GAME OVER"
        shadowLabel.fontSize = 44
        shadowLabel.fontColor = .black
        shadowLabel.alpha = 0.3
        shadowLabel.position = CGPoint(x: 2, y: -2)
        shadowLabel.zPosition = -1
        title.addChild(shadowLabel)
        
        addChild(title)
        
        title.position.y = size.height + 50
        let dropAction = SKAction.moveTo(y: size.height * 0.75, duration: 0.5)
        dropAction.timingMode = .easeOut
        let bounceUp = SKAction.moveBy(x: 0, y: 10, duration: 0.1)
        let bounceDown = SKAction.moveBy(x: 0, y: -10, duration: 0.1)
        let bounceSequence = SKAction.sequence([bounceUp, bounceDown])
        
        title.run(SKAction.sequence([dropAction, bounceSequence]))
    }
    
    private func setupScoreDisplay() {
        let currentScoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        currentScoreLabel.name = "currentScoreLabel"
        currentScoreLabel.fontSize = 32
        currentScoreLabel.fontColor = .white
        currentScoreLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.55)
        currentScoreLabel.zPosition = 10
        addChild(currentScoreLabel)
        
        if isNewHighScore {
            animateScore(label: currentScoreLabel, from: 0, to: finalScore, duration: 1.0)
            
            let newBadge = SKLabelNode(fontNamed: "AvenirNext-Bold")
            newBadge.text = "NEW!"
            newBadge.fontSize = 20
            newBadge.fontColor = UIColor(red: 0.83, green: 0.69, blue: 0.22, alpha: 1.0) // Trump Gold
            newBadge.position = CGPoint(x: currentScoreLabel.frame.width / 2 + 50, y: 0)
            newBadge.zPosition = 10
            currentScoreLabel.addChild(newBadge)
            
            let pulse = SKAction.sequence([
                SKAction.scale(to: 1.2, duration: 0.3),
                SKAction.scale(to: 1.0, duration: 0.3)
            ])
            newBadge.run(SKAction.repeatForever(pulse))
        } else {
            currentScoreLabel.text = "Score: \(finalScore)"
        }
        
        let highScoreLabel = SKLabelNode(fontNamed: "AvenirNext-Medium")
        highScoreLabel.text = "🏆 Best: \(max(finalScore, previousHighScore))"
        highScoreLabel.fontSize = 24
        highScoreLabel.fontColor = .white
        highScoreLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.48)
        highScoreLabel.zPosition = 10
        addChild(highScoreLabel)
    }
    
    private func animateScore(label: SKLabelNode, from: Int, to: Int, duration: TimeInterval) {
        let steps = 30
        let increment = max(1, (to - from) / steps)
        let stepDuration = duration / TimeInterval(steps)
        
        var current = from
        for i in 0..<steps {
            let wait = SKAction.wait(forDuration: stepDuration * TimeInterval(i))
            let update = SKAction.run {
                current = min(current + increment, to)
                label.text = "Score: \(current)"
            }
            run(SKAction.sequence([wait, update]))
        }
        
        let finalWait = SKAction.wait(forDuration: duration)
        let finalUpdate = SKAction.run {
            label.text = "Score: \(to)"
        }
        run(SKAction.sequence([finalWait, finalUpdate]))
    }
    
    private func setupMedal() {
        guard let medalName = getMedal(for: finalScore) else { return }
        
        let medal = SKSpriteNode(color: getMedalColor(for: medalName), size: CGSize(width: 60, height: 60))
        medal.position = CGPoint(x: size.width / 2, y: size.height * 0.38)
        medal.zPosition = 10
        addChild(medal)
        
        medal.setScale(0)
        let scaleUp = SKAction.scale(to: 1.0, duration: 0.4)
        scaleUp.timingMode = .easeOut
        let rotate = SKAction.rotate(byAngle: .pi * 2, duration: 0.4)
        medal.run(SKAction.group([scaleUp, rotate]))
    }
    
    private func setupButtons() {
        retryButton = ButtonNode(
            size: CGSize(width: 180, height: 50),
            normalColor: UIColor(red: 0.89, green: 0.11, blue: 0.24, alpha: 1.0), // MAGA Red
            highlightedColor: UIColor(red: 0.7, green: 0.09, blue: 0.19, alpha: 1.0)
        )
        retryButton.position = CGPoint(x: size.width / 2, y: size.height * 0.25)
        retryButton.zPosition = 10
        retryButton.name = "retryButton"
        retryButton.setup(text: "RETRY") { [weak self] in
            self?.retry()
        }
        addChild(retryButton)
        
        shareButton = ButtonNode(
            size: CGSize(width: 180, height: 50),
            normalColor: UIColor(red: 0.0, green: 0.24, blue: 0.45, alpha: 1.0), // Navy Blue
            highlightedColor: UIColor(red: 0.0, green: 0.19, blue: 0.36, alpha: 1.0)
        )
        shareButton.position = CGPoint(x: size.width / 2, y: size.height * 0.17)
        shareButton.zPosition = 10
        shareButton.name = "shareButton"
        shareButton.setup(text: "SHARE") { [weak self] in
            self?.share()
        }
        addChild(shareButton)
        
        menuButton = ButtonNode(
            size: CGSize(width: 180, height: 50),
            normalColor: UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0),
            highlightedColor: UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
        )
        menuButton.position = CGPoint(x: size.width / 2, y: size.height * 0.09)
        menuButton.zPosition = 10
        menuButton.name = "menuButton"
        menuButton.setup(text: "MENU") { [weak self] in
            self?.returnToMenu()
        }
        addChild(menuButton)
    }
    
    private func showNewHighScoreEffects() {
        if let confetti = SKEmitterNode(fileNamed: "Confetti") {
            confetti.position = CGPoint(x: size.width / 2, y: size.height)
            confetti.zPosition = 100
            addChild(confetti)
            
            let wait = SKAction.wait(forDuration: 2.0)
            let remove = SKAction.removeFromParent()
            confetti.run(SKAction.sequence([wait, remove]))
        } else {
            let confettiCount = 50
            for _ in 0..<confettiCount {
                let confettiPiece = SKSpriteNode(color: randomColor(), size: CGSize(width: 8, height: 8))
                confettiPiece.position = CGPoint(x: CGFloat.random(in: 0...size.width), y: size.height)
                confettiPiece.zPosition = 100
                addChild(confettiPiece)
                
                let fall = SKAction.moveBy(x: CGFloat.random(in: -50...50), y: -size.height - 100, duration: 2.0)
                let rotate = SKAction.rotate(byAngle: .pi * 4, duration: 2.0)
                let fadeOut = SKAction.fadeOut(withDuration: 2.0)
                let remove = SKAction.removeFromParent()
                
                confettiPiece.run(SKAction.sequence([
                    SKAction.group([fall, rotate, fadeOut]),
                    remove
                ]))
            }
        }
    }
    
    private func getMedal(for score: Int) -> String? {
        switch score {
        case 0...9:
            return nil
        case 10...24:
            return "medal_bronze"
        case 25...49:
            return "medal_silver"
        case 50...99:
            return "medal_gold"
        default:
            return "medal_platinum"
        }
    }
    
    private func getMedalColor(for medalName: String) -> UIColor {
        switch medalName {
        case "medal_bronze":
            return UIColor(red: 0.8, green: 0.5, blue: 0.2, alpha: 1.0)
        case "medal_silver":
            return UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
        case "medal_gold":
            return UIColor(red: 0.83, green: 0.69, blue: 0.22, alpha: 1.0)
        case "medal_platinum":
            return UIColor(red: 0.9, green: 0.9, blue: 0.95, alpha: 1.0)
        default:
            return .white
        }
    }
    
    private func randomColor() -> UIColor {
        let colors: [UIColor] = [
            UIColor(red: 0.83, green: 0.69, blue: 0.22, alpha: 1.0), // Gold
            UIColor(red: 0.89, green: 0.11, blue: 0.24, alpha: 1.0), // Red
            UIColor(red: 0.0, green: 0.24, blue: 0.45, alpha: 1.0),  // Blue
            .white
        ]
        return colors.randomElement() ?? .white
    }
    
    private func retry() {
        let gameScene = GameScene(size: size)
        let transition = SKTransition.fade(withDuration: 0.3)
        view?.presentScene(gameScene, transition: transition)
    }
    
    private func share() {
        // Share functionality will be implemented in ticket 09
        // For now, just log the action
        print("Share button tapped - Score: \(finalScore)")
    }
    
    private func returnToMenu() {
        let menuScene = MenuScene(size: size)
        let transition = SKTransition.fade(withDuration: 0.3)
        view?.presentScene(menuScene, transition: transition)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        
        if touchedNode == retryButton || touchedNode.parent == retryButton {
            retryButton.handleTouchBegan()
        } else if touchedNode == shareButton || touchedNode.parent == shareButton {
            shareButton.handleTouchBegan()
        } else if touchedNode == menuButton || touchedNode.parent == menuButton {
            menuButton.handleTouchBegan()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        
        if touchedNode == retryButton || touchedNode.parent == retryButton {
            retryButton.handleTouchEnded()
        } else if touchedNode == shareButton || touchedNode.parent == shareButton {
            shareButton.handleTouchEnded()
        } else if touchedNode == menuButton || touchedNode.parent == menuButton {
            menuButton.handleTouchEnded()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        retryButton.handleTouchCancelled()
        shareButton.handleTouchCancelled()
        menuButton.handleTouchCancelled()
    }
}
