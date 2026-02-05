# Master Elf Homepage – Design Polish Plan

**Goal:** Evolve the current look into a more **polished**, **intelligent** design that is **dark but vibrant**, with **rich dark colours**, **shadow aesthetics**, and **glassmorphism** applied consistently across the application.

---

## 1. Current Design Analysis

### 1.1 Theme & Colour System

| Area | Current state |
|------|----------------|
| **Theme** | Light-only (`AppTheme.light()`). No dark theme. |
| **Primary** | `#1A1A1A` (near black) – used for header bar, footer, hero overlay, CTA section. |
| **Accent** | `#C9A227` (gold) – buttons, highlights, borders, sticky CTA. |
| **Surface / Background** | White `#FFFFFF` and light grey `#F5F5F5` for main content and sections. |
| **Contrast** | Strong light/dark alternation: Hero + Academies + Consultations + CTA are dark; Events, Story, Testimonials are light. |

**Gaps:**

- No single “dark base” for the whole app; mix of light sections on light scaffold feels inconsistent for a “dark, vibrant” target.
- Palette is functional but not “rich” – flat `#1A1A1A` and single gold; no depth layers (e.g. charcoal, navy, warm darks).
- Accent is used well but could be more “vibrant” (e.g. subtle glow, gradient, or hover states).

### 1.2 Shadows & Elevation

| Component | Current state |
|-----------|----------------|
| **Theme cards** | `elevation: 2`, neutral shadow. |
| **Header** | No elevation; flat translucent bar. |
| **Sticky CTA** | `elevation: 12`, `shadowColor: Colors.black38`. |
| **Contact / CTA buttons** | Gold gradient + one `BoxShadow` (accent, blur 6, offset 0,2). |
| **Academy cards** | Single `BoxShadow` (black 0.3 alpha, blur 8, offset 0,4). |
| **Drawer / dropdowns** | `elevation: 12` on menus; no coloured or layered shadows. |

**Gaps:**

- No layered shadow system (e.g. soft ambient + directional).
- No accent-tinted shadows for CTAs or cards to support “vibrant” feel.
- No inner shadows or soft depth on glass-style surfaces.
- Elevation hierarchy is ad hoc rather than a defined scale.

### 1.3 Glassmorphism

| Component | Current state |
|-----------|----------------|
| **Header (mobile & desktop)** | Semi-opaque fill `#2A2A2A` at 88% – **already glass-like** but no blur. |
| **Drawer** | Same dark translucent fill; gold right border; no blur. |
| **Dropdown menus** | Same colour and border; no blur. |
| **Dialogs (Legal, Forecast)** | Opaque `Dialog` with solid background; no glass. |
| **Sticky CTA bar** | Solid accent colour; no transparency or blur. |
| **Cards** | Solid surfaces; no frosted effect. |

**Gaps:**

- No `BackdropFilter` (blur) anywhere – glass effect is “translucent only”.
- Overlays (dialogs, popups) don’t use glass; opportunity for modals and floating UI.
- Sticky CTA and floating elements could use glass + shadow for consistency.

### 1.4 Section-by-Section Summary

| Section | Background | Cards / Content | Improvement opportunities |
|---------|------------|-----------------|----------------------------|
| **Hero** | Dark gradient + video | Text + 2 buttons | Deeper gradient; soft glow on headline; buttons with shadow/glass. |
| **Events** | `#F5F5F5` | Material `Card` (white) | Darker base or dark cards with rich shadows; optional glass panel for strip. |
| **Academies** | Image + black 50% overlay | Dark cards, one shadow | Glass overlay for section; cards with layered shadow + optional glass. |
| **Consultations** | Image + black 45% overlay | White `Card` | Align with dark theme; glass or dark cards with accent shadow. |
| **Story** | White | Text + placeholder logos | Dark or dark-tinted section; logo strip with subtle glass/shadow. |
| **Testimonials** | `#F5F5F5` | White `Card` | Dark section; testimonial cards with glass or dark style + shadows. |
| **CTA** | `#1A1A1A` | Centred text + button | Richer dark; optional glass card for CTA block; accent glow on button. |
| **Header** | Translucent dark | Gold CTA | Add blur (glass); subtle shadow; keep current shape. |
| **Footer** | Solid primary | Links, offices, social | Optional glass strip or layered shadow; subtle top highlight. |
| **Sticky CTA** | Solid accent | Text + icon | Glass (blur + transparency) + layered shadow. |
| **Drawer** | Translucent dark | Tiles, chips | Add blur; optional inner shadow. |
| **Popups** | Opaque dialog | Form / legal text | Glass dialog (blur + border) for consistency. |

### 1.5 Typography & Spacing

- **Fonts:** Exo 2 (EN), Dangrek/Siemreap (KM), Noto Sans SC (ZH) – good; no change needed for this plan.
- **Spacing:** Consistent padding (e.g. 24, 56) and constrained width (900–1100) – keep; polish is colour/shadow/glass.

---

## 2. Design Direction (Target)

- **Dark but vibrant:** Base = rich darks (charcoal, deep navy, or warm black) with clear hierarchy (surface, elevated, overlay).
- **Vibrant:** Gold accent remains; add subtle glow on key CTAs and optional secondary accent (e.g. warm white or soft amber) for highlights.
- **Rich dark colours:** Replace flat `#1A1A1A` with a small palette (e.g. background dark, surface dark, elevated dark, overlay dark) for depth.
- **Shadow aesthetics:** Defined elevation scale with layered shadows (ambient + key) and optional accent-tinted shadows for buttons and cards.
- **Glassmorphism:** Frosted glass (blur + semi-transparent fill + light border) on header, drawer, dropdowns, sticky CTA, and dialogs; optional glass cards in key sections.

---

## 3. Proposed Development Plan

### Phase A: Theme & colour foundation (single source of truth)

**Objective:** Introduce a dark-first palette and optional dark theme so all components can be wired to one system.

1. **Extend `AppColors`** (in `lib/theme/app_theme.dart`):
   - Add dark palette: e.g. `backgroundDark`, `surfaceDark`, `surfaceElevatedDark`, `overlayDark`, `borderDark`, `borderLight`.
   - Keep existing names for compatibility; add new tokens (e.g. `primaryDark = Color(0xFF0D0D0D)`, `surfaceDarkVariant`, etc.).
   - Optionally add a second accent for “vibrant” (e.g. `accentGlow` for shadows/highlights).

2. **Add `AppTheme.dark()`** (or switch default to dark):
   - `ColorScheme.dark` using the new dark palette.
   - Same typography (locale-based) as light.
   - Card, button, and app bar themes using dark surfaces and gold accent.

3. **App entry point** (`lib/app.dart`):
   - Use dark theme as default (or add a theme mode toggle later); ensure `theme` and `darkTheme` both use locale-aware `textTheme`.

4. **Shadow tokens** (new or in `app_theme.dart`):
   - Define `AppShadows` (or equivalent): e.g. `card`, `cardHover`, `header`, `dialog`, `stickyCta`, `accentButton` (accent-tinted).
   - Each: list of `BoxShadow` (e.g. ambient + key; accent shadows for CTAs).

**Deliverables:**  
- Updated `app_theme.dart` with dark palette + shadow constants.  
- `app.dart` using dark theme (or both themes).  
- No visual change yet in shells/sections (next phases apply the tokens).

---

### Phase B: Glassmorphism system

**Objective:** Reusable glass style and apply it to header, drawer, dropdowns, sticky CTA, and dialogs.

1. **Glass widget / decorator** (e.g. `lib/widgets/glass_container.dart` or in theme):
   - Optional `BackdropFilter` with `ImageFilter.blur(sigmaX, sigmaY)`.
   - Semi-transparent fill (e.g. `Colors.white.withOpacity(0.08)` on dark, or dark with 0.7–0.85 opacity).
   - Optional border (e.g. `BorderSide(color: borderLight, width: 1)`).
   - Parameters: blur sigma, color, border radius, border, padding; child.

2. **Header:**
   - Replace current `Container` decoration with glass (blur + dark fill + gold/borderLight border).
   - Add one soft shadow from `AppShadows.header` so the bar floats.

3. **Drawer:**
   - Use same glass style (blur + fill + border).
   - Ensure performance is acceptable (blur can be costly on large areas).

4. **Dropdown menus** (header nav + locale):
   - When opening `showMenu`, use a custom route or overlay that uses the glass container (blur + fill + border) instead of opaque `color`.

5. **Sticky CTA bar:**
   - Replace solid accent container with glass (blur + accent-tinted transparency, e.g. gold at 0.85 opacity) + border + `AppShadows.stickyCta`.

6. **Dialogs (Legal popup, Forecast popup):**
   - Replace default `Dialog` background with glass (blur + dark fill + border) and apply `AppShadows.dialog`.

**Deliverables:**  
- Reusable glass component/decoration.  
- Header, drawer, dropdowns, sticky CTA, and both popups using glass + shadows.

---

### Phase C: Rich dark sections & cards

**Objective:** Make the page feel “dark but vibrant” with consistent section backgrounds and card treatment.

1. **Scaffold / root:**
   - Set scaffold background to dark (e.g. `AppColors.backgroundDark`) when using dark theme.

2. **Hero:**
   - Use richer gradient (e.g. primaryDark → primary with slight warmth).
   - Optional: very subtle radial gradient or glow behind headline (accent at low opacity).
   - Buttons: use `AppShadows.accentButton`; optional glass-style for outlined button.

3. **Events section:**
   - Background: dark (e.g. `surfaceDark` or `backgroundDark`).
   - Event cards: dark surface (`surfaceElevatedDark`) with layered shadow from `AppShadows.card` / `cardHover`; optional thin border (borderLight) or accent shadow on hover.

4. **Academies section:**
   - Keep image + overlay; optionally make overlay slightly glass (blur) or use richer dark overlay.
   - Academy cards: keep dark; add layered shadow (and optionally accent-tinted shadow); optional glass border.

5. **Consultations section:**
   - Same dark overlay approach.
   - Consultation blocks: dark card style (or glass) with `AppShadows.card` and accent hint on icon container or border.

6. **Story section:**
   - Background: dark (e.g. `surfaceDark`).
   - “Featured in” logo strip: small glass or dark tiles with subtle shadow.

7. **Testimonials section:**
   - Background: dark.
   - Testimonial cards: dark elevated surface or glass; layered shadow; optional accent line or glow.

8. **CTA section:**
   - Richer dark gradient or same dark with subtle accent glow.
   - Optional: wrap content in a glass or dark card with shadow; CTA button with accent shadow.

9. **Footer:**
   - Keep dark; add optional top border (borderLight) or very soft shadow above footer; optional glass if it overlaps content.

**Deliverables:**  
- All sections use dark palette tokens.  
- Cards and key blocks use `AppShadows` and optional glass; accent used for CTAs and highlights.

---

### Phase D: Shadows & elevation polish

**Objective:** Apply the shadow system everywhere and add accent-tinted shadows for vibrancy.

1. **Card theme (Material):**
   - In `AppTheme.dark()`, set `cardTheme` with `elevation` and `shadowColor` (or use `BoxDecoration` with `AppShadows.card` where cards are custom).

2. **Buttons:**
   - Elevated / Filled: `AppShadows.accentButton` (gold tint).
   - Outlined: optional soft shadow; hover state slightly stronger.

3. **Floating elements:**
   - Sticky CTA, FAB (back-to-top): ensure they use `AppShadows.stickyCta` / equivalent.

4. **Dialogs:**
   - Already glass in Phase B; confirm `AppShadows.dialog` (layered, soft).

5. **Navigation:**
   - Header bar shadow (Phase B); dropdowns and drawer already updated.

6. **Micro-interactions (optional):**
   - Hover/focus on cards: swap to `AppShadows.cardHover`; optional scale or border glow.

**Deliverables:**  
- Consistent use of `AppShadows` across cards, buttons, header, dialogs, sticky CTA.  
- Accent-tinted shadows on primary CTAs.

---

### Phase E: Final polish & accessibility

**Objective:** Ensure contrast, focus, and performance; optional light theme parity.

1. **Contrast (WCAG):**
   - Verify text on dark (onPrimary, onSurface for dark surfaces) and gold accent meet AA (or AAA where required).
   - Adjust `onSurfaceVariant` / muted text if needed.

2. **Focus indicators:**
   - Visible focus ring on buttons, links, and form fields (theme `focusColor` / `focusBorder`); ensure they work on dark and glass.

3. **Performance:**
   - If blur is heavy on low-end devices, consider reducing blur radius on mobile or offering a “reduce motion / simpler UI” option that skips blur.

4. **Optional:**
   - Re-enable or keep light theme and apply same structure (light palette + shadows + optional light glass) so switching theme doesn’t break layout.

**Deliverables:**  
- Contrast and focus checked; performance acceptable; optional light theme still usable.

---

## 4. Implementation Order Summary

| Phase | Focus | Key files |
|-------|--------|-----------|
| **A** | Theme, dark palette, shadow tokens | `app_theme.dart`, `app.dart` |
| **B** | Glass widget; header, drawer, menus, sticky CTA, dialogs | New glass widget; `app_header.dart`, `app_drawer.dart`, `sticky_cta_bar.dart`, `legal_popup.dart`, `forecast_popup.dart` |
| **C** | Section backgrounds and cards (dark + shadows) | All home section widgets, `app_footer.dart` |
| **D** | Shadow usage everywhere; accent shadows on CTAs | Theme + same widgets as B/C |
| **E** | Contrast, focus, performance, optional light theme | Theme, `app.dart`, and targeted widgets |

---

## 5. Technical Notes

- **BackdropFilter:** Requires a clip (e.g. `ClipRRect`) and can be expensive; use sparingly on large areas and test on low-end devices.
- **Blur values:** Typical sigma 8–15 for “glass”; start with 10 and tune.
- **Glass colour:** On dark, use dark fill (e.g. black or primary dark) at 0.7–0.88 alpha so content behind shows through slightly.
- **Shadows:** Flutter `BoxShadow` supports blur, spread, offset, and color; use 2–3 layers (e.g. soft large blur + smaller offset) for depth; accent shadow can use `AppColors.accent.withOpacity(0.25)`.

This plan keeps your current structure and content; it only refines theme, colours, shadows, and glass to achieve a more polished, dark, vibrant, and glassmorphism-led look.
