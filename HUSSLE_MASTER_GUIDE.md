# HUSSLE — MASTER PROJECT GUIDE & WORKLOG

**Purpose of this document:**
This is the single working source of truth for continuing development of Hussle without reconstructing the project from memory or from a long chat history.

**Last updated:** 23 July 2026
**Current stable base:** `v0.12.17-baseline`
**Current near-term target:** `v0.12.18 — Demo Quality Update`
**Repository:** `~/Documents/GitHub/hussle-ios`

---

# 1. How to use this file

Before making any change to Hussle:

1. Read this file first.
2. Check the current Git branch and status.
3. Confirm the exact current task.
4. Do only that task.
5. Do not introduce adjacent improvements unless they are required to complete the current task.
6. After every completed task, update:
   - current status;
   - files changed;
   - assets approved;
   - next exact step;
   - unresolved decisions.

This document must be updated whenever:
- the approved roadmap changes;
- a new build becomes the stable baseline;
- a demo asset is approved or rejected;
- the order of screens changes;
- new product decisions are made;
- a recurring error is discovered.

Do not rely on chat memory alone.
Do not rely on a model saying “I will remember.”
The repository and this file are the source of truth.

---

# 2. Product identity

## Working name

**Hussle**

Earlier names included Humper and Humpr.
Hussle is the current working product name until the owner explicitly changes it.

## Product shorthand

“Приложение для собак” / “the dog app.”

## Platform

- iPhone app
- SwiftUI
- Xcode project
- App language: English
- Goal: App Store-ready product

## Current product concept

A lightweight, visual, Tinder-like app for dog owners.

Primary product idea:
- find nearby dogs;
- prioritize relevant matches;
- initially emphasize same-breed discovery and purpose;
- enable mutual interest;
- move users toward real-world walks, playdates, friendship, community, or responsible breeding.

The original concept was strongly associated with:
- local discovery;
- swipe interface;
- same-breed matching;
- breeding as a possible goal.

The competitor research showed that “Tinder for dogs” is a useful acquisition hook, but not a sufficient full product strategy. The product must create value beyond swiping.

---

# 3. Current stable technical base

## Git status recovered during the session

The repository was restored from the original ZIP and returned to a clean, understandable state.

Known Git history:

```text
a9d8164 (HEAD -> main, origin/main, origin/HEAD) Update .gitignore
7e27261 Add competitor research and ignore local secrets
63a2d45 (tag: v0.12.17-baseline) Fix LocationManager Swift concurrency warning
2cc8ef7 Initial Hussle project structure
```

## Stable reference point

```text
v0.12.17-baseline
```

This is the safe base for future comparison and recovery.

## Files intentionally treated differently

- `COMPETITOR_RESEARCH_2026.md`
  - tracked;
  - part of repository knowledge.
- `Configs/Secrets.xcconfig`
  - local secret configuration;
  - ignored by Git;
  - must never be committed.

## Important Git rules

Before changing code:

```bash
cd ~/Documents/GitHub/hussle-ios
git status
git branch --show-current
git log --oneline --decorate -10
```

Never assume the repository is clean.

Before any risky refactor:
- create a commit;
- or create a branch;
- or create a tag if it is a confirmed stable milestone.

Never mix:
- asset generation;
- UI redesign;
- backend changes;
- architectural refactors;
- troubleshooting;
in one untracked batch.

---

# 4. Existing app and previously confirmed behavior

The last working demo build is not a blank prototype. It already contains:

- onboarding;
- owner profile fields;
- dog profile fields;
- breed selection;
- age;
- vaccination dates;
- goals;
- location/radius;
- Discover;
- swipe/Pass/Like interaction;
- Match flow;
- demo/mock data;
- a light minimalist design direction.

## Approved design direction

- light;
- minimalist;
- lots of white space;
- large dog image;
- little text;
- clear hierarchy;
- soft purple/pink accents;
- large Pass and Like buttons;
- readable in one or two seconds;
- no heavy explanatory interface.

The previously proposed block explaining “how matches are prioritized” was removed because it added too much text.

## Existing ranking concept

Discover priority should be:

1. same breed + relevant goal;
2. breed match before goal-only match;
3. then other relevant candidates;
4. if few results:
   - suggest increasing radius;
   - or adding/expanding goals.

This principle remains valuable, but the exact implementation must be checked against the current code before changing it.

---

# 5. Known onboarding requirements and fixes

These requirements were confirmed after running the prototype.

## Owner name

Use:

```text
Your name
What should we call you?
```

Do not use wording that could be interpreted as the dog’s name.

## Required fields

- required fields must be visibly clear;
- indication should be subtle;
- Continue must not appear broken;
- if a field is missing, show clear guidance.

## Navigation

- a Back arrow must exist on every later onboarding step;
- no dead-end screens;
- no screen should feel “stuck.”

## Goals

- goals must support multi-select;
- goals should remain internally consistent;
- inconsistent labels or typos must be corrected;
- goal choices should reflect the product strategy.

Possible purpose set from research:

```text
Same breed
Walks
Playdates
Friends
Breeding
```

This set is not automatically approved for immediate implementation. It must be reconciled with existing code and UX.

## Location

Location input needs:
- city-country autocomplete;
- consistent behavior everywhere;
- no isolated free-text implementations that behave differently across screens.

## Layout

All screens need spacing review:
- text must not crowd controls;
- text must not crowd image previews;
- cards must not feel compressed;
- safe areas must be respected.

## Demo cards

Previous prototype issues:
- missing dog photos;
- incomplete cards;
- inconsistent card content.

All demo cards must be complete and structurally consistent.

---

# 6. Competitor research: main conclusions

The repository contains `COMPETITOR_RESEARCH_2026.md`.

The research must inform Hussle, but it must not trigger an uncontrolled rewrite.

## Central conclusion

“Tinder for dogs” is a good hook, but a weak complete product strategy.

Why simple swipe products often fail:
- novelty is stronger than recurring value;
- swiping does not organize an actual meeting;
- unclear whether the people or dogs are dating;
- insufficient local density;
- inactive profiles;
- weak trust and safety;
- little reason to return;
- poor dog-to-dog compatibility logic.

## Market gaps identified

### 1. Active profile status

The product should eventually distinguish between:
- profile exists;
- owner was recently active;
- owner is actually open to meeting;
- dog is currently available;
- goal is still current.

Potential statuses:
- Active today;
- Available this weekend;
- Usually walks 6–8 PM;
- Open to a meetup.

Long-inactive profiles should be deprioritized or hidden.

### 2. Dog compatibility

Breed and distance are not enough.

Potential compatibility fields:
- energy level;
- temperament;
- play style;
- reaction to small dogs;
- reaction to large dogs;
- puppy tolerance;
- neutered/spayed status;
- leash behavior;
- anxiety/reactivity;
- preferred environment;
- vaccination status.

Long-term opportunity:
Hussle becomes a compatibility engine rather than a photo catalog.

### 3. Clear purpose

Every discovery candidate should have an understandable purpose:
- walk;
- regular walking partner;
- playdate;
- friendship/community;
- same-breed connection;
- responsible breeding.

Purpose should affect:
- onboarding;
- ranking;
- card messaging;
- match messaging.

### 4. Match to real meetup

A match should not end in an empty chat.

Long-term structured meetup flow:

1. choose a dog;
2. propose a walk;
3. choose time slots;
4. choose a safe public place;
5. other owner confirms;
6. reminders;
7. post-meet private compatibility feedback;
8. optionally suggest a repeat walk.

### 5. Trust and safety

Risks:
- fake profiles;
- aggressive dogs;
- false vaccination information;
- backyard breeding;
- stalking;
- unwanted human dating behavior;
- exposing exact home location.

Potential trust layer:
- approximate location;
- owner verification;
- selfie verification;
- vaccination verification;
- optional health documents;
- report/block;
- hidden owner details before mutual match;
- public meetup locations;
- private post-meet feedback;
- verified breeding mode.

### 6. Responsible breeding separation

Breeding must not be casually mixed into normal social discovery.

Long-term rules:
- explicit opt-in;
- suitable dogs only;
- separate verification;
- health and registration requirements;
- welfare rules;
- no puppy marketplace;
- no public sale listings;
- no design that encourages backyard breeding.

## Three strong positioning directions

### Compatibility before appearance

Find the right dog, not only the nearest or prettiest dog.

### From match to real walk

The app should turn profiles into actual confirmed walks.

### Same breed, same purpose, nearby

This is the sharpest early wedge:
- breed-first;
- purpose-first;
- local;
- real-world connection.

---

# 7. What the research does NOT mean

Do not redesign Hussle from zero.

Do not immediately build:
- a full social feed;
- stories;
- influencer features;
- marketplace;
- pet-services directory;
- travel platform;
- complex city map;
- a broad DogPack competitor;
- every compatibility field at once;
- full verification infrastructure before the demo is stable.

The correct approach is phased modernization.

The current stable demo should be improved incrementally.

---

# 8. Phased product roadmap

## Phase 0 — preserve the stable baseline

Status:
- completed;
- stable tag exists;
- repository recovered.

## Phase 1 — v0.12.18 Demo Quality Update

This is the immediate target.

Primary goals:
- replace weak/missing demo photos;
- create a coherent, polished Demo Library;
- preserve current app architecture;
- improve card text;
- add light research-informed messaging;
- avoid backend or major onboarding rewrites.

Candidate changes:
- high-quality dog photos;
- high-quality owner photos;
- visually complete demo cards;
- concise purpose;
- activity status;
- short reason for recommendation;
- short reason for match.

Examples:

```text
Same breed · Both looking for walks
Active today
Recommended because you share breed and purpose
```

Do not overfill the card.

## Phase 2 — compatibility and active-profile fields

Possible later additions:
- energy;
- temperament;
- play style;
- dog size preference;
- activity/availability;
- active-this-week filter.

Only after the demo flow is stable.

## Phase 3 — structured meetup flow

Possible later flow:
- propose walk;
- choose time;
- choose public place;
- confirm;
- reminder;
- completed meetup;
- repeat walk;
- private feedback.

## Phase 4 — trust layer

Possible later:
- owner verification;
- vaccination badge;
- report/block;
- approximate location;
- meet history;
- safety prompts.

## Phase 5 — verified breeding mode

Separate, strict, opt-in product mode.

Do not build as a casual extension of ordinary matching.

## Backend phase

Supabase remains the intended backend direction:
- authentication;
- database;
- dog profiles;
- location;
- ranking;
- swipes;
- matches.

Do not mix backend work into v0.12.18 unless it is technically required.

---

# 9. Demo scenario and resolved structure

## Confirmed original stable demo logic

The original working demo began with a Chihuahua profile.

The current Demo scenario includes:
- Charlie — Chihuahua;
- Luna — Chihuahua;
- Milo — Poodle;
- Buddy — Dachshund;
- Coco — Bichon Frise;
- Zoe — Golden Retriever;
- Max — French Bulldog;
- Nala — Cavalier King Charles Spaniel.

Important product logic:
- the onboarding/start profile is a Chihuahua;
- a second Chihuahua appears in Discover;
- this demonstrates same-breed relevance.

The two Chihuahuas should be visually different:
- different coloration;
- not duplicate images;
- still clearly same breed.

## Resolved extension

The Demo library has intentionally expanded to eight dogs total. Charlie is the current profile and the remaining seven dogs appear in Discover.

The accepted Zoe image is a Golden Retriever, so Zoe's mock-data breed was intentionally changed from Yorkshire Terrier to Golden Retriever. This keeps the visible portrait and metadata consistent.

---

# 10. Asset-generation workflow

This workflow is mandatory.

## General rule

Generate all approved source images first.
Integrate them into Xcode only after the library is complete and reviewed.

## Image separation

Each profile uses two separate images:

1. dog image;
2. owner image.

Never generate:
- dog + owner together;
- profile card;
- UI mockup;
- framed image;
- buttons;
- badges;
- text overlays;
- distance labels;
- app interface.

## Dog rule

“Dog” means:
- dog only;
- one animal;
- clean photographic image;
- no owner;
- no app UI;
- no text.

## Owner rule

“Owner” means:
- person only;
- no dog;
- no app UI;
- no text.

## Format

Preferred:
- square image;
- PNG;
- no white border;
- no baked-in circular crop;
- no transparent cutout unless specifically requested;
- subject centered with enough margin;
- safe for rectangular card and circular avatar crops;
- high enough resolution for iPhone display.

## Visual consistency

Use a broadly coherent photography standard:
- realistic;
- natural light;
- shallow depth of field;
- clear subject;
- uncluttered background;
- believable user-generated/lifestyle quality.

## Visual diversity

Do not generate a group of near-clones.

Vary deliberately:
- dog breed;
- dog coloration;
- dog size;
- indoor/outdoor location;
- city/park/home/beach;
- owner ethnicity;
- owner age;
- owner body type;
- hairstyle;
- wardrobe;
- facial structure;
- pose;
- composition.

A repeated “young, slim, smiling, European-looking person in the same park” is unacceptable.

## Approved interaction pattern

Because image generation may return only the image, use a two-message process:

### Step 1
User:

```text
Генерируй [Name] Dog
```

or

```text
Генерируй [Name] Owner
```

Assistant:
- generates only the clean image.

### Step 2
User:
- says “Ок,” “Принято,” “Приемлемо,” or requests changes.

Assistant:
- gives copyable filename;
- gives status;
- gives the exact next command.

Required response structure:

```text
Файл

owner-name.png
```

```text
Статус

✅ Принято
```

```text
Следующая команда

Генерируй Next Dog
```

Use code blocks for filename and command so the interface shows a copy button.

Do not try to draw copy buttons into the image.

---

# 11. Demo Library folder structure

Source/master assets should be stored outside Xcode asset catalogs first.

Recommended repository structure:

```text
Assets/
└── DemoLibrary/
    ├── Dogs/
    │   ├── dog-charlie.png
    │   ├── dog-luna.png
    │   ├── dog-milo.png
    │   ├── dog-buddy.png
    │   ├── dog-coco.png
    │   ├── dog-zoe.png
    │   ├── dog-max.png
    │   └── dog-nala.png
    └── Owners/
        ├── owner-tony.png
        ├── owner-anna.png
        ├── owner-james.png
        ├── owner-minh.png
        ├── owner-sophie.png
        ├── owner-emma.png
        ├── owner-daniel.png
        └── owner-olivia.png
```

After approval:
- copy/import the necessary files into the Xcode project;
- use stable asset names;
- do not rename casually after code references exist.

Possible app destination:

```text
HussleApp/Hussle/Assets.xcassets
```

or a dedicated resources folder if the current architecture uses one.

The actual integration path must be chosen after inspecting the current project structure.
Do not invent a new resources architecture without checking the existing Xcode project.

---

# 12. Asset progress at end of session

## Accepted

```text
dog-charlie.png
owner-tony.png

dog-luna.png
owner-anna.png

dog-milo.png
owner-james.png

dog-buddy.png
owner-minh.png

dog-coco.png
owner-sophie.png

dog-zoe.png
owner-emma.png

dog-max.png
owner-daniel.png
```

## Max correction

An incorrect Golden Retriever Max was generated and rejected.

Final accepted Max:
- French Bulldog;
- clean dog-only image;
- urban background.

## Emma correction

Several Emma generations were rejected because they looked too similar to Anna/Sophie.

Final accepted Emma:
- Black/African-looking woman;
- plus-size;
- braided hair;
- clearly different visual type;
- city background.

## Daniel

Accepted:
- man over 40;
- moustache;
- urban background.

## Completed additions

- `dog-nala.png`: accepted Cavalier King Charles Spaniel.
- `owner-olivia.png`: accepted owner portrait in an Asian city.
- `dog-luna.png`: accepted replacement on a seaside bench.
- `owner-james.png`: accepted replacement by a lake.

## Important review before coding

Review every accepted file side by side.

Check:
- no duplicate-looking owners;
- no repeated dog breeds unless intentional;
- no breed/image mismatch;
- no UI or text;
- safe crop;
- image quality;
- file naming;
- exact number of profiles required by v0.12.18.

---

# 13. Errors made during the session — never repeat

This section is deliberately explicit.

## Error 1: inventing breeds instead of checking the project

The assistant repeatedly proposed breeds from memory:
- multiple Golden Retrievers;
- changed Luna to Husky;
- proposed new character lists without checking the stable build.

Prevention:
- inspect MockData/current code first;
- treat the repository as source of truth;
- never assign breeds from memory.

## Error 2: changing the roadmap during execution

The task was asset generation, but the assistant repeatedly introduced:
- redesign ideas;
- new character bibles;
- new profile structures;
- new product strategy.

Prevention:
- finish the current approved task;
- place optional ideas in a backlog;
- do not interrupt execution with speculative redesign.

## Error 3: confusing dog and owner assets

Generated:
- combined dog + owner images;
- profile cards instead of source images.

Prevention:
- before every image call, verify:
  - current character;
  - Dog or Owner;
  - one subject only;
  - no UI;
  - no text.

## Error 4: adding UI/text into generated photos

Generated:
- profile interface;
- app buttons;
- filename labels;
- copy icons;
- Russian text directly on the image.

Prevention:
- copyable filename belongs in a later text message;
- source images must remain clean.

## Error 5: repeated similar people

Several female owners looked like the same person:
- similar age;
- similar face;
- similar body;
- similar hairstyle;
- similar smile;
- similar lighting.

Prevention:
- define contrast before generation;
- change several attributes simultaneously;
- compare with all approved owners before accepting.

## Error 6: repeated Retriever images

The assistant repeatedly fell back to Golden Retrievers even when:
- a different breed was required;
- the user explicitly requested variety;
- the existing demo already used other breeds.

Prevention:
- include breed explicitly;
- check the checklist;
- compare against all existing dogs;
- never use a generic “friendly dog” prompt.

## Error 7: forgetting the next-step comment

The assistant repeatedly promised to include:
- filename;
- status;
- next command;
but the image tool output did not reliably include later text.

Prevention:
- accept the technical limitation;
- use the two-message workflow;
- never promise simultaneous image + reliable follow-up text.

## Error 8: pretending a process fix worked when it did not

The assistant repeatedly said:
- “now this will never happen again”;
- “fixed format”;
without changing the actual process.

Prevention:
- change the workflow, not the wording;
- do not claim prevention unless there is a concrete mechanism.

## Error 9: excessive explanations instead of action

The user asked for concise forward motion.
The assistant often responded with long apologies, new frameworks, and unrequested improvements.

Prevention:
- answer the exact question;
- keep next step concrete;
- no repeated apology essays;
- no unsolicited expansion.

## Error 10: losing the approved sequence

The assistant sometimes skipped or renamed steps.

Prevention:
- read this checklist;
- update one checkbox at a time;
- never infer the next profile.

## Error 11: claiming certainty without verification

The assistant sometimes described project facts as confirmed when they were reconstructed from memory.

Prevention:
- label each fact as:
  - confirmed from code;
  - confirmed by user;
  - inferred;
  - unresolved.

## Error 12: mixing accepted image with wrong metadata

Example:
- Zoe accepted image appears inconsistent with earlier Yorkshire Terrier metadata.

Prevention:
- conduct a final asset-to-MockData reconciliation before coding.

---

# 14. Required assistant behavior for future sessions

## Response style

- concise;
- structured;
- one task at a time;
- no generic templates;
- no unnecessary “improvements” section;
- no new strategy unless the current task requires it.

## Development instructions

The user is not highly familiar with Xcode.

Therefore:
- give beginner-safe steps;
- specify exact file/path/button;
- use English Xcode/macOS menu names;
- avoid assuming knowledge;
- do not give five alternative approaches at once.

## Build honesty

Always distinguish:

- **code reviewed**;
- **files edited**;
- **project generated**;
- **build actually run**;
- **build succeeded**;
- **app manually tested**.

Never say “verified build” unless an actual build was executed.

## Troubleshooting

- do not change troubleshooting strategy mid-stream without explaining why;
- one concrete next step at the end;
- do not ask the user to repeat already-known device/project context;
- check the current repository first.

## Project changes

Before editing:
- inspect relevant files;
- state exact scope;
- avoid unrelated refactors.

After editing:
- list changed files;
- state what was not changed;
- state whether build was actually run;
- give one next step.

---

# 15. Integration workflow after assets are complete

## Step 1 — complete asset generation

Completed. Nala, Olivia, Luna replacement, and James replacement are approved.

## Step 2 — local file preparation

Save all approved images under exact filenames.

Check:
- extension;
- lowercase names;
- no spaces;
- no duplicate suffixes such as `(1)`;
- no accidental `.png.png`.

## Step 3 — repository package

Place the files in:

```text
Assets/DemoLibrary/Dogs
Assets/DemoLibrary/Owners
```

## Step 4 — create ZIP

Zip the full repository, not only images.

Reason:
- preserves folder names;
- preserves code;
- preserves project file;
- preserves current version;
- lets the assistant reconcile assets with actual Swift models.

## Step 5 — upload ZIP

Upload the latest full repository ZIP in the continuation session.

Also include this file:

```text
HUSSLE_MASTER_GUIDE.md
```

## Step 6 — inspect before editing

The assistant must inspect:
- current MockData;
- model types;
- image loading approach;
- asset catalog;
- onboarding;
- Discover;
- Match;
- profile/details;
- project build settings.

## Step 7 — reconcile profiles

Create a table:

| Profile | Breed in code | Accepted image | Owner | Decision |
|---|---|---|---|---|

Resolve all mismatches before integration.

## Step 8 — import assets

Import with stable names.

Do not:
- recreate images;
- crop destructively without keeping originals;
- alter accepted faces;
- silently rename profiles.

## Step 9 — v0.12.18 code changes

Only approved scope:
- demo image mapping;
- complete cards;
- light research-informed copy;
- spacing corrections required for assets;
- no backend rewrite;
- no major onboarding redesign.

## Step 10 — build

Run an actual Xcode build.

Record:
- scheme;
- simulator/device;
- build result;
- errors/warnings.

## Step 11 — manual demo test

Test full sequence:
- launch;
- onboarding;
- required fields;
- Back buttons;
- goal multi-select;
- location;
- Continue;
- Discover;
- all cards;
- Pass;
- Like;
- Match;
- owner image;
- dog image;
- spacing;
- no missing assets.

## Step 12 — commit

Only after working:

```bash
git status
git add ...
git commit -m "Build v0.12.18 demo quality update"
```

Tag only after the user confirms the build is stable.

---

# 16. Proposed v0.12.18 acceptance criteria

## Assets

- all intended dog images load;
- all intended owner images load;
- no placeholders;
- no duplicate faces;
- no wrong breed;
- no UI baked into images;
- no broken crop.

## Onboarding

- clear owner-name wording;
- required fields clear;
- Back works;
- goals multi-select;
- Continue works;
- missing-field guidance works;
- location autocomplete behaves consistently.

## Discover

- cards have consistent data;
- breed visible;
- age visible;
- distance visible;
- purpose visible;
- concise active status;
- concise reason for recommendation;
- Pass/Like work;
- no excessive explanatory copy.

## Match

- correct dog;
- correct owner;
- clear reason for match;
- next action understandable.

## Quality

- no text collisions;
- no content too close to controls;
- no overflow;
- no missing images;
- no debug artifacts;
- no secrets committed.

---

# 17. Research backlog — not immediate scope

Store these ideas for later:

## Compatibility fields
- energy;
- temperament;
- play style;
- leash behavior;
- reactivity;
- preferred meeting environment;
- dog-size tolerance;
- puppy tolerance;
- neutered/spayed.

## Activity
- Active today;
- Active this week;
- Available this weekend;
- open to meetup;
- usual walking hours.

## Meetup
- time proposals;
- safe location;
- confirmation;
- reminders;
- completed status;
- repeat walk;
- private feedback.

## Safety
- owner verification;
- vaccination verification;
- block/report;
- approximate location;
- hidden sensitive owner details.

## Business model
Free:
- one dog;
- basic discovery;
- limited radius;
- likes;
- mutual chat;
- basic meetup.

Potential Plus:
- larger radius;
- compatibility filters;
- breed-first search;
- see likes;
- travel mode;
- multiple dogs;
- priority visibility;
- availability calendar.

Verified breeding:
- separate verification fee;
- document review;
- health/genetic criteria;
- limited verified introductions.

Do not implement monetization before core product validation.

---

# 18. Decisions resolved for v0.12.18

The asset and Demo integration decisions are now explicit:

1. The Demo library contains eight dogs total: Charlie plus seven Discover candidates.
2. Zoe is a Golden Retriever and uses `dog-zoe.png`.
3. Max is a French Bulldog, paired with Daniel.
4. Nala is a Cavalier King Charles Spaniel, paired with Olivia.
5. Activity labels in this candidate are `Active today`, `Active this week`, and `Available this weekend`.
6. Every Discover candidate has one concise recommendation reason.
7. Luna remains the top same-breed/breeding match.
8. Owner portraits remain visible on Discover.
9. Match remains visually dog-to-dog and now repeats the concise recommendation reason.
10. Breeding remains visible in the ordinary Demo through Luna's profile and recommendation reason.

The exact profile-to-asset mapping is recorded in `Docs/QA/DEMO_ASSET_MATRIX_v01218.md`.

Future product questions remain outside this candidate:

- whether `Same breed` becomes a user-facing goal, a filter, or only a ranking preference;
- which compatibility, activity, safety, and meetup fields graduate from the research backlog.

---

# 19. Immediate continuation point

## Current status

All 16 Demo portraits are accepted and integrated:

- eight dogs: Charlie, Luna, Milo, Buddy, Coco, Zoe, Max, and Nala;
- eight owners: Tony, Anna, James, Minh, Sophie, Emma, Daniel, and Olivia.

The requested replacements are included:

- Luna is the long-haired white Chihuahua with brown patches on a seaside bench;
- James is the slim blond English man by a lake.

The candidate is on:

```text
candidate/v0.12.18-demo-quality
```

Static verification passes. The current environment does not contain Xcode, `xcodebuild`, `swiftc`, or XcodeGen, so no claim of successful compilation or Simulator behavior has been made.

## Next exact step

On macOS:

```bash
cd ~/Documents/GitHub/hussle-ios
xcodegen generate
open Hussle.xcodeproj
```

Then:

1. build the `Hussle` scheme;
2. run unit and UI tests;
3. complete the Demo journey in an iPhone Simulator;
4. review all image crops and text wrapping;
5. obtain Tony's explicit approval;
6. only then promote or tag the candidate.

---

# 20. Final operating principle

Hussle should progress through controlled, visible increments.

The correct order is:

```text
Inspect → Confirm scope → Execute one task → Verify → Record → Next task
```

Not:

```text
Remember vaguely → improvise → redesign → apologize → restart
```

Preserve what works.
Use the research to sharpen the product, not destabilize it.
Finish the current phase before opening the next one.
Keep the repository, this guide, and the approved checklist aligned.
