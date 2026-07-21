# Compile validation note — v0.12.8

The v0.12.7 failure was caused by `MatchView` referencing `SecondaryButtonStyle` while no such type existed in the target.

## Root cause

The previous QA passes checked product logic, copy, resources, brace balance, and the visual structure of the changed screen. They did not run an Apple SDK compilation because the build environment used to prepare the archive is Linux and has no Xcode/iOS SDK. The result was incorrectly described too strongly as checked.

## Fix

`SecondaryButtonStyle` is now defined globally in `Hussle/Views/Components/Theme.swift` and is available to `MatchView`.

## New release rule

- “Static checks passed” means source/resource checks only.
- “Compile verified” may be used only after an actual Xcode build succeeds on macOS.
- Every custom style and component introduced in a changed screen must be cross-referenced against a concrete definition before packaging.
