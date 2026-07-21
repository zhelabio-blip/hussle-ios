# Proposed App Store Privacy Disclosure — Hussle 1.0

This document is a working map for App Store Connect. The final answers must reflect the exact production build, backend logs and every third-party SDK.

## Data linked to the user

### Contact information
- Email address
Purpose: account management, authentication, support and security.

### User content
- Dog and optional owner photos
- Dog profile information
- Vaccination records and optional document images
- Messages
- Support requests and reports
Purpose: app functionality, safety, moderation and support.

### Identifiers
- Internal user ID
- Device push token
Purpose: authentication, account functionality, security and notifications.

### Location
- Approximate location
Purpose: nearby discovery and distance calculation.

The production design should not return precise coordinates to other users. Confirm whether the backend temporarily processes precise device coordinates; if it does, disclose Precise Location as collected even when the public UI shows only approximate distance.

### Usage data
- Product interaction events such as profile completion, swipes, matches and feature usage
Purpose: analytics and product improvement, only if production analytics are enabled.

### Diagnostics
- Crash data and performance data
Purpose: app functionality and diagnostics, only if crash-reporting or monitoring is enabled.

## Tracking
Planned answer for version 1.0: No.

Hussle should not combine its data with third-party data for targeted advertising, sell user data or use advertising identifiers in version 1.0.

## Data not collected in version 1.0
- Financial information
- Contacts/address book
- Browsing history
- Search history outside Hussle
- HealthKit or Apple Health data
- Advertising identifiers

## Third-party processing to verify before submission
- Supabase
- Any image moderation provider
- Any crash analytics provider
- Any product analytics provider
- Email delivery provider

## Required validation
Before submission, compare this file with:
- actual network traffic from the Release build;
- server and Edge Function logs;
- PrivacyInfo.xcprivacy;
- every included SDK privacy manifest;
- current App Store Connect data-type definitions.
