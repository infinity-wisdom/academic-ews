# Supabase Setup Guide — Academic EWS

Follow these steps **in order** to get the backend running. Each step is done in your Supabase dashboard at https://supabase.com/dashboard.

---

## Step 1 — Run the SQL migrations

Go to **SQL Editor → New query** and run each file in order (copy the whole file contents, paste, click Run):

1. `supabase/01_schema.sql` — creates all tables and the auto-profile trigger
2. `supabase/02_rls_policies.sql` — adds Row Level Security so users only see their own data
3. `supabase/03_storage.sql` — creates the `avatars` and `data-uploads` storage buckets
4. `supabase/04_sample_data.sql` — (optional) adds sample courses so dashboards aren't empty

---

## Step 2 — Enable Email auth

1. Go to **Authentication → Providers → Email**
2. Make sure **Enable Email provider** is ON
3. For a university setting, consider turning **Confirm email** ON (users get a verification link before they can log in)
4. Optionally set **Minimum password length** to 8

---

## Step 3 — Create your first Admin and Advisor accounts

Students self-register through the website. Admins and Advisors must be created manually:

1. Go to **Authentication → Users → Add user**
2. Fill in their email and a temporary password
3. After creating them, go to **Table Editor → profiles**
4. Find their row (it was auto-created by the trigger), click to edit it
5. Change the `role` field from `student` to `advisor` or `admin`
6. Save

Alternatively, run this SQL (replace the values):
```sql
-- After creating the auth user, update their role:
update public.profiles
set role = 'advisor', full_name = 'Dr. Jane Smith'
where email = 'jane.smith@university.edu';
```

---

## Step 4 — (Optional) Assign students to advisors

In **Table Editor → profiles**, find a student's row and set their `advisor_id` to the UUID of their advisor. This controls which students each advisor can see on their dashboard.

Or via SQL:
```sql
update public.profiles
set advisor_id = (select id from public.profiles where email = 'jane.smith@university.edu')
where email = 'student@university.edu';
```

---

## Step 5 — Set the password reset redirect URL

1. Go to **Authentication → URL Configuration**
2. Add your site URL to **Site URL**, e.g. `https://yourusername.github.io/academic-ews-website`
3. Add `https://yourusername.github.io/academic-ews-website/pages/update-password.html` to **Redirect URLs**

This ensures the "forgot password" email links work correctly.

---

## Step 6 — Deploy to GitHub Pages

1. Upload the site files to your GitHub repo (see `README.md`)
2. In repo **Settings → Pages**, set source to `main` branch, `/ (root)` folder
3. Your site will be live at `https://yourusername.github.io/your-repo-name/`

---

## Database tables overview

| Table | Purpose |
|---|---|
| `profiles` | One row per user; stores name, email, role, student ID |
| `courses` | Course catalogue (code, name, instructor, term) |
| `enrollments` | Student ↔ course link, with live grade and attendance |
| `risk_scores` | Risk level per student (low / medium / high + score) |
| `interventions` | Support actions raised by advisors for students |
| `alerts` | Flags raised about a student (e.g. missed 3+ classes) |
| `uploaded_files` | Metadata log of CSV files uploaded via the Upload Data page |

## Storage buckets

| Bucket | Public? | Used for |
|---|---|---|
| `avatars` | ✅ Public | Profile photos (uploaded from My Profile page) |
| `data-uploads` | 🔒 Private | Roster/grade CSV files uploaded by advisors |
