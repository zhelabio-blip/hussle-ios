# Supabase setup for Hussle — beginner steps

1. Open **SQL Editor → New query**.
2. Open `migrations/0001_hussle_bootstrap.sql` on the Mac.
3. Copy the entire file into the query and press **Run** once.
4. Do not run the old 0001–0008 files. They have been replaced.
5. Expected result: `Success. No rows returned`.
6. Open a new query and run `verification/verify_hussle_backend.sql`.
7. Every result should say `OK`.
8. Then create two private Storage buckets in **Storage**:
   - `dog-photos`
   - `vaccination-documents`

Do not delete Storage rows with SQL. Supabase Storage files and buckets are managed through the Storage Dashboard/API.
