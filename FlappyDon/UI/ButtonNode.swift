import SpriteKit

class ButtonNode: SKSpriteNode {
    
    private var label: SKLabelNode!
    var action: (() -> Void)?
    private let normalColor: UIColor
    private let highlightedColor: UIColor
    
    init(size: CGSize, normalColor: UIColor, highlightedColor: UIColor) {
        self.normalColor = normalColor
        self.highlightedColor = highlightedColor
        super.init(texture: nil, color: normalColor, size: size)
        
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
    
    func handleTouchBegan() {
        color = highlightedColor
        run(SKAction.scale(to: 0.95, duration: 0.1))
        HapticManager.shared.playButtonHaptic()
    }
    
    func handleTouchEnded() {
        color = normalColor
        run(SKAction.scale(to: 1.0, duration: 0.1))
        action?()
    }
    
    func handleTouchCancelled() {
        color = normalColor
        run(SKAction.scale(to: 1.0, duration: 0.1))
    }
}
