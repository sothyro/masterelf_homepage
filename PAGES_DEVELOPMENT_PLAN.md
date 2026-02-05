# Pages & Further Development Plan

This document summarizes the **current state of every page** in the Master Elf homepage project, identifies **gaps and placeholders**, and proposes a **concrete, ordered development plan**. It complements [CONCRETE_DEVELOPMENT_PLAN.md](CONCRETE_DEVELOPMENT_PLAN.md) (design polish) and [DEVELOPMENT_PLAN.md](DEVELOPMENT_PLAN.md) (original scope).

---

## 1. Project structure and routes

| Route | Screen | Purpose |
|-------|--------|---------|
| `/` | `HomeScreen` | Homepage with hero, events strip, academies, consultations, story, testimonials, CTA |
| `/about` | `AboutScreen` | About / Journey page |
| `/events` | `EventsScreen` | Events calendar/list with search |
| `/academy` | `AcademyScreen` | Learning / academies landing |
| `/contact` | `ContactScreen` | Contact Us: offices, chat, map |
| `/appointments` | `AppointmentsScreen` | Book Consultation: consultation types → contact |

**Not yet implemented (from DEVELOPMENT_PLAN / INFORMATION_NEEDED):**

- `/blog` – optional News/Blog
- `/apps` or Resources (BaZi Plotter, Feng Shui Explorer, Flying Star Charts, Store) – currently no route; header may link to external or placeholder

---

## 2. Page-by-page: what needs further development

### 2.1 Home (`/`)

| Area | Current state | Needs |
|------|----------------|--------|
| **Hero** | Video/gradient, 2 CTAs, l10n | Design polish (C2): richer gradient, button shadows – see CONCRETE_DEVELOPMENT_PLAN |
| **Events section** | Carousel, `kAllEvents`, “Limited seats” badge, “Explore All Events” | Content: ensure events from INFORMATION_NEEDED §10; design: C3 (dark cards, shadows) |
| **Academies section** | 3 cards, l10n, “Explore Courses” → external URL | Design: C4 (overlay, card shadows); content: link from `AppContent.academyExploreUrl` |
| **Consultations section** | 4 blocks, “Get Consultation” → `/appointments` | Design: C5 (dark/glass cards) |
| **Story section** | Heading, bullets, “Featured in” strip | “Featured in”: currently placeholder logos; replace with real assets or hide; design: C6 |
| **Testimonials** | Carousel with **placeholder** quotes (“Master Elf is the best” × 4) | **Content:** Replace with real testimonials (quote, name, location, optional video URL) from INFORMATION_NEEDED §8.5 |
| **CTA section** | “Not Sure Where To Start?” + Contact Us | Design: C8 (accent glow) |

**Summary:** Home is structurally complete. Main gaps: **testimonial content**, **Featured in** assets, and design polish (phases C2–C8 if not done).

---

### 2.2 About (`/about`)

| Area | Current state | Needs |
|------|----------------|--------|
| **Layout** | Breadcrumb, hero image, headline, 4 bullets, “Featured in” | Solid base |
| **Hero** | Single image (`AppContent.assetAboutHero`), fixed height 200 | Optional: hero treatment similar to home (gradient overlay, responsive height) |
| **Featured in** | **Placeholder:** 4 containers with “Logo 1” … “Logo 4” text | **Content:** Real “Featured in” logos (assets or URLs) or hide block per INFORMATION_NEEDED §8.4 |
| **Gallery** | Not implemented | **Feature:** If client wants gallery (§9), add a section + placeholder images; otherwise mark “No gallery” |
| **Design** | Uses `AppColors.background` for logo placeholders | Align with dark theme: use `AppColors.surfaceElevatedDark` / `surfaceDark` and shadows for “Featured in” blocks |

**Summary:** About needs **real Featured in assets** (or hide), optional **gallery**, and **dark-theme alignment** for the logo strip.

---

### 2.3 Events (`/events`)

| Area | Current state | Needs |
|------|----------------|--------|
| **Layout** | Breadcrumb, title, subline, search, “Secure your seat” CTA, list/table | Functional |
| **Data** | `kAllEvents` in `events_data.dart` (3 events) | **Content:** Add more events from INFORMATION_NEEDED §10; optional “Early bird ends” in model/UI |
| **View Event** | Navigates to `/contact` | **Decision:** Keep as “contact to register” or add event detail (e.g. modal or `/events/:id`) with description, image, CTA |
| **Search** | Client-side filter by title, date, location, description | Good; optional: debounce, clear button |
| **Design** | Table/cards, basic styling | Optional: apply card shadows and dark styling (e.g. `AppShadows.card`, `surfaceElevatedDark`) for consistency |

**Summary:** Events page is **feature-complete**. Remaining: **more event data**, optional **event detail** flow, and **visual polish**.

---

### 2.4 Academy (`/academy`)

| Area | Current state | Needs |
|------|----------------|--------|
| **Layout** | Breadcrumb, intro text, 3 academy cards (QiMen, BaZi, Feng Shui), “Contact us” CTA | Good |
| **Explore Courses** | `onExplore: () {}` – **no-op** | **Required:** Link to `AppContent.academyExploreUrl` (e.g. `launcher_utils.launchUrl(academyExploreUrl)`) or to an in-app course list if you add one |
| **Footer text** | Hardcoded: “More courses and schedules will be announced here…” | Move to l10n or keep as-is; consider making configurable |
| **Design** | Card layout, responsive | Optional: same dark cards/shadows as other sections |

**Summary:** Academy **must** wire “Explore Courses” to a real destination (external URL or future course page). Optional: l10n for footer line, design polish.

---

### 2.5 Contact (`/contact`)

| Area | Current state | Needs |
|------|----------------|--------|
| **Offices** | One office block (Office 1 – Cambodia) | **Feature:** Add Office 2 block if client has second office (INFORMATION_NEEDED §3) |
| **Chat** | WhatsApp + Email buttons (launcher_utils) | Good |
| **Map** | **Placeholder:** Grey box with “Map placeholder” text | **Required:** Embed map (e.g. Google Maps iframe or Flutter map package) using `AppContent.addressLine` or office address; or link “View on map” to Google Maps URL |
| **Breadcrumb** | “Home” hardcoded | Use `l10n.home` for consistency |
| **Design** | Uses `AppColors.background` for map container | Use dark surface for map container to match theme |

**Summary:** Contact needs **real map** (embed or link) and optionally **second office**. Small fix: breadcrumb use l10n.

---

### 2.6 Appointments (`/appointments`)

| Area | Current state | Needs |
|------|----------------|--------|
| **Layout** | Breadcrumb, title, intro, 4 consultation cards → Contact | Good |
| **Intro** | Hardcoded English: “Choose a consultation type below…” | Move to l10n (e.g. `appointmentsIntro`) for EN/KM/ZH |
| **Cards** | Category, method, description, “Get Consultation” | Content comes from l10n; no structural gap |
| **Design** | Material Card | Optional: dark card style and shadows for consistency |

**Summary:** Appointments is **functionally complete**. Remaining: **l10n for intro** and optional design polish.

---

### 2.7 Legal (Terms, Disclaimer, Privacy)

| Area | Current state | Needs |
|------|----------------|--------|
| **Access** | Footer links open `LegalPopup` (dialog) with `LegalContent` | Good |
| **Content** | Generic legal text in `legal_content.dart` (Master Elf entity) | **Content:** Replace with client-approved copy when available (INFORMATION_NEEDED §12); optional: last-updated date per page |
| **Design** | Dialog; CONCRETE_DEVELOPMENT_PLAN B6 suggests glass + shadow | If not done, apply GlassContainer + AppShadows.dialog |

**Summary:** Legal is **implemented**. Only **client review of copy** and optional **glass dialog** polish.

---

### 2.8 Shared / global

| Area | Current state | Needs |
|------|----------------|--------|
| **Header** | Logo, nav (About, Learning, Resources, News & Events, Consultations), locale, Contact Us; glass + shadow | Nav dropdowns may point to `/academy`, `/events`; Resources/Apps – add external links or placeholder route |
| **Footer** | Offices, Quick Links, Resources, Chat, Social, copyright, legal | Ensure Quick Links and Resources match routes and external URLs from INFORMATION_NEEDED §11 |
| **Sticky CTA** | “Free 12 Animal Forecast” → forecast popup | Design: B5 glass + shadow if not done |
| **Forecast popup** | Form + “Read Full Articles” | Design: B7 glass; content from config/l10n |
| **Design system** | `AppColors`, `AppShadows`, `AppTheme.dark()`, `GlassContainer` | CONCRETE_DEVELOPMENT_PLAN Phases A–E: verify checklist and complete any missing items |

---

## 3. Proposed development plan (ordered)

### Phase 1: Content and critical fixes (no new features)

1. **Testimonials (Home)**  
   - Replace placeholder testimonial list with real data (from INFORMATION_NEEDED §8.5 or config).  
   - Add l10n keys if quotes/names are localized.

2. **Academy – Explore Courses**  
   - In `AcademyScreen`, set `onExplore` to open `AppContent.academyExploreUrl` (e.g. `launcher_utils.launchUrl(AppContent.academyExploreUrl)`).  
   - Optionally add l10n for the “More courses…” footer line.

3. **Contact – Map**  
   - Replace map placeholder with either:  
     - Embedded map (e.g. Google Maps iframe in `web` or Flutter map widget), or  
     - “View on map” link using `AppContent.addressLine` / office address to Google Maps URL.

4. **Appointments – Intro l10n**  
   - Add `appointmentsIntro` (or similar) to ARB files and use in `AppointmentsScreen`.

5. **Contact – Breadcrumb**  
   - Use `l10n.home` instead of hardcoded `'Home'` in Contact breadcrumb.

6. **About – Featured in**  
   - If client provides “Featured in” logos: add assets and use them in About (and optionally Home story section).  
   - If not: hide “Featured in” block or keep minimal placeholders and document in INFORMATION_NEEDED.

**Deliverable:** All user-facing placeholders either filled or intentionally hidden; Academy and Contact are fully actionable.

---

### Phase 2: Optional second office and event detail

7. **Contact – Office 2**  
   - If client has a second office: add `office2Label`, `office2Company`, `office2Address`, `office2Phone` to `AppContent` and a second `_OfficeBlock` on Contact.

8. **Events – Event detail**  
   - Optional: add `/events/:id` or modal with event image, full description, date, location, “Secure your seat” → contact.  
   - Update “View Event” to navigate to detail when implemented.

9. **Events – Data**  
   - Add more events to `kAllEvents` from INFORMATION_NEEDED §10; use `earlyBirdEnds` in UI if provided.

**Deliverable:** Richer contact and events experience; no broken links.

---

### Phase 3: About gallery and Resources/Blog (if scope confirmed)

10. **About – Gallery**  
    - If INFORMATION_NEEDED §9 says “Yes” for gallery: add a gallery section (grid of images) with placeholder or client assets.

11. **Resources / Apps**  
    - If header “Resources” should point to in-app pages: add routes (e.g. `/resources` or `/apps`) and simple landing with links to BaZi Plotter, Feng Shui Explorer, Flying Star Charts, Store (from §5).  
    - Otherwise ensure dropdown links to external URLs or `#` with tooltip “Coming soon.”

12. **Blog / News**  
    - Only if §13 says “Yes”: add `/blog` route and minimal list/detail or link to external blog.

**Deliverable:** About and nav match INFORMATION_NEEDED and client scope.

---

### Phase 4: Design polish (align with CONCRETE_DEVELOPMENT_PLAN)

13. **Run through CONCRETE_DEVELOPMENT_PLAN checklist**  
    - Complete any unchecked items in Phases A–E (theme, glass, dark sections, shadows, a11y).  
    - Ensure About, Contact, Events, Academy, Appointments use dark surfaces and `AppShadows` where specified.

14. **Legal and Forecast popups**  
    - Apply glass + shadow (B6, B7) if not already done.

15. **Accessibility and SEO**  
    - Confirm skip-to-content, focus order, and meta/headings per DEVELOPMENT_PLAN Phase 5.

**Deliverable:** Consistent dark, glass, and shadow look; good a11y and SEO baseline.

---

### Phase 5: Legal copy and final content

16. **Legal content**  
    - Replace generic text in `LegalContent` with client-approved Terms, Disclaimer, Privacy (INFORMATION_NEEDED §12).

17. **Final copy pass**  
    - Replace any remaining “TBD” or placeholder strings from INFORMATION_NEEDED; verify all l10n keys for new copy.

**Deliverable:** Site ready for launch from a content and legal standpoint.

---

## 4. Task checklist (copy and tick)

**Phase 1 – Content & critical fixes**  
- [ ] 1.1 Replace testimonial placeholders with real data (+ l10n if needed)  
- [ ] 1.2 Academy: wire “Explore Courses” to `academyExploreUrl`  
- [ ] 1.3 Contact: implement map (embed or “View on map” link)  
- [ ] 1.4 Appointments: add l10n for intro paragraph  
- [ ] 1.5 Contact: breadcrumb use `l10n.home`  
- [ ] 1.6 About: Featured in – real assets or hide block  

**Phase 2 – Optional office & events**  
- [ ] 2.1 Contact: add Office 2 if client provides  
- [ ] 2.2 Events: optional event detail (route or modal)  
- [ ] 2.3 Events: more events in `kAllEvents`; optional early-bird UI  

**Phase 3 – About & nav scope**  
- [ ] 3.1 About: gallery section if required  
- [ ] 3.2 Resources/Apps: routes or external links in header  
- [ ] 3.3 Blog: stub or link if required  

**Phase 4 – Design polish**  
- [ ] 4.1 Complete CONCRETE_DEVELOPMENT_PLAN Phases A–E as needed  
- [ ] 4.2 Legal & Forecast popups: glass + shadow  
- [ ] 4.3 A11y and SEO check  

**Phase 5 – Final content**  
- [ ] 5.1 Legal: client-approved Terms, Disclaimer, Privacy  
- [ ] 5.2 Final copy and l10n pass  

---

## 5. Summary

| Page / area | Priority | Main actions |
|-------------|----------|--------------|
| **Home** | High | Real testimonials; Featured in assets or hide; design polish (C2–C8) |
| **About** | High | Featured in (real or hide); optional gallery; dark-theme logo strip |
| **Events** | Medium | More events; optional event detail; card/table styling |
| **Academy** | High | Wire “Explore Courses” to URL; optional l10n for footer text |
| **Contact** | High | Real map (embed or link); optional Office 2; breadcrumb l10n |
| **Appointments** | Medium | Intro string in l10n; optional card styling |
| **Legal** | Medium | Client copy when ready; optional glass dialog |
| **Global** | Ongoing | Design polish (CONCRETE_DEVELOPMENT_PLAN); Resources/Blog if in scope |

Implement **Phase 1** first to remove placeholders and fix Academy/Contact; then **Phase 2–3** per client scope; **Phase 4** in parallel or after for consistent design; **Phase 5** when final copy and legal are ready.
