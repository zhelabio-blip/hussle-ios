# Hussle production checklist

## Backend
- Apply migrations `0001` through `0008`.
- Deploy `delete-account`, `push-notifications`, and `photo-moderation` Edge Functions.
- Configure APNs secrets and photo-moderation webhook secret.
- Create at least two moderator accounts for operational coverage.
- Confirm Storage buckets remain private.
- Verify RLS using owner, ordinary user, moderator, and unauthenticated test accounts.

## iOS
- Set production bundle ID and Apple Developer team.
- Add Sign in with Apple capability before enabling that login option.
- Add Push Notifications and Background Modes capabilities.
- Populate Release Supabase settings through CI or a local uncommitted xcconfig.
- Test account deletion, notification permissions, denied location, and denied photo access.
- Validate PrivacyInfo.xcprivacy against every included SDK.

## Moderation
- Define response targets for urgent animal-abuse and threat reports.
- Connect real image-content moderation or human review; file validation alone is insufficient.
- Publish Community Guidelines and an appeal/contact path.
- Retain moderation audit records according to the final Privacy Policy.
