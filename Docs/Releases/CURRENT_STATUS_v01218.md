# Current Status — v0.12.18

**Candidate branch:** `candidate/v0.12.18-demo-quality`
**Stable base:** `v0.12.17-baseline`
**Status:** integrated candidate; awaiting macOS build and Tony's approval.

## Completed

- Normalized all 16 approved Demo assets.
- Integrated eight complete dog/owner profile pairs.
- Added activity and recommendation treatments to Discover.
- Added the recommendation reason to Match without changing the dog-to-dog composition.
- Updated image loading, onboarding breeds, tests, release checks, and release documentation.
- Removed macOS metadata and kept local secrets outside version control.

## Verification result

- `python3 Scripts/release_gate.py`: passed.
- `python3 -m py_compile Scripts/release_gate.py`: passed.
- Modified Swift files introduced no new tree-sitter parse errors compared with the stable source.
- Asset source copies and bundled copies are byte-identical.

## Still required on a Mac

1. Run `xcodegen generate`.
2. Open the generated Xcode project.
3. Build the `Hussle` scheme.
4. Run unit and UI tests.
5. Walk through onboarding, all seven Discover cards, Pass/Like, and Match in an iPhone Simulator.
6. Record Tony's explicit approval before creating a stable tag.

No stable tag has been created for this candidate.
