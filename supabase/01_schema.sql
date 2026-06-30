-- =========================================================
-- Academic EWS — Core Schema
-- Run this in: Supabase Dashboard → SQL Editor → New Query
-- =========================================================

-- 1. ROLE TYPE -------------------------------------------------
create type user_role as enum ('student', 'advisor', 'admin');

-- 2. PROFILES ----------------------------------------------------
-- One row per auth.users account. Created automatically on signup
-- by the trigger at the bottom of this file.
create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  email text not null,
  role user_role not null default 'student',
  student_id text unique,                 -- school-issued ID, students only
  advisor_id uuid references public.profiles(id),  -- which advisor this student is assigned to
  avatar_url text,
  created_at timestamptz not null default now()
);

-- 3. COURSES -------------------------------------------------------
create table public.courses (
  id uuid primary key default gen_random_uuid(),
  code text not null,            -- e.g. "CS101"
  name text not null,            -- e.g. "Intro to Programming"
  instructor text,
  term text,                     -- e.g. "Fall 2026"
  created_at timestamptz not null default now()
);

-- 4. ENROLLMENTS (a student in a course, with live grade/attendance) ---
create table public.enrollments (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.profiles(id) on delete cascade,
  course_id uuid not null references public.courses(id) on delete cascade,
  current_grade numeric(5,2),         -- 0-100
  attendance_rate numeric(5,2),       -- 0-100
  status text not null default 'on_track' check (status in ('on_track', 'warning', 'critical')),
  updated_at timestamptz not null default now(),
  unique (student_id, course_id)
);

-- 5. RISK SCORES (computed/assigned risk level per student) ------
create table public.risk_scores (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.profiles(id) on delete cascade,
  score numeric(5,2) not null,            -- 0-100, higher = more at risk
  level text not null check (level in ('low', 'medium', 'high')),
  factors jsonb default '{}'::jsonb,      -- e.g. {"attendance": 0.3, "gpa_drop": 0.5}
  calculated_at timestamptz not null default now()
);

-- 6. INTERVENTIONS (advisor support actions for a student) -------
create table public.interventions (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.profiles(id) on delete cascade,
  advisor_id uuid not null references public.profiles(id),
  type text not null,                     -- e.g. "Advising Meeting", "Tutoring Referral"
  notes text,
  status text not null default 'open' check (status in ('open', 'in_progress', 'resolved')),
  created_at timestamptz not null default now()
);

-- 7. ALERTS (flags raised about a student, optionally tied to a course) --
create table public.alerts (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.profiles(id) on delete cascade,
  course_id uuid references public.courses(id),
  message text not null,
  severity text not null default 'medium' check (severity in ('low', 'medium', 'high')),
  resolved boolean not null default false,
  created_at timestamptz not null default now()
);

-- 8. UPLOADED FILES (metadata for files dropped in Storage) ------
create table public.uploaded_files (
  id uuid primary key default gen_random_uuid(),
  uploaded_by uuid not null references public.profiles(id),
  file_path text not null,        -- path inside the storage bucket
  original_name text not null,
  status text not null default 'processing' check (status in ('processing', 'completed', 'failed')),
  created_at timestamptz not null default now()
);

-- =========================================================
-- AUTO-CREATE PROFILE ON SIGNUP
-- When someone signs up through the website's Sign Up form,
-- this trigger creates their `profiles` row automatically,
-- always as role = 'student' (self-signup is student-only;
-- advisors/admins are created manually — see README-SUPABASE.md).
-- =========================================================
create function public.handle_new_user()
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

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
