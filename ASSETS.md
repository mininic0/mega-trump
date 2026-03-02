# Flappy Don - Asset Creation Guide

## Overview

This document provides comprehensive specifications for all visual assets required for the Flappy Don game. All assets must be **original cartoon artwork** to comply with parody guidelines and avoid copyright issues.

**CRITICAL**: This is a parody game. All artwork must be:
- Original cartoon artwork (no photos)
- Cartoonish, exaggerated, playful style
- Bold outlines, clear shapes
- Satirical but not mean-spirited

## Asset Catalog Structure

All assets are organized in `FlappyDon/Resources/Assets.xcassets/` with the following structure:

```
Assets.xcassets/
├── Characters/          # Trump character sprites
├── Obstacles/           # Tower obstacle sprites
├── Backgrounds/         # Sky, clouds, city, ground
├── UI/                  # Buttons, medals, icons, logo
└── AppIcon.appiconset/  # App icon (all sizes)
```

## Technical Specifications

### General Requirements
- **Format**: PNG with transparency (where appropriate)
- **Resolution**: @3x for all assets (iPhone X and later)
- **Color Space**: sRGB
- **Compression**: Optimize for size without quality loss
- **Naming**: lowercase, underscores, descriptive

### File Placement
Each asset has a dedicated `.imageset` folder with a `Contents.json` file. Place the PNG file in the imageset folder with the exact filename specified in Contents.json.

Example:
```
Characters/trump_idle_1.imageset/
├── Contents.json
└── trump_idle_1@3x.png  ← Place your artwork here
```

---

## 1. Character Sprites (Characters/)

### Trump Character Design Requirements
- **Size**: 80x80 points @3x = 240x240px
- **Shape**: Circular head (easy hitbox)
- **Style**: Simplified, cartoonish, exaggerated
- **Skin Tone**: #FFCC99
- **Hair Color**: #FFAA00 (exaggerated orange swoop)
- **Features**: Dots for eyes, simple mouth shapes
- **Silhouette**: Must be recognizable

### Required Sprites

#### 1.1 trump_idle_1.imageset
- **File**: `trump_idle_1@3x.png` (240x240px)
- **Description**: Neutral expression, slight smile
- **Usage**: Default idle state, bobbing animation frame 1
- **Details**: Relaxed expression, hair in signature swoop

#### 1.2 trump_idle_2.imageset
- **File**: `trump_idle_2@3x.png` (240x240px)
- **Description**: Variation for bobbing animation
- **Usage**: Bobbing animation frame 2
- **Details**: Slightly different position/expression for subtle animation

#### 1.3 trump_flap_1.imageset
- **File**: `trump_flap_1@3x.png` (240x240px)
- **Description**: Surprised expression, mouth open
- **Usage**: Flapping/jumping animation frame 1
- **Details**: Eyes wide, mouth in "O" shape, hair slightly lifted

#### 1.4 trump_flap_2.imageset
- **File**: `trump_flap_2@3x.png` (240x240px)
- **Description**: Hair wiggle frame
- **Usage**: Flapping/jumping animation frame 2
- **Details**: Hair bouncing/wiggling from movement

#### 1.5 trump_dead.imageset
- **File**: `trump_dead@3x.png` (240x240px)
- **Description**: Shocked/sad expression
- **Usage**: Game over state
- **Details**: X eyes or spiral eyes, frown, disheveled hair

#### 1.6 trump_celebrate.imageset
- **File**: `trump_celebrate@3x.png` (240x240px)
- **Description**: Big grin, triumphant
- **Usage**: High score celebration
- **Details**: Wide smile, confident expression

---

## 2. Obstacle Sprites (Obstacles/)

### Tower Design Requirements
- **Color**: Gold/brass #D4AF37
- **Style**: Art deco styling (vertical lines, geometric)
- **Shape**: Vertical rectangular columns
- **Width**: 80-100 points (240-300px @3x)
- **Tiling**: Should stretch vertically without distortion
- **Depth**: Slight shadow/gradient for 3D effect

### Required Sprites

#### 2.1 tower_top.imageset
- **File**: `tower_top@3x.png` (240-300px wide, variable height)
- **Description**: Gold tower hanging from top of screen
- **Usage**: Upper obstacle
- **Details**: 
  - Cap/top edge at the top
  - Vertical lines/patterns that can tile
  - Slight shadow on right side
  - Art deco geometric patterns

#### 2.2 tower_bottom.imageset
- **File**: `tower_bottom@3x.png` (240-300px wide, variable height)
- **Description**: Gold tower rising from bottom of screen
- **Usage**: Lower obstacle
- **Details**:
  - Base/foundation at the bottom
  - Matches tower_top style
  - Same width and pattern style
  - Can be stretched vertically

---

## 3. Background Layers (Backgrounds/)

### Background Design Requirements
- **Tiling**: All backgrounds must tile seamlessly horizontally
- **Parallax**: Designed for parallax scrolling (different speeds)
- **Style**: Simple, not distracting from gameplay

### Required Backgrounds

#### 3.1 sky_background.imageset
- **File**: `sky_background@3x.png` (full screen width, ~2000px wide)
- **Description**: Blue sky gradient
- **Color**: #87CEEB (Sky Blue)
- **Usage**: Static or slow-scrolling background
- **Details**: 
  - Simple gradient from lighter blue at top to slightly darker at bottom
  - Optional: Can use solid color instead (programmatic)
  - Must tile seamlessly

#### 3.2 cloud_1.imageset
- **File**: `cloud_1@3x.png` (variable size, ~300-600px wide)
- **Description**: Fluffy white cloud variation 1
- **Color**: White (#FFFFFF)
- **Usage**: Parallax scrolling decoration
- **Details**: Simple, cartoonish cloud shape

#### 3.3 cloud_2.imageset
- **File**: `cloud_2@3x.png` (variable size, ~300-600px wide)
- **Description**: Fluffy white cloud variation 2
- **Color**: White (#FFFFFF)
- **Usage**: Parallax scrolling decoration
- **Details**: Different shape from cloud_1

#### 3.4 cloud_3.imageset
- **File**: `cloud_3@3x.png` (variable size, ~300-600px wide)
- **Description**: Fluffy white cloud variation 3
- **Color**: White (#FFFFFF)
- **Usage**: Parallax scrolling decoration
- **Details**: Different shape from cloud_1 and cloud_2

#### 3.5 city_skyline.imageset
- **File**: `city_skyline@3x.png` (tileable, ~1500px wide)
- **Description**: Silhouette of city buildings
- **Color**: #002868 (Navy Blue) silhouette
- **Usage**: Mid-ground parallax layer
- **Details**:
  - Simple building silhouettes
  - Various heights for visual interest
  - Must tile seamlessly at edges
  - Recognizable as NYC-style skyline

#### 3.6 ground_texture.imageset
- **File**: `ground_texture@3x.png` (tileable, ~500px wide, 150-240px tall)
- **Description**: Grass/ground pattern
- **Color**: Green grass texture
- **Height**: 50-80 points (150-240px @3x)
- **Usage**: Scrolling ground at bottom of screen
- **Details**:
  - Simple grass texture or pattern
  - Must tile seamlessly horizontally
  - Slight texture/variation for visual interest

---

## 4. UI Elements (UI/)

### 4.1 Logo

#### logo.imageset
- **File**: `logo@3x.png` (variable size, ~600-900px wide)
- **Description**: "FLAPPY DON" stylized text logo
- **Color**: Bold gold letters #D4AF37
- **Usage**: Title screen
- **Details**:
  - Bold, clear, readable font
  - Slight shadow or outline for depth
  - Patriotic/bold aesthetic
  - Transparent background

### 4.2 Buttons

All buttons should have consistent styling:
- **Background Color**: Red #E31C3D (MAGA Red)
- **Shape**: Rounded rectangle
- **Size**: ~200x60 points (600x180px @3x)
- **Style**: Slight gradient or shadow for depth
- **Text**: White text can be added programmatically (optional to include in asset)

#### button_play.imageset
- **File**: `button_play@3x.png` (600x180px)
- **Description**: Play button background
- **Usage**: Start game button

#### button_retry.imageset
- **File**: `button_retry@3x.png` (600x180px)
- **Description**: Retry button background
- **Usage**: Game over screen retry

#### button_share.imageset
- **File**: `button_share@3x.png` (600x180px)
- **Description**: Share button background
- **Usage**: Share score button

#### button_menu.imageset
- **File**: `button_menu@3x.png` (600x180px)
- **Description**: Menu button background
- **Usage**: Return to menu button

### 4.3 Icons

#### icon_sound_on.imageset
- **File**: `icon_sound_on@3x.png` (120x120px)
- **Description**: Speaker icon (sound enabled)
- **Color**: White
- **Size**: 40x40 points (120x120px @3x)
- **Usage**: Sound toggle button
- **Details**: Simple speaker icon, recognizable at small size

#### icon_sound_off.imageset
- **File**: `icon_sound_off@3x.png` (120x120px)
- **Description**: Muted speaker icon (sound disabled)
- **Color**: White
- **Size**: 40x40 points (120x120px @3x)
- **Usage**: Sound toggle button (muted state)
- **Details**: Speaker with X or slash through it

### 4.4 Medals

All medals should have consistent styling:
- **Shape**: Circular medal with ribbon
- **Size**: 80x80 points (240x240px @3x)
- **Style**: Metallic appearance with star or number in center

#### medal_bronze.imageset
- **File**: `medal_bronze@3x.png` (240x240px)
- **Description**: Bronze medal
- **Color**: Bronze/copper tones
- **Usage**: Score milestone reward

#### medal_silver.imageset
- **File**: `medal_silver@3x.png` (240x240px)
- **Description**: Silver medal
- **Color**: Silver/gray metallic
- **Usage**: Score milestone reward

#### medal_gold.imageset
- **File**: `medal_gold@3x.png` (240x240px)
- **Description**: Gold medal
- **Color**: Gold/yellow metallic
- **Usage**: Score milestone reward

#### medal_platinum.imageset
- **File**: `medal_platinum@3x.png` (240x240px)
- **Description**: Platinum medal
- **Color**: Platinum/white metallic
- **Usage**: Highest score milestone reward

### 4.5 Badges

#### badge_new.imageset
- **File**: `badge_new@3x.png` (180x90px)
- **Description**: "NEW!" badge for high score
- **Color**: Bright red or gold
- **Size**: 60x30 points (180x90px @3x)
- **Usage**: Highlight new high score
- **Details**: "NEW!" text integrated, attention-grabbing

### 4.6 Game Over

#### gameover_banner.imageset
- **File**: `gameover_banner@3x.png` (variable size)
- **Description**: "GAME OVER" text/banner
- **Color**: Red or gold
- **Usage**: Game over screen (optional - can use SKLabelNode instead)
- **Details**: Bold, dramatic text, transparent background

---

## 5. App Icon (AppIcon.appiconset/)

### App Icon Requirements

The app icon is the most important visual asset for the App Store and device home screen.

**Design Requirements**:
- **Subject**: Trump character head (recognizable)
- **Background**: Gold (#D4AF37) or sky blue (#87CEEB)
- **Style**: Simple, clear at small sizes
- **Text**: NO text (iOS guidelines recommend no text in icons)
- **Shape**: Square with rounded corners (iOS applies automatically)

### Required Sizes

The AppIcon.appiconset already has Contents.json configured for all required sizes. You need to provide PNG files for:

| Size (points) | Scale | Actual Size (px) | Filename | Usage |
|---------------|-------|------------------|----------|-------|
| 20x20 | @2x | 40x40 | icon_20@2x.png | iPhone Notification |
| 20x20 | @3x | 60x60 | icon_20@3x.png | iPhone Notification |
| 29x29 | @2x | 58x58 | icon_29@2x.png | iPhone Settings |
| 29x29 | @3x | 87x87 | icon_29@3x.png | iPhone Settings |
| 40x40 | @2x | 80x80 | icon_40@2x.png | iPhone Spotlight |
| 40x40 | @3x | 120x120 | icon_40@3x.png | iPhone Spotlight |
| 60x60 | @2x | 120x120 | icon_60@2x.png | iPhone App (older) |
| 60x60 | @3x | 180x180 | icon_60@3x.png | iPhone App |
| 1024x1024 | @1x | 1024x1024 | icon_1024.png | App Store |

**Note**: The Contents.json file in AppIcon.appiconset needs to be updated with these filenames. Currently it's configured but missing the filename references.

---

## Asset Creation Options

### Option A: Commission Professional Artist (RECOMMENDED)
**Pros**:
- Highest quality, consistent style
- Professional cartoon artwork
- Full ownership with work-for-hire agreement

**Cons**:
- Cost: $500-2000 depending on quality and artist

**Process**:
1. Find illustrator/designer (Fiverr, Upwork, Dribbble)
2. Provide this specification document
3. Request work-for-hire agreement (you own all rights)
4. Review drafts and provide feedback
5. Receive final assets in specified formats

### Option B: Create In-House
**Pros**:
- Full creative control
- No additional cost (if you have skills/tools)
- Iterate quickly

**Cons**:
- Requires graphic design skills
- Time-intensive
- Need proper tools

**Tools**:
- **iPad**: Procreate ($12.99, excellent for cartoon art)
- **Desktop**: Adobe Illustrator, Affinity Designer, Figma
- **Free**: Inkscape, GIMP, Krita

### Option C: Asset Marketplace
**Pros**:
- Quick acquisition
- Professional quality
- Lower cost than commission

**Cons**:
- May not match exact specifications
- Requires customization
- Trump character will need to be custom (not available)

**Sources**:
- GraphicRiver
- Creative Market
- Envato Elements

**Note**: You'll still need custom Trump character artwork.

### Option D: AI Generation + Manual Editing
**Pros**:
- Fast initial concepts
- Good starting point
- Lower cost

**Cons**:
- Requires manual editing/refinement
- Consistency can be challenging
- May need multiple iterations

**Tools**:
- Midjourney (best for cartoon styles)
- DALL-E 3
- Stable Diffusion

**Process**:
1. Generate initial concepts with AI
2. Import into Illustrator/Photoshop
3. Manually refine and ensure consistency
4. Verify no copyright issues (AI-generated art is original)

**Example Prompts**:
```
"Cartoon character head, circular shape, exaggerated orange hair swoop, 
simplified features, dots for eyes, playful expression, bold outlines, 
flat colors, parody style, transparent background"

"Art deco gold tower, vertical geometric patterns, brass color, 
cartoon style, simple shapes, game asset"
```

---

## Legal Compliance Checklist

Per specification Section 10.3, ensure:

- [ ] All assets are original cartoon artwork (no photos)
- [ ] No actual photos of Trump or any real person
- [ ] Clearly parody/satire style (exaggerated, cartoonish)
- [ ] Work-for-hire agreement if commissioning artist
- [ ] Original or properly licensed audio (separate from this document)
- [ ] Parody disclaimer included in app (handled in app code)

---

## Asset Delivery Checklist

When assets are ready:

- [ ] All PNG files at @3x resolution (240px for 80pt assets)
- [ ] Files named exactly as specified in Contents.json files
- [ ] Transparent backgrounds where appropriate
- [ ] Optimized file sizes (use ImageOptim or similar)
- [ ] Consistent style across all assets
- [ ] Source files provided (AI, PSD, etc.) for future edits
- [ ] All assets placed in correct .imageset folders

---

## Testing Assets

After adding assets to the project:

1. **Import Check**: Open Xcode, verify all assets appear in asset catalog
2. **Size Check**: Verify assets display at correct sizes in game
3. **Performance Check**: Monitor frame rate, ensure no performance issues
4. **Visual Check**: Test on actual device, verify clarity and appearance
5. **Consistency Check**: Ensure all assets have cohesive style

---

## Placeholder Strategy (Development)

During development, you can use placeholder assets:

1. **Colored Rectangles**: Use solid colors for backgrounds/obstacles
2. **Text Labels**: Use SKLabelNode for temporary UI elements
3. **Simple Shapes**: Use SKShapeNode for character (circle)

**Document which placeholders need replacement** before release.

---

## Next Steps

1. **Choose Asset Creation Method**: Select Option A, B, C, or D above
2. **Create/Source Assets**: Follow specifications in this document
3. **Place Assets**: Add PNG files to appropriate .imageset folders
4. **Update AppIcon Contents.json**: Add filename references for all icon sizes
5. **Test in Xcode**: Verify all assets load correctly
6. **Commit to Repository**: Add assets to version control

---

## Questions or Issues?

If you encounter any issues or need clarification on specifications:

1. Review iOS Human Interface Guidelines for App Icons
2. Check SpriteKit documentation for texture requirements
3. Test assets in-game early to catch sizing issues
4. Iterate based on actual gameplay appearance

---

**Document Version**: 1.0  
**Last Updated**: 2024  
**Project**: Flappy Don iOS Game
