# Hussle v0.12.20 — Exit Demo

## Source

- Source branch: `candidate/v0.12.18-demo-quality`
- Source commit: `88d7195078a56bb30b68bd8cfff40f6ef72c26c3`
- Approved Candidate branch: `candidate/v0.12.20-exit-demo`
- Approved code commit: `c0540bc273e35be036ff46b9a9b6cd2c841bd9ef`
- Final Candidate documentation commit: `dfba6921aa784d6575f8d0a485682ae98c7035bf`

## Added

- Reusable compact `Exit Demo` control.
- Dedicated `exitDemoMode()` reset path.
- Exit Demo availability for root navigation and app-controlled modal flows.
- UI test definitions for exiting Demo Mode from onboarding and the main experience.
- Release-gate checks for Exit Demo behavior and coverage.

## Changed

- Marketing version: `0.12.20`.
- Build number: `20`.
- Discover header spacing in Demo Mode was corrected to prevent collision between Exit Demo, the Hussle logo, and the settings icon.
- Repository maintenance now ignores generated `Hussle.xcodeproj/` output.

## Preserved

- Entire v0.12.18 Demo image library.
- Eight approved dog-owner pairs.
- Onboarding content and order.
- Discover card hierarchy, activity labels, recommendation reasons, and owner portraits.
- Match dog-to-dog composition.
- Existing backend, authentication, navigation, and data architecture outside the Demo exit path.

## Verification completed

- GitHub source, ancestry, and diff review.
- XcodeGen project generation on Tony’s Mac.
- Successful Xcode build and Simulator launch.
- Manual confirmation that the new build preserved all expected v0.12.18 Demo assets.
- Manual detection of an initial header collision.
- Header correction committed as `c0540bc273e35be036ff46b9a9b6cd2c841bd9ef`.
- Corrected build manually rechecked and accepted by Tony.

## Verification not confirmed

- Unit test execution.
- UI test execution.

## Approval and promotion

Tony approved v0.12.20 as the latest stable build on 23 July 2026.

Pull Request #1 merged:

```text
candidate/v0.12.20-exit-demo → main
```

Promotion merge commit:

```text
1d64a3544b3311a03783ca23dd6a38abe9289d86
```

The final stable tag `v0.12.20-stable` must be created on the final `main` commit after release-finalization maintenance is merged.
