# HUSSLE — MASTER PROJECT GUIDE

**Purpose:** permanent source of truth for Hussle product, architecture, UX, release governance, and working rules.

**Last updated:** 23 July 2026  
**Last Approved Build:** `v0.12.20 — Exit Demo`  
**Current stable branch:** `main`  
**Approved Candidate branch:** `candidate/v0.12.20-exit-demo`  
**Approved code commit:** `c0540bc273e35be036ff46b9a9b6cd2c841bd9ef`  
**Final Candidate documentation commit:** `dfba6921aa784d6575f8d0a485682ae98c7035bf`  
**Promotion PR:** `#1 — Promote v0.12.20 Exit Demo to main`  
**Promotion merge commit:** `1d64a3544b3311a03783ca23dd6a38abe9289d86`  
**Release-finalization PR:** `#2 — Finalize v0.12.20 release documentation`  
**Release-finalization merge commit:** `718e1aa4315d5e13c12080394203da086db35147`  
**Post-merge record PR:** `#3 — Record merged v0.12.20 release finalization`  
**Post-merge record merge commit:** `c3b8001ff50d3c9268b65fbc34e42bff4ae2aa3a`  
**Stable tag:** `v0.12.20-stable` is the only remaining release-administration action and must point to the final current `main` commit.  
**Repository:** `zhelabio-blip/hussle-ios`

---

# 1. How to use this guide

Before changing Hussle:

1. Read this guide and `HUSSLE_WORKLOG.md`.
2. Inspect the exact source branch and commit.
3. Inspect relevant code, UI, navigation, data flow, integrations, and side effects.
4. Confirm one exact task.
5. Create a new Candidate or maintenance branch from the approved source commit.
6. Change only the approved scope.
7. Review the diff.
8. Build and test honestly.
9. Update this guide and the worklog.
10. Promote only after Tony explicitly approves the build.

The repository and its documentation are the source of truth. Chat memory is not sufficient.

---

# 2. Release governance

## Candidate Build

Any new build remains a Candidate Build while it is being created or tested.

A Candidate Build must not replace the approved baseline automatically.

## Last Approved Build

A Candidate becomes the Last Approved Build only after Tony explicitly says the equivalent of:

```text
Сборка утверждена
```

Current Last Approved Build:

```text
v0.12.20 — Exit Demo
```

Tony approved v0.12.20 on 23 July 2026 after Xcode generated the project, the app built and launched in Simulator, the initial header collision was corrected, and the corrected Demo experience was manually rechecked.

## Stable-history rule

Stable history is preserved through:

- one current `main` branch;
- permanent stable tags such as `v0.12.20-stable`;
- retained Candidate branches when useful;
- Git commit history.

Moving `main` forward does not erase older commits, tags, or branches.

## Baseline preservation

The previous approved source branch remains untouched:

```text
candidate/v0.12.18-demo-quality
```

Exact v0.12.18 commit:

```text
88d7195078a56bb30b68bd8cfff40f6ef72c26c3
```

v0.12.20 was created directly from that exact commit.

## Required release gates

Every release must review:

1. Baseline Preservation Gate.
2. End-to-End User Flow Gate, including Demo Mode and real-account flow.
3. UI/UX and Design System Gate.
4. Architecture, Data, and Backend Gate.
5. Build, Test, and Evidence Gate.
6. Visual Asset Quality Gate.

## Build honesty

Always distinguish:

- code reviewed;
- files edited;
- project generated;
- Xcode build executed;
- build succeeded;
- automated tests executed;
- manual Simulator testing completed.

`Compile verified` means an actual successful Xcode build.

For v0.12.20:

- Xcode project generation: completed on Tony’s Mac;
- Xcode build and Simulator launch: completed successfully;
- manual requested-flow review: completed;
- Exit Demo header collision: found during manual review and fixed;
- corrected header: manually reviewed and accepted;
- automated unit/UI test execution: not confirmed.

---

# 3. Current repository state

## Stable product state

```text
main
└── contains approved v0.12.20 and finalized release documentation
```

Product promotion:

```text
PR #1
candidate/v0.12.20-exit-demo → main
merge commit: 1d64a3544b3311a03783ca23dd6a38abe9289d86
```

Release-finalization maintenance:

```text
PR #2
maintenance/v0.12.20-release-finalization → main
merge commit: 718e1aa4315d5e13c12080394203da086db35147
```

Post-merge documentation record:

```text
PR #3
maintenance/v0.12.20-post-merge-record → main
merge commit: c3b8001ff50d3c9268b65fbc34e42bff4ae2aa3a
```

PR #2 and PR #3 changed repository hygiene and documentation only. They did not change app code, Demo data, assets, backend schema, or product behavior.

## Approved Candidate retained for history

```text
Branch: candidate/v0.12.20-exit-demo
Final Candidate commit: dfba6921aa784d6575f8d0a485682ae98c7035bf
Approved code commit: c0540bc273e35be036ff46b9a9b6cd2c841bd9ef
Marketing version: 0.12.20
Build number: 20
```

## Preserved previous build

```text
Branch: candidate/v0.12.18-demo-quality
Commit: 88d7195078a56bb30b68bd8cfff40f6ef72c26c3
```

Do not modify or delete either retained Candidate branch without explicit approval.

## Release administration status

Completed:

- Tony approved v0.12.20;
- final Candidate documentation was committed;
- PR #1 merged the approved Candidate into `main`;
- PR #2 merged release-finalization maintenance into `main`;
- PR #3 recorded the completed finalization in permanent documentation;
- version 0.12.18 remains preserved;
- version 0.12.20 Candidate remains preserved;
- generated `Hussle.xcodeproj/` is excluded through `.gitignore`;
- Master Guide, Worklog, changelog, current status, and release audit are aligned with the merged state.

Still required:

- create and push stable tag `v0.12.20-stable` on the final current `main` commit;
- fetch the final remote state in GitHub Desktop.

---

# 4. Product identity

## Name

**Hussle**

Earlier names included Humper and Humpr. Hussle remains the working product name until Tony explicitly changes it.

## Platform

- iPhone app;
- SwiftUI;
- XcodeGen-generated Xcode project;
- English app interface;
- intended for App Store release.

## Product concept

A lightweight, visual, Tinder-like app for dog owners.

Primary value:

- discover nearby dogs;
- prioritize breed and purpose relevance;
- support walks, playdates, friendship, community, and responsible breeding;
- enable mutual interest and real-world connection.

## Ranking direction

Discover priority:

1. same breed plus relevant goal;
2. breed match before goal-only match;
3. other relevant candidates;
4. when results are limited, suggest wider radius or expanded goals.

Do not add a large explanation of ranking to the UI. The interface must stay minimal.

---

# 5. Approved UX principles

Hussle UX must remain:

- minimal;
- fast to understand;
- low text;
- visually polished;
- cleanly spaced;
- consistent;
- free from unnecessary scrolling;
- focused on one primary purpose per screen.

Approved visual direction:

- light interface;
- generous white space;
- soft purple and pink accents;
- dominant dog photography;
- consistent circular dog and owner portrait treatment;
- large, clear Pass and Like actions;
- readable in one or two seconds;
- no heavy explanatory blocks.

## Layout rule

No text, logo, badge, button, safe-area control, or navigation icon may overlap or crowd another control.

A technically functional control is not acceptable if it visually collides with branding or navigation.

The v0.12.20 lesson is permanent: global safe-area overlays must be reviewed against every screen-specific header before handoff.

---

# 6. Onboarding rules

## Owner name

Use:

```text
Your name
What should we call you?
```

## Required fields

- Required fields must be visibly indicated.
- Continue must never appear broken.
- Missing input must produce clear guidance.

## Navigation

- A Back arrow must exist after the first onboarding screen.
- Entries must be preserved when going back.
- No dead-end screens.

## Goals

- Multi-select is required.
- Labels must remain consistent with current product decisions.
- Do not introduce new goals without approval.

## Location

Location inputs should use consistent city-country autocomplete behavior everywhere location appears.

---

# 7. Approved Demo Library

The Demo library contains eight dog-owner pairs and sixteen approved PNG portraits.

| Dog | Breed | Owner | Dog asset | Owner asset |
|---|---|---|---|---|
| Charlie | Chihuahua | Tony | `dog-charlie.png` | `owner-tony.png` |
| Luna | Chihuahua | Anna | `dog-luna.png` | `owner-anna.png` |
| Milo | Poodle | James | `dog-milo.png` | `owner-james.png` |
| Buddy | Dachshund | Minh | `dog-buddy.png` | `owner-minh.png` |
| Coco | Bichon Frise | Sophie | `dog-coco.png` | `owner-sophie.png` |
| Zoe | Golden Retriever | Emma | `dog-zoe.png` | `owner-emma.png` |
| Max | French Bulldog | Daniel | `dog-max.png` | `owner-daniel.png` |
| Nala | Cavalier King Charles Spaniel | Olivia | `dog-nala.png` | `owner-olivia.png` |

Important approved replacements:

- Luna: long-haired white Chihuahua with brown patches on a seaside bench;
- James: slim blond English man by a lake.

Demo structure:

- Charlie is the current profile.
- Seven other dogs appear in Discover.
- Luna demonstrates same-breed relevance.
- Owner portrait circles remain visible on Discover.
- Match remains visually dog-to-dog.
- Activity status and one concise recommendation reason remain visible.

No Demo images or profile mappings were changed in v0.12.20.

---

# 8. v0.12.20 — Exit Demo

## Approved behavior

While Demo Mode is active, the user can leave Demo Mode and return to the first real Sign Up / Log In screen.

The control must:

- appear only in Demo Mode;
- remain secondary to the screen’s primary action;
- be available throughout app-controlled Demo navigation;
- reset transient Demo state;
- not alter real-account backend data;
- not change v0.12.18 assets or profile mappings.

## Coverage

Exit Demo is available through:

- all onboarding pages;
- Discover;
- pushed dog profiles;
- Matches;
- Messages and Chat;
- Profile and pushed settings/editing screens;
- Match sheet;
- Report sheet;
- Vaccinations;
- Add vaccination.

## Approved UI implementation

- Compact capsule labeled `Exit Demo`.
- Secondary styling.
- Top safe-area placement.
- Hidden outside Demo Mode.

## Header correction

The initial implementation overlapped the `Hussle` logo and crowded the settings icon on Discover.

Approved correction:

- reserve right-side space for Exit Demo;
- shift the Hussle header content left in Demo Mode;
- keep the settings icon visible;
- preserve the original non-Demo header behavior.

Approved correction commit:

```text
c0540bc273e35be036ff46b9a9b6cd2c841bd9ef
```

---

# 9. Architecture and data rules

Verified repository structure includes:

- SwiftUI views;
- `AppStore` as central observable application state;
- XcodeGen project generation;
- Demo data through `MockData`;
- Supabase-oriented authentication, profile, discovery, swipe, chat, safety, storage, and realtime services;
- separate Demo and real-account behavior.

Do not redesign working architecture without an approved reason.

Before every change inspect:

- relevant code;
- navigation;
- state ownership;
- data flow;
- backend impact;
- modal and pushed-screen coverage;
- regressions;
- error states;
- future maintainability.

## Secrets

`Configs/Secrets.xcconfig` is local and must never be committed.

## Generated Xcode project

`Hussle.xcodeproj/` is generated locally by XcodeGen.

Repository policy:

- it remains available locally for Xcode;
- it is not a source-of-truth project artifact;
- it must not be committed;
- `.gitignore` contains `Hussle.xcodeproj/`;
- XcodeGen configuration and source files are the tracked source of truth.

---

# 10. Demo asset rules

Generate clean source assets only.

Dog image:

- dog only;
- one animal;
- realistic photography;
- no owner;
- no UI;
- no text;
- no profile card.

Owner image:

- owner only;
- no dog;
- realistic photography;
- no UI;
- no text.

Maintain variation across breed, coloration, ethnicity, age, body type, hairstyle, clothing, pose, and background.

Avoid near-duplicate characters and repetitive green-park backgrounds.

File locations:

```text
Assets/DemoLibrary/Dogs
Assets/DemoLibrary/Owners
HussleApp/Hussle/Resources/DemoImages
```

Use stable lowercase filenames and do not rename accepted assets casually after code references exist.

---

# 11. Git, GitHub, and Mac workflow

## Three separate layers

1. **GitHub remote:** online branches, commits, Pull Requests, and tags.
2. **Local Git repository:** branches, commits, and stash stored on Tony’s Mac.
3. **Working folder:** the files currently visible to Xcode and Finder.

Only one local branch is checked out into the working folder at a time.

## GitHub Desktop map

- **Current Repository:** which local repository folder is open.
- **Current Branch:** which local branch is currently checked out.
- **Changes:** local files differing from the current branch’s latest local commit.
- **History:** already committed history of the selected branch.
- **Stashed Changes:** temporarily hidden local changes; not a branch and not uploaded.
- **Fetch origin:** learn about remote changes without applying them to working files.
- **Pull origin:** download remote commits into the selected local branch.
- **Commit:** save selected local changes into local Git history.
- **Push origin:** upload local commits or tags to GitHub.

## Remote-first assistant workflow

When ChatGPT changes GitHub through the connected GitHub tool:

1. the remote branch changes first;
2. Tony presses **Fetch origin**;
3. Tony selects the required branch;
4. Tony presses **Pull origin** when offered;
5. only then do the updated files exist locally on the Mac.

## Why Changes can appear without editing code

Tools can create local generated or user-specific files:

- `xcodegen generate` creates `Hussle.xcodeproj/`;
- Xcode can update user-state files;
- builds can update local generated metadata.

These are not remote GitHub changes. `Fetch origin` does not create them; it can merely refresh the Desktop display and make existing local files visible again.

## Stash rule

Stash temporarily hides local changes.

- it does not commit them;
- it does not upload them;
- it may not remove unrelated untracked generated files unless those files are included in the stash operation;
- do not restore a stash without inspecting what it contains.

## Branch-switch safety

When GitHub Desktop asks what to do with local changes while switching branches:

- choose **Leave my changes on [current branch]** when changes must not move into the target branch;
- do not choose **Bring my changes to [target branch]** unless mixing those changes is explicitly intended.

After switching to a Candidate branch, confirm the Changes list contains no tracked source changes before building.

## Authentication

Use GitHub Desktop/browser authentication for routine work.

Do not enter Google, ordinary GitHub, or Mac passwords into Git HTTPS prompts.

Terminal HTTPS operations require a configured credential or Personal Access Token, but Terminal authentication is not required for the approved Desktop workflow.

---

# 12. Permanent lessons from 23 July 2026

1. Branch creation must use the exact approved commit.
2. GitHub access does not prove the Mac is running that branch.
3. Only describe what is actually visible in screenshots.
4. A successful compile is not complete visual QA.
5. Global overlays need screen-specific spacing review.
6. Documentation must be finalized before tagging.
7. GitHub Desktop is the default beginner-safe workflow for Tony.
8. Generated `Hussle.xcodeproj/` must be ignored so it does not repeatedly appear as project work.
9. `Changes` is not the repository tree; it is only the local difference list.
10. A merged Pull Request can put `main` one merge commit ahead of the Candidate while file contents remain identical.
11. Remote writes must be isolated on a branch and verified before merging into stable `main`.

---

# 13. Release history

## v0.12.17 — Repository baseline

- repository structure normalized;
- baseline tag existed;
- no claim of full current product completion.

## v0.12.18 — Demo Quality Update

- sixteen approved PNG portraits;
- eight dog-owner pairs;
- improved Demo card quality;
- activity labels;
- recommendation reasons;
- Match remained dog-to-dog;
- approved source branch preserved.

## v0.12.20 — Exit Demo

- reusable Exit Demo control;
- Demo reset to real authentication screen;
- broad navigation and modal coverage;
- UI test definitions added but execution not confirmed;
- release gate expanded;
- Discover header collision found and corrected;
- Xcode build and Simulator launch succeeded on Tony’s Mac;
- corrected UX manually accepted;
- Tony approved v0.12.20;
- PR #1 merged v0.12.20 into `main`;
- PR #2 merged release hygiene and documentation alignment into `main`;
- PR #3 recorded the completed finalization in permanent documentation.

---

# 14. Backlog — not current scope

Do not implement automatically:

- compatibility fields such as energy, temperament, play style, leash behavior, and reactivity;
- active-profile filtering;
- structured meetup scheduling;
- verification infrastructure;
- broad social feed;
- marketplace;
- pet-services directory;
- monetization;
- verified breeding mode.

New ideas go into backlog and do not override approved architecture, UX, workflow, or roadmap.

---

# 15. Next exact step

1. Create and push tag:

```text
v0.12.20-stable
```

on the final current `main` commit.

2. In GitHub Desktop, press **Fetch origin**.
3. Keep `candidate/v0.12.18-demo-quality` and `candidate/v0.12.20-exit-demo` for history.
4. Do not restore the existing stash until its contents are intentionally reviewed.
5. Create the next development Candidate from final `main` or `v0.12.20-stable`.

---

# 16. Final operating principle

```text
Inspect → Verify source → Explain impact → Execute one task → Build/test → Review consequences → Document → Promote
```

Never:

```text
Assume → mix branches → claim verification → discover the wrong build later
```

Preserve what works. Keep the repository, approved build, documentation, and local checkout aligned.
