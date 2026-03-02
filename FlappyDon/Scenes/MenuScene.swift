import SpriteKit

class MenuScene: SKScene {
    
    private var soundEnabled = true
    private var soundIcon: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupLogo()
        setupTrumpCharacter()
        setupPlayButton()
        setupHighScore()
        setupSoundToggle()
        loadSettings()
    }
    
    private func setupBackground() {
        backgroundColor = SKColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0)
    }
    
    private func setupLogo() {
        let logo = SKLabelNode(fontNamed: "AvenirNext-Bold")
        logo.text = "FLAPPY DON"
        logo.fontSize = 48
        logo.fontColor = UIColor(red: 0.83, green: 0.69, blue: 0.22, alpha: 1.0) // Trump Gold #D4AF37
        logo.position = CGPoint(x: size.width / 2, y: size.height * 0.75)
        logo.zPosition = 10
        
        let shadowLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        shadowLabel.text = "FLAPPY DON"
        shadowLabel.fontSize = 48
        shadowLabel.fontColor = .black
        shadowLabel.alpha = 0.3
        shadowLabel.position = CGPoint(x: 2, y: -2)
        shadowLabel.zPosition = -1
        logo.addChild(shadowLabel)
        
        addChild(logo)
    }
    
    private func setupTrumpCharacter() {
        let trumpHead = SKSpriteNode(color: UIColor(red: 1.0, green: 0.8, blue: 0.6, alpha: 1.0), size: CGSize(width: 80, height: 80))
        trumpHead.position = CGPoint(x: size.width / 2, y: size.height * 0.55)
        trumpHead.zPosition = 10
        addChild(trumpHead)
        
        let bobUp = SKAction.moveBy(x: 0, y: 15, duration: 1.0)
        bobUp.timingMode = .easeInEaseOut
        let bobDown = SKAction.moveBy(x: 0, y: -15, duration: 1.0)
        bobDown.timingMode = .easeInEaseOut
        let bobSequence = SKAction.sequence([bobUp, bobDown])
        let bobForever = SKAction.repeatForever(bobSequence)
        
        trumpHead.run(bobForever)
    }
    
    private func setupPlayButton() {
        let playButton = ButtonNode(
            size: CGSize(width: 200, height: 60),
            normalColor: UIColor(red: 0.89, green: 0.11, blue: 0.24, alpha: 1.0), // MAGA Red #E31C3D
            highlightedColor: UIColor(red: 0.7, green: 0.09, blue: 0.19, alpha: 1.0)
        )
        playButton.position = CGPoint(x: size.width / 2, y: size.height * 0.35)
        playButton.zPosition = 10
        playButton.setup(text: "PLAY") { [weak self] in
            self?.startGame()
        }
        addChild(playButton)
    }
    
    private func setupHighScore() {
        let highScore = UserDefaults.standard.integer(forKey: "HighScore")
        
        let highScoreLabel = SKLabelNode(fontNamed: "AvenirNext-Medium")
        highScoreLabel.text = "🏆 Best: \(highScore)"
        highScoreLabel.fontSize = 22
        highScoreLabel.fontColor = .white
        highScoreLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.25)
        highScoreLabel.zPosition = 10
        
        let shadowLabel = SKLabelNode(fontNamed: "AvenirNext-Medium")
        shadowLabel.text = "🏆 Best: \(highScore)"
        shadowLabel.fontSize = 22
        shadowLabel.fontColor = .black
        shadowLabel.alpha = 0.3
        shadowLabel.position = CGPoint(x: 1, y: -1)
        shadowLabel.zPosition = -1
        highScoreLabel.addChild(shadowLabel)
        
        addChild(highScoreLabel)
    }
    
    private func setupSoundToggle() {
        soundIcon = SKSpriteNode(color: .white, size: CGSize(width: 40, height: 40))
        soundIcon.position = CGPoint(x: 40, y: 40)
        soundIcon.zPosition = 10
        soundIcon.name = "soundToggle"
        addChild(soundIcon)
        
        let iconLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        iconLabel.fontSize = 24
        iconLabel.verticalAlignmentMode = .center
        iconLabel.horizontalAlignmentMode = .center
        iconLabel.name = "soundIconLabel"
        soundIcon.addChild(iconLabel)
        
        updateSoundIcon()
    }
    
    private func loadSettings() {
        soundEnabled = UserDefaults.standard.bool(forKey: "SoundEnabled")
        if UserDefaults.standard.object(forKey: "SoundEnabled") == nil {
            soundEnabled = true
            UserDefaults.standard.set(true, forKey: "SoundEnabled")
        }
        updateSoundIcon()
    }
    
    private func updateSoundIcon() {
        if let iconLabel = soundIcon.childNode(withName: "soundIconLabel") as? SKLabelNode {
            iconLabel.text = soundEnabled ? "🔊" : "🔇"
        }
    }
    
    private func toggleSound() {
        soundEnabled.toggle()
        UserDefaults.standard.set(soundEnabled, forKey: "SoundEnabled")
        updateSoundIcon()
    }
    
    private func startGame() {
        let gameScene = GameScene(size: size)
        let transition = SKTransition.fade(withDuration: 0.3)
        view?.presentScene(gameScene, transition: transition)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        
        if touchedNode.name == "soundToggle" || touchedNode.parent?.name == "soundToggle" {
            toggleSound()
        }
    }
}
