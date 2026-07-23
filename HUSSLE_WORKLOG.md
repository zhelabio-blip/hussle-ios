# HUSSLE — WORKLOG

This file records dated project progress, evidence, lessons, and the next exact step.

---

# 23 July 2026

## Session objective

Create a new build from the preserved v0.12.18 Demo Quality branch, add Exit Demo throughout Demo Mode, verify it on Tony’s Mac, and promote the accepted result toward the next stable release.

## Approved source

```text
Branch: candidate/v0.12.18-demo-quality
Commit: 88d7195078a56bb30b68bd8cfff40f6ef72c26c3
```

The source branch was not modified.

## New Candidate

```text
Branch: candidate/v0.12.20-exit-demo
Approved code commit: c0540bc273e35be036ff46b9a9b6cd2c841bd9ef
Version: 0.12.20
Build: 20
```

## Completed work

- Created v0.12.20 directly from the exact v0.12.18 source commit.
- Added a compact `Exit Demo` control visible only in Demo Mode.
- Added Demo exit/reset behavior returning to the real Sign Up / Log In screen.
- Preserved all v0.12.18 Demo images, profile mappings, onboarding content, Discover structure, Match composition, and backend architecture.
- Added Exit Demo coverage to onboarding, root navigation, pushed screens, Match, Report, Vaccinations, and Add vaccination.
- Added UI test definitions for exiting Demo Mode from onboarding and the main experience.
- Expanded the release gate for Exit Demo contracts.
- Updated marketing version and build number to 0.12.20 / 20.
- Corrected Discover header spacing after manual review showed Exit Demo overlapping the Hussle logo and crowding the settings icon.
- Updated release documentation.
- Rebuilt `HUSSLE_MASTER_GUIDE.md` as the current permanent source of truth.
- Created the required separate `HUSSLE_WORKLOG.md`.

## Mac verification actually completed

- GitHub Desktop switched to `candidate/v0.12.20-exit-demo`.
- Branch ancestry and version values were checked before launch.
- XcodeGen generated the project locally.
- Xcode built and launched the app in Simulator.
- Tony confirmed the build was genuinely new and contained the preserved v0.12.18 Demo assets.
- Tony found a real UI issue: Exit Demo overlapped the Hussle logo.
- Header spacing was corrected in commit `c0540bc273e35be036ff46b9a9b6cd2c841bd9ef`.
- Tony rebuilt/rechecked and confirmed the corrected screen looked normal and worked without observed glitches.
- Tony explicitly approved v0.12.20 as the latest stable build.

## Not confirmed

- Automated unit tests were not confirmed as executed.
- Automated UI tests were not confirmed as executed.
- Stable tag has not yet been created.
- Pull Request to `main` has not yet been merged.

## Important incidents

### Wrong-build incident before v0.12.20

An earlier attempt was presented as a new build even though the local/remote branch state and actual running build were not verified end to end.

Permanent prevention:

- exact source SHA first;
- new branch from that SHA;
- clean checkout;
- `0 changed files` before build;
- latest commit downloaded;
- fresh XcodeGen generation;
- actual Simulator evidence before claiming success.

### Screenshot interpretation incident

A screenshot was described using expected content that was not actually visible.

Permanent prevention:

- describe only visible evidence;
- never infer screen content from the intended version.

### Exit Demo collision

The first working v0.12.20 build compiled and launched but the global Exit Demo safe-area control overlapped the custom Discover header.

Permanent prevention:

- compile success is not visual QA;
- inspect every affected header, pushed view, and sheet;
- reusable overlays require screen-specific spacing review.

## Git/GitHub workflow learned

- GitHub remote and the Mac local repository are separate copies.
- Remote changes made by ChatGPT do not appear locally until GitHub Desktop fetches/pulls and switches to the branch.
- `Fetch origin` discovers remote changes.
- `Pull origin` downloads commits into the current local branch.
- `Commit` saves local changes into local Git history.
- `Push origin` uploads local commits to GitHub.
- When switching branches with unrelated local changes, choose `Leave my changes on [current branch]` rather than bringing them into the target branch.
- GitHub Desktop/browser is the default workflow for Tony; Terminal authentication is not required for routine synchronization and promotion.

## Files changed for v0.12.20

Code and tests:

- `HussleApp/Hussle/ViewModels/AppStore+DemoExit.swift`
- `HussleApp/Hussle/Views/Components/DemoExitControl.swift`
- `HussleApp/Hussle/Views/RootView.swift`
- `HussleApp/Hussle/Views/Discover/DiscoverView.swift`
- `HussleApp/Hussle/Views/Matches/MatchView.swift`
- `HussleApp/Hussle/Views/Profile/DogEditorView.swift`
- `HussleApp/Hussle/Views/Profile/VaccinationsEditorView.swift`
- `HussleApp/Hussle/Views/Safety/ReportView.swift`
- `Tests/UI/HussleSmokeUITests.swift`
- `Scripts/release_gate.py`
- `Configs/Base.xcconfig`

Documentation:

- `CHANGELOG.md`
- `Docs/Releases/CHANGELOG_v01220.md`
- `Docs/Releases/CURRENT_STATUS_v01220.md`
- `Docs/Releases/RELEASE_AUDIT_v01220.md`
- `HUSSLE_MASTER_GUIDE.md`
- `HUSSLE_WORKLOG.md`

## Preserved without modification

- `candidate/v0.12.18-demo-quality`;
- sixteen approved Demo portraits;
- eight dog-owner mappings;
- `MockData` Demo library;
- Supabase schema and backend services;
- real-account data behavior outside the Demo exit path.

## Release decision

Tony approved v0.12.20 as the Last Approved Build.

The build becomes fully promoted after the final documentation commit is downloaded locally, tagged `v0.12.20-stable`, and merged into `main`.

## Next exact step

In GitHub Desktop:

1. Stay on `candidate/v0.12.20-exit-demo`.
2. Click **Fetch origin**.
3. Click **Pull origin** when offered.
4. Confirm the final documentation commit is at the top of **History**.
5. Right-click the top commit and choose **Create Tag…**.
6. Create `v0.12.20-stable` and push it.
7. Click **Preview Pull Request**.
8. Confirm `base: main` and `compare: candidate/v0.12.20-exit-demo`.
9. Create and merge the Pull Request in the browser.
10. Do not delete the v0.12.18 or v0.12.20 branches yet.
11. Return to GitHub Desktop and click **Fetch origin**.

---
