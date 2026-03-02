import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    private var scenePresented = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            
            #if targetEnvironment(simulator)
            view.preferredFramesPerSecond = 60
            #else
            view.preferredFramesPerSecond = 60
            #endif
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Present scene only once, after view bounds are set
        if !scenePresented, let view = self.view as? SKView, view.bounds.size.width > 0 {
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
            scenePresented = true
        }
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
