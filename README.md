# Flappy Don

A satirical mobile game for iOS built with SpriteKit. Navigate through obstacles in this parody game inspired by the classic Flappy Bird mechanics.

## ⚠️ Legal Disclaimer

This is a parody game created for entertainment purposes only. It is not affiliated with, endorsed by, or connected to any real persons, political figures, or entities. All content is satirical in nature and protected under fair use.

## 🎮 Project Description

Flappy Don is a 2D side-scrolling game built using Apple's SpriteKit framework. The game features:
- Physics-based gameplay with gravity simulation
- Portrait-only orientation optimized for mobile
- 60 FPS target for smooth gameplay
- Organized asset management system
- Modular code architecture for easy expansion

## 🏗️ Project Structure

```
FlappyDon/
├── FlappyDon.xcodeproj/     # Xcode project file
└── FlappyDon/               # Source code
    ├── Scenes/              # SpriteKit scene files
    │   ├── GameScene.swift
    │   └── GameScene.sks
    ├── Nodes/               # Custom sprite nodes (Trump, obstacles, etc.)
    ├── Managers/            # Game managers (audio, score, etc.)
    ├── UI/                  # UI view controllers
    │   ├── GameViewController.swift
    │   ├── Main.storyboard
    │   └── LaunchScreen.storyboard
    ├── Resources/           # Asset catalogs, sounds, etc.
    │   └── Assets.xcassets/
    │       ├── Characters/  # Trump sprites
    │       ├── Obstacles/   # Tower sprites
    │       ├── Backgrounds/ # Sky, city, ground layers
    │       ├── UI/          # Buttons, medals, icons
    │       └── AppIcon.appiconset/
    ├── Utils/               # Helper classes and extensions
    ├── Models/              # Data models
    ├── AppDelegate.swift
    ├── SceneDelegate.swift
    └── Info.plist
```

## 🛠️ Build Instructions

### Requirements
- Xcode 14.0 or later
- iOS 14.0+ deployment target
- macOS for development

### Steps
1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd mini-trump
   ```

2. Open the project in Xcode:
   ```bash
   open FlappyDon.xcodeproj
   ```

3. Select your target device or simulator

4. Build and run (⌘R)

### Configuration
- **Bundle Identifier**: `com.flappydon.game`
- **Deployment Target**: iOS 14.0
- **Supported Orientations**: Portrait only
- **Status Bar**: Hidden during gameplay
- **Frame Rate**: 60 FPS

## 📋 Asset Requirements Checklist

Before the game is fully functional, the following assets need to be created and added to the asset catalog:

### Characters/
- [ ] Trump character sprite (idle)
- [ ] Trump character sprite (flapping)
- [ ] Trump character sprite (falling)

### Obstacles/
- [ ] Tower sprite (top)
- [ ] Tower sprite (bottom)
- [ ] Tower sprite (middle section - repeatable)

### Backgrounds/
- [ ] Sky background layer
- [ ] City skyline layer
- [ ] Ground layer (repeating)

### UI/
- [ ] Start button
- [ ] Restart button
- [ ] Medal icons (bronze, silver, gold)
- [ ] Score display background
- [ ] Game over panel

### AppIcon.appiconset/
- [ ] App icon (all required sizes)

## 🎯 Technical Details

### SpriteKit Configuration
- **Scene Scale Mode**: `.aspectFill`
- **Physics Gravity**: `CGVector(dx: 0, dy: -5.0)`
- **Metal Rendering**: Enabled for optimal performance

### Game Features (Planned)
- Tap-to-flap mechanics
- Procedurally generated obstacles
- Score tracking and high score system
- Sound effects and background music
- Game Center integration (future)

## 🚀 Development Roadmap

1. ✅ Project initialization and structure
2. ⬜ Character implementation
3. ⬜ Obstacle generation system
4. ⬜ Collision detection
5. ⬜ Score system
6. ⬜ UI/UX polish
7. ⬜ Sound effects and music
8. ⬜ Game Center integration

## 📝 License

This project is for educational and entertainment purposes only. See legal disclaimer above.

## 🤝 Contributing

This is a parody project. Contributions should maintain the satirical and humorous nature while respecting all applicable laws and guidelines.
