# Release Audit — v0.12.20

| Gate | Result | Evidence |
|---|---|---|
| Baseline preservation | Passed | Branch created directly from `88d7195078a56bb30b68bd8cfff40f6ef72c26c3`; `candidate/v0.12.18-demo-quality` remained unchanged |
| Scope | Passed | Exit Demo behavior, coverage, tests, versioning, header spacing fix, and release documentation only |
| Demo asset preservation | Passed | Tony confirmed the v0.12.18 Demo assets and profile set appeared in the new Simulator build; no Demo image or MockData changes in v0.12.20 |
| Navigation coverage | Passed by code review and targeted manual use | Root flow plus app-controlled pushed and modal coverage implemented |
| State reset | Passed by implementation review and manual use | Dedicated reset reuses `signOut()` and clears Demo navigation/transient state |
| Real-account behavior | Preserved by design | Control hidden when `isDemoMode` is false; no backend service or schema changes |
| UI automation coverage | Added, execution not confirmed | Onboarding and main-experience Exit Demo tests exist; no claim that they ran |
| Release gate | Updated | Checks Demo reset, control, root attachment, modal coverage, and existing v0.12.18 assets |
| Xcode compile | Passed on Tony’s Mac | Xcode built and launched v0.12.20 in Simulator |
| Initial Simulator visual QA | Failed, then corrected | Exit Demo overlapped the Hussle logo and crowded the settings icon |
| Header correction | Passed manual review | Commit `c0540bc273e35be036ff46b9a9b6cd2c841bd9ef`; Tony confirmed corrected layout looked normal |
| End-to-end requested behavior | Passed manual review | New build launched, preserved Demo content, Exit Demo behavior present, no observed glitches reported after correction |
| Automated unit tests | Not confirmed | No claim of execution |
| Automated UI tests | Not confirmed | No claim of execution |
| Approval | Passed | Tony explicitly approved v0.12.20 as the latest stable build on 23 July 2026 |
| Documentation | Passed after this update | Master guide, worklog, changelog, current status, and release audit aligned |
| Stable tag | Pending release administration | Create `v0.12.20-stable` after pulling the final documentation commit |
| `main` promotion | Pending release administration | Merge PR from `candidate/v0.12.20-exit-demo` to `main` |

## Release decision

v0.12.20 is the Last Approved Build.

The code and corrected UI were built and manually accepted. Automated test execution remains unknown and must not be claimed.

The remaining actions are administrative rather than product changes:

1. pull the final documentation commit;
2. create and push `v0.12.20-stable`;
3. merge the approved branch into `main`;
4. retain v0.12.18 and v0.12.20 branches for now.
