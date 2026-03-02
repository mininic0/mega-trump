import SpriteKit

class BackgroundManager {
    
    // MARK: - Properties
    
    private var skyLayer: SKNode!
    private var cityLayer: SKNode!
    private var groundLayer: SKNode!
    
    private var skyNode1: SKNode!
    private var skyNode2: SKNode!
    private var cityNode1: SKSpriteNode!
    private var cityNode2: SKSpriteNode!
    private var groundNode1: SKSpriteNode!
    private var groundNode2: SKSpriteNode!
    
    private var scrollSpeed: CGFloat = 150.0
    private var isScrolling: Bool = false
    
    private var sceneSize: CGSize = .zero
    
    // MARK: - Setup
    
    func setup(in scene: SKScene) {
        sceneSize = scene.size
        
        createSkyLayer(in: scene)
        createCityLayer(in: scene)
        createGroundLayer(in: scene)
    }
    
    // MARK: - Sky Layer (Far Background)
    
    private func createSkyLayer(in scene: SKScene) {
        skyLayer = SKNode()
        skyLayer.zPosition = -100
        scene.addChild(skyLayer)
        
        // Create two sky segments for seamless looping
        skyNode1 = createSkySegment()
        skyNode1.position = CGPoint(x: sceneSize.width / 2, y: sceneSize.height / 2)
        skyLayer.addChild(skyNode1)
        
        skyNode2 = createSkySegment()
        skyNode2.position = CGPoint(x: sceneSize.width * 1.5, y: sceneSize.height / 2)
        skyLayer.addChild(skyNode2)
    }
    
    private func createSkySegment() -> SKNode {
        let segment = SKNode()
        
        // Sky background - solid blue color #87CEEB
        let skyBackground = SKSpriteNode(color: UIColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0),
                                        size: CGSize(width: sceneSize.width, height: sceneSize.height))
        skyBackground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        segment.addChild(skyBackground)
        
        // Add clouds scattered across the sky
        addClouds(to: segment)
        
        return segment
    }
    
    private func addClouds(to segment: SKNode) {
        let cloudNames = ["cloud_1", "cloud_2", "cloud_3"]
        let cloudCount = 4
        
        for i in 0..<cloudCount {
            let cloudName = cloudNames[i % cloudNames.count]
            
            // Try to load cloud texture, fallback to simple white oval
            let cloud: SKSpriteNode
            if let cloudTexture = SKTexture(imageNamed: cloudName) as SKTexture?, cloudTexture.size() != .zero {
                cloud = SKSpriteNode(texture: cloudTexture)
            } else {
                // Fallback: create simple white oval cloud
                cloud = SKSpriteNode(color: .white, size: CGSize(width: 80, height: 40))
                cloud.alpha = 0.8
            }
            
            // Position clouds at different heights and horizontal positions
            let xPosition = CGFloat(i) * (sceneSize.width / CGFloat(cloudCount)) - sceneSize.width / 2 + 40
            let yPosition = sceneSize.height * 0.3 + CGFloat.random(in: -50...50)
            
            cloud.position = CGPoint(x: xPosition, y: yPosition)
            segment.addChild(cloud)
        }
    }
    
    // MARK: - City Layer (Mid Background)
    
    private func createCityLayer(in scene: SKScene) {
        cityLayer = SKNode()
        cityLayer.zPosition = -50
        scene.addChild(cityLayer)
        
        // Create two city segments for seamless looping
        cityNode1 = createCitySegment()
        cityNode1.position = CGPoint(x: sceneSize.width / 2, y: 0)
        cityLayer.addChild(cityNode1)
        
        cityNode2 = createCitySegment()
        cityNode2.position = CGPoint(x: sceneSize.width * 1.5, y: 0)
        cityLayer.addChild(cityNode2)
    }
    
    private func createCitySegment() -> SKSpriteNode {
        // Try to load city skyline texture
        if let cityTexture = SKTexture(imageNamed: "city_skyline") as SKTexture?, cityTexture.size() != .zero {
            let citySprite = SKSpriteNode(texture: cityTexture)
            citySprite.anchorPoint = CGPoint(x: 0.5, y: 0)
            citySprite.size = CGSize(width: sceneSize.width, height: sceneSize.height * 0.3)
            return citySprite
        } else {
            // Fallback: create simple building silhouettes
            return createSimpleCitySilhouette()
        }
    }
    
    private func createSimpleCitySilhouette() -> SKSpriteNode {
        let container = SKSpriteNode(color: .clear, size: CGSize(width: sceneSize.width, height: sceneSize.height * 0.3))
        container.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        // Navy blue color for buildings #002868
        let buildingColor = UIColor(red: 0.0, green: 0.16, blue: 0.41, alpha: 1.0)
        
        // Create simple building shapes
        let buildingCount = 8
        let buildingWidth = sceneSize.width / CGFloat(buildingCount)
        
        for i in 0..<buildingCount {
            let height = CGFloat.random(in: 80...180)
            let building = SKSpriteNode(color: buildingColor, size: CGSize(width: buildingWidth - 2, height: height))
            building.anchorPoint = CGPoint(x: 0.5, y: 0)
            building.position = CGPoint(x: CGFloat(i) * buildingWidth - sceneSize.width / 2 + buildingWidth / 2, y: 0)
            container.addChild(building)
            
            // Add simple windows
            addWindows(to: building)
        }
        
        return container
    }
    
    private func addWindows(to building: SKSpriteNode) {
        let windowColor = UIColor(red: 1.0, green: 0.9, blue: 0.5, alpha: 0.3)
        let windowSize = CGSize(width: 6, height: 8)
        let rows = Int(building.size.height / 20)
        let cols = Int(building.size.width / 15)
        
        for row in 0..<rows {
            for col in 0..<cols {
                if Bool.random() {
                    let window = SKSpriteNode(color: windowColor, size: windowSize)
                    window.position = CGPoint(
                        x: CGFloat(col) * 15 - building.size.width / 2 + 10,
                        y: CGFloat(row) * 20 + 10
                    )
                    building.addChild(window)
                }
            }
        }
    }
    
    // MARK: - Ground Layer (Near Background)
    
    private func createGroundLayer(in scene: SKScene) {
        groundLayer = SKNode()
        groundLayer.zPosition = -10
        scene.addChild(groundLayer)
        
        let groundHeight: CGFloat = 70
        
        // Create two ground segments for seamless looping
        groundNode1 = createGroundSegment(height: groundHeight)
        groundNode1.position = CGPoint(x: sceneSize.width / 2, y: groundHeight / 2)
        groundLayer.addChild(groundNode1)
        
        groundNode2 = createGroundSegment(height: groundHeight)
        groundNode2.position = CGPoint(x: sceneSize.width * 1.5, y: groundHeight / 2)
        groundLayer.addChild(groundNode2)
    }
    
    private func createGroundSegment(height: CGFloat) -> SKSpriteNode {
        // Try to load ground texture
        if let groundTexture = SKTexture(imageNamed: "ground_texture") as SKTexture?, groundTexture.size() != .zero {
            let groundSprite = SKSpriteNode(texture: groundTexture)
            groundSprite.size = CGSize(width: sceneSize.width, height: height)
            return groundSprite
        } else {
            // Fallback: create simple grass pattern
            return createSimpleGroundTexture(height: height)
        }
    }
    
    private func createSimpleGroundTexture(height: CGFloat) -> SKSpriteNode {
        let container = SKSpriteNode(color: UIColor(red: 0.4, green: 0.6, blue: 0.2, alpha: 1.0),
                                    size: CGSize(width: sceneSize.width, height: height))
        
        // Add simple grass blades
        let grassColor = UIColor(red: 0.3, green: 0.5, blue: 0.1, alpha: 1.0)
        let grassCount = Int(sceneSize.width / 10)
        
        for i in 0..<grassCount {
            let grass = SKSpriteNode(color: grassColor, size: CGSize(width: 2, height: 12))
            grass.position = CGPoint(
                x: CGFloat(i) * 10 - sceneSize.width / 2,
                y: height / 2 - 6
            )
            container.addChild(grass)
        }
        
        return container
    }
    
    // MARK: - Scrolling Control
    
    func startScrolling() {
        isScrolling = true
    }
    
    func stopScrolling() {
        isScrolling = false
    }
    
    func update(deltaTime: TimeInterval) {
        guard isScrolling else { return }
        
        let dt = CGFloat(deltaTime)
        
        // Update each layer at different speeds for parallax effect
        updateLayer(node1: skyNode1, node2: skyNode2, speed: scrollSpeed * 0.2, deltaTime: dt)
        updateLayer(node1: cityNode1, node2: cityNode2, speed: scrollSpeed * 0.5, deltaTime: dt)
        updateLayer(node1: groundNode1, node2: groundNode2, speed: scrollSpeed * 1.0, deltaTime: dt)
    }
    
    private func updateLayer(node1: SKNode, node2: SKNode, speed: CGFloat, deltaTime: CGFloat) {
        // Move both nodes left
        node1.position.x -= speed * deltaTime
        node2.position.x -= speed * deltaTime
        
        // When node1 is fully off-screen to the left, move it to the right of node2
        if node1.position.x <= -sceneSize.width / 2 {
            node1.position.x = node2.position.x + sceneSize.width
        }
        
        // When node2 is fully off-screen to the left, move it to the right of node1
        if node2.position.x <= -sceneSize.width / 2 {
            node2.position.x = node1.position.x + sceneSize.width
        }
    }
    
    // MARK: - Reset
    
    func reset() {
        // Reset positions to initial state
        skyNode1.position = CGPoint(x: sceneSize.width / 2, y: sceneSize.height / 2)
        skyNode2.position = CGPoint(x: sceneSize.width * 1.5, y: sceneSize.height / 2)
        
        cityNode1.position = CGPoint(x: sceneSize.width / 2, y: 0)
        cityNode2.position = CGPoint(x: sceneSize.width * 1.5, y: 0)
        
        let groundHeight: CGFloat = 70
        groundNode1.position = CGPoint(x: sceneSize.width / 2, y: groundHeight / 2)
        groundNode2.position = CGPoint(x: sceneSize.width * 1.5, y: groundHeight / 2)
        
        isScrolling = false
    }
}
