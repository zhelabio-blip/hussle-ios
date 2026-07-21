# Hussle — Approved Product Contract

This contract is the regression baseline for every Candidate Build. A Candidate may add functionality, but it must not silently remove, hide, reorder, or modify any approved behavior. Only Tony's exact phrase **“Сборка утверждена”** promotes a Candidate to the new Last Approved Build.

## Launch and authentication
- App launches without crashing.
- Sign Up and Log In remain available.
- Demo Mode remains visible even when Supabase is configured and reachable.
- Demo Mode is independent of backend, network, account, and authentication errors.
- Authentication errors appear once inside the form, not duplicated in a global banner.
- Email-confirmation signup is handled without a decoding crash.

## Approved Demo Mode journey
1. Authentication screen.
2. Tap Demo Mode.
3. Welcome onboarding screen — not a prefilled Main/Discover screen.
4. Get Started.
5. Owner setup first: required owner photo, “Your name”, multi-select goals.
6. Dog details second: dog name, breed, sex, date of birth, sterilization.
7. Health: at least one vaccination record; health tests and pedigree options.
8. Location: approximate location or city/country autocomplete; radius.
9. Review Profile: large circular dog photo + smaller overlapping circular owner photo.
10. Create Profile.
11. Main app opens on Discover with demo data.

## Onboarding rules
- Back exists after the first screen.
- Back preserves all entered data.
- Required fields show Required chips, inline explanation, and explicit validation.
- Continue never fails silently.
- Goals are multi-select: Breeding, Walks, Friends.
- First selected goal may remain internal primary; no separate Primary Goal UI.
- Owner name is explicitly the owner's name.
- Owner photo is required.
- Dog photo fills its circle without internal white gaps.

## Main app and demo data
- Tabs: Discover, Matches, Messages, Profile.
- Discover ranking: same breed + same goal; same breed; same goal; everyone else; then distance/completeness/activity.
- Do not silently show unrelated dogs when results are exhausted; suggest expanding radius/goals/other breeds.
- Discover cards use consistent dog circle, owner circle, offsets, spacing, buttons, and text padding.
- Dog profile is reachable from Discover.
- Pass and Like remain available.
- Match is dog-to-dog only; owner is never one side of Match.
- Matches, Messages, demo Chat, Profile, dog editor, vaccination editor, discovery settings, notification settings, safety screens remain reachable.

## Visual contract
- Light minimalist system, white space, purple/pink accents, rounded cards.
- Text never touches screen/card/button edges; wrap or shorten instead.
- Identical component sizes and spacing across repeated cards.
- Dog and owner images use full-bleed clipping in circular frames.
- Dog faces/muzzles remain visually centered and not excessively zoomed.
- Owner images are clean portraits, never screenshots or UI fragments.
- No blurry oversized hero imagery.

## Backend contract
- Supabase publishable key only in client; no secret/service-role key.
- One canonical bootstrap migration.
- Auth, REST, Storage connectivity retained.
- Database tables, RLS, RPC, Realtime and Edge Function integration code must not be removed while adding UI work.
- Demo Mode must continue working if all backend calls fail.

## Change-control rule
For every item above, Candidate Build documentation must mark exactly one:
- UNCHANGED
- ADDED
- CHANGE REQUESTED BY TONY
- BLOCKED / NOT RUNTIME-VERIFIED

No unlabelled behavior change is allowed.
