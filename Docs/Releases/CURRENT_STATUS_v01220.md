# Current Status — v0.12.20

**Status:** Last Approved Build; product, repository hygiene, and finalized release documentation are in `main`.  
**Source branch:** `candidate/v0.12.18-demo-quality`  
**Exact source commit:** `88d7195078a56bb30b68bd8cfff40f6ef72c26c3`  
**Approved Candidate branch:** `candidate/v0.12.20-exit-demo`  
**Approved code commit:** `c0540bc273e35be036ff46b9a9b6cd2c841bd9ef`  
**Final Candidate documentation commit:** `dfba6921aa784d6575f8d0a485682ae98c7035bf`  
**Product promotion merge commit:** `1d64a3544b3311a03783ca23dd6a38abe9289d86`  
**Release-finalization merge commit:** `718e1aa4315d5e13c12080394203da086db35147`  
**Post-merge documentation record:** `c3b8001ff50d3c9268b65fbc34e42bff4ae2aa3a`  
**Stable tag:** pending on the final current `main` commit.

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
- Pull Request #1 merged `candidate/v0.12.20-exit-demo` into `main`.
- Pull Request #2 merged repository hygiene and release-documentation alignment into `main`.
- Pull Request #3 recorded the completed finalization in permanent documentation.

## Validation not confirmed

- Automated unit tests: not confirmed as executed.
- Automated UI tests: not confirmed as executed.

## Repository maintenance completed

PR #2 merged:

```text
maintenance/v0.12.20-release-finalization → main
```

It:

- added `Hussle.xcodeproj/` to `.gitignore`;
- aligned Master Guide, Worklog, changelog, current status, and release audit with the completed PR #1 merge;
- documented GitHub Desktop, stash, generated-file, and release-process lessons;
- changed no app code, Demo data, assets, backend schema, or product behavior.

PR #3 merged:

```text
maintenance/v0.12.20-post-merge-record → main
```

It recorded PR #2 as completed and changed documentation only.

## Remaining release administration

1. Create and push `v0.12.20-stable` on the final current `main` commit.
2. In GitHub Desktop, press **Fetch origin**.
3. Keep `candidate/v0.12.18-demo-quality` and `candidate/v0.12.20-exit-demo` for history.
4. Do not restore the existing local stash until its contents are intentionally reviewed.
