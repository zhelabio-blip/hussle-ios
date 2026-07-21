# Hussle Ultimate Release Gate

Every Candidate Build must pass all five gates before delivery.

## Gate 1 — Baseline preservation
- Diff Candidate vs Last Approved Build.
- Confirm every approved screen, file, asset, route, tab, action, state and copy remains.
- Compare exact start points and route order, not merely file presence.
- Confirm Back behavior and state preservation.
- Confirm no feature is hidden by configuration, authentication, network, feature flags or data state.

## Gate 2 — Full user journeys
Run/inspect separately:
1. New real user: launch → sign-up → email-confirmation state → login → onboarding → main.
2. Returning user: launch → restored session → main.
3. Demo user: launch → Demo Mode → onboarding → review → Discover → profile → swipe → match → matches → messages → chat → profile/settings.
4. Failure path: offline/auth error/empty results/validation/storage failure.
5. Safety path: report/block/logout/delete-account entry.

## Gate 3 — UI/UX and design-code
- Screen-edge padding and vertical spacing.
- Dynamic text wrapping and no overlap.
- Required-field guidance and one clear error location.
- Consistent buttons, cards, radii, typography and iconography.
- Dog/owner photo crops, face visibility, fill, clipping, resolution and no accidental screenshots.
- Dog-to-dog Match composition.
- Accessibility labels, hit targets and contrast.

## Gate 4 — Architecture, data and integrations
- Swift models vs SQL schema/RPC response compatibility.
- RLS/authenticated vs anonymous behavior.
- Storage paths and policies.
- Realtime publication and subscriptions.
- Navigation/state ownership; no configuration-coupled feature loss.
- Migration idempotency/transaction safety; no forbidden storage-table mutations.
- Secrets excluded from source control and archive.

## Gate 5 — verification evidence
- Static whole-project audit.
- Automated tests updated for every regression.
- XcodeGen generation.
- Xcode Build result on macOS.
- Simulator walkthrough with screenshots and console review.
- Changelog, acceptance matrix, known limitations and Current Status.

No Candidate becomes baseline until Tony writes: «Сборка утверждена».
