# HUSSLE — MASTER PROJECT GUIDE

**Purpose:** permanent source of truth for Hussle product, architecture, UX, release governance, and working rules.

**Last updated:** 23 July 2026  
**Last Approved Build:** `v0.12.20 — Exit Demo`  
**Approved branch:** `candidate/v0.12.20-exit-demo`  
**Approved code commit:** `c0540bc273e35be036ff46b9a9b6cd2c841bd9ef`  
**Release promotion status:** documentation is being finalized; stable tag and `main` promotion are the next exact steps.  
**Repository:** `zhelabio-blip/hussle-ios`

---

# 1. How to use this guide

Before changing Hussle:

1. Read this guide.
2. Inspect the exact source branch and commit.
3. Inspect relevant code, UI, navigation, data flow, integrations, and side effects.
4. Confirm one exact task.
5. Create a new Candidate branch from the approved source commit.
6. Change only the approved scope.
7. Review the diff.
8. Build and test honestly.
9. Update `HUSSLE_MASTER_GUIDE.md` and `HUSSLE_WORKLOG.md`.
10. Promote only after Tony explicitly approves the build.

The repository and its documentation are the source of truth. Chat memory is not sufficient.

---

# 2. Release governance

## Build labels

### Candidate Build

Any new build remains a Candidate Build while it is being created or tested.

A Candidate Build must not replace the approved baseline automatically.

### Last Approved Build

A Candidate becomes the Last Approved Build only after Tony explicitly approves it.

Current Last Approved Build:

```text
v0.12.20 — Exit Demo
```

Tony approved v0.12.20 as the latest stable build on 23 July 2026 after launching it in Xcode and manually checking the corrected Demo experience in Simulator.

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
- automated unit/UI test execution: not confirmed in this session.

---

# 3. Current repository state

## Approved build

```text
Branch: candidate/v0.12.20-exit-demo
Approved code commit: c0540bc273e35be036ff46b9a9b6cd2c841bd9ef
Marketing version: 0.12.20
Build number: 20
```

Documentation-only commits may follow the approved code commit before the stable tag is created. The final stable tag must point to the branch head after documentation is finalized.

## Promotion still required

The approved build is not fully promoted until:

1. GitHub Desktop downloads the final documentation commit.
2. Tag `v0.12.20-stable` is created on the final branch head and pushed.
3. A Pull Request is created from `candidate/v0.12.20-exit-demo` to `main`.
4. The Pull Request is merged on GitHub.
5. GitHub Desktop fetches the updated remote state.

## Preserved previous build

```text
Branch: candidate/v0.12.18-demo-quality
Commit: 88d7195078a56bb30b68bd8cfff40f6ef72c26c3
```

Do not modify or delete this branch during v0.12.20 promotion.

---

# 4. Product identity

## Name

**Hussle**

Earlier names included Humper and Humpr. Hussle is the current working product name until Tony explicitly changes it.

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

No text, logo, badge, button, or safe-area control may overlap or crowd another control.

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

## Demo structure

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

## Existing architecture

Verified repository structure includes:

- SwiftUI views;
- `AppStore` as central observable application state;
- XcodeGen project generation;
- Demo data through `MockData`;
- Supabase-oriented authentication, profile, discovery, swipe, chat, safety, storage, and realtime services;
- separate Demo and real-account behavior.

## Stability rule

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

## Generated project

`Hussle.xcodeproj` is generated locally by XcodeGen.

It may appear as an untracked local folder after generation. Do not commit it unless repository policy is explicitly changed.

---

# 10. Demo asset rules

Generate clean source assets only.

## Dog image

- dog only;
- one animal;
- realistic photography;
- no owner;
- no UI;
- no text;
- no profile card.

## Owner image

- owner only;
- no dog;
- realistic photography;
- no UI;
- no text.

## Diversity

Maintain strong variation across:

- breeds and coloration;
- ethnicity;
- age;
- body type;
- hairstyle;
- clothing;
- pose;
- background.

Avoid near-duplicate characters and repetitive green-park backgrounds.

## File structure

```text
Assets/DemoLibrary/Dogs
Assets/DemoLibrary/Owners
HussleApp/Hussle/Resources/DemoImages
```

Use stable lowercase filenames and do not rename accepted assets casually after code references exist.

---

# 11. Git, GitHub, and Mac workflow

## Separate copies

There are two separate working locations:

1. remote repository on GitHub;
2. local repository on Tony’s Mac.

Creating or editing a branch on GitHub does not automatically change files on the Mac.

## GitHub Desktop actions

- **Fetch origin:** learn about new remote branches and commits without applying them to working files.
- **Pull origin:** download remote commits into the currently selected local branch.
- **Commit:** save selected local changes into local Git history.
- **Push origin:** upload local commits to GitHub.

## Remote-first assistant workflow

When ChatGPT changes GitHub through the connected GitHub tool:

1. the remote branch changes first;
2. Tony presses `Fetch origin` in GitHub Desktop;
3. Tony selects the required branch;
4. Tony presses `Pull origin` when offered;
5. only then do the updated files exist locally on the Mac.

## Branch-switch safety

When GitHub Desktop asks what to do with local changes while switching branches:

- choose **Leave my changes on [current branch]** when the changes must not move into the target branch;
- do not choose **Bring my changes to [target branch]** unless mixing those local changes is explicitly intended.

After switching to a clean Candidate branch, confirm `0 changed files` before building.

## Authentication

Use GitHub Desktop/browser authentication for routine work.

Do not enter:

- Google password;
- ordinary GitHub password;
- Mac password;

into Git HTTPS prompts. Terminal HTTPS operations require a properly configured credential or Personal Access Token, but Terminal authentication is not required for the approved Desktop workflow.

---

# 12. Permanent lessons from 23 July 2026

## Lesson 1 — branch creation must use the exact approved commit

Never create a Candidate from a branch whose ancestry has not been checked.

Required evidence:

- exact source branch;
- exact source SHA;
- merge base comparison;
- reviewed diff.

## Lesson 2 — GitHub access does not prove the Mac is running that branch

Before a build, verify in GitHub Desktop:

- current branch;
- clean Changes list;
- latest remote commit downloaded.

A correct remote branch can still be tested incorrectly if the Mac is on `main`, has local changes, or is using a stale generated Xcode project.

## Lesson 3 — never describe a screenshot from expectation

Only describe what is actually visible.

Do not infer a dog, screen, control, or version that is not shown.

## Lesson 4 — a successful compile is not complete visual QA

The first v0.12.20 build compiled and launched, but Exit Demo overlapped the Hussle logo.

Therefore every UI change requires a visual pass on all affected screens, not only compile success.

## Lesson 5 — global overlays need screen-specific spacing review

A reusable safe-area control can conflict with custom headers.

Before handoff, inspect:

- branding;
- navigation buttons;
- settings icons;
- sheets;
- pushed views;
- small-screen layouts.

## Lesson 6 — documentation must be finalized before tagging

The stable tag must point to the branch head after:

- code approval;
- release status update;
- release audit update;
- master guide update;
- worklog update.

## Lesson 7 — GitHub Desktop is the default beginner-safe workflow

Prefer exact English UI labels and one action at a time.

Do not require Terminal authentication when Desktop/browser can perform the same operation safely.

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
- UI test coverage added but execution not confirmed;
- release gate expanded;
- Discover header collision found and corrected;
- Xcode build and Simulator launch succeeded on Tony’s Mac;
- corrected UX manually accepted;
- Tony approved v0.12.20 as latest stable build.

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

After this documentation commit appears on GitHub:

1. In GitHub Desktop, stay on `candidate/v0.12.20-exit-demo`.
2. Press **Fetch origin**.
3. Press **Pull origin** when offered.
4. Confirm the documentation commit is the top item in **History**.
5. Create and push tag:

```text
v0.12.20-stable
```

6. Create a Pull Request:

```text
base: main
compare: candidate/v0.12.20-exit-demo
```

7. Merge it on GitHub.
8. Do not delete `candidate/v0.12.18-demo-quality` or `candidate/v0.12.20-exit-demo` yet.
9. Return to GitHub Desktop and press **Fetch origin**.

After promotion, the next development branch must be created from `main` or `v0.12.20-stable`, not from memory or an older local branch.

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
