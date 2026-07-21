-- Hussle backend bootstrap v1
-- Intended for a new or partially initialized Supabase project with no real user data.
-- This script is transactional: if any statement fails, database changes in this script roll back.
-- Storage buckets are intentionally NOT created/deleted here. Create them in Supabase Storage UI.

begin;

create extension if not exists pgcrypto;
create extension if not exists postgis;

-- Remove Hussle policies left on Supabase-managed Storage tables.
drop policy if exists "owners upload dog photos" on storage.objects;
drop policy if exists "owners manage dog photos" on storage.objects;
drop policy if exists "owners manage vaccination docs" on storage.objects;
drop policy if exists "authenticated read active dog photos" on storage.objects;
drop policy if exists "authenticated users view active dog photos" on storage.objects;
drop policy if exists "owners select dog photos" on storage.objects;
drop policy if exists "owners update dog photos" on storage.objects;
drop policy if exists "owners delete dog photos" on storage.objects;
drop policy if exists "owners upload vaccination docs" on storage.objects;
drop policy if exists "owners select vaccination docs" on storage.objects;
drop policy if exists "owners update vaccination docs" on storage.objects;
drop policy if exists "owners delete vaccination docs" on storage.objects;

-- Remove the Auth trigger before rebuilding public tables.
drop trigger if exists on_auth_user_created on auth.users;

-- Remove previous Hussle public objects. No Storage rows or files are deleted.
drop table if exists public.photo_moderation_queue cascade;
drop table if exists public.moderation_actions cascade;
drop table if exists public.moderator_accounts cascade;
drop table if exists public.notification_outbox cascade;
drop table if exists public.device_tokens cascade;
drop table if exists public.messages cascade;
drop table if exists public.conversations cascade;
drop table if exists public.matches cascade;
drop table if exists public.swipes cascade;
drop table if exists public.reports cascade;
drop table if exists public.blocks cascade;
drop table if exists public.vaccinations cascade;
drop table if exists public.dog_photos cascade;
drop table if exists public.dogs cascade;
drop table if exists public.profiles cascade;

drop type if exists public.moderation_decision cascade;
drop type if exists public.moderation_role cascade;
drop type if exists public.swipe_action cascade;
drop type if exists public.connection_purpose cascade;
drop type if exists public.dog_sex cascade;

create type public.dog_sex as enum ('male', 'female');
create type public.connection_purpose as enum ('breeding', 'walks', 'friends');
create type public.swipe_action as enum ('like', 'pass');
create type public.moderation_role as enum ('moderator', 'admin');
create type public.moderation_decision as enum (
  'no_action',
  'warning',
  'content_removed',
  'profile_paused',
  'temporary_suspension',
  'permanent_ban'
);

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  first_name text not null check (char_length(first_name) between 1 and 80),
  city text not null default '',
  country text not null default '',
  bio text not null default '',
  latitude double precision,
  longitude double precision,
  location geography(point, 4326) generated always as (
    case
      when latitude is null or longitude is null then null
      else st_setsrid(st_makepoint(longitude, latitude), 4326)::geography
    end
  ) stored,
  account_status text not null default 'active'
    check (account_status in ('active', 'warned', 'suspended', 'banned')),
  suspended_until timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.dogs (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.profiles(id) on delete cascade,
  name text not null check (char_length(name) between 1 and 80),
  breed text not null check (char_length(breed) between 1 and 120),
  sex public.dog_sex not null,
  date_of_birth date not null check (date_of_birth <= current_date),
  primary_purpose public.connection_purpose not null,
  purposes public.connection_purpose[] not null,
  city text not null default '',
  bio text not null default '',
  has_health_info boolean not null default false,
  has_pedigree boolean not null default false,
  is_sterilized boolean not null default false,
  is_active boolean not null default true,
  moderation_status text not null default 'approved'
    check (moderation_status in ('pending', 'approved', 'rejected')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (cardinality(purposes) > 0),
  check (primary_purpose = any(purposes)),
  check (not (is_sterilized and primary_purpose = 'breeding'))
);

create table public.dog_photos (
  id uuid primary key default gen_random_uuid(),
  dog_id uuid not null references public.dogs(id) on delete cascade,
  storage_path text not null,
  sort_order integer not null default 0 check (sort_order between 0 and 5),
  moderation_status text not null default 'approved'
    check (moderation_status in ('pending', 'approved', 'rejected')),
  created_at timestamptz not null default now(),
  unique (dog_id, sort_order),
  unique (storage_path)
);

create table public.vaccinations (
  id uuid primary key default gen_random_uuid(),
  dog_id uuid not null references public.dogs(id) on delete cascade,
  name text not null check (char_length(name) between 1 and 120),
  administered_on date not null,
  valid_until date,
  clinic_name text not null default '',
  document_path text,
  created_at timestamptz not null default now(),
  check (valid_until is null or valid_until >= administered_on)
);

create table public.blocks (
  blocker_id uuid not null references public.profiles(id) on delete cascade,
  blocked_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (blocker_id, blocked_id),
  check (blocker_id <> blocked_id)
);

create table public.swipes (
  id uuid primary key default gen_random_uuid(),
  source_dog_id uuid not null references public.dogs(id) on delete cascade,
  target_dog_id uuid not null references public.dogs(id) on delete cascade,
  action public.swipe_action not null,
  created_at timestamptz not null default now(),
  unique (source_dog_id, target_dog_id),
  check (source_dog_id <> target_dog_id)
);

create table public.matches (
  id uuid primary key default gen_random_uuid(),
  dog_a_id uuid not null references public.dogs(id) on delete cascade,
  dog_b_id uuid not null references public.dogs(id) on delete cascade,
  created_at timestamptz not null default now(),
  closed_at timestamptz,
  check (dog_a_id <> dog_b_id),
  check (dog_a_id < dog_b_id)
);

create unique index matches_open_canonical_pair_idx
  on public.matches (dog_a_id, dog_b_id)
  where closed_at is null;

create table public.conversations (
  id uuid primary key default gen_random_uuid(),
  match_id uuid not null unique references public.matches(id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.messages (
  id uuid primary key default gen_random_uuid(),
  match_id uuid not null references public.matches(id) on delete cascade,
  conversation_id uuid not null references public.conversations(id) on delete cascade,
  sender_id uuid not null references public.profiles(id) on delete cascade,
  body text not null check (char_length(body) between 1 and 4000),
  created_at timestamptz not null default now()
);

create index messages_conversation_created_idx
  on public.messages (conversation_id, created_at);

create table public.reports (
  id uuid primary key default gen_random_uuid(),
  reporter_id uuid not null references public.profiles(id) on delete cascade,
  reported_user_id uuid references public.profiles(id) on delete set null,
  reported_dog_id uuid references public.dogs(id) on delete set null,
  category text not null check (char_length(category) between 1 and 120),
  description text not null default '',
  status text not null default 'open'
    check (status in ('open', 'in_review', 'resolved', 'dismissed')),
  priority integer not null default 0,
  assigned_moderator_id uuid references auth.users(id) on delete set null,
  reviewed_at timestamptz,
  resolution_notes text not null default '',
  created_at timestamptz not null default now(),
  check (reported_user_id is not null or reported_dog_id is not null)
);

create table public.device_tokens (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  token text not null unique,
  platform text not null default 'ios' check (platform = 'ios'),
  matches_enabled boolean not null default true,
  messages_enabled boolean not null default true,
  reminders_enabled boolean not null default false,
  product_updates_enabled boolean not null default false,
  updated_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

create table public.notification_outbox (
  id uuid primary key default gen_random_uuid(),
  recipient_user_id uuid not null references auth.users(id) on delete cascade,
  category text not null check (category in ('match', 'message', 'reminder', 'product_update')),
  title text not null,
  body text not null,
  payload jsonb not null default '{}'::jsonb,
  processed_at timestamptz,
  created_at timestamptz not null default now()
);

create table public.moderator_accounts (
  user_id uuid primary key references auth.users(id) on delete cascade,
  role public.moderation_role not null default 'moderator',
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table public.moderation_actions (
  id uuid primary key default gen_random_uuid(),
  report_id uuid references public.reports(id) on delete set null,
  moderator_id uuid not null references auth.users(id) on delete restrict,
  decision public.moderation_decision not null,
  notes text not null default '',
  target_user_id uuid references public.profiles(id) on delete set null,
  target_dog_id uuid references public.dogs(id) on delete set null,
  target_photo_id uuid references public.dog_photos(id) on delete set null,
  created_at timestamptz not null default now()
);

create table public.photo_moderation_queue (
  photo_id uuid primary key references public.dog_photos(id) on delete cascade,
  status text not null default 'queued'
    check (status in ('queued', 'processing', 'completed', 'failed')),
  attempts integer not null default 0 check (attempts >= 0),
  last_error text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index dogs_owner_idx on public.dogs (owner_id);
create index dogs_discovery_idx on public.dogs (is_active, moderation_status, breed);
create index dog_photos_dog_idx on public.dog_photos (dog_id, sort_order);
create index vaccinations_dog_idx on public.vaccinations (dog_id, administered_on desc);
create index swipes_source_idx on public.swipes (source_dog_id, created_at desc);
create index reports_moderation_queue_idx on public.reports (status, priority desc, created_at asc);
create index profiles_account_status_idx on public.profiles (account_status);

alter table public.profiles enable row level security;
alter table public.dogs enable row level security;
alter table public.dog_photos enable row level security;
alter table public.vaccinations enable row level security;
alter table public.blocks enable row level security;
alter table public.swipes enable row level security;
alter table public.matches enable row level security;
alter table public.conversations enable row level security;
alter table public.messages enable row level security;
alter table public.reports enable row level security;
alter table public.device_tokens enable row level security;
alter table public.notification_outbox enable row level security;
alter table public.moderator_accounts enable row level security;
alter table public.moderation_actions enable row level security;
alter table public.photo_moderation_queue enable row level security;

create or replace function public.is_moderator(candidate uuid default auth.uid())
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.moderator_accounts
    where user_id = candidate and is_active
  );
$$;

create policy "authenticated read profiles"
  on public.profiles for select to authenticated
  using (account_status in ('active', 'warned') or id = auth.uid() or public.is_moderator());

create policy "users insert own profile"
  on public.profiles for insert to authenticated
  with check (id = auth.uid());

create policy "users update own profile"
  on public.profiles for update to authenticated
  using (id = auth.uid()) with check (id = auth.uid());

create policy "active dogs readable"
  on public.dogs for select to authenticated
  using (
    owner_id = auth.uid()
    or public.is_moderator()
    or (
      is_active
      and moderation_status = 'approved'
      and exists (
        select 1 from public.profiles p
        where p.id = owner_id and p.account_status in ('active', 'warned')
      )
    )
  );

create policy "owners insert dogs"
  on public.dogs for insert to authenticated
  with check (owner_id = auth.uid());

create policy "owners update dogs"
  on public.dogs for update to authenticated
  using (owner_id = auth.uid()) with check (owner_id = auth.uid());

create policy "owners delete dogs"
  on public.dogs for delete to authenticated
  using (owner_id = auth.uid());

create policy "owners manage dog photos"
  on public.dog_photos for all to authenticated
  using (exists (select 1 from public.dogs d where d.id = dog_id and d.owner_id = auth.uid()))
  with check (exists (select 1 from public.dogs d where d.id = dog_id and d.owner_id = auth.uid()));

create policy "active dog photos readable"
  on public.dog_photos for select to authenticated
  using (
    moderation_status = 'approved'
    and exists (
      select 1 from public.dogs d
      join public.profiles p on p.id = d.owner_id
      where d.id = dog_id
        and d.is_active
        and d.moderation_status = 'approved'
        and p.account_status in ('active', 'warned')
    )
  );

create policy "owners manage vaccinations"
  on public.vaccinations for all to authenticated
  using (exists (select 1 from public.dogs d where d.id = dog_id and d.owner_id = auth.uid()))
  with check (exists (select 1 from public.dogs d where d.id = dog_id and d.owner_id = auth.uid()));

create policy "active dog vaccinations readable"
  on public.vaccinations for select to authenticated
  using (exists (select 1 from public.dogs d where d.id = dog_id and d.is_active));

create policy "users manage own blocks"
  on public.blocks for all to authenticated
  using (blocker_id = auth.uid()) with check (blocker_id = auth.uid());

create policy "owners read outgoing swipes"
  on public.swipes for select to authenticated
  using (exists (select 1 from public.dogs d where d.id = source_dog_id and d.owner_id = auth.uid()));

create policy "match participants read matches"
  on public.matches for select to authenticated
  using (exists (
    select 1 from public.dogs d
    where d.id in (dog_a_id, dog_b_id) and d.owner_id = auth.uid()
  ));

create policy "match participants read conversations"
  on public.conversations for select to authenticated
  using (exists (
    select 1
    from public.matches m
    join public.dogs d on d.id in (m.dog_a_id, m.dog_b_id)
    where m.id = match_id and d.owner_id = auth.uid()
  ));

create policy "conversation participants read messages"
  on public.messages for select to authenticated
  using (exists (
    select 1
    from public.conversations c
    join public.matches m on m.id = c.match_id
    join public.dogs d on d.id in (m.dog_a_id, m.dog_b_id)
    where c.id = conversation_id and d.owner_id = auth.uid()
  ));

create policy "conversation participants send messages"
  on public.messages for insert to authenticated
  with check (
    sender_id = auth.uid()
    and exists (
      select 1
      from public.conversations c
      join public.matches m on m.id = c.match_id
      join public.dogs d on d.id in (m.dog_a_id, m.dog_b_id)
      where c.id = conversation_id
        and m.closed_at is null
        and d.owner_id = auth.uid()
    )
  );

create policy "users create reports"
  on public.reports for insert to authenticated
  with check (reporter_id = auth.uid());

create policy "users and moderators read reports"
  on public.reports for select to authenticated
  using (reporter_id = auth.uid() or public.is_moderator());

create policy "moderators update reports"
  on public.reports for update to authenticated
  using (public.is_moderator()) with check (public.is_moderator());

create policy "users manage own device tokens"
  on public.device_tokens for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

-- notification_outbox intentionally has no client policies (service role only).

create policy "moderators read roles"
  on public.moderator_accounts for select to authenticated
  using (user_id = auth.uid() or public.is_moderator());

create policy "moderators read actions"
  on public.moderation_actions for select to authenticated
  using (public.is_moderator());

create policy "moderators insert actions"
  on public.moderation_actions for insert to authenticated
  with check (public.is_moderator() and moderator_id = auth.uid());

create policy "moderators read photo queue"
  on public.photo_moderation_queue for select to authenticated
  using (public.is_moderator());

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, first_name)
  values (new.id, coalesce(nullif(trim(new.raw_user_meta_data->>'first_name'), ''), 'New owner'))
  on conflict (id) do nothing;
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

create or replace function public.discover_dogs(active_dog_id uuid, radius_km double precision)
returns table (
  id uuid,
  owner_id uuid,
  name text,
  breed text,
  sex text,
  date_of_birth date,
  primary_purpose text,
  purposes text[],
  city text,
  bio text,
  distance_km double precision,
  has_health_info boolean,
  has_pedigree boolean,
  is_sterilized boolean
)
language sql
stable
security invoker
as $$
  with source as (
    select d.*, p.location
    from public.dogs d
    join public.profiles p on p.id = d.owner_id
    where d.id = active_dog_id
      and d.owner_id = auth.uid()
      and d.is_active
  ), candidates as (
    select
      d.id,
      d.owner_id,
      d.name,
      d.breed,
      d.sex::text as sex,
      d.date_of_birth,
      d.primary_purpose::text as primary_purpose,
      d.purposes::text[] as purposes,
      d.city,
      d.bio,
      case
        when s.location is null or p.location is null then null
        else st_distance(s.location, p.location) / 1000.0
      end as distance_km,
      d.has_health_info,
      d.has_pedigree,
      d.is_sterilized,
      case
        when lower(d.breed) = lower(s.breed) and d.purposes && s.purposes then 4
        when lower(d.breed) = lower(s.breed) then 3
        when d.purposes && s.purposes then 2
        else 1
      end as match_rank,
      d.created_at
    from public.dogs d
    join public.profiles p on p.id = d.owner_id
    cross join source s
    where d.is_active
      and d.moderation_status = 'approved'
      and p.account_status in ('active', 'warned')
      and d.owner_id <> auth.uid()
      and exists (
        select 1 from public.dog_photos dp
        where dp.dog_id = d.id and dp.moderation_status = 'approved'
      )
      and not exists (
        select 1 from public.blocks b
        where (b.blocker_id = auth.uid() and b.blocked_id = d.owner_id)
           or (b.blocker_id = d.owner_id and b.blocked_id = auth.uid())
      )
      and not exists (
        select 1 from public.swipes sw
        where sw.source_dog_id = active_dog_id and sw.target_dog_id = d.id
      )
      and (
        s.location is null
        or p.location is null
        or st_dwithin(s.location, p.location, greatest(radius_km, 1) * 1000)
      )
  )
  select
    id, owner_id, name, breed, sex, date_of_birth, primary_purpose, purposes,
    city, bio, distance_km, has_health_info, has_pedigree, is_sterilized
  from candidates
  order by match_rank desc, distance_km asc nulls last, created_at desc;
$$;

create or replace function public.create_conversation_for_match()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.conversations (match_id)
  values (new.id)
  on conflict (match_id) do nothing;
  return new;
end;
$$;

create trigger create_conversation_after_match
  after insert on public.matches
  for each row execute function public.create_conversation_for_match();

create or replace function public.record_swipe(
  source_dog_id uuid,
  target_dog_id uuid,
  swipe_action text
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  reciprocal_like boolean := false;
  created_match_id uuid;
  canonical_a uuid;
  canonical_b uuid;
begin
  if auth.uid() is null then
    raise exception 'Authentication required';
  end if;

  if swipe_action not in ('like', 'pass') then
    raise exception 'Unsupported swipe action';
  end if;

  if source_dog_id = target_dog_id then
    raise exception 'A dog cannot swipe on itself';
  end if;

  if not exists (
    select 1 from public.dogs
    where id = source_dog_id and owner_id = auth.uid() and is_active
  ) then
    raise exception 'Source dog is unavailable';
  end if;

  if not exists (
    select 1 from public.dogs
    where id = target_dog_id and owner_id <> auth.uid() and is_active
  ) then
    raise exception 'Target dog is unavailable';
  end if;

  if exists (
    select 1
    from public.dogs target
    join public.blocks b on
      (b.blocker_id = auth.uid() and b.blocked_id = target.owner_id)
      or (b.blocker_id = target.owner_id and b.blocked_id = auth.uid())
    where target.id = target_dog_id
  ) then
    raise exception 'Interaction is blocked';
  end if;

  insert into public.swipes (source_dog_id, target_dog_id, action)
  values (source_dog_id, target_dog_id, swipe_action::public.swipe_action)
  on conflict (source_dog_id, target_dog_id)
  do update set action = excluded.action, created_at = now();

  if swipe_action = 'like' then
    select exists (
      select 1 from public.swipes
      where public.swipes.source_dog_id = target_dog_id
        and public.swipes.target_dog_id = source_dog_id
        and action = 'like'
    ) into reciprocal_like;
  end if;

  if reciprocal_like then
    canonical_a := least(source_dog_id, target_dog_id);
    canonical_b := greatest(source_dog_id, target_dog_id);

    insert into public.matches (dog_a_id, dog_b_id)
    values (canonical_a, canonical_b)
    on conflict do nothing;

    select m.id into created_match_id
    from public.matches m
    where m.dog_a_id = canonical_a
      and m.dog_b_id = canonical_b
      and m.closed_at is null
    order by m.created_at desc
    limit 1;
  end if;

  return jsonb_build_object('matched', reciprocal_like, 'match_id', created_match_id);
end;
$$;

create or replace function public.get_my_matches(active_dog_id uuid)
returns table (
  id uuid,
  conversation_id uuid,
  matched_at timestamptz,
  other_dog_id uuid,
  other_owner_id uuid,
  other_owner_name text,
  dog_name text,
  breed text,
  sex text,
  date_of_birth date,
  primary_purpose text,
  purposes text[],
  city text,
  bio text,
  has_health_info boolean,
  has_pedigree boolean,
  is_sterilized boolean,
  last_message text,
  last_message_at timestamptz
)
language sql
stable
security invoker
as $$
  select
    m.id,
    c.id as conversation_id,
    m.created_at as matched_at,
    other_dog.id as other_dog_id,
    other_dog.owner_id as other_owner_id,
    p.first_name as other_owner_name,
    other_dog.name as dog_name,
    other_dog.breed,
    other_dog.sex::text as sex,
    other_dog.date_of_birth,
    other_dog.primary_purpose::text as primary_purpose,
    other_dog.purposes::text[] as purposes,
    other_dog.city,
    other_dog.bio,
    other_dog.has_health_info,
    other_dog.has_pedigree,
    other_dog.is_sterilized,
    latest.body as last_message,
    latest.created_at as last_message_at
  from public.matches m
  join public.conversations c on c.match_id = m.id
  join public.dogs mine on mine.id = active_dog_id and mine.owner_id = auth.uid()
  join public.dogs other_dog
    on other_dog.id = case when m.dog_a_id = active_dog_id then m.dog_b_id else m.dog_a_id end
  join public.profiles p on p.id = other_dog.owner_id
  left join lateral (
    select msg.body, msg.created_at
    from public.messages msg
    where msg.conversation_id = c.id
    order by msg.created_at desc
    limit 1
  ) latest on true
  where active_dog_id in (m.dog_a_id, m.dog_b_id)
    and m.closed_at is null
  order by coalesce(latest.created_at, m.created_at) desc;
$$;

create or replace function public.get_conversation_messages(requested_conversation_id uuid)
returns table (
  id uuid,
  conversation_id uuid,
  sender_id uuid,
  body text,
  created_at timestamptz
)
language sql
stable
security invoker
as $$
  select msg.id, msg.conversation_id, msg.sender_id, msg.body, msg.created_at
  from public.messages msg
  join public.conversations c on c.id = msg.conversation_id
  join public.matches m on m.id = c.match_id
  where c.id = requested_conversation_id
    and exists (
      select 1 from public.dogs d
      where d.id in (m.dog_a_id, m.dog_b_id) and d.owner_id = auth.uid()
    )
  order by msg.created_at asc;
$$;

create or replace function public.send_chat_message(requested_conversation_id uuid, message_body text)
returns table (id uuid, created_at timestamptz)
language plpgsql
security invoker
as $$
declare
  inserted_id uuid;
  inserted_at timestamptz;
begin
  if char_length(trim(message_body)) < 1 or char_length(message_body) > 4000 then
    raise exception 'Message must contain between 1 and 4000 characters';
  end if;

  if not exists (
    select 1
    from public.conversations c
    join public.matches m on m.id = c.match_id
    join public.dogs d on d.id in (m.dog_a_id, m.dog_b_id)
    where c.id = requested_conversation_id
      and m.closed_at is null
      and d.owner_id = auth.uid()
  ) then
    raise exception 'Conversation is unavailable';
  end if;

  insert into public.messages (match_id, conversation_id, sender_id, body)
  select c.match_id, c.id, auth.uid(), trim(message_body)
  from public.conversations c
  where c.id = requested_conversation_id
  returning public.messages.id, public.messages.created_at into inserted_id, inserted_at;

  update public.conversations
  set updated_at = inserted_at
  where id = requested_conversation_id;

  return query select inserted_id, inserted_at;
end;
$$;

create or replace function public.unmatch_dogs(requested_match_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if not exists (
    select 1
    from public.matches m
    join public.dogs d on d.id in (m.dog_a_id, m.dog_b_id)
    where m.id = requested_match_id and d.owner_id = auth.uid()
  ) then
    raise exception 'Match not found';
  end if;

  update public.matches
  set closed_at = coalesce(closed_at, now())
  where id = requested_match_id;
end;
$$;

create or replace function public.block_user(blocked_user_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if blocked_user_id is null or blocked_user_id = auth.uid() then
    raise exception 'Invalid user';
  end if;

  insert into public.blocks (blocker_id, blocked_id)
  values (auth.uid(), blocked_user_id)
  on conflict do nothing;

  update public.matches m
  set closed_at = coalesce(m.closed_at, now())
  where exists (
    select 1
    from public.dogs mine
    join public.dogs other on true
    where mine.owner_id = auth.uid()
      and other.owner_id = blocked_user_id
      and mine.id in (m.dog_a_id, m.dog_b_id)
      and other.id in (m.dog_a_id, m.dog_b_id)
  );
end;
$$;

create or replace function public.unblock_user(blocked_user_id uuid)
returns void
language sql
security definer
set search_path = public
as $$
  delete from public.blocks
  where blocker_id = auth.uid() and blocked_id = blocked_user_id;
$$;

create or replace function public.submit_report(
  reported_user_id uuid,
  reported_dog_id uuid,
  report_category text,
  report_description text
)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if char_length(trim(report_category)) < 1 then
    raise exception 'Report category is required';
  end if;

  if reported_user_id is null and reported_dog_id is null then
    raise exception 'A reported user or dog is required';
  end if;

  insert into public.reports (
    reporter_id, reported_user_id, reported_dog_id, category, description
  ) values (
    auth.uid(), reported_user_id, reported_dog_id,
    left(trim(report_category), 120),
    left(trim(coalesce(report_description, '')), 2000)
  );
end;
$$;

create or replace function public.get_blocked_users()
returns table (
  id uuid,
  first_name text,
  dog_name text,
  blocked_at timestamptz
)
language sql
stable
security definer
set search_path = public
as $$
  select p.id, p.first_name, min(d.name), b.created_at
  from public.blocks b
  join public.profiles p on p.id = b.blocked_id
  left join public.dogs d on d.owner_id = p.id and d.is_active
  where b.blocker_id = auth.uid()
  group by p.id, p.first_name, b.created_at
  order by b.created_at desc;
$$;

create or replace function public.set_device_token_owner()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  new.user_id := auth.uid();
  new.updated_at := now();
  return new;
end;
$$;

create trigger device_tokens_set_owner
  before insert or update on public.device_tokens
  for each row execute function public.set_device_token_owner();

create or replace function public.enqueue_match_notification()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  owner_a uuid;
  owner_b uuid;
  name_a text;
  name_b text;
begin
  select owner_id, name into owner_a, name_a from public.dogs where id = new.dog_a_id;
  select owner_id, name into owner_b, name_b from public.dogs where id = new.dog_b_id;

  insert into public.notification_outbox (recipient_user_id, category, title, body, payload)
  values
    (owner_a, 'match', 'It''s a match!', name_a || ' and ' || name_b || ' liked each other.', jsonb_build_object('match_id', new.id)),
    (owner_b, 'match', 'It''s a match!', name_b || ' and ' || name_a || ' liked each other.', jsonb_build_object('match_id', new.id));
  return new;
end;
$$;

create trigger matches_enqueue_notification
  after insert on public.matches
  for each row execute function public.enqueue_match_notification();

create or replace function public.enqueue_message_notification()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  recipient uuid;
  sender_name text;
begin
  select case when da.owner_id = new.sender_id then db.owner_id else da.owner_id end
  into recipient
  from public.conversations c
  join public.matches m on m.id = c.match_id
  join public.dogs da on da.id = m.dog_a_id
  join public.dogs db on db.id = m.dog_b_id
  where c.id = new.conversation_id;

  select first_name into sender_name
  from public.profiles
  where id = new.sender_id;

  if recipient is not null then
    insert into public.notification_outbox (recipient_user_id, category, title, body, payload)
    values (
      recipient,
      'message',
      coalesce(sender_name, 'New message'),
      left(new.body, 160),
      jsonb_build_object('conversation_id', new.conversation_id)
    );
  end if;
  return new;
end;
$$;

create trigger messages_enqueue_notification
  after insert on public.messages
  for each row execute function public.enqueue_message_notification();

create or replace function public.enqueue_new_photo()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.photo_moderation_queue (photo_id, status)
  values (new.id, 'queued')
  on conflict (photo_id)
  do update set status = 'queued', updated_at = now();
  return new;
end;
$$;

create trigger enqueue_dog_photo_moderation
  after insert on public.dog_photos
  for each row execute function public.enqueue_new_photo();

create or replace function public.claim_next_report()
returns setof public.reports
language plpgsql
security definer
set search_path = public
as $$
declare
  selected_id uuid;
begin
  if not public.is_moderator() then
    raise exception 'Moderator access required';
  end if;

  select id into selected_id
  from public.reports
  where status = 'open' and assigned_moderator_id is null
  order by priority desc, created_at asc
  for update skip locked
  limit 1;

  if selected_id is null then
    return;
  end if;

  update public.reports
  set assigned_moderator_id = auth.uid(), status = 'in_review'
  where id = selected_id;

  return query select * from public.reports where id = selected_id;
end;
$$;

create or replace function public.resolve_report(
  report_id uuid,
  decision public.moderation_decision,
  notes text default ''
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  r public.reports;
begin
  if not public.is_moderator() then
    raise exception 'Moderator access required';
  end if;

  select * into r from public.reports where id = report_id for update;
  if r.id is null then
    raise exception 'Report not found';
  end if;

  insert into public.moderation_actions (
    report_id, moderator_id, decision, notes, target_user_id, target_dog_id
  ) values (
    r.id, auth.uid(), decision, left(coalesce(notes, ''), 4000),
    r.reported_user_id, r.reported_dog_id
  );

  if decision = 'profile_paused' and r.reported_dog_id is not null then
    update public.dogs
    set is_active = false, moderation_status = 'rejected'
    where id = r.reported_dog_id;
  elsif decision = 'temporary_suspension' and r.reported_user_id is not null then
    update public.profiles
    set account_status = 'suspended', suspended_until = now() + interval '7 days'
    where id = r.reported_user_id;
    update public.dogs set is_active = false where owner_id = r.reported_user_id;
  elsif decision = 'permanent_ban' and r.reported_user_id is not null then
    update public.profiles
    set account_status = 'banned', suspended_until = null
    where id = r.reported_user_id;
    update public.dogs set is_active = false where owner_id = r.reported_user_id;
  elsif decision = 'warning' and r.reported_user_id is not null then
    update public.profiles
    set account_status = 'warned'
    where id = r.reported_user_id and account_status = 'active';
  end if;

  update public.reports
  set status = 'resolved',
      reviewed_at = now(),
      resolution_notes = left(coalesce(notes, ''), 4000),
      assigned_moderator_id = coalesce(assigned_moderator_id, auth.uid())
  where id = r.id;
end;
$$;

revoke all on function public.discover_dogs(uuid, double precision) from public;
revoke all on function public.record_swipe(uuid, uuid, text) from public;
revoke all on function public.get_my_matches(uuid) from public;
revoke all on function public.get_conversation_messages(uuid) from public;
revoke all on function public.send_chat_message(uuid, text) from public;
revoke all on function public.unmatch_dogs(uuid) from public;
revoke all on function public.block_user(uuid) from public;
revoke all on function public.unblock_user(uuid) from public;
revoke all on function public.submit_report(uuid, uuid, text, text) from public;
revoke all on function public.get_blocked_users() from public;
revoke all on function public.claim_next_report() from public;
revoke all on function public.resolve_report(uuid, public.moderation_decision, text) from public;

grant execute on function public.discover_dogs(uuid, double precision) to authenticated;
grant execute on function public.record_swipe(uuid, uuid, text) to authenticated;
grant execute on function public.get_my_matches(uuid) to authenticated;
grant execute on function public.get_conversation_messages(uuid) to authenticated;
grant execute on function public.send_chat_message(uuid, text) to authenticated;
grant execute on function public.unmatch_dogs(uuid) to authenticated;
grant execute on function public.block_user(uuid) to authenticated;
grant execute on function public.unblock_user(uuid) to authenticated;
grant execute on function public.submit_report(uuid, uuid, text, text) to authenticated;
grant execute on function public.get_blocked_users() to authenticated;
grant execute on function public.claim_next_report() to authenticated;
grant execute on function public.resolve_report(uuid, public.moderation_decision, text) to authenticated;

-- Storage access policies. Buckets must be created separately in Storage UI.
create policy "owners upload dog photos"
  on storage.objects for insert to authenticated
  with check (
    bucket_id = 'dog-photos'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "owners select dog photos"
  on storage.objects for select to authenticated
  using (
    bucket_id = 'dog-photos'
    and (
      (storage.foldername(name))[1] = auth.uid()::text
      or exists (
        select 1
        from public.dogs d
        join public.dog_photos dp on dp.dog_id = d.id
        where dp.storage_path = storage.objects.name
          and d.is_active
          and d.moderation_status = 'approved'
          and dp.moderation_status = 'approved'
      )
    )
  );

create policy "owners update dog photos"
  on storage.objects for update to authenticated
  using (bucket_id = 'dog-photos' and (storage.foldername(name))[1] = auth.uid()::text)
  with check (bucket_id = 'dog-photos' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "owners delete dog photos"
  on storage.objects for delete to authenticated
  using (bucket_id = 'dog-photos' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "owners upload vaccination docs"
  on storage.objects for insert to authenticated
  with check (
    bucket_id = 'vaccination-documents'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "owners select vaccination docs"
  on storage.objects for select to authenticated
  using (
    bucket_id = 'vaccination-documents'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "owners update vaccination docs"
  on storage.objects for update to authenticated
  using (bucket_id = 'vaccination-documents' and (storage.foldername(name))[1] = auth.uid()::text)
  with check (bucket_id = 'vaccination-documents' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "owners delete vaccination docs"
  on storage.objects for delete to authenticated
  using (bucket_id = 'vaccination-documents' and (storage.foldername(name))[1] = auth.uid()::text);

-- Add messages to Postgres Changes only if it is not already present.
do $$
begin
  if not exists (
    select 1
    from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'messages'
  ) then
    alter publication supabase_realtime add table public.messages;
  end if;
end;
$$;

commit;
