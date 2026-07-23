# Current Status — v0.12.20

**Candidate branch:** `candidate/v0.12.20-exit-demo`  
**Exact source commit:** `88d7195078a56bb30b68bd8cfff40f6ef72c26c3`  
**Source branch:** `candidate/v0.12.18-demo-quality`  
**Status:** code integrated; awaiting macOS Xcode build, automated tests, Simulator review, and Tony’s approval.

## Approved scope

This candidate adds one behavior only:

- while Demo Mode is active, the user can exit from any app-controlled Demo stage and return to the first real Sign Up / Log In screen.

## UX implementation

- Compact 32-point secondary capsule labeled `Exit Demo`.
- Positioned in a narrow top safe-area inset so it remains visible without competing with the screen’s primary action.
- Hidden completely outside Demo Mode.
- Available through:
  - all onboarding pages;
  - Discover and pushed dog profiles;
  - Matches;
  - Messages and Chat;
  - Profile and pushed settings/editing screens;
  - Match sheet;
  - Report sheet;
  - vaccination and Add vaccination sheets.

## State and data behavior

- Reuses the existing sign-out reset path.
- Clears Demo navigation and transient UI state.
- Returns to the authentication screen.
- Does not alter real-account backend data.
- Does not modify the v0.12.18 Demo assets or profile mappings.

## Preserved from v0.12.18

- all 16 approved dog and owner portraits;
- all eight dog-owner profile pairs;
- Demo onboarding order and content;
- Discover card hierarchy and owner portrait circles;
- Match dog-to-dog composition;
- Pass, Like, matching, messaging, profile, and backend architecture.

## Validation completed outside Xcode

- Branch created directly from the exact v0.12.18 commit.
- Scope reviewed against the source architecture.
- Exit Demo UI tests added for onboarding and the main experience.
- Release gate extended to verify the Exit Demo reset and modal coverage.
- GitHub diff must contain only the approved Exit Demo implementation, versioning, tests, and release documentation.

## Validation still required on Tony’s Mac

1. Confirm a clean checkout of `candidate/v0.12.20-exit-demo`.
2. Confirm the checked-out commit SHA matches the branch head reported after final verification.
3. Run `xcodegen generate`.
4. Build the `Hussle` scheme in Xcode.
5. Run unit and UI tests.
6. Verify Exit Demo from onboarding, Discover, a pushed profile, Match, Matches, Messages/Chat, Profile, Report, Vaccinations, and Add vaccination.
7. Confirm the control does not cause clipping, crowding, or unnecessary scrolling.
8. Confirm all v0.12.18 images and dog-owner pairs remain unchanged.
9. Obtain Tony’s explicit approval before promotion or tagging.

No stable tag has been created.
