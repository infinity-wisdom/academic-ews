-- =========================================================
-- Academic EWS — Row Level Security (RLS)
-- Run this AFTER 01_schema.sql, in the same SQL Editor.
-- This is what enforces: students only see their own data,
-- advisors only see their assigned students, admins see all.
-- =========================================================

-- Small helper: what role is the currently logged-in user?
create or replace function public.get_user_role()
returns user_role as $$
  select role from public.profiles where id = auth.uid();
$$ language sql security definer stable;

-- ---------------------------------------------------------
-- PROFILES
-- ---------------------------------------------------------
alter table public.profiles enable row level security;

drop policy if exists "view own profile" on public.profiles;
create policy "view own profile"
  on public.profiles for select
  using (id = auth.uid());

drop policy if exists "advisors view their assigned students" on public.profiles;
create policy "advisors view their assigned students"
  on public.profiles for select
  using (advisor_id = auth.uid() and public.get_user_role() = 'advisor');

drop policy if exists "admins view all profiles" on public.profiles;
create policy "admins view all profiles"
  on public.profiles for select
  using (public.get_user_role() = 'admin');

drop policy if exists "users update own profile" on public.profiles;
create policy "users update own profile"
  on public.profiles for update
  using (id = auth.uid());

drop policy if exists "admins update any profile" on public.profiles;
create policy "admins update any profile"
  on public.profiles for update
  using (public.get_user_role() = 'admin');

drop policy if exists "admins insert profiles" on public.profiles;
create policy "admins insert profiles"
  on public.profiles for insert
  with check (public.get_user_role() = 'admin');

-- ---------------------------------------------------------
-- COURSES (reference data — any signed-in user can read)
-- ---------------------------------------------------------
alter table public.courses enable row level security;

drop policy if exists "any signed-in user reads courses" on public.courses;
create policy "any signed-in user reads courses"
  on public.courses for select
  using (auth.uid() is not null);

drop policy if exists "advisors and admins manage courses" on public.courses;
create policy "advisors and admins manage courses"
  on public.courses for all
  using (public.get_user_role() in ('advisor', 'admin'))
  with check (public.get_user_role() in ('advisor', 'admin'));

-- ---------------------------------------------------------
-- ENROLLMENTS
-- ---------------------------------------------------------
alter table public.enrollments enable row level security;

drop policy if exists "students view own enrollments" on public.enrollments;
create policy "students view own enrollments"
  on public.enrollments for select
  using (student_id = auth.uid());

drop policy if exists "advisors view their students' enrollments" on public.enrollments;
create policy "advisors view their students' enrollments"
  on public.enrollments for select
  using (
    public.get_user_role() = 'advisor'
    and student_id in (select id from public.profiles where advisor_id = auth.uid())
  );

drop policy if exists "admins view all enrollments" on public.enrollments;
create policy "admins view all enrollments"
  on public.enrollments for select
  using (public.get_user_role() = 'admin');

drop policy if exists "advisors and admins manage enrollments" on public.enrollments;
create policy "advisors and admins manage enrollments"
  on public.enrollments for all
  using (public.get_user_role() in ('advisor', 'admin'))
  with check (public.get_user_role() in ('advisor', 'admin'));

-- ---------------------------------------------------------
-- RISK SCORES
-- ---------------------------------------------------------
alter table public.risk_scores enable row level security;

drop policy if exists "students view own risk scores" on public.risk_scores;
create policy "students view own risk scores"
  on public.risk_scores for select
  using (student_id = auth.uid());

drop policy if exists "advisors view their students' risk scores" on public.risk_scores;
create policy "advisors view their students' risk scores"
  on public.risk_scores for select
  using (
    public.get_user_role() = 'advisor'
    and student_id in (select id from public.profiles where advisor_id = auth.uid())
  );

drop policy if exists "admins view all risk scores" on public.risk_scores;
create policy "admins view all risk scores"
  on public.risk_scores for select
  using (public.get_user_role() = 'admin');

drop policy if exists "advisors and admins manage risk scores" on public.risk_scores;
create policy "advisors and admins manage risk scores"
  on public.risk_scores for all
  using (public.get_user_role() in ('advisor', 'admin'))
  with check (public.get_user_role() in ('advisor', 'admin'));

-- ---------------------------------------------------------
-- INTERVENTIONS
-- ---------------------------------------------------------
alter table public.interventions enable row level security;

drop policy if exists "students view own interventions" on public.interventions;
create policy "students view own interventions"
  on public.interventions for select
  using (student_id = auth.uid());

drop policy if exists "advisors view/manage their own interventions" on public.interventions;
create policy "advisors view/manage their own interventions"
  on public.interventions for all
  using (advisor_id = auth.uid())
  with check (advisor_id = auth.uid());

drop policy if exists "admins manage all interventions" on public.interventions;
create policy "admins manage all interventions"
  on public.interventions for all
  using (public.get_user_role() = 'admin')
  with check (public.get_user_role() = 'admin');

-- ---------------------------------------------------------
-- ALERTS
-- ---------------------------------------------------------
alter table public.alerts enable row level security;

drop policy if exists "students view own alerts" on public.alerts;
create policy "students view own alerts"
  on public.alerts for select
  using (student_id = auth.uid());

drop policy if exists "advisors view their students' alerts" on public.alerts;
create policy "advisors view their students' alerts"
  on public.alerts for select
  using (
    public.get_user_role() = 'advisor'
    and student_id in (select id from public.profiles where advisor_id = auth.uid())
  );

drop policy if exists "advisors and admins manage alerts" on public.alerts;
create policy "advisors and admins manage alerts"
  on public.alerts for all
  using (public.get_user_role() in ('advisor', 'admin'))
  with check (public.get_user_role() in ('advisor', 'admin'));

-- ---------------------------------------------------------
-- UPLOADED FILES (advisor/admin only — students never see this)
-- ---------------------------------------------------------
alter table public.uploaded_files enable row level security;

drop policy if exists "advisors and admins manage uploaded files" on public.uploaded_files;
create policy "advisors and admins manage uploaded files"
  on public.uploaded_files for all
  using (public.get_user_role() in ('advisor', 'admin'))
  with check (public.get_user_role() in ('advisor', 'admin'));
