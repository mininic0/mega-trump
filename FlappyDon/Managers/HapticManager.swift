import UIKit

class HapticManager {
    static let shared = HapticManager()
    
    private let lightImpact = UIImpactFeedbackGenerator(style: .light)
    private let heavyImpact = UIImpactFeedbackGenerator(style: .heavy)
    private let successFeedback = UINotificationFeedbackGenerator()
    private let selectionFeedback = UISelectionFeedbackGenerator()
    
    var isHapticsEnabled: Bool {
        return AudioManager.shared.isSoundEnabled
    }
    
    private init() {
        setup()
    }
    
    func setup() {
        lightImpact.prepare()
        heavyImpact.prepare()
        successFeedback.prepare()
        selectionFeedback.prepare()
    }
    
    func playFlapHaptic() {
        guard isHapticsEnabled else { return }
        guard UIDevice.current.userInterfaceIdiom == .phone else { return }
        
        lightImpact.impactOccurred()
        lightImpact.prepare()
    }
    
    func playScoreHaptic() {
        guard isHapticsEnabled else { return }
        guard UIDevice.current.userInterfaceIdiom == .phone else { return }
        
        successFeedback.notificationOccurred(.success)
        successFeedback.prepare()
    }
    
    func playDeathHaptic() {
        guard isHapticsEnabled else { return }
        guard UIDevice.current.userInterfaceIdiom == .phone else { return }
        
        heavyImpact.impactOccurred()
        heavyImpact.prepare()
    }
    
    func playButtonHaptic() {
        guard isHapticsEnabled else { return }
        guard UIDevice.current.userInterfaceIdiom == .phone else { return }
        
        selectionFeedback.selectionChanged()
        selectionFeedback.prepare()
    }
}
