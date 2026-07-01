-- =========================================================
-- Academic EWS — Optional sample data
-- Safe to run after 03_storage.sql. Only adds reference
-- courses so dashboards have something to enroll students into.
-- Skip this if you'd rather add courses manually via the
-- Table Editor.
-- =========================================================

insert into public.courses (code, name, instructor, term) values
  ('CS101', 'Intro to Programming', 'Dr. Patel', 'Fall 2026'),
  ('MATH202', 'Calculus II', 'Dr. Lindqvist', 'Fall 2026'),
  ('ENG105', 'Academic Writing', 'Prof. Whitman', 'Fall 2026');
