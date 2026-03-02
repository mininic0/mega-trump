import SpriteKit

class ScoreLabel: SKLabelNode {
    
    private var currentScore: Int = 0
    
    init(position: CGPoint) {
        super.init()
        
        self.position = position
        self.fontName = "AvenirNext-Bold"
        self.fontSize = 64
        self.fontColor = .white
        self.zPosition = 100
        self.horizontalAlignmentMode = .center
        self.verticalAlignmentMode = .top
        
        addShadow()
        updateText()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addShadow() {
        let shadow = SKLabelNode(fontNamed: "AvenirNext-Bold")
        shadow.fontSize = 64
        shadow.fontColor = .black
        shadow.alpha = 0.3
        shadow.position = CGPoint(x: 3, y: -3)
        shadow.zPosition = -1
        shadow.horizontalAlignmentMode = .center
        shadow.verticalAlignmentMode = .top
        shadow.name = "shadow"
        addChild(shadow)
    }
    
    func setScore(_ score: Int, animated: Bool = true) {
        let previousScore = currentScore
        currentScore = score
        
        if animated && score > previousScore {
            animateScoreChange()
        } else {
            updateText()
        }
    }
    
    private func updateText() {
        text = "\(currentScore)"
        
        if let shadow = childNode(withName: "shadow") as? SKLabelNode {
            shadow.text = "\(currentScore)"
        }
    }
    
    private func animateScoreChange() {
        updateText()
        
        // Scale animation: 1.0 → 1.2 → 1.0
        let scaleUp = SKAction.scale(to: 1.2, duration: 0.1)
        scaleUp.timingMode = .easeOut
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
        scaleDown.timingMode = .easeIn
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        
        // Color flash: white → gold → white
        let goldColor = UIColor(red: 0.83, green: 0.69, blue: 0.22, alpha: 1.0)
        let flashGold = SKAction.colorize(with: goldColor, colorBlendFactor: 1.0, duration: 0.1)
        let flashWhite = SKAction.colorize(with: .white, colorBlendFactor: 1.0, duration: 0.1)
        let colorSequence = SKAction.sequence([flashGold, flashWhite])
        
        // Run both animations together
        run(SKAction.group([scaleSequence, colorSequence]))
    }
    
    func reset() {
        currentScore = 0
        updateText()
        setScale(1.0)
        fontColor = .white
    }
}
