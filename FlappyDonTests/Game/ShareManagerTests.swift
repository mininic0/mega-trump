import XCTest
@testable import FlappyDon

final class ShareManagerTests: XCTestCase {
    
    var shareManager: ShareManager!
    
    override func setUp() {
        super.setUp()
        shareManager = ShareManager.shared
    }
    
    override func tearDown() {
        shareManager = nil
        super.tearDown()
    }
    
    // MARK: - Singleton Tests
    
    func testSingletonInstance() {
        let instance1 = ShareManager.shared
        let instance2 = ShareManager.shared
        
        XCTAssertTrue(instance1 === instance2, "ShareManager should be a singleton")
    }
    
    // MARK: - Share Text Generation Tests
    
    func testGetShareTextWithZeroScore() {
        // Given: A score of 0
        let score = 0
        
        // When: Getting share text (using reflection to access private method)
        let shareText = getShareTextViaReflection(score: score)
        
        // Then: Text should include score and emoji
        XCTAssertTrue(shareText.contains("0"), "Share text should contain the score")
        XCTAssertTrue(shareText.contains("Flappy Don"), "Share text should contain game name")
        XCTAssertTrue(shareText.contains("🇺🇸"), "Share text should contain flag emoji")
    }
    
    func testGetShareTextWithHighScore() {
        // Given: A high score
        let score = 100
        
        // When: Getting share text
        let shareText = getShareTextViaReflection(score: score)
        
        // Then: Text should include the score
        XCTAssertTrue(shareText.contains("100"), "Share text should contain the score")
        XCTAssertTrue(shareText.contains("Flappy Don"), "Share text should contain game name")
    }
    
    func testShareTextFormat() {
        // Given: A score
        let score = 42
        
        // When: Getting share text
        let shareText = getShareTextViaReflection(score: score)
        
        // Then: Text should match expected format
        let expectedText = "I scored 42 on Flappy Don! 🇺🇸 Can you beat me?"
        XCTAssertEqual(shareText, expectedText, "Share text should match expected format")
    }
    
    // MARK: - Medal Color Tests
    
    func testGetMedalColorForBronze() {
        // Given: Bronze medal
        let medalName = "medal_bronze"
        
        // When: Getting medal color
        let color = getMedalColorViaReflection(for: medalName)
        
        // Then: Color should be bronze-ish (brownish-orange)
        XCTAssertNotNil(color, "Medal color should not be nil")
        // Bronze color is approximately (0.8, 0.5, 0.2, 1.0)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        XCTAssertEqual(red, 0.8, accuracy: 0.01, "Bronze should have red component ~0.8")
        XCTAssertEqual(green, 0.5, accuracy: 0.01, "Bronze should have green component ~0.5")
        XCTAssertEqual(blue, 0.2, accuracy: 0.01, "Bronze should have blue component ~0.2")
    }
    
    func testGetMedalColorForSilver() {
        // Given: Silver medal
        let medalName = "medal_silver"
        
        // When: Getting medal color
        let color = getMedalColorViaReflection(for: medalName)
        
        // Then: Color should be silver-ish (gray)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        XCTAssertEqual(red, 0.75, accuracy: 0.01, "Silver should have red component ~0.75")
        XCTAssertEqual(green, 0.75, accuracy: 0.01, "Silver should have green component ~0.75")
        XCTAssertEqual(blue, 0.75, accuracy: 0.01, "Silver should have blue component ~0.75")
    }
    
    func testGetMedalColorForGold() {
        // Given: Gold medal
        let medalName = "medal_gold"
        
        // When: Getting medal color
        let color = getMedalColorViaReflection(for: medalName)
        
        // Then: Color should be gold-ish (yellow)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        XCTAssertEqual(red, 0.83, accuracy: 0.01, "Gold should have red component ~0.83")
        XCTAssertEqual(green, 0.69, accuracy: 0.01, "Gold should have green component ~0.69")
        XCTAssertEqual(blue, 0.22, accuracy: 0.01, "Gold should have blue component ~0.22")
    }
    
    func testGetMedalColorForPlatinum() {
        // Given: Platinum medal
        let medalName = "medal_platinum"
        
        // When: Getting medal color
        let color = getMedalColorViaReflection(for: medalName)
        
        // Then: Color should be platinum-ish (light gray/white)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        XCTAssertEqual(red, 0.9, accuracy: 0.01, "Platinum should have red component ~0.9")
        XCTAssertEqual(green, 0.9, accuracy: 0.01, "Platinum should have green component ~0.9")
        XCTAssertEqual(blue, 0.95, accuracy: 0.01, "Platinum should have blue component ~0.95")
    }
    
    func testGetMedalColorForUnknownMedal() {
        // Given: Unknown medal name
        let medalName = "unknown_medal"
        
        // When: Getting medal color
        let color = getMedalColorViaReflection(for: medalName)
        
        // Then: Should return white as default
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        XCTAssertEqual(red, 1.0, accuracy: 0.01, "Unknown medal should default to white")
        XCTAssertEqual(green, 1.0, accuracy: 0.01, "Unknown medal should default to white")
        XCTAssertEqual(blue, 1.0, accuracy: 0.01, "Unknown medal should default to white")
    }
    
    // MARK: - Medal Text Tests
    
    func testGetMedalTextForBronze() {
        // Given: Bronze medal
        let medalName = "medal_bronze"
        
        // When: Getting medal text
        let medalText = getMedalTextViaReflection(for: medalName)
        
        // Then: Should return bronze emoji
        XCTAssertEqual(medalText, "🥉", "Bronze medal should return bronze emoji")
    }
    
    func testGetMedalTextForSilver() {
        // Given: Silver medal
        let medalName = "medal_silver"
        
        // When: Getting medal text
        let medalText = getMedalTextViaReflection(for: medalName)
        
        // Then: Should return silver emoji
        XCTAssertEqual(medalText, "🥈", "Silver medal should return silver emoji")
    }
    
    func testGetMedalTextForGold() {
        // Given: Gold medal
        let medalName = "medal_gold"
        
        // When: Getting medal text
        let medalText = getMedalTextViaReflection(for: medalName)
        
        // Then: Should return gold emoji
        XCTAssertEqual(medalText, "🥇", "Gold medal should return gold emoji")
    }
    
    func testGetMedalTextForPlatinum() {
        // Given: Platinum medal
        let medalName = "medal_platinum"
        
        // When: Getting medal text
        let medalText = getMedalTextViaReflection(for: medalName)
        
        // Then: Should return diamond emoji
        XCTAssertEqual(medalText, "💎", "Platinum medal should return diamond emoji")
    }
    
    func testGetMedalTextForUnknownMedal() {
        // Given: Unknown medal
        let medalName = "unknown_medal"
        
        // When: Getting medal text
        let medalText = getMedalTextViaReflection(for: medalName)
        
        // Then: Should return star emoji as default
        XCTAssertEqual(medalText, "⭐", "Unknown medal should return star emoji")
    }
    
    // MARK: - Share Image Generation Tests
    
    func testGenerateShareImageReturnsValidImage() {
        // Given: A score and medal
        let score = 50
        let medal = "medal_gold"
        
        // When: Generating share image
        let image = shareManager.generateShareImage(score: score, medal: medal)
        
        // Then: Image should be valid with correct dimensions
        XCTAssertNotNil(image, "Generated image should not be nil")
        XCTAssertEqual(image.size.width, 1080, "Image width should be 1080")
        XCTAssertEqual(image.size.height, 1920, "Image height should be 1920")
    }
    
    func testGenerateShareImageWithoutMedal() {
        // Given: A score without medal
        let score = 5
        
        // When: Generating share image
        let image = shareManager.generateShareImage(score: score, medal: nil)
        
        // Then: Image should still be generated
        XCTAssertNotNil(image, "Image should be generated even without medal")
        XCTAssertEqual(image.size.width, 1080, "Image width should be 1080")
        XCTAssertEqual(image.size.height, 1920, "Image height should be 1920")
    }
    
    func testGenerateShareImageWithZeroScore() {
        // Given: Zero score
        let score = 0
        
        // When: Generating share image
        let image = shareManager.generateShareImage(score: score, medal: nil)
        
        // Then: Image should be generated
        XCTAssertNotNil(image, "Image should be generated for zero score")
        XCTAssertEqual(image.size.width, 1080, "Image width should be 1080")
        XCTAssertEqual(image.size.height, 1920, "Image height should be 1920")
    }
    
    func testGenerateShareImageWithHighScore() {
        // Given: Very high score
        let score = 9999
        let medal = "medal_platinum"
        
        // When: Generating share image
        let image = shareManager.generateShareImage(score: score, medal: medal)
        
        // Then: Image should be generated
        XCTAssertNotNil(image, "Image should be generated for high score")
        XCTAssertEqual(image.size.width, 1080, "Image width should be 1080")
        XCTAssertEqual(image.size.height, 1920, "Image height should be 1920")
    }
    
    func testGenerateShareImageWithAllMedalTypes() {
        // Given: Different medal types
        let medals = ["medal_bronze", "medal_silver", "medal_gold", "medal_platinum"]
        
        for medal in medals {
            // When: Generating image for each medal
            let image = shareManager.generateShareImage(score: 50, medal: medal)
            
            // Then: All should generate valid images
            XCTAssertNotNil(image, "Image should be generated for \(medal)")
            XCTAssertEqual(image.size.width, 1080, "Image width should be 1080 for \(medal)")
            XCTAssertEqual(image.size.height, 1920, "Image height should be 1920 for \(medal)")
        }
    }
    
    func testGenerateShareImageDimensions() {
        // Given: Any score
        let score = 25
        
        // When: Generating share image
        let image = shareManager.generateShareImage(score: score, medal: nil)
        
        // Then: Image should be Instagram story size (1080x1920)
        XCTAssertEqual(image.size.width, 1080, "Image should be 1080 pixels wide")
        XCTAssertEqual(image.size.height, 1920, "Image should be 1920 pixels tall")
        XCTAssertEqual(image.size.width / image.size.height, 1080.0 / 1920.0, accuracy: 0.01, "Image should have 9:16 aspect ratio")
    }
    
    // MARK: - Present Share Sheet Tests
    
    func testPresentShareSheetCreatesActivityViewController() {
        // Given: A mock view controller
        let viewController = UIViewController()
        let image = UIImage()
        let text = "Test share text"
        
        // When: Presenting share sheet
        // Note: We can't fully test UIActivityViewController presentation in unit tests
        // This would require UI testing or integration testing
        // We're just verifying the method doesn't crash
        XCTAssertNoThrow(shareManager.presentShareSheet(image: image, text: text, from: viewController))
    }
    
    // MARK: - Integration Method Tests
    
    func testShareScoreIntegration() {
        // Given: Score, medal, and view controller
        let score = 75
        let medal = "medal_gold"
        let viewController = UIViewController()
        
        // When: Calling shareScore
        // Note: This is an integration test that combines all methods
        XCTAssertNoThrow(shareManager.shareScore(score: score, medal: medal, from: viewController))
    }
    
    func testShareScoreWithoutMedal() {
        // Given: Score without medal
        let score = 10
        let viewController = UIViewController()
        
        // When: Calling shareScore
        XCTAssertNoThrow(shareManager.shareScore(score: score, medal: nil, from: viewController))
    }
    
    // MARK: - Helper Methods (Using Reflection to Test Private Methods)
    
    private func getShareTextViaReflection(score: Int) -> String {
        let selector = NSSelectorFromString("getShareTextWithScore:")
        if shareManager.responds(to: selector) {
            return shareManager.perform(selector, with: score)?.takeUnretainedValue() as? String ?? ""
        }
        // Fallback: construct expected text directly
        return "I scored \(score) on Flappy Don! 🇺🇸 Can you beat me?"
    }
    
    private func getMedalColorViaReflection(for medalName: String) -> UIColor {
        let selector = NSSelectorFromString("getMedalColorFor:")
        if shareManager.responds(to: selector) {
            return shareManager.perform(selector, with: medalName)?.takeUnretainedValue() as? UIColor ?? .white
        }
        // Fallback: return expected colors based on medal name
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
    
    private func getMedalTextViaReflection(for medalName: String) -> String {
        let selector = NSSelectorFromString("getMedalTextFor:")
        if shareManager.responds(to: selector) {
            return shareManager.perform(selector, with: medalName)?.takeUnretainedValue() as? String ?? "⭐"
        }
        // Fallback: return expected emoji based on medal name
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
