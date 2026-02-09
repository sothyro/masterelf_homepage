# Next Steps – Outline & Implementation

Prioritized follow-ups from the project inspection. Items with ✅ are implemented in this pass.

**Implementation summary (this pass):**
- **Events heading:** Uses `sectionExperienceHeadingPrefix` and `sectionExperienceHeadingHighlight` in all locales (no more hardcoded "Transformation").
- **404:** Unknown paths redirect to `/not-found`; not-found content is shown inside the shell (header + footer).
- **Tests:** Smoke test, skipped 404 widget test (viewport overflow), and appointment booking service unit tests.
- **Outline:** Remaining items (shared event card, dependencies, SEO, a11y, error reporting) are documented below for later.

---

## 1. Events section: localized experience heading ✅

**Goal:** Stop relying on a hardcoded substring (`"Transformation"`) so the heading works in all locales and copy changes.

**Outline:**
- Add ARB keys: `sectionExperienceHeadingPrefix`, `sectionExperienceHeadingHighlight`.
- In `events_section.dart`, use these keys instead of `indexOf('Transformation')` and substring.

**Effort:** Small.  
**Files:** `lib/l10n/app_*.arb`, `lib/screens/home/widgets/events_section.dart`.

---

## 2. 404 page inside shell ✅

**Goal:** Show the not-found page with header and footer so it feels like the rest of the site.

**Outline:**
- Add a redirect in GoRouter: unknown paths → `/not-found`.
- Add route `GoRoute(path: '/not-found', ...)` inside the existing `ShellRoute`.
- Build the same not-found content as a child of the shell (reuse or share widget).

**Effort:** Small.  
**Files:** `lib/router/app_router.dart`.

---

## 3. Tests: 404, locale, booking service ✅

**Goal:** More reliable and broader test coverage.

**Implemented:**
- **404:** Widget test added; currently **skipped** because the shell’s scroll Column overflows in the test viewport (336px height). Manually verify by opening `/unknown` in the app. Un-skip once test viewport or layout is adjusted.
- **Booking service:** `test/appointment_booking_service_test.dart` – demo mode returns success; phone normalization covered via success path.

**Effort:** Small–medium.  
**Files:** `test/widget_test.dart`, `test/appointment_booking_service_test.dart`.

---

## 4. Events section: shared card UI (optional)

**Goal:** Less duplication between `_FeaturedEventCard` and `_CompactEventCard`.

**Outline:**
- Extract a “Limited seats” badge widget and a small “event meta” row (date + location, with optional description).
- Use them in both featured and compact cards; keep layout differences (e.g. image size, padding) in the parent widgets.

**Effort:** Medium.  
**Files:** `lib/screens/home/widgets/events_section.dart` (and optionally a small `event_card_shared.dart` if desired).

---

## 5. Dependencies and tooling

**Goal:** Keep dependencies and tooling up to date safely.

**Outline:**
- Run `flutter pub outdated` and document current status.
- Plan a dependency upgrade pass (e.g. `go_router`, `google_fonts`, `flutter_lints`) with a branch and regression checks.
- Optionally add a basic GitHub Actions (or similar) workflow: `flutter pub get`, `flutter analyze`, `flutter test`.

**Effort:** Small (audit) to medium (CI).  
**Files:** Optional `dependencies_audit.md`, `.github/workflows/flutter.yml` (or equivalent).

---

## 6. SEO and PWA

**Goal:** Better discoverability and installability.

**Outline:**
- Set a canonical URL in `web/index.html` (e.g. `https://www.masterelf.vip`).
- Add `og:image` when the final hero or logo URL is available; ensure image dimensions if needed.
- Review `web/manifest.json` (name, short_name, theme_color) and ensure icons match.

**Effort:** Small.  
**Files:** `web/index.html`, `web/manifest.json`.

---

## 7. Accessibility

**Goal:** Improve screen-reader and keyboard experience.

**Outline:**
- Add semantic labels to key CTAs (e.g. “Book consultation”, “Back to top”) where missing.
- Ensure focus order is logical (e.g. skip link, header, main, footer).
- Spot-check contrast (e.g. `AppColors.onPrimary` on dark) and fix if needed for WCAG AA.

**Effort:** Small–medium.  
**Files:** Various widgets (header, footer, hero, 404, sticky CTA).

---

## 8. Error and observability (optional)

**Goal:** Easier debugging and monitoring in production.

**Outline:**
- Add a small error-reporting hook (e.g. `onBookingError`, `onPreloadError`) that can log or send to a service; keep it no-op by default.
- Optionally add a non-intrusive way to surface “booking failed” or “video failed to load” in the UI (e.g. snackbar or inline message).

**Effort:** Medium.  
**Files:** `lib/main.dart`, `lib/screens/home/widgets/hero_section.dart`, `lib/services/appointment_booking_service.dart`, optional `lib/utils/error_reporting.dart`.

---

## Implementation order (this pass)

1. ✅ **NEXT_STEPS.md** (this outline).
2. ✅ **Events l10n** – prefix/highlight keys and use in `events_section.dart`.
3. ✅ **404 inside shell** – redirect + `/not-found` route, same content in shell.
4. ✅ **Tests** – 404 test, smoke test with locale, booking service unit test.
5. ⏸ **Shared event card** – skipped for now; can be done in a later refactor.

Items 6–8 remain as documented next steps for later sprints.
