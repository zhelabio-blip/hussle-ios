# HUSSLE — WORKLOG

This file records dated project progress, evidence, lessons, and the next exact step.

---

# 23 July 2026

## Session objective

Create a new build from the preserved v0.12.18 Demo Quality branch, add Exit Demo throughout Demo Mode, verify it on Tony’s Mac, approve it, promote it to `main`, and finalize repository documentation and local GitHub Desktop behavior.

## Approved source

```text
Branch: candidate/v0.12.18-demo-quality
Commit: 88d7195078a56bb30b68bd8cfff40f6ef72c26c3
```

The source branch was not modified.

## Approved v0.12.20 Candidate

```text
Branch: candidate/v0.12.20-exit-demo
Approved code commit: c0540bc273e35be036ff46b9a9b6cd2c841bd9ef
Final Candidate documentation commit: dfba6921aa784d6575f8d0a485682ae98c7035bf
Version: 0.12.20
Build: 20
```

## Completed product work

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
- Rebuilt `HUSSLE_MASTER_GUIDE.md` as the permanent source of truth.
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

## Validation not confirmed

- Automated unit tests were not confirmed as executed.
- Automated UI tests were not confirmed as executed.

## Promotion to main

Pull Request:

```text
#1 — Promote v0.12.20 Exit Demo to main
```

Direction:

```text
candidate/v0.12.20-exit-demo → main
```

Result:

- PR #1 was successfully merged on 23 July 2026.
- Merge commit: `1d64a3544b3311a03783ca23dd6a38abe9289d86`.
- `main` contains marketing version 0.12.20 and build 20.
- `candidate/v0.12.18-demo-quality` remains at `88d7195078a56bb30b68bd8cfff40f6ef72c26c3`.
- `candidate/v0.12.20-exit-demo` remains retained for history.
- `main` is one merge commit ahead of the Candidate while file contents are identical at the promotion point.

## Release-finalization maintenance

Maintenance branch:

```text
maintenance/v0.12.20-release-finalization
```

Pull Request:

```text
#2 — Finalize v0.12.20 release documentation
```

Result:

- PR #2 was successfully merged into `main`.
- Merge commit: `718e1aa4315d5e13c12080394203da086db35147`.
- `.gitignore` now includes `Hussle.xcodeproj/`.
- Master Guide, Worklog, changelog, current status, and release audit were aligned with the completed PR #1 promotion.
- No app code, Demo data, visual assets, backend schema, or product behavior changed in PR #2.

## Post-merge documentation record

Current documentation-only branch:

```text
maintenance/v0.12.20-post-merge-record
```

Purpose:

- record the successful PR #2 merge;
- make the final repository state self-consistent before tagging;
- leave only one remaining release-administration action: create `v0.12.20-stable` on final `main`.

## Important incidents and lessons

### Wrong-build incident before v0.12.20

An earlier attempt was presented as a new build even though the local/remote branch state and actual running build were not verified end to end.

Permanent prevention:

- exact source SHA first;
- new branch from that SHA;
- clean checkout;
- no tracked local changes before build;
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

### GitHub Desktop instruction mismatch

Earlier instructions referred to controls or screens that were not present in Tony’s current Desktop state.

Permanent prevention:

- use the exact visible English label from the current screenshot;
- distinguish `Changes`, `History`, and browser GitHub actions;
- give one verified action at a time;
- do not assume `No local changes` while generated files are visible.

### Generated Xcode project repeatedly appeared as Changes

`xcodegen generate` created:

```text
Hussle.xcodeproj/
```

GitHub Desktop showed four new files because the directory was not ignored.

Permanent resolution:

- `.gitignore` now includes `Hussle.xcodeproj/`;
- the folder remains usable locally by Xcode;
- the generated project must not be committed;
- tracked source, XcodeGen configuration, and app resources remain the source of truth.

### Stash behavior clarified

Tony stashed five local changes. The modified tracked file moved into `Stashed Changes`, while generated/untracked Xcode project files remained visible.

Permanent lesson:

- stash is temporary local storage, not a commit or branch;
- do not assume all untracked generated files disappeared;
- do not restore a stash without inspecting its contents.

### Remote and local state clarified

- GitHub remote and the Mac local repository are separate copies.
- Remote changes made by ChatGPT do not appear locally until GitHub Desktop fetches/pulls and switches to the branch.
- `Fetch origin` discovers remote state.
- `Pull origin` downloads commits into the current local branch.
- `Commit` saves local changes into local Git history.
- `Push origin` uploads local commits or tags to GitHub.
- `Changes` is only the local difference list, not the full repository tree.
- `History` shows committed history of the selected branch.
- `Stashed Changes` is temporary local storage.

### Release-finalization tool incident

During an attempted automated maintenance-branch setup, temporary no-op file commits were accidentally created on `main` and immediately removed. `main` was then explicitly moved back to the verified promotion merge commit:

```text
1d64a3544b3311a03783ca23dd6a38abe9289d86
```

A follow-up comparison confirmed `main` was identical to that exact commit before the real maintenance branch was created.

Permanent prevention:

- create the branch first with `create_branch` from an exact SHA;
- never probe branch existence by writing files;
- verify `main` after every remote write;
- keep maintenance changes isolated from stable `main` until reviewed.

## Files changed for v0.12.20 product work

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

Release-finalization maintenance:

- `.gitignore`
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

`main` contains the approved product and merged release-finalization maintenance. The final stable tag must be created only after this post-merge documentation record is merged.

## Next exact step

1. Review and merge `maintenance/v0.12.20-post-merge-record` into `main`.
2. Create and push `v0.12.20-stable` on the resulting final `main` commit.
3. In GitHub Desktop, press **Fetch origin**.
4. Keep the v0.12.18 and v0.12.20 Candidate branches.
5. Do not restore the existing stash until its contents are intentionally reviewed.

---
