# App Review Notes — Hussle 1.0

## Summary
Hussle is a location-based social application for adult dog owners. Users create dog profiles and discover other dogs for responsible breeding discussions, walks and friendship.

## Core review flow
1. Create an account with the supplied review credentials.
2. Complete or open the prepared dog profile.
3. Allow approximate location access, or select a city manually.
4. Open Discover and swipe right on the prepared test profile.
5. The reciprocal test like creates a match.
6. Open Matches or Messages and send a test message.
7. Open a profile or conversation menu to verify Report, Block and Unmatch.
8. Go to Profile → Settings → Account → Delete Account to inspect the deletion flow. Do not complete deletion unless required.

## Review credentials
Email: REVIEW-ACCOUNT@YOUR-DOMAIN.example
Password: REPLACE-BEFORE-SUBMISSION

## Prepared test data
- Reviewer dog: Charlie
- Reciprocal test dog: Luna
- Test city: Da Nang
- Discovery radius: 25 km

## Location
The app uses approximate location only for radius-based discovery. Exact coordinates are not displayed to other users. Reviewers may choose a city manually when declining location permission.

## User-generated content safeguards
Hussle includes:
- profile and photo moderation states;
- report controls on profiles and conversations;
- blocking;
- unmatching;
- moderation queue and support contact;
- Community Guidelines;
- in-app account deletion.

## Responsible breeding
Hussle does not certify health, pedigree, fertility or genetic compatibility. A responsible-breeding notice is shown before breeding discovery.

## Purchases
Hussle 1.0 contains no subscriptions, in-app purchases or external payment flow.

## Account deletion
Profile → Settings → Account → Delete Account.
Deletion removes the user account and associated data through a protected Supabase Edge Function, except information that must legally be retained.

## Backend access
The production backend must be online throughout review. Ensure the prepared reciprocal test profile and match path remain available.
