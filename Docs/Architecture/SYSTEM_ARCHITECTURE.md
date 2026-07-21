# System Architecture

## Client
- SwiftUI iOS application
- ViewModels and service-oriented client layer
- Keychain-backed authentication session
- Demo Mode fallback

## Backend
- Supabase Auth
- PostgreSQL and PostGIS
- Row Level Security and RPC functions
- Supabase Storage
- Edge Functions for privileged operations and notifications

## Supporting surfaces
- Moderation dashboard in `Tools/AdminDashboard/`
- Build configuration in `Configs/`
- App Store package in `AppStore/`

## Architectural rule
Repository moves must preserve XcodeGen paths, resource inclusion, entitlements, configuration references, tests, and backend deployment paths.
