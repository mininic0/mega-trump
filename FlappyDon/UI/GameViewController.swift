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
        
        // Register for app lifecycle notifications
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillResignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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

    // MARK: - App Lifecycle Event Handlers
    
    @objc func appWillResignActive(_ notification: Notification) {
        // App is about to lose focus (phone call, control center, etc.)
        if let gameScene = (view as? SKView)?.scene as? GameScene {
            if GameManager.shared.currentState == .playing {
                gameScene.pauseGame()
            }
        }
    }
    
    @objc func appDidBecomeActive(_ notification: Notification) {
        // App regained focus
        // Don't auto-resume - wait for user tap
    }
    
    @objc func appDidEnterBackground(_ notification: Notification) {
        // App moved to background
        if let gameScene = (view as? SKView)?.scene as? GameScene {
            if GameManager.shared.currentState == .playing {
                gameScene.pauseGame()
            }
        }
    }
    
    @objc func appWillEnterForeground(_ notification: Notification) {
        // App returning from background
        // Game remains paused until user taps
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
