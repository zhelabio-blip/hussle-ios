# Hussle Candidate v0.12.14 — five-pass audit

## Pass 1 — baseline preservation
Result: PASS (static).
- Compared against v0.12.13 candidate file-by-file.
- No existing file was removed.
- Existing code changes are limited to AppStore demo routing and its UI regression test.
- Existing asset changes are limited to the 12 approved demo portraits.
- Backend, views, services, models, migrations, configs and documentation remain present.

## Pass 2 — exact route and state logic
Result: PASS (static).
- User-facing Demo Mode remains available with configured Supabase.
- Demo entry now sets `launchState = .onboarding`.
- Demo entry no longer jumps to `.main`.
- Demo state is reset before onboarding to prevent stale selected cards, conversations, match overlays or tabs.
- RootView still maps authentication → onboarding → main explicitly.

## Pass 3 — approved UX and design contract
Result: PASS (static code + asset inspection).
- Owner-first onboarding, required owner photo, multi-goal selection and Back-with-state-preservation remain.
- Review profile composition remains dog circle + smaller owner circle.
- Discover composition remains consistent dog/owner portrait.
- Match remains dog-to-dog.
- All 12 demo assets decode correctly; dog assets are 1600×1600 and owner assets 1200×1200.
- Affected dog assets were center-cropped to remove baked white margins and keep the face in the circular safe area.

## Pass 4 — backend and integration preservation
Result: PASS (static).
- Auth, profile, Storage, Realtime, safety, discovery, swipe and chat services remain.
- Canonical bootstrap migration remains.
- No forbidden direct deletion from `storage.objects` or `storage.buckets` is present.
- No client secret/service-role value is embedded.

## Pass 5 — syntax, tests and package integrity
Result: PASS within available environment.
- Every Swift file passed Swift frontend syntax parsing.
- Regression UI test now asserts Demo Mode opens onboarding and does not jump to Discover.
- ZIP integrity test passed with no compressed-data errors.

## Not yet verified
- XcodeGen generation on macOS.
- Xcode compilation for v0.12.14.
- Simulator visual walkthrough and console check.
- Automated UI test execution on an iOS Simulator.

This is a Candidate Build, not a Last Approved Build. It becomes the baseline only after Tony writes: «Сборка утверждена».
