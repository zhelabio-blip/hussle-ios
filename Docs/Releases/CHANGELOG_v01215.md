# Hussle v0.12.15 Candidate

Baseline: v0.12.14 Candidate. This build is not approved until Tony writes “Сборка утверждена”.

## Changes requested by Tony
- Reprocessed every demo dog image with additional safe framing so the complete face remains visible and centered in circular UI frames.
- Removed white empty areas from demo image files by using full-bleed square assets.
- Reprocessed owner portraits to fill their circles and applied conservative smoothing/high-quality JPEG export.
- Added high-quality image interpolation in every shared dog/owner photo component and onboarding preview.
- Added `Scripts/check_local_config.sh` to catch a missing `Secrets.xcconfig` before testing real registration.

## Preserved without intentional change
- Demo Mode begins with onboarding, not pre-filled Discover.
- All approved onboarding pages and Back/data-preservation behavior.
- Discover, dog profile, dog-to-dog Match, Matches, Messages, Chat, Profile and settings routes.
- Supabase backend, migration, auth email-confirmation handling and single auth error presentation.
