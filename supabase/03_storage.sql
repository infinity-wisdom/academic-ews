-- =========================================================
-- Academic EWS — Storage Buckets
-- Run this AFTER 02_rls_policies.sql.
-- Creates two buckets: "avatars" (public profile photos) and
-- "data-uploads" (private roster/grade CSV files, advisor+admin only).
-- =========================================================

insert into storage.buckets (id, name, public)
values ('avatars', 'avatars', true)
on conflict (id) do nothing;

insert into storage.buckets (id, name, public)
values ('data-uploads', 'data-uploads', false)
on conflict (id) do nothing;

-- ---------------------------------------------------------
-- AVATARS — public read, but you can only upload/replace your own
-- (file path convention: avatars/{user_id}/filename.ext)
-- ---------------------------------------------------------
create policy "anyone can view avatars"
  on storage.objects for select
  using (bucket_id = 'avatars');

create policy "users upload their own avatar"
  on storage.objects for insert
  with check (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "users update their own avatar"
  on storage.objects for update
  using (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

-- ---------------------------------------------------------
-- DATA UPLOADS — private, advisor/admin only
-- ---------------------------------------------------------
create policy "advisors and admins read data uploads"
  on storage.objects for select
  using (
    bucket_id = 'data-uploads'
    and public.current_role() in ('advisor', 'admin')
  );

create policy "advisors and admins upload data files"
  on storage.objects for insert
  with check (
    bucket_id = 'data-uploads'
    and public.current_role() in ('advisor', 'admin')
  );
