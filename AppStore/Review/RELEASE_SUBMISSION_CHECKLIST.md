# Hussle 1.0 — Release Submission Checklist

## Apple and build
- [ ] Active Apple Developer Program membership
- [ ] Final bundle identifier and App Store Connect record
- [ ] Build generated with Xcode 26 or later and iOS 26 SDK or later
- [ ] Release signing, distribution certificate and provisioning profile
- [ ] Push Notifications capability and production APNs credentials
- [ ] Archive validates without errors
- [ ] TestFlight internal testing completed
- [ ] External beta review completed when needed

## Product
- [ ] Authentication, session refresh and Sign in with Apple decision confirmed
- [ ] Production Supabase project and all migrations deployed
- [ ] Edge Functions deployed with secrets stored server-side
- [ ] Prepared App Review account and reciprocal test profile
- [ ] Location denial/manual-city path tested
- [ ] Photo moderation and report queue operational
- [ ] Report, Block, Unmatch and account deletion tested end to end
- [ ] Support channel monitored

## Privacy and legal
- [ ] Privacy Policy hosted on a public HTTPS page
- [ ] Terms and Community Guidelines hosted or accessible in app
- [ ] Legal entity, address and emails inserted
- [ ] PrivacyInfo.xcprivacy validated
- [ ] All third-party SDK privacy manifests reviewed
- [ ] App Store privacy answers match production behavior
- [ ] Data retention periods documented
- [ ] International-transfer terms reviewed

## Storefront
- [ ] Final app icon
- [ ] App name availability and trademark screening
- [ ] Subtitle, description, promotional text and keywords entered
- [ ] Support, marketing and privacy URLs working
- [ ] Six final screenshots captured from submitted build
- [ ] Age-rating questionnaire completed accurately
- [ ] Social-media capability descriptor completed when App Store Connect requests it
- [ ] Review notes and credentials entered
- [ ] Export compliance answered

## Quality
- [ ] Unit and UI tests pass
- [ ] VoiceOver and Dynamic Type audit
- [ ] Offline and server-error states verified
- [ ] No exact location appears in client API payloads or UI
- [ ] No secrets committed or embedded in the app
- [ ] Crash-free smoke test on at least two physical iPhones
