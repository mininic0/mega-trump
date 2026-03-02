# Trump Character Sprite Assets

## Required Sprite Files

All sprites should be designed with the following specifications:
- **Size**: 80x80 points at @3x resolution (240x240 pixels)
- **Format**: PNG with transparency
- **Design**: Cartoonish, recognizable, expressive
- **Head**: Circular design for easy hitbox alignment
- **Hair**: Exaggerated signature swoop
- **Features**: Simplified facial features

## Asset List

### Idle Animation (2 frames)
- **trump_idle_1.png** - Neutral expression, base frame
  - Slight smile
  - Eyes looking forward
  - Hair in signature swoop position
  
- **trump_idle_2.png** - Slight variation for bobbing animation
  - Same as idle_1 but with minor expression variation
  - Can have slightly different eye position or hair position

### Flap Animation (2 frames)
- **trump_flap_1.png** - Surprised expression
  - Wide eyes
  - Open mouth (O shape)
  - Hair slightly lifted/wiggled
  
- **trump_flap_2.png** - Hair wiggle frame
  - Same surprised expression
  - Hair in exaggerated wiggle position
  - Adds motion to the flap action

### Death State (1 frame)
- **trump_dead.png** - Shocked/sad expression
  - X eyes or closed eyes
  - Frown or shocked open mouth
  - Hair disheveled
  - Used when player hits obstacle

### Celebrate State (1 frame)
- **trump_celebrate.png** - Big grin/victory expression
  - Wide smile
  - Excited eyes
  - Hair perfectly swooped
  - Triggered on new high score

## Optional Assets

### Particle Effects
- **spark.png** - Small sparkle/star for celebrate particle effect
  - 16x16 pixels
  - White or yellow star/sparkle shape
  - Used in celebration animation

## Design Guidelines

### Color Palette
- **Skin**: Orange/tan (#F4A460 or similar)
- **Hair**: Bright yellow/gold (#FFD700)
- **Eyes**: Blue (#4169E1)
- **Suit** (if visible): Dark blue or red

### Hitbox Considerations
- The physics body is 85% of the visual size
- Keep important visual elements within the inner 85% circle
- Hair can extend beyond this for visual flair
- Ensure the face/head is centered in the sprite

## Current Status

**Placeholder Implementation**: The TrumpNode currently uses a programmatically generated placeholder:
- Orange circular head
- Yellow hair swoop on top
- Simple white eyes with black pupils
- This placeholder will be replaced when actual sprite assets are added

## Integration

Sprites should be added to:
```
FlappyDon/Resources/Assets.xcassets/Characters/
```

Each sprite needs its own `.imageset` folder with:
- The PNG file(s) (@1x, @2x, @3x)
- Contents.json file

The TrumpNode will automatically load these textures by name and fall back to the placeholder if not found.
