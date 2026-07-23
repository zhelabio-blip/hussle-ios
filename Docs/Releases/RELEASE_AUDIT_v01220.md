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
| Candidate documentation | Passed | Final Candidate documentation commit `dfba6921aa784d6575f8d0a485682ae98c7035bf` |
| `main` promotion | Passed | PR #1 merged `candidate/v0.12.20-exit-demo` into `main`; merge commit `1d64a3544b3311a03783ca23dd6a38abe9289d86` |
| Generated-project policy | Passed in maintenance | `.gitignore` includes `Hussle.xcodeproj/`; generated Xcode project remains local and untracked |
| Final documentation alignment | Passed in maintenance | Master Guide, Worklog, changelog, current status, and release audit record the actual merged state |
| Stable tag | Pending final administration | Create `v0.12.20-stable` on the final `main` commit after maintenance merge |

## Release decision

v0.12.20 is the Last Approved Build.

The code and corrected UI were built and manually accepted. Automated test execution remains unknown and must not be claimed.

## Promotion result

Completed:

1. final Candidate documentation committed;
2. PR #1 created;
3. PR #1 merged into `main`;
4. previous v0.12.18 branch retained;
5. v0.12.20 Candidate branch retained.

Release-finalization maintenance adds only repository hygiene and documentation alignment. It does not change product code or behavior.

## Remaining action

After maintenance is merged into `main`:

1. create and push tag `v0.12.20-stable` on the final `main` commit;
2. fetch the final state in GitHub Desktop;
3. retain both approved Candidate branches for history.
