# Hussle v0.12.13 Release Gate

## Preserved product surfaces
- Authentication: Sign Up and Log In
- Independent Demo Mode entry regardless of backend configuration
- Owner/dog onboarding code and back-navigation preservation
- Discover cards, dog/owner portrait composition, Pass/Like/Profile actions
- Dog-to-dog Match screen
- Matches, Messages, Chat, Profile, dog editor, vaccinations, discovery settings, safety flows
- Supabase backend configuration, migration, REST, Auth, Storage and Realtime service code

## Regression fixes
- Demo Mode no longer depends on missing Supabase keys.
- Demo Mode opens the complete populated app directly.
- Sign-up supports Supabase responses with no session while email confirmation is pending.
- Authentication errors are no longer duplicated in the global banner and form.
- Added clear email-confirmation feedback and safer user-facing auth errors.

## Visual audit
- Dog and owner circles use scaled-to-fill with explicit clipping.
- Discover composition remains fixed at 214/62 points.
- Match remains dog-to-dog only.
- Authentication spacing and horizontal padding increased.
- Demo entry is visually separated but uses the same design system.

## Validation level
- Full static source audit completed.
- File/routes/assets regression inventory completed.
- Xcode compilation and Simulator runtime must be confirmed on macOS by the user.
