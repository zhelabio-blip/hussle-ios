-- Run after hussle_bootstrap.sql. Every row should show OK.
with expected_tables(name) as (
  values
    ('profiles'), ('dogs'), ('dog_photos'), ('vaccinations'), ('blocks'),
    ('swipes'), ('matches'), ('conversations'), ('messages'), ('reports'),
    ('device_tokens'), ('notification_outbox'), ('moderator_accounts'),
    ('moderation_actions'), ('photo_moderation_queue')
), table_checks as (
  select
    'table public.' || name as check_name,
    case when to_regclass('public.' || name) is not null then 'OK' else 'MISSING' end as result
  from expected_tables
), expected_functions(signature) as (
  values
    ('public.discover_dogs(uuid,double precision)'),
    ('public.record_swipe(uuid,uuid,text)'),
    ('public.get_my_matches(uuid)'),
    ('public.get_conversation_messages(uuid)'),
    ('public.send_chat_message(uuid,text)'),
    ('public.unmatch_dogs(uuid)'),
    ('public.block_user(uuid)'),
    ('public.unblock_user(uuid)'),
    ('public.submit_report(uuid,uuid,text,text)'),
    ('public.get_blocked_users()')
), function_checks as (
  select
    'function ' || signature as check_name,
    case when to_regprocedure(signature) is not null then 'OK' else 'MISSING' end as result
  from expected_functions
), storage_checks as (
  select
    'storage policy: ' || required.name as check_name,
    case when exists (
      select 1 from pg_policies p
      where p.schemaname = 'storage'
        and p.tablename = 'objects'
        and p.policyname = required.name
    ) then 'OK' else 'MISSING' end as result
  from (values
    ('owners upload dog photos'),
    ('owners select dog photos'),
    ('owners update dog photos'),
    ('owners delete dog photos'),
    ('owners upload vaccination docs'),
    ('owners select vaccination docs'),
    ('owners update vaccination docs'),
    ('owners delete vaccination docs')
  ) as required(name)
), realtime_check as (
  select
    'Realtime publication: public.messages' as check_name,
    case when exists (
      select 1 from pg_publication_tables
      where pubname = 'supabase_realtime'
        and schemaname = 'public'
        and tablename = 'messages'
    ) then 'OK' else 'MISSING' end as result
)
select * from table_checks
union all select * from function_checks
union all select * from storage_checks
union all select * from realtime_check
order by check_name;
