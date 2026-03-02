# Audio Asset Sourcing Guide

This guide provides practical instructions for creating or sourcing all audio assets for FlappyDon.

## Quick Start

**Total Assets Needed:** 12 audio files
- 5 sound effects (SFX/)
- 7 voice lines (Voice/)

**Estimated Time:** 4-8 hours (depending on method)
**Estimated Budget:** $0-500 (depending on method)

---

## Option 1: Free/Low-Cost Approach (Recommended for MVP)

### Sound Effects - Use Royalty-Free Libraries

**Best Free Sources:**

1. **Freesound.org** (Creative Commons)
   - URL: https://freesound.org
   - Account: Free registration required
   - License: Check each sound (CC0, CC-BY, etc.)
   - Search tips:
     - "whoosh" or "wing flap" for flap.m4a
     - "ding" or "bell" for score.m4a
     - "bonk" or "cartoon hit" for death.m4a
     - "fanfare" or "victory" for highscore.m4a
     - "click" or "button" for button.m4a

2. **Zapsplat.com** (Free with attribution)
   - URL: https://www.zapsplat.com
   - Account: Free registration required
   - License: Free with attribution in app credits
   - Categories: Game sounds, UI sounds, cartoon sounds

3. **Mixkit.co** (Free, no attribution)
   - URL: https://mixkit.co/free-sound-effects/
   - No account needed
   - License: Free for commercial use
   - Good for: UI sounds, game effects

**Workflow:**
1. Search for each sound effect by type
2. Download 2-3 options for each
3. Test in game context
4. Select best fit
5. Document source and license
6. Edit/process as needed (see Processing section)

### Voice Lines - Text-to-Speech (Synthetic Voice)

**Recommended TTS Services:**

1. **ElevenLabs** (Best quality)
   - URL: https://elevenlabs.io
   - Free tier: 10,000 characters/month
   - Cost: $5/month for more
   - Process:
     - Create account
     - Select voice (try "Adam" or "Antoni")
     - Adjust settings for emphasis
     - Generate each line
     - Download as MP3

2. **Play.ht**
   - URL: https://play.ht
   - Free tier: 2,500 words
   - Good voice variety
   - Easy to use

3. **Google Cloud Text-to-Speech**
   - URL: https://cloud.google.com/text-to-speech
   - Free tier: 1M characters/month
   - WaveNet voices sound natural
   - Requires Google Cloud account

**Voice Line Scripts:**
```
Wrong!
Sad!
Fake news!
Disaster!
Tremendous!
This is huge!
Nobody plays better than me!
```

**TTS Tips:**
- Use emphasis tags if available: `<emphasis level="strong">Wrong!</emphasis>`
- Adjust speech rate slightly slower for clarity
- Try different voices to find best match
- Add slight pitch adjustment if available
- Generate multiple takes and pick best

---

## Option 2: Professional Approach (Best Quality)

### Sound Effects - Commission Sound Designer

**Where to Find:**
- Fiverr.com - Search "game sound effects"
- Upwork.com - Post job for sound designer
- Reddit r/gameDevClassifieds

**Budget:** $100-300 for full SFX package
**Deliverables:** Custom sounds matching exact specifications
**Timeline:** 3-7 days

**Job Posting Template:**
```
Title: 5 Custom Sound Effects for Mobile Game

Description:
Need 5 custom sound effects for a mobile game (Flappy Bird style):
1. Flap/whoosh sound (0.1-0.2s)
2. Score ding (0.2s)
3. Comedic death bonk (0.3-0.5s)
4. Victory jingle (1-2s)
5. UI button click (0.1s)

Requirements:
- Delivered as AAC or MP3
- 44.1kHz, mono, 128-192kbps
- Normalized and processed
- Full commercial rights

Budget: $100-300
Timeline: 5 days
```

### Voice Lines - Hire Impersonator

**Where to Find:**
- Fiverr.com - Search "Trump impersonator" or "political voice"
- Voices.com - Professional voice actors
- Voice123.com - Voice talent marketplace

**Budget:** $50-200 for 7 short lines
**Deliverables:** 7 voice lines as specified
**Timeline:** 2-5 days

**CRITICAL:** Ensure work-for-hire agreement and confirm voice is clearly parody/impersonation

**Job Posting Template:**
```
Title: Trump Impersonator for Mobile Game (Parody)

Description:
Need 7 short voice lines in Trump impersonation style for satirical mobile game.
This is clearly parody/transformative use.

Lines needed:
1. "Wrong!" (< 1s)
2. "Sad!" (< 1s)
3. "Fake news!" (< 1.5s)
4. "Disaster!" (< 1.5s)
5. "Tremendous!" (< 1.5s)
6. "This is huge!" (< 1.5s)
7. "Nobody plays better than me!" (< 2s)

Requirements:
- Clear impersonation/parody (not actual Trump recordings)
- Delivered as AAC or MP3
- 44.1kHz, mono, 128-192kbps
- Full commercial rights
- Work-for-hire agreement

Budget: $50-200
Timeline: 3-5 days
```

---

## Option 3: DIY Approach (Free but Time-Intensive)

### Sound Effects - Create Your Own

**Tools Needed:**
- Audacity (free) - https://www.audacityteam.org/
- Microphone (built-in or USB mic)
- Household items for sound effects

**DIY Sound Ideas:**
1. **Flap:** Record fabric flapping, paper whoosh
2. **Score:** Record glass ding, spoon on glass
3. **Death:** Record pillow punch, rubber ball bounce
4. **Highscore:** Use Audacity tone generator for simple melody
5. **Button:** Record soft click, pen click

**Audacity Tutorial:**
1. Record sound
2. Trim silence (Effect > Truncate Silence)
3. Normalize (Effect > Normalize to -3dB)
4. Fade in/out (Effect > Fade In/Out)
5. Export as MP3 (File > Export > Export as MP3)

### Voice Lines - Record Yourself

**Requirements:**
- Decent microphone
- Quiet room
- Willingness to do exaggerated impersonation

**Tips:**
- Practice each line several times
- Record multiple takes
- Exaggerate the style (it's parody!)
- Speak clearly and with emphasis
- Don't worry about perfect accuracy - parody is the goal

**Recording Setup:**
1. Use Audacity or Voice Memos app
2. Position mic 6-12 inches from mouth
3. Record in quiet room
4. Do 3-5 takes of each line
5. Select best take
6. Process in Audacity (normalize, trim, fade)

---

## Audio Processing Workflow

**Required Software:**
- Audacity (free) - https://www.audacityteam.org/
- OR GarageBand (Mac, free)
- OR any audio editor

**Step-by-Step Processing:**

1. **Import audio file**
   - File > Open or drag into Audacity

2. **Trim silence**
   - Select silent portions at start/end
   - Delete or use Effect > Truncate Silence

3. **Normalize volume**
   - Select all (Ctrl/Cmd + A)
   - Effect > Normalize
   - Set to -3dB peak amplitude
   - Check "Normalize stereo channels independently"

4. **Convert to mono** (if stereo)
   - Tracks > Mix > Mix Stereo Down to Mono

5. **Add fade in**
   - Select first 0.01 seconds
   - Effect > Fade In

6. **Add fade out**
   - Select last 0.01 seconds
   - Effect > Fade Out

7. **Apply compression** (optional, for consistent volume)
   - Effect > Compressor
   - Use default settings or "Make-up gain for 0dB"

8. **Export**
   - File > Export > Export as MP3
   - Quality: 192 kbps
   - Channel: Mono
   - Sample rate: 44100 Hz

9. **Verify**
   - Check file size (should be < 100KB for most)
   - Listen for quality
   - Check duration matches spec

---

## File Naming and Organization

**Sound Effects (SFX/):**
```
flap.m4a (or .mp3)
score.m4a
death.m4a
highscore.m4a
button.m4a
```

**Voice Lines (Voice/):**
```
wrong.m4a (or .mp3)
sad.m4a
fakenews.m4a
disaster.m4a
tremendous.m4a
huge.m4a
nobody.m4a
```

**Naming Rules:**
- All lowercase
- No spaces
- Use underscores if needed (but avoid)
- Include file extension
- Match specification exactly

---

## Quality Checklist

Before considering audio complete:

**Technical Quality:**
- [ ] All files in AAC (.m4a) or MP3 (.mp3) format
- [ ] Sample rate: 44.1 kHz
- [ ] Bit rate: 128-192 kbps
- [ ] Channels: Mono
- [ ] Peak levels: -3dB to -6dB (no clipping)
- [ ] Fade in/out applied (5-10ms)
- [ ] File sizes optimized (< 100KB for most)

**Content Quality:**
- [ ] Flap sound works well with rapid repetition
- [ ] Score sound feels rewarding
- [ ] Death sound is comedic, not harsh
- [ ] High score jingle is celebratory
- [ ] Button click is subtle
- [ ] All voice lines are clear and understandable
- [ ] Voice lines match character/tone
- [ ] Durations meet specifications

**Legal Compliance:**
- [ ] All audio is original or properly licensed
- [ ] Licenses allow commercial use
- [ ] Voice lines are clearly parody (not actual Trump)
- [ ] Attribution documented (if required)
- [ ] Sources documented in AUDIO_SOURCES.md

**Integration Ready:**
- [ ] Files named correctly
- [ ] Files in correct directories (SFX/ or Voice/)
- [ ] All 12 files present
- [ ] Files tested for playback
- [ ] Ready to add to Xcode project

---

## Testing Audio

**Before Integration:**
1. Play all files in sequence
2. Check volume balance
3. Test flap sound with rapid clicking
4. Verify no pops, clicks, or distortion
5. Test on both speakers and headphones

**After Integration (Ticket 07):**
1. Test in-game playback
2. Verify volume levels in game context
3. Check for audio conflicts (multiple sounds playing)
4. Test on actual iOS device
5. Verify audio works with device muted/unmuted
6. Test with background music (if added later)

---

## Recommended Approach for MVP

**For fastest implementation:**

1. **Sound Effects:** Use Freesound.org + Zapsplat
   - Time: 1-2 hours
   - Cost: Free (may require attribution)
   - Quality: Good enough for MVP

2. **Voice Lines:** Use ElevenLabs TTS
   - Time: 30 minutes
   - Cost: Free (with free tier)
   - Quality: Clearly synthetic but functional

3. **Processing:** Use Audacity
   - Time: 1-2 hours
   - Cost: Free
   - Quality: Professional

**Total Time:** 3-5 hours
**Total Cost:** $0
**Quality:** Suitable for MVP/testing

**For production release:**
Consider upgrading to professional voice actor for voice lines ($50-200) for better quality and more authentic parody feel.

---

## Next Steps

1. Choose your approach (Option 1, 2, or 3)
2. Source/create all audio files
3. Process audio using workflow above
4. Complete quality checklist
5. Document sources in AUDIO_SOURCES.md
6. Place files in correct directories
7. Proceed to Ticket 07 (Audio Implementation)

---

## Support Resources

**Audacity Tutorials:**
- Official manual: https://manual.audacityteam.org/
- YouTube: Search "Audacity game sound effects"

**TTS Guides:**
- ElevenLabs docs: https://docs.elevenlabs.io/
- Play.ht tutorials: https://play.ht/blog/

**Sound Effect Search:**
- Freesound: https://freesound.org/
- Zapsplat: https://www.zapsplat.com/
- Mixkit: https://mixkit.co/free-sound-effects/

**Voice Actor Platforms:**
- Fiverr: https://www.fiverr.com/categories/music-audio/voice-overs
- Voices.com: https://www.voices.com/
- Voice123: https://voice123.com/

---

## Questions?

If you encounter issues or need clarification:
1. Check AUDIO_SPECIFICATIONS.md for detailed requirements
2. Review this guide's troubleshooting sections
3. Test audio in Audacity before finalizing
4. Document any deviations from spec in AUDIO_SOURCES.md
