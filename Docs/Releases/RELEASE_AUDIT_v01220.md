# Release Audit — v0.12.20 Candidate

| Gate | Result | Evidence |
|---|---|---|
| Baseline preservation | Passed in GitHub | Branch created directly from `88d7195078a56bb30b68bd8cfff40f6ef72c26c3`; source branch remains unchanged |
| Scope | Passed by review | Exit Demo behavior, tests, versioning, and release documentation only |
| Demo asset preservation | Passed by diff review | No Demo image or MockData changes are permitted in this candidate |
| Navigation coverage | Passed statically | Root flow plus Match, Report, Vaccinations, and Add vaccination modal coverage |
| State reset | Passed statically | Dedicated reset reuses `signOut()` and clears Demo navigation/transient state |
| Real-account behavior | Preserved by design | Control is hidden when `isDemoMode` is false; no backend service or schema changes |
| UI automation coverage | Added, not executed | Onboarding and main-experience Exit Demo tests added |
| Release gate | Updated, not yet executed on Mac checkout | Checks Demo reset, control, root attachment, modal coverage, and existing v0.12.18 assets |
| Swift syntax | Pending final static parser check | Must be reviewed before handoff |
| Xcode compile | Pending | Requires Xcode on Tony’s Mac |
| Simulator visual QA | Pending | Requires target iPhone Simulator |
| Approval | Pending | Requires Tony’s explicit approval |

## Release decision

This branch is a Candidate Build only. Do not merge, promote, or tag it until the macOS build, automated tests, complete Demo walkthrough, visual review, and Tony’s explicit approval are complete.
