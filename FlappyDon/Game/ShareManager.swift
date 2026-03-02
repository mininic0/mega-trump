import UIKit

class ShareManager {
    
    static let shared = ShareManager()
    
    private init() {}
    
    func shareScore(score: Int, medal: String?, from viewController: UIViewController) {
        let shareImage = generateShareImage(score: score, medal: medal)
        let shareText = getShareText(score: score)
        presentShareSheet(image: shareImage, text: shareText, from: viewController)
    }
    
    func generateShareImage(score: Int, medal: String?) -> UIImage {
        let size = CGSize(width: 1080, height: 1920)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            let ctx = context.cgContext
            
            // Background - Sky Blue
            UIColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0).setFill()
            ctx.fill(CGRect(origin: .zero, size: size))
            
            // Add subtle gradient
            let colors = [
                UIColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0).cgColor,
                UIColor(red: 0.45, green: 0.73, blue: 0.84, alpha: 1.0).cgColor
            ]
            if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                        colors: colors as CFArray,
                                        locations: [0.0, 1.0]) {
                ctx.drawLinearGradient(gradient,
                                      start: CGPoint(x: size.width / 2, y: 0),
                                      end: CGPoint(x: size.width / 2, y: size.height),
                                      options: [])
            }
            
            // Game Title at top
            let titleText = "FLAPPY DON"
            let titleFont = UIFont(name: "AvenirNext-Bold", size: 120) ?? UIFont.boldSystemFont(ofSize: 120)
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: titleFont,
                .foregroundColor: UIColor(red: 0.89, green: 0.11, blue: 0.24, alpha: 1.0), // MAGA Red
                .strokeColor: UIColor.white,
                .strokeWidth: -8.0
            ]
            let titleSize = titleText.size(withAttributes: titleAttributes)
            let titleRect = CGRect(x: (size.width - titleSize.width) / 2,
                                  y: 200,
                                  width: titleSize.width,
                                  height: titleSize.height)
            titleText.draw(in: titleRect, withAttributes: titleAttributes)
            
            // Score Display - Large and prominent
            let scoreText = "\(score)"
            let scoreFont = UIFont(name: "AvenirNext-Bold", size: 280) ?? UIFont.boldSystemFont(ofSize: 280)
            let scoreAttributes: [NSAttributedString.Key: Any] = [
                .font: scoreFont,
                .foregroundColor: UIColor.white,
                .strokeColor: UIColor(red: 0.89, green: 0.11, blue: 0.24, alpha: 1.0),
                .strokeWidth: -12.0
            ]
            let scoreSize = scoreText.size(withAttributes: scoreAttributes)
            let scoreRect = CGRect(x: (size.width - scoreSize.width) / 2,
                                  y: 650,
                                  width: scoreSize.width,
                                  height: scoreSize.height)
            scoreText.draw(in: scoreRect, withAttributes: scoreAttributes)
            
            // "SCORE" label above the number
            let scoreLabelText = "SCORE"
            let scoreLabelFont = UIFont(name: "AvenirNext-Bold", size: 60) ?? UIFont.boldSystemFont(ofSize: 60)
            let scoreLabelAttributes: [NSAttributedString.Key: Any] = [
                .font: scoreLabelFont,
                .foregroundColor: UIColor.white
            ]
            let scoreLabelSize = scoreLabelText.size(withAttributes: scoreLabelAttributes)
            let scoreLabelRect = CGRect(x: (size.width - scoreLabelSize.width) / 2,
                                       y: 550,
                                       width: scoreLabelSize.width,
                                       height: scoreLabelSize.height)
            scoreLabelText.draw(in: scoreLabelRect, withAttributes: scoreLabelAttributes)
            
            // Medal Display
            if let medal = medal {
                let medalColor = getMedalColor(for: medal)
                let medalSize: CGFloat = 200
                let medalRect = CGRect(x: (size.width - medalSize) / 2,
                                      y: 1050,
                                      width: medalSize,
                                      height: medalSize)
                
                // Draw medal circle
                ctx.setFillColor(medalColor.cgColor)
                ctx.fillEllipse(in: medalRect)
                
                // Draw medal border
                ctx.setStrokeColor(UIColor.white.cgColor)
                ctx.setLineWidth(8)
                ctx.strokeEllipse(in: medalRect)
                
                // Draw medal text
                let medalText = getMedalText(for: medal)
                let medalFont = UIFont(name: "AvenirNext-Bold", size: 50) ?? UIFont.boldSystemFont(ofSize: 50)
                let medalTextAttributes: [NSAttributedString.Key: Any] = [
                    .font: medalFont,
                    .foregroundColor: UIColor.white
                ]
                let medalTextSize = medalText.size(withAttributes: medalTextAttributes)
                let medalTextRect = CGRect(x: (size.width - medalTextSize.width) / 2,
                                          y: medalRect.midY - medalTextSize.height / 2,
                                          width: medalTextSize.width,
                                          height: medalTextSize.height)
                medalText.draw(in: medalTextRect, withAttributes: medalTextAttributes)
            }
            
            // Trump Character Emoji (happy if high score, neutral otherwise)
            let characterEmoji = score >= 50 ? "😎" : score >= 25 ? "🙂" : "😐"
            let emojiFont = UIFont.systemFont(ofSize: 180)
            let emojiAttributes: [NSAttributedString.Key: Any] = [
                .font: emojiFont
            ]
            let emojiSize = characterEmoji.size(withAttributes: emojiAttributes)
            let emojiRect = CGRect(x: (size.width - emojiSize.width) / 2,
                                  y: 1300,
                                  width: emojiSize.width,
                                  height: emojiSize.height)
            characterEmoji.draw(in: emojiRect, withAttributes: emojiAttributes)
            
            // Call to action at bottom
            let ctaText = "Download Flappy Don"
            let ctaFont = UIFont(name: "AvenirNext-Medium", size: 50) ?? UIFont.systemFont(ofSize: 50)
            let ctaAttributes: [NSAttributedString.Key: Any] = [
                .font: ctaFont,
                .foregroundColor: UIColor.white.withAlphaComponent(0.8)
            ]
            let ctaSize = ctaText.size(withAttributes: ctaAttributes)
            let ctaRect = CGRect(x: (size.width - ctaSize.width) / 2,
                                y: size.height - 200,
                                width: ctaSize.width,
                                height: ctaSize.height)
            ctaText.draw(in: ctaRect, withAttributes: ctaAttributes)
            
            // American flag emoji
            let flagEmoji = "🇺🇸"
            let flagFont = UIFont.systemFont(ofSize: 80)
            let flagAttributes: [NSAttributedString.Key: Any] = [
                .font: flagFont
            ]
            let flagSize = flagEmoji.size(withAttributes: flagAttributes)
            let flagRect = CGRect(x: (size.width - flagSize.width) / 2,
                                 y: size.height - 120,
                                 width: flagSize.width,
                                 height: flagSize.height)
            flagEmoji.draw(in: flagRect, withAttributes: flagAttributes)
        }
    }
    
    func presentShareSheet(image: UIImage, text: String, from viewController: UIViewController) {
        let activityItems: [Any] = [text, image]
        let activityVC = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        
        activityVC.excludedActivityTypes = [
            .assignToContact,
            .addToReadingList,
            .openInIBooks
        ]
        
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = viewController.view
            popover.sourceRect = CGRect(x: viewController.view.bounds.midX,
                                       y: viewController.view.bounds.midY,
                                       width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        viewController.present(activityVC, animated: true)
    }
    
    private func getShareText(score: Int) -> String {
        return "I scored \(score) on Flappy Don! 🇺🇸 Can you beat me?"
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
    
    private func getMedalText(for medalName: String) -> String {
        switch medalName {
        case "medal_bronze":
            return "🥉"
        case "medal_silver":
            return "🥈"
        case "medal_gold":
            return "🥇"
        case "medal_platinum":
            return "💎"
        default:
            return "⭐"
        }
    }
}
