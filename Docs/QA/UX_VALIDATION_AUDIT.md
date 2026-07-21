# Hussle UX Validation Audit — v0.12.2

Goal: a user must never have to guess why an action did not work or what is required to continue.

## Validation pattern used throughout the app

- Required inputs have a visible **Required** capsule next to the field label.
- Required controls use a calm purple outline before interaction.
- When the user tries to continue or save with missing information:
  - the relevant field receives a red outline;
  - an inline error explains the exact missing action;
  - a page-level message summarizes the first blocker;
  - VoiceOver announces the missing requirement.
- Primary actions remain tappable when practical so tapping them reveals the blocker instead of silently doing nothing.
- Loading is the only normal reason an action becomes temporarily disabled.

## Screens reviewed

### Authentication
- Email and password are visibly marked Required.
- Invalid email and short password receive exact inline messages.
- Submit announces missing fields.
- Demo Mode remains clearly available when Supabase is not configured.

### Onboarding — owner and goals
- First name is visibly marked Required.
- Placeholder example is shown.
- Multi-select goal behavior is explicit: one, two, or all three.
- At least one goal is required.
- The confusing primary-goal picker is removed.
- Continue reveals missing requirements and does not silently fail.

### Onboarding — dog details
- Dog name, breed, sex, and date of birth are grouped and labelled.
- Required details are visually differentiated.
- Dates cannot be set in the future.

### Onboarding — health
- At least one vaccination record is required for an active profile.
- Empty vaccination state includes an Add vaccination action.

### Onboarding — location
- User can use current location or enter a city manually.
- Missing location produces an exact instruction.

### Dog profile editor
- Photo, name, goals, vaccination record, and city are validated.
- Save remains actionable and reveals all missing requirements.
- Save failure is shown in an alert.

### Add vaccination
- Vaccination name and date are labelled.
- Missing name is explained inline.

### Discovery preferences
- The user cannot accidentally deselect the final active goal.
- A visible explanation appears when attempting to do so.
- Location guidance explains the available alternatives.

### Chat
- Send is disabled only when the message is empty or currently sending.
- The text field and send button make the reason self-evident.

### Report
- A reason is required.
- Details become explicitly required when Other is selected.

### Delete account
- The exact confirmation phrase is explained before the field.
- Incorrect confirmation produces an inline message.
- A final destructive confirmation is required.

### Notification settings
- System permission state is visible.
- When permission is denied, Open iOS Settings is shown.
- Notification toggles are disabled only with a visible reason and recovery path.

## Remaining real-device checks

- Test Dynamic Type at the largest accessibility sizes.
- Test VoiceOver focus order on every form.
- Test keyboard avoidance on smaller iPhones.
- Test all permission-denied flows on a physical iPhone.
- Test low-connectivity and complete offline transitions.


## v0.12.3 navigation and identity clarity

- The first onboarding form explicitly distinguishes the owner’s name from the dog’s name.
- All onboarding steps after Welcome expose a visible Back control.
- Back navigation preserves the in-memory draft, including selected goals, owner name, dog data, vaccinations, city and radius.
