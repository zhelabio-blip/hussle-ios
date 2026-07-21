# Supabase migration fix

Version 0.12.10 fixes `0001_hussle_schema.sql`. The `discover_dogs` function now explicitly aliases the computed distance expression as `distance_km`, so the `ORDER BY distance_km` clause can resolve it.

This archive has not been executed against the user's live Supabase project from this environment. Run migrations one at a time in Supabase SQL Editor and stop on the first error.
