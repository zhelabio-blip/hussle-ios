# Hussle v0.12.20 — Exit Demo

## Source

- Branch: `candidate/v0.12.18-demo-quality`
- Commit: `88d7195078a56bb30b68bd8cfff40f6ef72c26c3`

## Added

- Reusable compact `Exit Demo` control.
- Dedicated `exitDemoMode()` reset path.
- Exit Demo availability for root navigation and app-controlled modal flows.
- UI tests for exiting Demo Mode from onboarding and the main experience.
- Release-gate checks for Exit Demo behavior and coverage.

## Changed

- Marketing version: `0.12.20`.
- Build number: `20`.

## Preserved

- Entire v0.12.18 Demo image library.
- Eight approved dog-owner pairs.
- Onboarding content and order.
- Discover layout, activity labels, recommendation reasons, and owner portraits.
- Match dog-to-dog composition.
- Existing backend, authentication, navigation, and data architecture outside the Demo exit path.

## Verification status

- GitHub source and diff review: required and performed before handoff.
- Xcode compilation: pending on macOS.
- Unit/UI test execution: pending on macOS.
- Simulator visual and end-to-end review: pending on macOS.
- Candidate approval: pending Tony’s explicit confirmation.
