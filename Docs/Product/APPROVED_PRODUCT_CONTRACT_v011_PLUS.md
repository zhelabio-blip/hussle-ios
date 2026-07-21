# Hussle approved product contract — baseline from v0.11 onward

## Entry and authentication
- English UI.
- Start screen offers Sign Up, Log In, and Demo Mode.
- Demo Mode remains available even when Supabase is configured and when network/auth fails.
- Authentication validation identifies missing required fields.
- Auth errors are shown once, inside the form, not duplicated globally.
- Email-confirmation registration without a session is handled as a valid pending-confirmation state.

## Demo Mode exact route
Authentication → Demo Mode → onboarding/profile creation → main app.
Demo Mode must never jump directly to a pre-completed Discover state when entered through the user-facing Demo button.

## Onboarding
- Six-step flow begins with Welcome.
- Owner is entered before dog details.
- Label: “Your name”; explanation distinguishes owner name from dog name.
- Owner photo is required.
- Back is available after the first screen and preserves entered data.
- Goals are multi-select: Breeding, Walks, Friends.
- No visible primary-goal picker; first selected remains primary internally.
- Required fields have visible chips, inline explanation, validation, and no silent blockers.
- Location supports city-country suggestions and approximate location/radius.
- Review Profile uses a large circular dog photo with a smaller circular owner photo overlapping lower-right.
- Discover opens only after onboarding is completed.

## Main app
- Tabs: Discover, Matches, Messages, Profile.
- Discover ranking: same breed + same goal; same breed; same goal; others; then distance, completeness, activity.
- No silent unrelated results; suggest expanding radius/goals/breeds when exhausted.
- Discover cards have a consistent large dog image and small owner portrait, fixed sizes and offsets.
- Pass and Like buttons are large, rounded, and consistent.
- Match is dog-to-dog only; owner photos never appear as a side of the match.
- Owner photos remain contextual in profiles, Discover, Messages, and Chat.
- Demo data covers Discover, dog profile, swipes, match, matches, messages, chat, profile, editors, and settings.

## Visual system
- White minimal UI, generous whitespace, purple/pink accents, rounded cards.
- Text never touches screen edges, previews, or buttons; wrap or shorten instead.
- Circular photos are completely filled, clipped, without internal white borders.
- Dog faces remain visible and centered in circular frames.
- All cards use identical image dimensions, offsets, and spacing.
- No generated-looking UI screenshots inside owner portraits.

## Backend and safety
- Supabase URL and publishable key only in client; never secret/service-role keys.
- One canonical bootstrap migration; no direct SQL deletion from storage system tables.
- Auth, REST, Storage, RLS, Realtime, account deletion, reporting and blocking remain in architecture.
