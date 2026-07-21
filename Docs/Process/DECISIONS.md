# Architecture and Product Decisions

## 2026-07-21 — Repository structure
The project uses a product-level repository. iOS source code lives in `HussleApp/`, while documentation, backend, tests, App Store material, scripts, configuration, and shared assets remain separate top-level concerns.

## 2026-07-21 — Verification language
Static checks never substitute for an actual Xcode build. Compile verification requires macOS, Xcode, and Apple SDKs.
