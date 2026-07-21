# Hussle v0.12.14 Candidate — Release Gate

Baseline: approved behavior contract assembled from the accepted v0.11–v0.12.x product decisions. This Candidate is **not** a Last Approved Build until Tony writes “Сборка утверждена”.

## Change set
- RESTORED: Demo Mode now begins at onboarding welcome, matching the approved journey.
- PRESERVED: backend-configured Auth screen still exposes Demo Mode.
- PRESERVED: onboarding data is user-entered; profile is not pre-completed on entry.
- PRESERVED: Supabase, email-confirmation handling, and single auth-error presentation from v0.12.13.
- IMPROVED: demo dog/owner image assets re-exported at higher pixel dimensions with safer centered composition and full-bleed backgrounds.
- ADDED: UI regression assertion that Demo Mode opens onboarding and does not jump directly to Discover.
- ADDED: immutable product contract and automated static release-gate script.

## Five-pass audit
1. Functional inventory: required source files, screens, services, migrations and demo assets present.
2. Journey/state audit: Auth → Demo → Onboarding, Back/state preservation code, completion → Main.
3. Visual/data audit: 12 demo assets readable, dimensions checked, circular fill code and Match dog-to-dog composition checked.
4. Backend/security audit: canonical migration, publishable client configuration, Auth/REST/Storage/Realtime code retained, forbidden storage-table deletes absent.
5. Regression/diff audit: Candidate compared against v0.12.13; only declared source and asset changes accepted.

## Validation boundary
- Static release gate: PASSED in the packaging environment.
- Archive integrity: PASSED.
- Xcode compile: NOT available in this environment; must be confirmed on Tony's Mac.
- Simulator visual walkthrough: NOT available in this environment; must be confirmed before approval.
