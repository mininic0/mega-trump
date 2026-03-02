# Flappy Don - Asset Checklist

Quick reference for tracking asset creation progress.

## Characters/ (6 sprites)
- [ ] `trump_idle_1@3x.png` - 240x240px - Neutral expression
- [ ] `trump_idle_2@3x.png` - 240x240px - Bobbing variation
- [ ] `trump_flap_1@3x.png` - 240x240px - Surprised, mouth open
- [ ] `trump_flap_2@3x.png` - 240x240px - Hair wiggle
- [ ] `trump_dead@3x.png` - 240x240px - Shocked/sad
- [ ] `trump_celebrate@3x.png` - 240x240px - Big grin

## Obstacles/ (2 sprites)
- [ ] `tower_top@3x.png` - 240-300px wide - Gold tower (top)
- [ ] `tower_bottom@3x.png` - 240-300px wide - Gold tower (bottom)

## Backgrounds/ (6 sprites)
- [ ] `sky_background@3x.png` - ~2000px wide - Sky blue gradient
- [ ] `cloud_1@3x.png` - 300-600px wide - White cloud variation 1
- [ ] `cloud_2@3x.png` - 300-600px wide - White cloud variation 2
- [ ] `cloud_3@3x.png` - 300-600px wide - White cloud variation 3
- [ ] `city_skyline@3x.png` - ~1500px wide - Navy blue silhouette
- [ ] `ground_texture@3x.png` - ~500px wide, 150-240px tall - Green grass

## UI/ (13 sprites)
- [ ] `logo@3x.png` - 600-900px wide - "FLAPPY DON" gold text
- [ ] `button_play@3x.png` - 600x180px - Red button
- [ ] `button_retry@3x.png` - 600x180px - Red button
- [ ] `button_share@3x.png` - 600x180px - Red button
- [ ] `button_menu@3x.png` - 600x180px - Red button
- [ ] `icon_sound_on@3x.png` - 120x120px - White speaker icon
- [ ] `icon_sound_off@3x.png` - 120x120px - White muted speaker
- [ ] `medal_bronze@3x.png` - 240x240px - Bronze medal
- [ ] `medal_silver@3x.png` - 240x240px - Silver medal
- [ ] `medal_gold@3x.png` - 240x240px - Gold medal
- [ ] `medal_platinum@3x.png` - 240x240px - Platinum medal
- [ ] `badge_new@3x.png` - 180x90px - "NEW!" badge
- [ ] `gameover_banner@3x.png` - Variable - "GAME OVER" text

## AppIcon.appiconset/ (9 sizes)
- [ ] `icon_20@2x.png` - 40x40px
- [ ] `icon_20@3x.png` - 60x60px
- [ ] `icon_29@2x.png` - 58x58px
- [ ] `icon_29@3x.png` - 87x87px
- [ ] `icon_40@2x.png` - 80x80px
- [ ] `icon_40@3x.png` - 120x120px
- [ ] `icon_60@2x.png` - 120x120px
- [ ] `icon_60@3x.png` - 180x180px
- [ ] `icon_1024.png` - 1024x1024px (App Store)

---

## Total Assets Required: 36 PNG files

## Color Palette Reference
- **Skin Tone**: #FFCC99
- **Hair**: #FFAA00
- **Gold/Brass**: #D4AF37
- **MAGA Red**: #E31C3D
- **Sky Blue**: #87CEEB
- **Navy Blue**: #002868
- **White**: #FFFFFF

## File Placement
Place each PNG file in its corresponding `.imageset` folder:
```
FlappyDon/Resources/Assets.xcassets/
├── Characters/trump_idle_1.imageset/trump_idle_1@3x.png
├── Obstacles/tower_top.imageset/tower_top@3x.png
├── Backgrounds/sky_background.imageset/sky_background@3x.png
├── UI/logo.imageset/logo@3x.png
└── AppIcon.appiconset/icon_1024.png
```

## Legal Requirements
- [ ] All assets are original cartoon artwork (no photos)
- [ ] Cartoonish, exaggerated, playful style
- [ ] Bold outlines, clear shapes
- [ ] Satirical but not mean-spirited
- [ ] Work-for-hire agreement if commissioning (you own rights)

## Next Steps
1. Choose asset creation method (see ASSETS.md)
2. Create or commission artwork
3. Place PNG files in .imageset folders
4. Update AppIcon Contents.json with filenames
5. Test in Xcode
6. Commit to repository
