# Changelog

## v0.12.20 — Exit Demo — Approved and promoted
- Created directly from `candidate/v0.12.18-demo-quality` commit `88d7195078a56bb30b68bd8cfff40f6ef72c26c3`.
- Added a compact secondary `Exit Demo` control while Demo Mode is active.
- Kept the control available through onboarding, all main tabs, pushed navigation screens, Match, Report, and nested vaccination sheets.
- Added a dedicated Demo reset that returns to the real Sign Up / Log In screen without changing the real-account flow.
- Preserved the approved v0.12.18 Demo Library, dog-owner pairs, Discover presentation, Match composition, onboarding order, and backend behavior.
- Added UI test definitions and release-gate checks for Exit Demo.
- Updated the app version to 0.12.20 (build 20).
- Xcode built and launched successfully on Tony’s Mac.
- Manual review found an initial collision between Exit Demo and the Discover header.
- Corrected the Demo header spacing in commit `c0540bc273e35be036ff46b9a9b6cd2c841bd9ef`.
- Tony manually rechecked the corrected build and approved v0.12.20 as the latest stable build on 23 July 2026.
- Automated unit/UI test execution was not confirmed and must not be claimed.
- Pull Request #1 merged the approved Candidate into `main` at merge commit `1d64a3544b3311a03783ca23dd6a38abe9289d86`.
- Added release-finalization maintenance to ignore generated `Hussle.xcodeproj/` and align repository documentation.
- Stable tag `v0.12.20-stable` must be created on the final `main` commit after maintenance is merged.

## v0.12.18 — Demo Quality Update
- Replaced the bundled Demo library with 16 approved PNG portraits: eight dogs and eight owners.
- Added Max with Daniel and Nala with Olivia to the Demo journey.
- Aligned Zoe with the approved Golden Retriever portrait.
- Added concise activity status and recommendation reason treatments to Discover.
- Added the recommendation reason to Match while preserving the dog-to-dog layout.
- Updated Demo image loading to support PNG with JPG/JPEG fallback.
- Expanded the onboarding breed list for the Demo profiles.
- Added Demo mapping tests and repaired the repository release-gate paths.
- Updated the app version to 0.12.18 (build 18).
- Static release checks passed; Xcode compile and Simulator verification remained required at that stage.

## v0.12.17 — Repository Start
- Reorganized the v0.12.16 candidate into a GitHub-ready product repository.
- Moved iOS source into `HussleApp/`.
- Consolidated unit and UI tests under `Tests/`.
- Renamed the backend root to `Supabase/`.
- Moved historical documents into Product, Process, Architecture, QA, Releases, and Setup sections.
- Added permanent governance documents and repository README.
- Updated XcodeGen paths for the new structure.
- Preserved app source and bundled resources without intentional functional changes.
- Static checks only; no Xcode compile verification was performed.
