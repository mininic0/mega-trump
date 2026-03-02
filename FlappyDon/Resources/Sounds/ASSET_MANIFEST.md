# Audio Asset Manifest

This document tracks the status of all audio assets for FlappyDon.

## Asset Status Legend
- ⬜ Not started
- 🔄 In progress
- ✅ Complete
- ⚠️ Needs revision

---

## Sound Effects (5 files)

### SFX/flap.m4a (or .mp3)
- **Status:** ⬜ Not started
- **Type:** Wing flap / whoosh
- **Duration:** 0.1-0.2s
- **Source:** _[To be documented]_
- **License:** _[To be documented]_
- **Date Added:** _[To be documented]_
- **Notes:** _[Any special notes]_

---

### SFX/score.m4a (or .mp3)
- **Status:** ⬜ Not started
- **Type:** Ding / ping
- **Duration:** ~0.2s
- **Source:** _[To be documented]_
- **License:** _[To be documented]_
- **Date Added:** _[To be documented]_
- **Notes:** _[Any special notes]_

---

### SFX/death.m4a (or .mp3)
- **Status:** ⬜ Not started
- **Type:** Comedic bonk
- **Duration:** 0.3-0.5s
- **Source:** _[To be documented]_
- **License:** _[To be documented]_
- **Date Added:** _[To be documented]_
- **Notes:** _[Any special notes]_

---

### SFX/highscore.m4a (or .mp3)
- **Status:** ⬜ Not started
- **Type:** Victory jingle
- **Duration:** 1-2s
- **Source:** _[To be documented]_
- **License:** _[To be documented]_
- **Date Added:** _[To be documented]_
- **Notes:** _[Any special notes]_

---

### SFX/button.m4a (or .mp3)
- **Status:** ⬜ Not started
- **Type:** UI click
- **Duration:** ~0.1s
- **Source:** _[To be documented]_
- **License:** _[To be documented]_
- **Date Added:** _[To be documented]_
- **Notes:** _[Any special notes]_

---

## Voice Lines - Death Reactions (4 files)

### Voice/wrong.m4a (or .mp3)
- **Status:** ⬜ Not started
- **Text:** "Wrong!"
- **Duration:** < 1s
- **Source:** _[To be documented]_
- **Voice Type:** _[Impersonator / TTS / Other]_
- **License:** _[To be documented]_
- **Date Added:** _[To be documented]_
- **Notes:** _[Any special notes]_

---

### Voice/sad.m4a (or .mp3)
- **Status:** ⬜ Not started
- **Text:** "Sad!"
- **Duration:** < 1s
- **Source:** _[To be documented]_
- **Voice Type:** _[Impersonator / TTS / Other]_
- **License:** _[To be documented]_
- **Date Added:** _[To be documented]_
- **Notes:** _[Any special notes]_

---

### Voice/fakenews.m4a (or .mp3)
- **Status:** ⬜ Not started
- **Text:** "Fake news!"
- **Duration:** < 1.5s
- **Source:** _[To be documented]_
- **Voice Type:** _[Impersonator / TTS / Other]_
- **License:** _[To be documented]_
- **Date Added:** _[To be documented]_
- **Notes:** _[Any special notes]_

---

### Voice/disaster.m4a (or .mp3)
- **Status:** ⬜ Not started
- **Text:** "Disaster!"
- **Duration:** < 1.5s
- **Source:** _[To be documented]_
- **Voice Type:** _[Impersonator / TTS / Other]_
- **License:** _[To be documented]_
- **Date Added:** _[To be documented]_
- **Notes:** _[Any special notes]_

---

## Voice Lines - Milestone Celebrations (3 files)

### Voice/tremendous.m4a (or .mp3)
- **Status:** ⬜ Not started
- **Text:** "Tremendous!"
- **Duration:** < 1.5s
- **Trigger:** Score = 25
- **Source:** _[To be documented]_
- **Voice Type:** _[Impersonator / TTS / Other]_
- **License:** _[To be documented]_
- **Date Added:** _[To be documented]_
- **Notes:** _[Any special notes]_

---

### Voice/huge.m4a (or .mp3)
- **Status:** ⬜ Not started
- **Text:** "This is huge!"
- **Duration:** < 1.5s
- **Trigger:** Score = 50
- **Source:** _[To be documented]_
- **Voice Type:** _[Impersonator / TTS / Other]_
- **License:** _[To be documented]_
- **Date Added:** _[To be documented]_
- **Notes:** _[Any special notes]_

---

### Voice/nobody.m4a (or .mp3)
- **Status:** ⬜ Not started
- **Text:** "Nobody plays better than me!"
- **Duration:** < 2s
- **Trigger:** Score = 100
- **Source:** _[To be documented]_
- **Voice Type:** _[Impersonator / TTS / Other]_
- **License:** _[To be documented]_
- **Date Added:** _[To be documented]_
- **Notes:** _[Any special notes]_

---

## Overall Progress

**Sound Effects:** 0/5 complete (0%)
**Voice Lines:** 0/7 complete (0%)
**Total Assets:** 0/12 complete (0%)

---

## Quality Assurance Checklist

Run this checklist once all assets are complete:

### Technical Compliance
- [ ] All files in AAC (.m4a) or MP3 (.mp3) format
- [ ] All files at 44.1 kHz sample rate
- [ ] All files at 128-192 kbps bit rate
- [ ] All files in mono (not stereo)
- [ ] All files normalized to -3dB to -6dB peak
- [ ] All files have fade in/out (5-10ms)
- [ ] All file sizes optimized (< 100KB for most)
- [ ] All files named correctly (lowercase, no spaces)

### Content Quality
- [ ] Flap sound tested with rapid repetition
- [ ] Score sound feels rewarding
- [ ] Death sound is comedic, not harsh
- [ ] High score jingle is celebratory
- [ ] Button click is subtle
- [ ] All voice lines clear and understandable
- [ ] Voice lines match character/tone
- [ ] All durations meet specifications

### Legal Compliance
- [ ] All audio original or properly licensed
- [ ] All licenses allow commercial use
- [ ] Voice lines use impersonator or synthetic voice
- [ ] Voice lines are clearly parody
- [ ] All sources documented
- [ ] Attribution requirements met (if any)

### Organization
- [ ] All SFX files in SFX/ directory
- [ ] All voice files in Voice/ directory
- [ ] AUDIO_SOURCES.md completed
- [ ] All manifest entries updated
- [ ] Ready for Xcode integration

---

## Notes and Issues

_Document any issues, deviations from spec, or special considerations here:_

---

## Sign-off

**Audio Assets Completed By:** _[Name]_
**Date:** _[Date]_
**Approved By:** _[Name]_
**Date:** _[Date]_

**Ready for Implementation (Ticket 07):** ⬜ Yes / ⬜ No

---

## Revision History

| Date | Change | By |
|------|--------|-----|
| _[Date]_ | Initial manifest created | _[Name]_ |
| | | |
| | | |
