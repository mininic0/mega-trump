import SpriteKit

class ButtonNode: SKSpriteNode {
    
    private var label: SKLabelNode!
    private var action: (() -> Void)?
    private let normalColor: UIColor
    private let highlightedColor: UIColor
    
    init(size: CGSize, normalColor: UIColor, highlightedColor: UIColor) {
        self.normalColor = normalColor
        self.highlightedColor = highlightedColor
        super.init(texture: nil, color: normalColor, size: size)
        
        self.isUserInteractionEnabled = true
        
        label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.fontSize = 28
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(text: String, action: @escaping () -> Void) {
        label.text = text
        self.action = action
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        color = highlightedColor
        run(SKAction.scale(to: 0.95, duration: 0.1))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        color = normalColor
        run(SKAction.scale(to: 1.0, duration: 0.1))
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if contains(location) {
            action?()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        color = normalColor
        run(SKAction.scale(to: 1.0, duration: 0.1))
    }
}
