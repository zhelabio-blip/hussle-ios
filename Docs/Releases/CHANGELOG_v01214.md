# Candidate v0.12.14 changelog

- Restored the approved Demo Mode entry path: Demo Mode now starts onboarding/profile creation rather than opening a completed Discover profile.
- Demo Mode remains independent of Supabase configuration and network/auth state.
- Added a regression UI test asserting the Demo button opens onboarding and does not jump to Discover.
- Preserved the v0.12.13 email-confirmation/session decoding fix and single-location auth error UX.
- Reprocessed demo images at higher output resolution and quality.
- Removed baked white circular margins from affected dog assets by centered crops, keeping faces in the central safe area.
- Added formal immutable-baseline policy, approved product contract and five-gate release checklist.
