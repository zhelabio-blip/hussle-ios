# Hussle Supabase migration audit — v0.12.11

## Why the previous setup failed

The original eight-file migration chain had several defects:

1. `discover_dogs` sorted by `distance_km` without defining that alias in every version.
2. The files were not wrapped in one transaction, so a later error left earlier types, tables, buckets, and policies behind.
3. Re-running the files was unsafe because enum types and policies were created without first removing existing versions.
4. A recovery instruction attempted to delete rows from Supabase-managed `storage.objects` / `storage.buckets`. Supabase intentionally blocks direct SQL deletion there; file and bucket operations must use the Storage API or Dashboard.
5. Storage buckets were being managed from SQL even though Supabase documents the Storage schema as API-managed.
6. Later migrations repeated non-idempotent enum, table, and policy creation.
7. Photo moderation defaults could make every new profile invisible before a moderation worker was operating.
8. The migration chain was too complex for a first-time setup and too easy to execute in the wrong state.

## Replacement approach

`migrations/0001_hussle_bootstrap.sql` replaces the original chain for a new project.

It:

- starts with `BEGIN` and finishes with `COMMIT`;
- safely removes partial Hussle database objects and Hussle Storage policies;
- never directly deletes Storage metadata or files;
- creates the complete current schema in dependency order;
- creates all RLS policies and RPC functions once;
- defines `distance_km` correctly before sorting;
- safely adds `messages` to the Realtime publication only when needed;
- leaves Storage bucket creation to the Supabase Dashboard;
- defaults uploaded photos to `approved` for the first MVP so profiles are not silently hidden before moderation automation is live.

## Validation performed

- All original migration files were manually audited as one dependency chain.
- The replacement SQL was parsed successfully as 164 top-level PostgreSQL statements using `pglast`.
- A separate verification query checks required tables, functions, Storage policies, and Realtime publication membership.

This is a static SQL validation. The setup is considered Supabase-runtime-verified only after the bootstrap and verification scripts both complete successfully in the target Supabase project.
