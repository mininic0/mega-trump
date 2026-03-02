# Audio Asset Specifications for FlappyDon

This document provides detailed specifications for all audio assets required for the FlappyDon game.

## Technical Specifications

**All Audio Files:**
- Format: AAC (.m4a) or MP3 (.mp3)
- Sample rate: 44.1 kHz
- Bit rate: 128-192 kbps
- Channels: Mono
- Normalization: -3dB to -6dB peak (prevent clipping)
- Fade in/out: Brief fades (5-10ms) to prevent clicks
- File naming: Lowercase, no spaces, descriptive

## Sound Effects (SFX/)

### 1. flap.m4a (or .mp3)
**Purpose:** Plays on every tap/flap action
**Type:** Soft "whoosh" or wing flap sound
**Duration:** 0.1-0.2 seconds
**Tone:** Satisfying, not annoying
**Volume:** Medium
**Requirements:**
- Must work well with rapid repetition (player taps frequently)
- Not harsh or grating
- Clear but subtle
- Should feel responsive and satisfying

**Reference sounds:** Soft whoosh, fabric flap, gentle wing beat

---

### 2. score.m4a (or .mp3)
**Purpose:** Plays when passing through gap (scoring a point)
**Type:** Quick "ding" or "ping"
**Duration:** ~0.2 seconds
**Tone:** Rewarding, positive
**Volume:** Medium-high
**Requirements:**
- Celebratory feeling
- Clear and distinct from other sounds
- Not too loud or jarring
- Should feel like an achievement

**Reference sounds:** Bell ding, chime, positive notification sound

---

### 3. death.m4a (or .mp3)
**Purpose:** Plays on collision with obstacle or ground
**Type:** Comedic "bonk" or "thud"
**Duration:** 0.3-0.5 seconds
**Tone:** Funny, cartoonish
**Volume:** Medium-high
**Requirements:**
- Comedic, not harsh or unpleasant
- Clear indication of failure
- Fits satirical/parody tone of game
- Should make player smile even when losing

**Reference sounds:** Cartoon bonk, comedic thud, "doink" sound

---

### 4. highscore.m4a (or .mp3)
**Purpose:** Plays only when achieving a NEW high score
**Type:** Triumphant short melody or jingle
**Duration:** 1-2 seconds
**Tone:** Celebratory, victorious
**Volume:** High
**Requirements:**
- Exciting and rewarding
- Memorable
- Optional: Patriotic feel (fits Trump theme)
- Should feel like a major achievement

**Reference sounds:** Victory fanfare, triumphant jingle, achievement unlock sound

---

### 5. button.m4a (or .mp3)
**Purpose:** Plays on UI button taps
**Type:** Soft click or tap
**Duration:** ~0.1 seconds
**Tone:** Responsive, neutral
**Volume:** Low-medium
**Requirements:**
- Standard UI feedback
- Not distracting
- Immediate response feel
- Subtle and professional

**Reference sounds:** UI click, soft tap, button press

---

## Voice Lines (Voice/)

**CRITICAL LEGAL REQUIREMENT:**
- Must use impersonator OR clearly synthetic parody voice
- NOT actual recordings of Donald Trump
- Must be clearly parody (transformative use)
- Short clips (under 2 seconds)
- Clear and understandable

### Death Reactions (Random selection on collision)

#### 1. wrong.m4a (or .mp3)
**Text:** "Wrong!"
**Duration:** < 1 second
**Tone:** Dismissive, emphatic
**Delivery:** Sharp, definitive
**Usage:** Random death reaction

---

#### 2. sad.m4a (or .mp3)
**Text:** "Sad!"
**Duration:** < 1 second
**Tone:** Disappointed, dramatic
**Delivery:** Exaggerated disappointment
**Usage:** Random death reaction

---

#### 3. fakenews.m4a (or .mp3)
**Text:** "Fake news!"
**Duration:** < 1.5 seconds
**Tone:** Accusatory, signature phrase
**Delivery:** Emphatic, recognizable
**Usage:** Random death reaction

---

#### 4. disaster.m4a (or .mp3)
**Text:** "Disaster!"
**Duration:** < 1.5 seconds
**Tone:** Dramatic, exaggerated
**Delivery:** Over-the-top dramatic
**Usage:** Random death reaction

---

### Milestone Celebrations (Triggered at specific scores)

#### 5. tremendous.m4a (or .mp3)
**Text:** "Tremendous!"
**Duration:** < 1.5 seconds
**Tone:** Enthusiastic, positive
**Delivery:** Excited, boastful
**Trigger:** Score reaches 25

---

#### 6. huge.m4a (or .mp3)
**Text:** "This is huge!"
**Duration:** < 1.5 seconds
**Tone:** Excited, emphatic
**Delivery:** Enthusiastic, emphasizing "huge"
**Trigger:** Score reaches 50

---

#### 7. nobody.m4a (or .mp3)
**Text:** "Nobody plays better than me!"
**Duration:** < 2 seconds
**Tone:** Boastful, confident
**Delivery:** Self-congratulatory, signature style
**Trigger:** Score reaches 100

---

## Audio Processing Checklist

For each audio file:
- [ ] Trim silence from start and end
- [ ] Normalize volume to -3dB to -6dB peak
- [ ] Add brief fade in (5-10ms)
- [ ] Add brief fade out (5-10ms)
- [ ] Apply compression/limiting to prevent clipping
- [ ] Export in AAC (.m4a) or MP3 (.mp3) format
- [ ] Verify file size is reasonable (< 100KB for most)
- [ ] Test playback quality
- [ ] Verify duration meets requirements

## Quality Assurance

Before finalizing audio:
1. Listen to all files in sequence
2. Check volume balance between files
3. Verify no clipping or distortion
4. Test rapid playback (especially flap sound)
5. Ensure voice lines are clear and understandable
6. Confirm all files meet duration requirements
7. Verify file naming matches specification
8. Check file sizes are optimized

## Legal Compliance

- [ ] All audio is original or properly licensed
- [ ] Voice lines use impersonator or synthetic voice (not actual Trump)
- [ ] All licenses allow commercial use
- [ ] Attribution documented (if required)
- [ ] Voice lines are clearly parody/transformative use
