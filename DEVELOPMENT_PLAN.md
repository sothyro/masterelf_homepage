# Master Elf Feng Shui – Development Plan

This plan builds the Joey Yap–style website using content and structure from **INFORMATION_NEEDED.md**.  
**Icons:** open-source only (Material Icons + Lucide-style). **Media:** placeholders for images/videos.

---

## Verification vs [home.joeyyap.com](https://home.joeyyap.com/)

Checked against the live site to ensure full coverage. Items below are explicitly called out so nothing is missed.

| Site element | In plan? | Notes |
|--------------|----------|--------|
| **Skip to content** (a11y link to #content) | ✅ Added below | Phase 1 – header |
| **Header nav:** Home, About (Journey, Method), Learning (3 academies), Resources (Plotter, Explorer, Charts, Store), News & Events (Events, Blog, Media), Consultations, **Contact Us** CTA | ✅ §1.4, §5 INFO | Sub-items match; Resources = BaZi Plotter, Feng Shui Explorer, Flying Star Charts, Store (+ Academy in INFO) |
| **Hero:** 2-line headline (emphasis word), subline, Book Consultation + About | ✅ §2.1 | |
| **Section 2:** “Experience guided, actionable Transformation” (multi-line heading); “Coming Up Next”; **multiple event cards** in a row; “Limited seats” badge; “All Upcoming Events” + “Explore All Events” | ✅ Updated §2.2 | Plan now: carousel of **multiple** events + optional “Limited seats” badge |
| **Section 3:** “This isn’t just Knowledge…” (multi-line); body; 3 academy cards; Explore Courses | ✅ §2.3 | |
| **Section 4:** “You need a Map…” (multi-line); intro; **4** consultation blocks (Category + Method + question + description + Get Consultation) | ✅ §2.4 | |
| **Section 5:** “The Story of …”; paragraphs; Journey CTA; “Featured in” logos | ✅ §2.5 | |
| **Section 6:** “Authentic Insights. Measurable Impact.”; sublines; testimonial carousel with **Watch** + quote + name + location | ✅ §2.6 | |
| **Section 7:** “Not Sure Where To Start?”; body; Contact Us | ✅ §2.7 | |
| **Sticky bar:** “Free 12 Animal Forecast”; megaphone/gift icon; opens popup or article | ✅ §3.1 | |
| **Popup:** Title line 1 + 2; description; “Read Full Articles”; form “Enter Your Details Below…” | ✅ §3.2 | |
| **Footer:** 2 offices (address + phone); Quick Links; Resources; “Chat with us” (WhatsApp, email); “Our Social's Media”; copyright; Terms, Disclaimer, Privacy | ✅ §1.5, §3.3, §4.3 | |
| **Multi-line / emphasis headings** (e.g. gold word, line breaks) | ✅ Added below | §2 typography / section widgets |

**Explicit additions from verification:**
- **Skip to content:** First focusable link in header (anchor to main content).
- **Events strip:** Show **multiple** event cards in a horizontal carousel (e.g. 3); first card can show an optional “Limited seats” badge when configured.
- **Headings:** Support multi-line section titles and optional emphasis (e.g. gold) on one word per line where content specifies.

---

## 0. Conventions

| Item | Choice |
|------|--------|
| **Content source** | `INFORMATION_NEEDED.md`; use placeholders where values are empty |
| **Icons** | `flutter/material.dart` (Material Icons) + `lucide_icons` (open-source, MIT) |
| **Images / videos** | Placeholder assets (e.g. `assets/images/placeholders/`) and/or placeholder service (e.g. `placehold.co`) for missing images; video = placeholder card with play icon |
| **Fonts** | Google Fonts: Exo 2 (EN), Dangrek (KM headings), Siemreap (KM body), Noto Sans SC (ZH) |
| **Languages** | EN (default), KM, ZH (Simplified); add translations as provided or use EN fallback |

---

## Phase 1: Foundation (Week 1)

**Goal:** App runs on web with theme, fonts, i18n, and routing. No full page content yet.

### 1.1 Dependencies & assets
- Add: `google_fonts`, `flutter_localizations`, `intl`, `go_router` (or `auto_route`), `lucide_icons`, `provider` or `riverpod` (for locale/theme).
- Enable `generate: true` for l10n (ARB files in `l10n/`).
- Create `assets/images/placeholders/` and add placeholder images (logo, hero, event, profile, “Featured in” logos, 12-animals) – can be simple colored rectangles or a single `placeholder.png` reused.
- In `pubspec.yaml`: register `assets/` and `packages` for fonts if not using Google Fonts package for all.

### 1.2 Theming & typography
- Define `AppTheme` (light/dark optional): primary, accent, surface, background, error; button styles; card elevation.
- Map fonts by locale:
  - **EN:** Exo 2 (headings + body).
  - **KM:** Dangrek (headings), Siemreap (body).
  - **ZH:** Noto Sans SC (headings + body).
- Apply via `ThemeData` and a small `AppTypography` helper that selects font family from `Localizations.localeOf(context)`.

### 1.3 Internationalization (EN / KM / ZH)
- Add `l10n.yaml` and ARB files: `app_en.arb`, `app_km.arb`, `app_zh.arb`.
- Extract all UI strings from INFORMATION_NEEDED.md into ARB keys (hero, nav, sections, footer, buttons, etc.); start with EN; KM/ZH can be “same as EN” or filled later.
- Wire `flutter_localizations`, `AppLocalizations`, and a locale switcher (e.g. in app bar or footer).

### 1.4 Routing & shell
- Routes from INFORMATION_NEEDED.md §5: `/`, `/about`, `/events`, `/contact`, `/appointments` (or `/services`), optional `/blog`, `/apps`.
- Single `Scaffold` shell: persistent header + footer; `child` = router outlet.
- Header: logo (placeholder), nav menu (from §5), primary CTA “Book Consultation” → `/appointments`, optional secondary “About Master Elf” → `/about`. Mobile: drawer or bottom nav.

### 1.5 Header & footer (structure only)
- **Skip to content:** First focusable control: link/button that scrolls focus to main content (`#content` or `main`) for accessibility (matches Joey Yap).
- **Header:** Logo, nav with dropdowns (About → Journey, Method; Learning → 3 academies; Resources → BaZi Plotter, Feng Shui Explorer, Flying Star Charts, Store; News & Events → Events, Blog, Media), language switcher, primary CTA “Contact Us” / “Book Consultation”, optional secondary CTA. Use Material Icons / Lucide for menu, phone, etc.
- **Footer:** Two office blocks (address + phone each), Quick links (§11), Resources section, “Chat with us!” (WhatsApp, email), “Our Social's Media” (§4), copyright, Terms / Disclaimer / Privacy (§12). Use placeholder logo; legal links to `#` or TBD.

**Deliverable:** App runs on web; switching locale changes fonts and labels; navigation and footer links go to placeholder pages (empty content).

---

## Phase 2: Homepage sections (Week 2)

**Goal:** Homepage matches Joey Yap structure; all content keys come from INFORMATION_NEEDED.md; images/videos are placeholders.

### 2.1 Hero
- Headline line 1 & 2 (§2), with optional **emphasis word** (e.g. gold) and **multi-line** layout to match reference.
- Subline paragraph.
- Two CTAs: primary “Book Consultation”, secondary “About Master Elf”.
- Background: hero placeholder image or gradient overlay.

### 2.2 Section 2 – “Experience / Transformation” (events strip)
- Section heading (§8.1) with **multi-line** support (e.g. “Experience guided, actionable Transformation”).
- “Coming up next” label; **multiple event cards** in a horizontal carousel (e.g. 3 cards from §10 or placeholders).
- Event card: image placeholder, optional **“Limited seats”** badge, title, date, location, short description, “View Event” link.
- “All Upcoming Events” label + “Explore All Events” button → `/events`.

### 2.3 Section 3 – “Knowledge / Framework” (academies/learning)
- Section heading with **multi-line** layout (§8.2) + body paragraph + optional “X+ students”.
- Three cards: title, short description, “Explore Courses” button; link from §8.2 (or placeholder).
- Card images: placeholders (e.g. QiMen, BaZi, Feng Shui logos as placeholders).

### 2.4 Section 4 – Consultations / “Map”
- Section heading with **multi-line** layout + intro paragraph (§8.3).
- Four consultation blocks: **category** (e.g. “Destiny/Personal Readings”), **method** (e.g. “BaZi”), **question** (italic/prominent), short description, “Get Consultation” → `/appointments`. Icons: open-source (e.g. Lucide `user`, `calendar`, `home`, `clock`).

### 2.5 Section 5 – Story (About teaser)
- “The Story of [Master Elf]” (multi-line if needed) + 2–3 paragraphs (§8.4).
- CTA “Master Elf's Journey” → `/about`.
- “Featured in”: horizontal row of logo placeholders (or hide if “None” in §8.4).

### 2.6 Section 6 – Testimonials
- Section heading “Authentic Insights. Measurable Impact.” (multi-line) + two sublines (§8.5).
- Horizontal carousel of testimonial cards: **Watch** button/link, quote, name, location; video = play icon + thumbnail placeholder. At least 1 testimonial; use placeholder text if needed.

### 2.7 Section 7 – Final CTA
- “Not Sure Where To Start?” + body + “Contact Us” button → `/contact` (§8.6).

**Deliverable:** Full homepage with all sections; copy from INFORMATION_NEEDED.md or placeholders; all media placeholders.

---

## Phase 3: Sticky CTA, popup, and contact (Week 3)

### 3.1 Sticky CTA bar (§6)
- If “Show this bar? = Yes”: fixed bottom bar with icon (e.g. Lucide `megaphone` or `gift`), button text (e.g. “Free 12 Animal Forecast”), link to popup or article. Dismissible (e.g. ×).

### 3.2 Popup / modal (§7)
- If “Show popup? = Yes”: on first visit (or after delay), show modal with title line 1 & 2, short description, optional image placeholder, form (e.g. email + “Notify me”) and/or primary button “Read Full Articles” / “Submit” with link. Use `showDialog` or overlay route.

### 3.3 Contact page
- “Contact Us” page: offices from §3 (address, phone, company name); “Chat with us!” (WhatsApp, email); map placeholder (or embed map if address provided). Use icons for phone, email, location.

### 3.4 About / Journey page (§9)
- Page title, breadcrumb “About Master Elf”, hero headline + optional hero image placeholder.
- Bullets 1–4; optional gallery (placeholder grid); “Featured in” same as homepage.

**Deliverable:** Sticky bar and popup (if enabled), contact page, about page with placeholders.

---

## Phase 4: Events and remaining pages (Week 4)

### 4.1 Events calendar page (§10)
- Hero headline + subline; “Coming up next”; search placeholder; table or card list: Event, Date, Location.
- Events from §10 (or `DataService.events` if you add that). Each event: optional image placeholder, “View” / “Secure your seat” link.

### 4.2 Consultations / Appointments page
- Landing for “Book Consultation” and “Get Consultation”: short intro + links to contact or external booking (from §5); optional service cards repeating §8.3.

### 4.3 Footer and legal
- Finalize footer links; Terms, Disclaimer, Privacy from §12 (links to # or TBD).
- Optional: Blog/News stub if §13 says Yes.

**Deliverable:** Events page, consultations entry page, footer/legal complete.

---

## Phase 5: Polish and SEO (Week 5)

### 5.1 Responsive and UX
- Breakpoints: mobile (< 768), tablet (768–1024), desktop (> 1024). Test header (drawer vs nav), carousels, and grids.
- Smooth scroll to section anchors from header; hover states on cards and buttons; optional light scroll animations.

### 5.2 SEO and web
- `web/index.html`: title, meta description, Open Graph; favicon from §1 or placeholder.
- Semantic headings (h1 on hero, h2 per section); alt texts for placeholder images.

### 5.3 Accessibility and performance
- **Skip to content:** Ensure first focusable element jumps to main content (implemented in Phase 1).
- Focus order, aria-labels where needed; contrast check.
- Lazy load images; ensure placeholders don’t block first paint.

**Deliverable:** Responsive, SEO-friendly, accessible site ready for content and asset swap.

---

## File structure (target)

```
lib/
  main.dart
  app.dart                    # MaterialApp, theme, router, locale
  router.dart                 # go_router config
  theme/
    app_theme.dart
    app_typography.dart
  l10n/                       # generated from ARB
  l10n_arb/
    app_en.arb
    app_km.arb
    app_zh.arb
  config/
    app_content.dart          # Optional: read from INFORMATION_NEEDED or const maps
  screens/
    home/
      home_screen.dart
      widgets/
        hero_section.dart
        events_section.dart
        academies_section.dart
        consultations_section.dart
        story_section.dart
        testimonials_section.dart
        cta_section.dart
    about/
      about_screen.dart
    events/
      events_screen.dart
    contact/
      contact_screen.dart
    appointments/
      appointments_screen.dart
  widgets/
    app_header.dart
    app_footer.dart
    locale_switcher.dart
    sticky_cta_bar.dart
    forecast_popup.dart
  assets/
    images/
      placeholders/
        logo.png
        hero_bg.png
        event_default.png
        profile_default.png
        featured_logo_1.png ... 
```

---

## Content and copy

- All section titles, body text, button labels, and nav items are defined in INFORMATION_NEEDED.md. Implement with:
  - **Filled rows:** use your values.
  - **Empty rows:** use Joey Yap example as placeholder (or a generic “Master Elf” version) and mark in code with `// TODO: replace with client copy`.
- Translations: start with EN in ARB; add KM/ZH keys with same EN text or “TBD” until you provide translations.

---

## Icon and image placeholders

| Use case | Implementation |
|----------|----------------|
| Logo | `assets/images/placeholders/logo.png` (or Icon + text “Master Elf”) |
| Hero background | Placeholder image or `Container` + gradient |
| Event cards | Single `event_default.png` or colored container + icon |
| Academy/service cards | Placeholder image or Lucide icon (e.g. `book_open`, `compass`, `home`) |
| Testimonial video | Card with play icon (Lucide `play`) + placeholder thumbnail |
| “Featured in” logos | 4–6 placeholder logos in `placeholders/featured_*.png` |
| 12 Animals popup | One placeholder image |
| About hero / gallery | Placeholder images |

---

## Summary checklist

- [ ] Phase 1: Dependencies, theme, fonts, i18n (EN/KM/ZH), routing, **Skip to content**, header (with nav dropdowns), footer (2 offices, Quick Links, Resources, Chat, Social, legal)
- [ ] Phase 2: Hero (multi-line + emphasis), Events strip (multiple cards + “Limited seats” badge), Academies, Consultations (4 blocks), Story, Testimonials (Watch + carousel), Final CTA
- [ ] Phase 3: Sticky CTA bar, popup (title + form + Read Full Articles), contact page, about page
- [ ] Phase 4: Events page, appointments page, footer/legal
- [ ] Phase 5: Responsive, SEO, a11y (incl. skip to content), performance

**Verified against [home.joeyyap.com](https://home.joeyyap.com/):** Navigation structure, all 7 homepage sections, multi-line headings, events carousel, sticky bar, popup, footer (2 offices, links, chat, social, legal). No gaps.

Once you confirm this plan (or request changes), implementation can start from Phase 1.
