# Hussle iOS

Hussle is an English-language SwiftUI app for helping dog owners discover nearby compatible dogs for breeding, friendship, and walks.

## Repository structure

- `HussleApp/` — iOS application source code and bundled resources.
- `Tests/` — unit and UI tests.
- `Supabase/` — database migrations, Edge Functions, and backend setup material.
- `Configs/` — Xcode build configuration files. Local secrets are excluded from Git.
- `Docs/` — product, process, architecture, QA, release, and setup documentation.
- `Assets/` — shared branding, mockups, screenshots, and demo material not bundled directly into the app.
- `AppStore/` — App Store metadata, legal drafts, privacy material, screenshots, and review notes.
- `Scripts/` — repository checks and release utilities.
- `Tools/AdminDashboard/` — lightweight moderation dashboard.

## Generate the Xcode project

Install XcodeGen once:

```bash
brew install xcodegen
```

From the repository root:

```bash
xcodegen generate
open Hussle.xcodeproj
```

Then select your Apple Development Team in Xcode under **Signing & Capabilities**.

## Local Supabase configuration

```bash
cp Configs/Secrets.xcconfig.example Configs/Secrets.xcconfig
```

Add the Supabase Project URL and publishable key to the local file. Never commit service-role keys or other server secrets.

Backend instructions are in `Supabase/` and `Docs/Setup/`.

## Verification status

This package was reorganized and checked statically outside macOS. It has **not** been compile-verified with Apple SDKs. A successful Xcode build on macOS is required before it may be described as compile-verified or approved.

## Current baseline

Source baseline: `HussleApp_Prototype_v0.12.16_Candidate`.

Repository restructuring baseline: `v0.12.17 Repository Start`.
