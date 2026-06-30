---
name: Academic Intelligence System
colors:
  surface: '#fbf8fa'
  surface-dim: '#dcd9db'
  surface-bright: '#fbf8fa'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f5f3f5'
  surface-container: '#f0edef'
  surface-container-high: '#eae7e9'
  surface-container-highest: '#e4e2e4'
  on-surface: '#1b1b1d'
  on-surface-variant: '#44474d'
  inverse-surface: '#303032'
  inverse-on-surface: '#f2f0f2'
  outline: '#75777d'
  outline-variant: '#c5c6cd'
  surface-tint: '#535f75'
  primary: '#091529'
  on-primary: '#ffffff'
  primary-container: '#1e2a3e'
  on-primary-container: '#8591aa'
  inverse-primary: '#bbc7e1'
  secondary: '#4355b9'
  on-secondary: '#ffffff'
  secondary-container: '#8596ff'
  on-secondary-container: '#11278e'
  tertiary: '#001339'
  on-tertiary: '#ffffff'
  tertiary-container: '#002662'
  on-tertiary-container: '#578dff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d7e3fe'
  primary-fixed-dim: '#bbc7e1'
  on-primary-fixed: '#0f1c2f'
  on-primary-fixed-variant: '#3b475c'
  secondary-fixed: '#dee0ff'
  secondary-fixed-dim: '#bac3ff'
  on-secondary-fixed: '#00105c'
  on-secondary-fixed-variant: '#293ca0'
  tertiary-fixed: '#d9e2ff'
  tertiary-fixed-dim: '#b0c6ff'
  on-tertiary-fixed: '#001945'
  on-tertiary-fixed-variant: '#00419d'
  background: '#fbf8fa'
  on-background: '#1b1b1d'
  surface-variant: '#e4e2e4'
typography:
  headline-h1:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
    letterSpacing: -0.02em
  headline-h1-mobile:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '700'
    lineHeight: 28px
  headline-h2:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  headline-h3:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-sm:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
  caption-xs:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 4px
  padding-card: 24px
  gutter: 24px
  sidebar-expanded: 260px
  sidebar-collapsed: 72px
  topbar-height: 64px
---

## Brand & Style

The design system is engineered for educational institutions, prioritizing clarity, institutional trust, and rapid intervention. The aesthetic is **Corporate / Modern**, leaning heavily into a systematic, data-rich environment that remains approachable for educators and empathetic toward student outcomes.

The interface must balance the gravity of "Early Warning" alerts with a supportive, non-punitive tone. High whitespace and a structured information hierarchy prevent cognitive overload, ensuring that administrative staff can identify at-risk students and academic trends within seconds of viewing a dashboard.

## Colors

The palette is anchored by a deep **Navy/Slate (#1E2A3E)** to establish authority and permanence. The background uses a soft **Off-White (#F8F9FA)** to reduce glare during long sessions of data analysis, while the primary workspace consists of **White (#FFFFFF)** cards to create a clear "paper-like" focus area.

Functional colors are strictly mapped to academic status:
- **Critical Red**: Immediate intervention required (e.g., failing grade, high absence).
- **Warning Yellow**: At-risk behavior (e.g., declining performance).
- **Safe Green**: On-track or improved performance.
- **Admin Indigo**: System-level actions and administrative functions.
- **Success Blue**: Confirmation of positive system actions.

## Typography

This design system utilizes **Inter** for its exceptional legibility in data-heavy environments. The typeface’s high x-height and neutral character make it ideal for reading student names, numeric IDs, and performance metrics.

The hierarchy is intentionally flat to keep the user focused on data content rather than dramatic styling. Headlines use a slight negative letter-spacing to maintain a professional, compact appearance. Use `label-sm` for table headers and form labels to maximize vertical space without sacrificing readability.

## Layout & Spacing

The system follows a **Fixed Grid** philosophy for the main content area to ensure data visualizations remain consistent, while the overall shell uses a fluid approach to accommodate the sidebar.

- **Sidebar**: A persistent, dark navy (#1E2A3E) navigation bar on the left. It is collapsible to provide more horizontal space for complex tables or scatter plots.
- **Top Bar**: A white (#FFFFFF) utility bar for search, notifications, and profile management.
- **Content Area**: Centered or left-aligned within the viewport with a max-width of 1440px on large monitors.
- **Rhythm**: All spacing is derived from a 4px/8px base. A standard 24px padding is applied to all container elements (Cards, Modals) to ensure breathability.

## Elevation & Depth

To maintain a clean, professional "SaaS" aesthetic, the design system avoids heavy shadows. 

- **Level 1 (Cards)**: Uses a subtle, soft shadow: `0 2px 8px rgba(0,0,0,0.08)`. This creates enough separation from the off-white background to define the workspace without feeling cluttered.
- **Level 2 (Dropdowns/Modals)**: Uses a slightly deeper shadow: `0 8px 24px rgba(0,0,0,0.12)` to indicate temporary interaction layers.
- **Outline**: Borders are used sparingly. For input fields and inactive states, use a 1px border in a light slate gray to define boundaries without adding visual weight.

## Shapes

The design system utilizes a **Rounded** shape language to soften the institutional nature of the data.

- **Cards**: All primary containers use a **12px** corner radius.
- **Buttons**: Secondary and Primary buttons use an **8px** corner radius to appear distinct from the larger card containers.
- **Chips/Badges**: Use a fully rounded (pill-shaped) radius for status indicators (e.g., "At Risk") to differentiate them from interactive buttons.

## Components

### Cards
Cards are the primary building block. Every card must have a 12px radius, a white background, and the defined 24px padding. Titles within cards should use `headline-h3`.

### Buttons
- **Primary**: Solid Admin Indigo (#3F51B5) with white text.
- **Destructive**: Solid Critical Red (#D92D20) for significant interventions.
- **Secondary**: Ghost style with 1px Navy/Slate border for less frequent actions.

### Data Tables
Tables should use `label-sm` for headers (uppercase, medium weight) and `body-md` for row content. Alternate row striping is not required; instead, use a 1px light gray divider between rows.

### Status Chips
Small, high-contrast badges used to communicate the early warning level. 
- **Critical**: Red background, white text.
- **Warning**: Yellow background, dark slate text for contrast.
- **Safe**: Green background, white text.

### Input Fields
Inputs should have an 8px radius and a 1px border. On focus, the border should transition to Success Blue (#0A58CA) with a subtle outer glow.

### Sidebar Nav
Active states in the sidebar should use a subtle background tint (white at 10% opacity) or a 4px left-side accent bar in Admin Indigo to indicate the current page.