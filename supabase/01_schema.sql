-- =========================================================
-- Academic EWS — Core Schema  (safe to re-run)
-- Run this in: Supabase Dashboard → SQL Editor → New Query
-- =========================================================

-- 1. ROLE TYPE (skipped if it already exists) ---------------
do $$ begin
  create type user_role as enum ('student', 'advisor', 'admin');
exception when duplicate_object then null;
end $$;

-- 2. PROFILES -----------------------------------------------
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  email text not null,
  role user_role not null default 'student',
  student_id text unique,
  advisor_id uuid references public.profiles(id),
  avatar_url text,
  created_at timestamptz not null default now()
);

-- 3. COURSES ------------------------------------------------
create table if not exists public.courses (
  id uuid primary key default gen_random_uuid(),
  code text not null,
  name text not null,
  instructor text,
  term text,
  created_at timestamptz not null default now()
);

-- 4. ENROLLMENTS --------------------------------------------
create table if not exists public.enrollments (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.profiles(id) on delete cascade,
  course_id uuid not null references public.courses(id) on delete cascade,
  current_grade numeric(5,2),
  attendance_rate numeric(5,2),
  status text not null default 'on_track' check (status in ('on_track', 'warning', 'critical')),
  updated_at timestamptz not null default now(),
  unique (student_id, course_id)
);

-- 5. RISK SCORES --------------------------------------------
create table if not exists public.risk_scores (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.profiles(id) on delete cascade,
  score numeric(5,2) not null,
  level text not null check (level in ('low', 'medium', 'high')),
  factors jsonb default '{}'::jsonb,
  calculated_at timestamptz not null default now()
);

-- 6. INTERVENTIONS ------------------------------------------
create table if not exists public.interventions (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.profiles(id) on delete cascade,
  advisor_id uuid not null references public.profiles(id),
  type text not null,
  notes text,
  status text not null default 'open' check (status in ('open', 'in_progress', 'resolved')),
  created_at timestamptz not null default now()
);

-- 7. ALERTS -------------------------------------------------
create table if not exists public.alerts (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.profiles(id) on delete cascade,
  course_id uuid references public.courses(id),
  message text not null,
  severity text not null default 'medium' check (severity in ('low', 'medium', 'high')),
  resolved boolean not null default false,
  created_at timestamptz not null default now()
);

-- 8. UPLOADED FILES -----------------------------------------
create table if not exists public.uploaded_files (
  id uuid primary key default gen_random_uuid(),
  uploaded_by uuid not null references public.profiles(id),
  file_path text not null,
  original_name text not null,
  status text not null default 'processing' check (status in ('processing', 'completed', 'failed')),
  created_at timestamptz not null default now()
);

-- =========================================================
-- AUTO-CREATE PROFILE ON SIGNUP
-- =========================================================
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, full_name, email, role)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'full_name', new.email),
    new.email,
    'student'
  );
  return new;
end;
$$ language plpgsql security definer set search_path = public;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
