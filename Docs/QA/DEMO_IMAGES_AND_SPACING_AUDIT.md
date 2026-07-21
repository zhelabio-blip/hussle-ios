# Hussle demo images and spacing audit — v0.12.5

## Root cause fixed
The JPG demo files existed in the repository but were not explicitly added to the Xcode resources build phase. The UI therefore fell back to the placeholder. `project.yml` now copies `Hussle/Resources/DemoImages` into the application bundle, and `DogArtwork` performs robust bundle lookup.

## Demo consistency
- Charlie — Chihuahua, male
- Luna — Chihuahua, female
- Milo — Poodle, male
- Buddy — Dachshund, male
- Coco — Bichon Frise, female
- Zoe — Yorkshire Terrier, female

The same image source is used by Discover, full profiles, matches, messages, chat headers, the match celebration, onboarding preview and Profile.

## Spacing standard
- Screen horizontal inset: 20 pt
- Primary content spacing: 16 pt
- Photo-to-text spacing in profile summaries: 18 pt
- Compact label spacing: 8 pt
- Card internal padding: 16 pt

Reviewed and adjusted Profile, Discover card, full dog profile, Matches and Messages rows.
