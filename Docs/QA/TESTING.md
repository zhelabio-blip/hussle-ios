# Hussle testing guide

## Test layers

- `HussleTests`: ranking rules, domain-model behavior and request mocking.
- `HussleUITests`: smoke launch in deterministic demo mode and core-tab visibility.
- Manual Xcode checks: permissions, PhotosPicker, Core Location, APNs, Keychain and Supabase Realtime.

## Run

```bash
xcodegen generate
open Hussle.xcodeproj
```

In Xcode, select **Product → Test**. The UI tests launch the application with `UITEST_DEMO`, so they do not require Supabase credentials.

## Required pre-TestFlight device matrix

- Current iOS release on a recent Pro Max-sized iPhone.
- A smaller supported iPhone screen.
- Light and Dark appearance.
- Dynamic Type at default, XL and an accessibility size.
- VoiceOver enabled for onboarding, Discover, Match and Chat.
- Location allowed, denied and manually selected.
- Photos access allowed, limited and denied.
- Online, offline at launch and connection loss during chat.
