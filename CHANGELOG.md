# Changelog

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
- Static release checks passed; Xcode compile and Simulator verification remain required on macOS.

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
