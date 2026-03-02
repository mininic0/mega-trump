# FlappyDon Audio Assets

This directory contains all audio assets for the FlappyDon game, including sound effects and voice lines.

## Directory Structure

```
Sounds/
├── SFX/                          # Sound effects (5 files)
│   ├── flap.m4a                  # Wing flap sound
│   ├── score.m4a                 # Score ding
│   ├── death.m4a                 # Death bonk
│   ├── highscore.m4a             # High score jingle
│   └── button.m4a                # Button click
│
├── Voice/                        # Voice lines (7 files)
│   ├── wrong.m4a                 # "Wrong!" (death reaction)
│   ├── sad.m4a                   # "Sad!" (death reaction)
│   ├── fakenews.m4a              # "Fake news!" (death reaction)
│   ├── disaster.m4a              # "Disaster!" (death reaction)
│   ├── tremendous.m4a            # "Tremendous!" (score 25)
│   ├── huge.m4a                  # "This is huge!" (score 50)
│   └── nobody.m4a                # "Nobody plays better than me!" (score 100)
│
├── README.md                     # This file
├── AUDIO_SPECIFICATIONS.md       # Detailed specs for each audio file
├── SOURCING_GUIDE.md             # How to create/source audio assets
├── ASSET_MANIFEST.md             # Track status of all audio files
└── AUDIO_SOURCES.md              # Document sources and licenses
```

## Quick Start

**If you're creating audio assets for the first time:**

1. **Read the specifications:**
   - Open `AUDIO_SPECIFICATIONS.md` for detailed requirements

2. **Choose your approach:**
   - Open `SOURCING_GUIDE.md` for step-by-step instructions
   - Recommended: Use free libraries + TTS for MVP

3. **Track your progress:**
   - Update `ASSET_MANIFEST.md` as you complete each file

4. **Document sources:**
   - Fill out `AUDIO_SOURCES.md` for legal compliance

5. **Place files in correct directories:**
   - Sound effects → `SFX/`
   - Voice lines → `Voice/`

## Required Assets

**Total:** 12 audio files

**Sound Effects (5):**
- ✅ flap.m4a - Wing flap/whoosh (0.1-0.2s)
- ✅ score.m4a - Score ding (0.2s)
- ✅ death.m4a - Comedic bonk (0.3-0.5s)
- ✅ highscore.m4a - Victory jingle (1-2s)
- ✅ button.m4a - UI click (0.1s)

**Voice Lines (7):**
- ✅ wrong.m4a - "Wrong!" (<1s)
- ✅ sad.m4a - "Sad!" (<1s)
- ✅ fakenews.m4a - "Fake news!" (<1.5s)
- ✅ disaster.m4a - "Disaster!" (<1.5s)
- ✅ tremendous.m4a - "Tremendous!" (<1.5s)
- ✅ huge.m4a - "This is huge!" (<1.5s)
- ✅ nobody.m4a - "Nobody plays better than me!" (<2s)

## Technical Requirements

**All audio files must meet these specs:**
- Format: AAC (.m4a) or MP3 (.mp3)
- Sample rate: 44.1 kHz
- Bit rate: 128-192 kbps
- Channels: Mono
- Peak level: -3dB to -6dB (no clipping)
- Fade in/out: 5-10ms

## Legal Requirements

**CRITICAL - Voice Lines:**
- Must use impersonator OR synthetic voice
- NOT actual Trump recordings
- Must be clearly parody/transformative use

**All Audio:**
- Original or properly licensed
- Commercial use allowed
- Attribution documented (if required)

## Recommended Workflow

**For MVP (3-5 hours, $0):**

1. **Sound Effects** - Use Freesound.org or Zapsplat
   - Search for each sound type
   - Download 2-3 options
   - Test and select best fit
   - Process in Audacity

2. **Voice Lines** - Use ElevenLabs TTS (free tier)
   - Create account
   - Generate each line
   - Download as MP3
   - Process in Audacity

3. **Processing** - Use Audacity (free)
   - Trim silence
   - Normalize to -3dB
   - Add fade in/out
   - Export as MP3/AAC

4. **Documentation**
   - Update ASSET_MANIFEST.md
   - Complete AUDIO_SOURCES.md
   - Verify quality checklist

## Documentation Files

### AUDIO_SPECIFICATIONS.md
Detailed specifications for each audio file including:
- Purpose and usage
- Duration requirements
- Tone and style
- Technical specs
- Reference sounds

### SOURCING_GUIDE.md
Step-by-step instructions for creating/sourcing audio:
- Three approaches (free, professional, DIY)
- Recommended tools and services
- Audio processing workflow
- Quality checklist
- Testing procedures

### ASSET_MANIFEST.md
Track the status of all audio assets:
- Status indicators (not started, in progress, complete)
- Source and license tracking
- Quality assurance checklist
- Sign-off section

### AUDIO_SOURCES.md
Legal compliance documentation:
- Source information for each file
- License details
- Attribution requirements
- Commercial use verification
- Parody confirmation for voice lines

## Integration (Ticket 07)

Once all audio assets are complete:

1. Verify all 12 files are present
2. Confirm all files meet technical specs
3. Complete AUDIO_SOURCES.md
4. Update ASSET_MANIFEST.md to 100%
5. Proceed to Ticket 07 for Xcode integration

**Note:** Audio files should be added to Xcode project (not asset catalog) with "Copy items if needed" checked.

## Quality Checklist

Before considering audio complete:

**Technical:**
- [ ] All files in correct format (AAC/MP3)
- [ ] All files at 44.1 kHz, mono, 128-192 kbps
- [ ] All files normalized and faded
- [ ] No clipping or distortion
- [ ] File sizes optimized

**Content:**
- [ ] All sounds match specifications
- [ ] Voice lines clear and understandable
- [ ] Volume levels balanced
- [ ] Durations meet requirements

**Legal:**
- [ ] All sources documented
- [ ] Commercial use verified
- [ ] Voice lines are parody
- [ ] Attribution prepared (if needed)

**Organization:**
- [ ] Files in correct directories
- [ ] Files named correctly
- [ ] Documentation complete
- [ ] Ready for Xcode integration

## Support

**Tools:**
- Audacity (free): https://www.audacityteam.org/
- ElevenLabs TTS: https://elevenlabs.io/
- Freesound: https://freesound.org/
- Zapsplat: https://www.zapsplat.com/

**Documentation:**
- See SOURCING_GUIDE.md for detailed instructions
- See AUDIO_SPECIFICATIONS.md for requirements
- See ASSET_MANIFEST.md for progress tracking

## Questions?

1. Check the documentation files in this directory
2. Review the game specification (Section 5: Audio Design)
3. Test audio in Audacity before finalizing
4. Document any issues in ASSET_MANIFEST.md

---

**Status:** Audio assets pending creation
**Next Step:** Follow SOURCING_GUIDE.md to create/source audio files
**Target:** Complete all 12 audio files before Ticket 07 (Implementation)
