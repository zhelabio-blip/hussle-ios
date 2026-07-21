# Hussle v0.12.4 — Demo Data and Location UX Audit

## Demo profiles

All demo dogs now include a bundled photograph and internally consistent profile data:

- Charlie — male Chihuahua, 3 years old, Breeding + Walks, Da Nang, Vietnam.
- Luna — female Chihuahua, 3 years old, Breeding + Walks, Da Nang, Vietnam.
- Milo — male Poodle, 4 years old, Walks + Friends, Da Nang, Vietnam.
- Buddy — male Dachshund, 2 years old, Walks + Friends, Da Nang, Vietnam.
- Coco — female Bichon Frise, 3 years old, Walks + Friends, Hoi An, Vietnam.
- Zoe — female Yorkshire Terrier, 2 years old, Friends, Hoi An, Vietnam.

The same dog photograph and profile data are reused consistently in Discover, full profile, match celebration, Matches, Messages, Chat, Profile, and profile editing.

## Location entry

Location entry is now an interactive autocomplete field in:

- onboarding;
- Edit Dog Profile;
- Discovery Preferences.

Behavior:

- The user types a few letters.
- Matching city-and-country suggestions appear immediately.
- Selecting a suggestion fills the full value, for example `Da Nang, Vietnam`.
- Clear and location icons make the field visibly interactive.
- Validation explains what is missing instead of silently blocking progress.

The bundled city list is suitable for the prototype. Before the public release, this component should be connected to Apple MapKit local search or another production geocoding provider for global coverage.

## Form-state review

Checked that required actions are explained on authentication, onboarding, dog editing, vaccinations, discovery settings, reporting, and account deletion screens. Buttons that cannot proceed show inline guidance rather than leaving the user to guess.
