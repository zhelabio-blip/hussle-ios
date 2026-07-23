# Current Status — v0.12.20

**Approved branch:** `candidate/v0.12.20-exit-demo`  
**Exact source commit:** `88d7195078a56bb30b68bd8cfff40f6ef72c26c3`  
**Source branch:** `candidate/v0.12.18-demo-quality`  
**Approved code commit:** `c0540bc273e35be036ff46b9a9b6cd2c841bd9ef`  
**Status:** Tony approved v0.12.20 as the latest stable build; final documentation, stable tag, and `main` promotion are the remaining release-administration steps.

## Approved scope

v0.12.20 adds one product behavior:

- while Demo Mode is active, the user can exit from app-controlled Demo stages and return to the first real Sign Up / Log In screen.

## UX implementation

- Compact secondary capsule labeled `Exit Demo`.
- Hidden completely outside Demo Mode.
- Available through onboarding, main tabs, pushed screens, Match, Report, Vaccinations, and Add vaccination.
- Discover header adjusted so Exit Demo no longer overlaps the Hussle logo or hides/crowds the settings icon.
- Non-Demo header behavior remains preserved.

## State and data behavior

- Reuses the existing sign-out reset path.
- Clears Demo navigation and transient UI state.
- Returns to authentication.
- Does not alter real-account backend data.
- Does not modify v0.12.18 Demo assets or profile mappings.

## Preserved from v0.12.18

- all 16 approved dog and owner portraits;
- all eight dog-owner profile pairs;
- Demo onboarding order and content;
- Discover card hierarchy and owner portrait circles;
- Match dog-to-dog composition;
- Pass, Like, matching, messaging, profile, and backend architecture.

## Validation completed

- Branch created directly from exact v0.12.18 commit `88d7195078a56bb30b68bd8cfff40f6ef72c26c3`.
- GitHub ancestry and diff reviewed.
- XcodeGen project generation completed on Tony’s Mac.
- Xcode build succeeded and the app launched in Simulator.
- Tony manually confirmed the preserved v0.12.18 Demo assets appeared in the new build.
- Initial header collision was discovered during manual visual QA.
- Header correction was committed as `c0540bc273e35be036ff46b9a9b6cd2c841bd9ef`.
- Tony rebuilt/rechecked the corrected build and confirmed it looked normal and worked without observed glitches.
- Tony explicitly approved v0.12.20 as the latest stable build.

## Validation not confirmed

- Automated unit tests: not confirmed as executed.
- Automated UI tests: not confirmed as executed.

## Release administration still required

1. Pull the final documentation commit in GitHub Desktop.
2. Create and push stable tag `v0.12.20-stable` on the final branch head.
3. Create a Pull Request from `candidate/v0.12.20-exit-demo` to `main`.
4. Merge the Pull Request on GitHub.
5. Fetch the resulting remote state in GitHub Desktop.
6. Keep `candidate/v0.12.18-demo-quality` and `candidate/v0.12.20-exit-demo` for now.

No stable tag existed at the time this status document was finalized.
