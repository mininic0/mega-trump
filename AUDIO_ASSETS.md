# Audio Assets Documentation

## Overview
This document describes all audio files required for the FlappyDon game audio system.

## Audio File Requirements

### Sound Effects

#### 1. flap.wav
- **Description**: Soft "whoosh" sound for wing flap
- **Duration**: 0.1-0.2 seconds
- **Trigger**: Every tap when game is active
- **Characteristics**: 
  - Not annoying with rapid tapping
  - Soft, subtle whoosh
  - Quick attack and decay

#### 2. score.wav
- **Description**: Quick "ding" or "ping" sound for scoring
- **Duration**: ~0.2 seconds
- **Trigger**: When passing through pipe gap
- **Characteristics**:
  - Rewarding, positive tone
  - Subtle, not overwhelming
  - Clear, bright sound

#### 3. death.wav
- **Description**: Comedic "bonk" or "thud" sound
- **Duration**: 0.3-0.5 seconds
- **Trigger**: On collision with pipe or ground
- **Characteristics**:
  - Funny, not harsh
  - Cartoonish bonk sound
  - Clear impact sound

#### 4. highscore.wav
- **Description**: Triumphant short melody/jingle
- **Duration**: 1-2 seconds
- **Trigger**: Only on NEW high score achievement
- **Characteristics**:
  - Celebratory, triumphant tone
  - Short musical phrase
  - Rewarding and memorable

#### 5. button.wav
- **Description**: Soft click sound for UI feedback
- **Duration**: ~0.1 seconds
- **Trigger**: Any button press in menus
- **Characteristics**:
  - Responsive, immediate feedback
  - Soft, non-intrusive
  - Clean click sound

### Voice Lines

**Important**: Voice lines should use impersonator recordings or clearly synthetic parody voices to avoid legal issues. Do NOT use actual recordings of public figures.

#### Death Voice Lines (Random Selection)
- **wrong.wav** - "Wrong!"
- **sad.wav** - "Sad!"
- **fakenews.wav** - "Fake news!"
- **disaster.wav** - "Disaster!"

**Characteristics**:
- One randomly selected per death
- Short, punchy delivery
- Comedic timing
- Clear pronunciation

#### Milestone Voice Lines
- **tremendous.wav** - "Tremendous!" (Score 25)
- **huge.wav** - "This is huge!" (Score 50)
- **nobody.wav** - "Nobody plays better than me!" (Score 100)

**Characteristics**:
- Play once per game session when milestone reached
- Enthusiastic, celebratory delivery
- Clear, prominent audio
- Longer than death lines (1-2 seconds)

## Technical Specifications

### Format Requirements
- **File Format**: WAV (preferred) or MP3/AAC for compression
- **Sample Rate**: 44.1 kHz or 48 kHz
- **Bit Depth**: 16-bit minimum
- **Channels**: Mono (preferred for smaller file size) or Stereo
- **Compression**: Use AAC or MP3 for voice lines to reduce app size

### File Size Guidelines
- Sound effects: < 50 KB each
- Voice lines: < 200 KB each
- Total audio assets: < 2 MB

### Performance Considerations
- All files are preloaded at app launch
- Use `waitForCompletion: false` to prevent blocking
- Files should be optimized for mobile playback
- Avoid high-frequency content that may cause distortion on phone speakers

## Asset Location
Place all audio files in:
```
FlappyDon/Resources/Audio/
```

Create subdirectories if needed:
```
FlappyDon/Resources/Audio/SoundEffects/
FlappyDon/Resources/Audio/VoiceLines/
```

## Temporary Placeholders
During development, you can use:
1. System sounds (limited options)
2. Silence (empty audio files)
3. Text-to-speech generated placeholders
4. Royalty-free sound effects from:
   - freesound.org
   - zapsplat.com
   - soundbible.com

## Integration Checklist
- [ ] Create Audio directory in Resources
- [ ] Add all sound effect files
- [ ] Add all voice line files
- [ ] Add files to Xcode project
- [ ] Verify files are included in app bundle (Target Membership)
- [ ] Test audio playback on device
- [ ] Verify file sizes are optimized
- [ ] Test with sound enabled/disabled
- [ ] Test milestone voice lines trigger correctly
- [ ] Test random death voice line selection

## Legal Considerations
⚠️ **IMPORTANT**: 
- Do NOT use actual recordings of public figures
- Use impersonator recordings with proper licensing
- Use clearly synthetic/parody voices
- Ensure all audio is properly licensed for commercial use
- Consider trademark and right of publicity laws

## Future Enhancements (Post-V1)
- Background music (not in V1)
- Additional voice lines for variety
- Adjustable volume controls (separate for SFX and voice)
- Audio ducking (lower voice when SFX plays)
- Haptic feedback integration
