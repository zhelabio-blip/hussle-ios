# Changelog — v0.12.16 Candidate

- Preserved the v0.12.15 code paths and all previously restored Demo Mode onboarding behavior.
- Re-cropped all six demo dog assets from full-bleed square sources so the complete face is centered and baked-in white circular edges are removed.
- Re-cropped all six owner assets to remove polygonal/white edge artifacts and ensure every thumbnail fills its frame.
- Kept shared dog/owner image components in fill mode with clipping, high interpolation and explicit center alignment.
- Supabase code is unchanged. Real registration requires the user's existing local `Configs/Secrets.xcconfig`; credentials are intentionally never packaged in a shared archive.
