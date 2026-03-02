import SpriteKit

class SplashScene: SKScene {
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupLogo()
        setupTrumpAnimation()
        scheduleTransition()
    }
    
    private func setupBackground() {
        backgroundColor = SKColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0)
    }
    
    private func setupLogo() {
        let logo = SKLabelNode(fontNamed: "AvenirNext-Bold")
        logo.text = "FLAPPY DON"
        logo.fontSize = 56
        logo.fontColor = UIColor(red: 0.83, green: 0.69, blue: 0.22, alpha: 1.0) // Trump Gold #D4AF37
        logo.position = CGPoint(x: size.width / 2, y: size.height * 0.67)
        logo.zPosition = 10
        
        let shadowLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        shadowLabel.text = "FLAPPY DON"
        shadowLabel.fontSize = 56
        shadowLabel.fontColor = .black
        shadowLabel.alpha = 0.3
        shadowLabel.position = CGPoint(x: 2, y: -2)
        shadowLabel.zPosition = -1
        logo.addChild(shadowLabel)
        
        addChild(logo)
        
        logo.setScale(0.5)
        logo.alpha = 0
        logo.run(SKAction.group([
            SKAction.fadeIn(withDuration: 0.5),
            SKAction.scale(to: 1.0, duration: 0.5)
        ]))
    }
    
    private func setupTrumpAnimation() {
        let trumpHead = SKSpriteNode(color: UIColor(red: 1.0, green: 0.8, blue: 0.6, alpha: 1.0), size: CGSize(width: 80, height: 80))
        trumpHead.position = CGPoint(x: size.width / 2, y: size.height * 0.45)
        trumpHead.zPosition = 10
        addChild(trumpHead)
        
        let flapUp = SKAction.moveBy(x: 0, y: 20, duration: 0.3)
        flapUp.timingMode = .easeOut
        let flapDown = SKAction.moveBy(x: 0, y: -20, duration: 0.3)
        flapDown.timingMode = .easeIn
        let flapSequence = SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            flapUp,
            flapDown
        ])
        
        trumpHead.run(flapSequence)
    }
    
    private func scheduleTransition() {
        let wait = SKAction.wait(forDuration: 2.0)
        let transition = SKAction.run { [weak self] in
            self?.transitionToMenu()
        }
        run(SKAction.sequence([wait, transition]))
    }
    
    private func transitionToMenu() {
        let menuScene = MenuScene(size: size)
        let transition = SKTransition.fade(withDuration: 0.5)
        view?.presentScene(menuScene, transition: transition)
    }
}
