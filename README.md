# Academic Early Warning System (EWS)

A static, multi-page web app design for an Academic Early Warning System — a tool that helps universities flag at-risk students and coordinate interventions.

This is the front-end UI only (HTML, Tailwind CSS via CDN, Google Material icons). It is not yet connected to a real database or backend, so logging in and submitting forms is currently for demonstration purposes.

## Pages

| Page | File |
| --- | --- |
| Student / Staff Login | `pages/login.html` |
| Admin Login | `pages/admin-login.html` |
| Student Dashboard | `pages/student-dashboard.html` |
| Advisor Dashboard | `pages/advisor-dashboard.html` |
| Admin Panel | `pages/admin-panel.html` |
| Risk Analysis (modal view) | `pages/risk-analysis-modal.html` |
| Analytics | `pages/analytics.html` |
| Interventions | `pages/interventions.html` |
| Reports | `pages/reports.html` |
| Upload Data | `pages/upload-data.html` |
| Settings | `pages/settings.html` |
| My Profile | `pages/profile.html` |
| Student Profile (advisor view) | `pages/student-profile.html` |

`index.html` at the project root redirects to the login page.

## Running it locally

No build step is required — these are plain HTML files. Easiest ways to view them:

1. **Double-click `index.html`** to open it directly in your browser, or
2. **Use a local server** (recommended, avoids some browser file-access quirks):
   ```bash
   # from the project root
   python3 -m http.server 8000
   # then visit http://localhost:8000
   ```

## Design system

Colors, type scale, spacing, and component rules are documented in `assets/DESIGN.md` (carried over from the original design export). Static screenshots of each screen from the original design are in `assets/screenshots/`.

## Status / next steps

- [ ] Connect forms (login, upload data) to a real backend/API
- [ ] Replace placeholder student/course data with live data
- [ ] Add authentication and role-based access (student / advisor / admin)
- [ ] Add automated tests

## Tech stack

- HTML5
- [Tailwind CSS](https://tailwindcss.com/) (via CDN — fine for a prototype; consider a local build step before production)
- Google Fonts (Inter) and Material Symbols icons
