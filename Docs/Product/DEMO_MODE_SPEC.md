# Demo Mode Specification

Demo Mode is a protected product flow used when live Supabase configuration is unavailable.

## Required behavior
- App launches without production credentials.
- Onboarding can be completed.
- Dog cards contain complete, consistent data and visible photos.
- Discover, Pass, Like, Match, Messages, and Profile flows remain navigable.
- Demo changes must not silently diverge from production-facing models and UI contracts.

## Release rule
A candidate cannot pass release review if Demo Mode is broken or incomplete.
