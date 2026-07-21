# Five-pass release audit — v0.12.15 Candidate

1. Baseline preservation: no Swift screen/service/model/migration removed from v0.12.14.
2. Demo route: authentication → Explore Demo Mode → onboarding remains unchanged.
3. Image pipeline: all 12 demo images decode, are square, full-bleed and exported at 1600×1600 (dogs) or 1200×1200 (owners).
4. Shared UI coverage: DogThumbnail, OwnerThumbnail, DogOwnerPortrait, DogArtwork and OwnerPhotoPreview use fill mode, clipping and high interpolation.
5. Backend/configuration: backend code unchanged; real registration still requires the user's local `Configs/Secrets.xcconfig`, now guarded by a preflight script.

Static audit only. Xcode build, Simulator walkthrough and visual approval must be performed on the user's Mac.
