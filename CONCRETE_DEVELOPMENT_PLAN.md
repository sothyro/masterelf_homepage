# Concrete Development Plan – Design Polish

This document turns [DESIGN_POLISH_PLAN.md](DESIGN_POLISH_PLAN.md) into **ordered, actionable tasks** with specific files and implementation steps. Work through tasks in order; dependencies are noted.

---

## Phase A: Theme & colour foundation

### A1. Extend `AppColors` with dark palette and glow

**File:** `lib/theme/app_theme.dart`

**Actions:**

1. Add these constants inside `AppColors` (keep all existing ones):

```dart
// Dark palette (rich darks for depth)
static const Color backgroundDark = Color(0xFF0A0A0C);      // deepest
static const Color surfaceDark = Color(0xFF121214);
static const Color surfaceElevatedDark = Color(0xFF1A1A1E);
static const Color overlayDark = Color(0xFF0D0D0F);          // for glass fill
static const Color borderDark = Color(0xFF2A2A2E);
static const Color borderLight = Color(0xFFC9A227);          // gold, reuse for glass border
// Vibrant accent glow (shadows, highlights)
static const Color accentGlow = Color(0xFFC9A227);           // same as accent; use with alpha for shadows
```

2. Do not remove or rename existing `primary`, `accent`, `surface`, `background`, etc. (other code still references them).

**Checkpoint:** Project compiles; no visual change yet.

---

### A2. Define `AppShadows` in theme

**File:** `lib/theme/app_theme.dart`

**Actions:**

1. Add a new class after `AppColors` (use Flutter’s `BoxShadow` from `package:flutter/material.dart` or `package:flutter/painting.dart`):

```dart
class AppShadows {
  AppShadows._();

  static const double _blurCard = 12;
  static const double _blurCardHover = 20;
  static const double _blurHeader = 16;
  static const double _blurDialog = 24;
  static const double _blurStickyCta = 16;
  static const double _blurAccent = 12;

  static List<BoxShadow> get card => [
    BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: _blurCard, offset: const Offset(0, 4)),
    BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: _blurCard * 2, offset: const Offset(0, 2)),
  ];

  static List<BoxShadow> get cardHover => [
    BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: _blurCardHover, offset: const Offset(0, 6)),
    BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: _blurCardHover * 1.5, offset: const Offset(0, 3)),
  ];

  static List<BoxShadow> get header => [
    BoxShadow(color: Colors.black.withValues(alpha: 0.35), blurRadius: _blurHeader, offset: const Offset(0, 4)),
  ];

  static List<BoxShadow> get dialog => [
    BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: _blurDialog, offset: const Offset(0, 8)),
    BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: _blurDialog * 1.5, offset: const Offset(0, 4)),
  ];

  static List<BoxShadow> get stickyCta => [
    BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: _blurStickyCta, offset: const Offset(-2, 0)),
    BoxShadow(color: AppColors.accentGlow.withValues(alpha: 0.2), blurRadius: _blurStickyCta, offset: const Offset(-2, 0)),
  ];

  static List<BoxShadow> get accentButton => [
    BoxShadow(color: AppColors.accentGlow.withValues(alpha: 0.4), blurRadius: _blurAccent, offset: const Offset(0, 4)),
    BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: _blurAccent, offset: const Offset(0, 2)),
  ];
}
```

2. `BoxShadow` is provided by `package:flutter/material.dart` (or `painting.dart`); no extra import needed if the file already imports Material.

**Checkpoint:** `AppShadows.card`, `.header`, etc. are available; no UI uses them yet.

---

### A3. Add `AppTheme.dark()` and wire `ColorScheme.dark`

**File:** `lib/theme/app_theme.dart`

**Actions:**

1. Add a static method `AppTheme.dark()` that returns `ThemeData` with:
   - `brightness: Brightness.dark`
   - `useMaterial3: true`
   - `colorScheme: ColorScheme.dark(primary: AppColors.primary, surface: AppColors.surfaceDark, onSurface: AppColors.onPrimary, ...)` using `AppColors` (and new dark tokens where appropriate for surface/background)
   - `scaffoldBackgroundColor: AppColors.backgroundDark`
   - Same `appBarTheme`, `elevatedButtonTheme`, `outlinedButtonTheme`, `cardTheme` structure as light, but with dark surface colours and `AppColors.accent` for primary/buttons
   - Card: use `color: AppColors.surfaceElevatedDark`, `elevation: 0` (we use custom `BoxDecoration` with `AppShadows` later)

2. Keep `AppTheme.light()` unchanged for now (optional Phase E will align it).

**Checkpoint:** `ThemeData` dark exists; not yet used by app.

---

### A4. Use dark theme in app and pass text theme to both themes

**File:** `lib/app.dart`

**Actions:**

1. In `MaterialApp.router`:
   - Set `theme: theme` where `theme` is built from `AppTheme.dark()` (not `AppTheme.light()`) with the same `textTheme: textThemeForLocale(...)`.
   - Set `darkTheme: theme` to the same (or build from `AppTheme.light()` with same text theme if you want a toggle later).
   - So for now: single `theme` = dark + locale text theme.

2. Ensure `theme` uses `AppTheme.dark().copyWith(textTheme: textThemeForLocale(localeNotifier.locale.languageCode))`.

**Checkpoint:** App runs with dark theme; scaffold and surfaces may still need to be explicitly set in shell/sections (Phase C).

---

## Phase B: Glassmorphism system

### B1. Create reusable `GlassContainer` widget

**File:** `lib/widgets/glass_container.dart` (new file)

**Actions:**

1. Create a stateless widget that:
   - Takes `child`, `blurSigma` (default 10), `color` (default `AppColors.overlayDark.withValues(alpha: 0.85)`), `borderRadius`, `border` (optional; default gold thin border), `boxShadow` (optional; default `AppShadows.header` or empty), `padding`.
   - Builds: `ClipRRect(borderRadius: borderRadius, child: BackdropFilter(imageFilter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma), child: Container(decoration: BoxDecoration(color: color, borderRadius: borderRadius, border: border, boxShadow: boxShadow), padding: padding, child: child)))`.
   - Import `dart:ui` for `ImageFilter`.

2. Export a simple API, e.g. `GlassContainer({ Key? key, required Widget child, double blurSigma = 10, Color? color, BorderRadius? borderRadius, Border? border, List<BoxShadow>? boxShadow, EdgeInsetsGeometry? padding })`.

**Checkpoint:** Can wrap any child in glass; used in next tasks.

---

### B2. Apply glass + shadow to header (mobile and desktop)

**File:** `lib/widgets/app_header.dart`

**Actions:**

1. Replace the outer `Container` decoration (in both `_MobileHeader` and `_DesktopHeader`) with `GlassContainer`:
   - Use `color: AppColors.overlayDark.withValues(alpha: 0.88)` (or from theme).
   - Use existing `borderRadius` and gold border; add `boxShadow: AppShadows.header`.
   - Keep the same layout (Row, logo, nav, CTA).

2. Ensure `GlassContainer` wraps the same content that the current `Container` wraps (padding and child structure unchanged).

**Checkpoint:** Header has blur and soft shadow; gold border preserved.

---

### B3. Apply glass to drawer

**File:** `lib/widgets/app_drawer.dart`

**Actions:**

1. Replace the `Container` that wraps the drawer content with `GlassContainer`:
   - Same fill colour style (dark, ~0.88 alpha), `border: right BorderSide(gold)`.
   - Optional: reduce `blurSigma` on narrow screens (e.g. 8) if performance is an issue.

**Checkpoint:** Drawer has frosted glass effect.

---

### B4. Apply glass to dropdown menus (nav + locale)

**File:** `lib/widgets/app_header.dart`

**Actions:**

1. In `_NavDropdown._showDropdown` and `_LocaleSwitcher._showLocaleMenu`: when calling `showMenu`, the menu’s `color` is currently `Color(0xFF2A2A2A).withValues(alpha: 0.88)`.
2. Options (choose one approach):
   - **Option A:** Build a custom overlay (e.g. `showDialog` or `Overlay`) that uses a `GlassContainer` as the menu panel, and position it under the button; populate with the same menu items and callbacks. This gives full glass + blur.
   - **Option B:** Keep `showMenu` but set `color` to a translucent dark (e.g. `AppColors.overlayDark.withValues(alpha: 0.92)`) and add a thin gold border via `shape`; no blur inside platform menu. (Simpler; add blur later with custom overlay if needed.)

3. Document in code: “Dropdown uses translucent fill; for full glass blur we could switch to custom overlay (see DESIGN_POLISH_PLAN).”

**Checkpoint:** Dropdowns look consistent with dark glass style (with or without blur).

---

### B5. Apply glass + shadow to sticky CTA bar

**File:** `lib/widgets/sticky_cta_bar.dart`

**Actions:**

1. Replace the `Material` + `Container` (solid accent) with `GlassContainer`:
   - `color: AppColors.accent.withValues(alpha: 0.9)` (or 0.85) so it stays vibrant but slightly translucent.
   - `borderRadius`: same as current (topLeft + bottomLeft 12).
   - `border`: left/top/bottom with gold or borderLight.
   - `boxShadow: AppShadows.stickyCta`.

2. Keep the same child (column with dismiss, icon, rotated text).

**Checkpoint:** Sticky CTA is glass-style with layered shadow.

---

### B6. Apply glass + shadow to Legal popup

**File:** `lib/widgets/legal_popup.dart`

**Actions:**

1. Replace `Dialog(shape: ..., child: ConstrainedBox(...))` with a `Dialog` whose child is `GlassContainer`:
   - `GlassContainer` wraps the same `ConstrainedBox` content.
   - Use `borderRadius: BorderRadius.circular(16)`, `boxShadow: AppShadows.dialog`, optional gold border.

2. Ensure the dialog still has no solid white/dark fill behind the glass (barrier can stay as is).

**Checkpoint:** Legal popup has glass panel and shadow.

---

### B7. Apply glass + shadow to Forecast popup

**File:** `lib/widgets/forecast_popup.dart`

**Actions:**

1. Same as B6: wrap the dialog content in `GlassContainer` with `AppShadows.dialog` and matching border radius.

**Checkpoint:** Both dialogs use glass consistently.

---

## Phase C: Rich dark sections & cards

### C1. Set scaffold background to dark in shell

**File:** `lib/widgets/app_shell.dart`

**Actions:**

1. Set `Scaffold(backgroundColor: AppColors.backgroundDark)` (or from `Theme.of(context).scaffoldBackgroundColor` if theme already sets it from A4).

**Checkpoint:** Main scroll area has dark background.

---

### C2. Hero – richer gradient and button shadows

**File:** `lib/screens/home/widgets/hero_section.dart`

**Actions:**

1. First gradient (solid fallback): use `AppColors.backgroundDark` and `AppColors.surfaceDark` (or primary dark) for a deeper gradient.
2. Overlay gradient: keep or slightly deepen; ensure contrast for text.
3. FilledButton: add `style: FilledButton.styleFrom(..., elevation: 0, shadowColor: Colors.transparent)` and wrap in a `Container` with `decoration: BoxDecoration(boxShadow: AppShadows.accentButton)` if needed, or apply shadow to the button’s parent so the gold glow is visible.
4. OutlinedButton: optional soft shadow (e.g. one layer from `AppShadows.card`).

**Checkpoint:** Hero feels darker and CTAs have accent shadow.

---

### C3. Events section – dark background and dark cards with shadows

**File:** `lib/screens/home/widgets/events_section.dart`

**Actions:**

1. Section `Container` background: change from `AppColors.background` to `AppColors.surfaceDark` (or `backgroundDark`).
2. Section title/subtitle text colours: use `AppColors.onPrimary` or theme `onSurface` so they’re light on dark.
3. `_EventCard`: replace `Card` with a `Container` (or keep `Card` with `color: AppColors.surfaceElevatedDark`, `elevation: 0`) and add `BoxDecoration(borderRadius: 12, color: AppColors.surfaceElevatedDark, boxShadow: AppShadows.card, border: Border.all(color: AppColors.borderDark, width: 1))`.
4. Card body text: use light text colours (onSurface / onPrimary).

**Checkpoint:** Events strip is dark with elevated cards and layered shadows.

---

### C4. Academies section – overlay and card shadows

**File:** `lib/screens/home/widgets/academies_section.dart`

**Actions:**

1. Overlay: keep or change to `AppColors.overlayDark.withValues(alpha: 0.6)` for consistency.
2. `_AcademyCard`: add layered shadow: `boxShadow: AppShadows.card` (and optionally one accent-tinted layer). Keep dark fill; optional thin `border: Border.all(AppColors.borderLight, 1)`.

**Checkpoint:** Academy cards match global shadow system.

---

### C5. Consultations section – dark overlay and dark/glass cards

**File:** `lib/screens/home/widgets/consultations_section.dart`

**Actions:**

1. Overlay: use same dark overlay style as academies.
2. `_ConsultBlock`: replace `Card` with a container using `AppColors.surfaceElevatedDark`, `AppShadows.card`, and optional gold border or accent shadow. Ensure icon container and text use light/onSurface colours.

**Checkpoint:** Consultation blocks are dark with consistent shadows.

---

### C6. Story section – dark background and logo strip

**File:** `lib/screens/home/widgets/story_section.dart`

**Actions:**

1. Section background: `AppColors.surfaceDark`.
2. All text: switch to light-on-dark (e.g. `AppColors.onPrimary` or theme onSurface for dark).
3. “Featured in” placeholders: use small containers with `AppColors.surfaceElevatedDark` and `AppShadows.card` (or a single `GlassContainer` strip).

**Checkpoint:** Story section is dark and cohesive.

---

### C7. Testimonials section – dark background and cards

**File:** `lib/screens/home/widgets/testimonials_section.dart`

**Actions:**

1. Section background: `AppColors.surfaceDark` (or `backgroundDark`).
2. Headings and body: light text colours.
3. `_TestimonialCard`: dark surface (`surfaceElevatedDark`), `AppShadows.card`, optional thin border; keep “Watch” and quote text readable (light colours).

**Checkpoint:** Testimonials match dark + shadow style.

---

### C8. CTA section – richer dark and accent glow

**File:** `lib/screens/home/widgets/cta_section.dart`

**Actions:**

1. Background: use `AppColors.backgroundDark` or a short gradient (e.g. `surfaceDark` → `primary`) with optional very subtle radial accent glow.
2. FilledButton: use `AppShadows.accentButton` (e.g. wrap in container with shadow or set in theme from Phase D).

**Checkpoint:** Final CTA feels rich and vibrant.

---

### C9. Footer – dark with top border or shadow

**File:** `lib/widgets/app_footer.dart`

**Actions:**

1. Keep `AppColors.primary` or switch to `AppColors.surfaceDark`; add `BoxDecoration` with top `Border(borderSide: BorderSide(color: AppColors.borderLight, width: 1))` or a single soft `boxShadow` above the footer.

**Checkpoint:** Footer fits dark system and has subtle separation.

---

## Phase D: Shadows & elevation polish

### D1. Theme card and button shadows (dark theme)

**File:** `lib/theme/app_theme.dart`

**Actions:**

1. In `AppTheme.dark()`:
   - `cardTheme`: set `color: AppColors.surfaceElevatedDark`, `elevation: 0`, `shadowColor: Colors.transparent` (cards that still use `Card` get colour; custom cards use `AppShadows` in widgets).
   - `elevatedButtonTheme`: add `elevation: 0` and a custom `shadowColor` or rely on widgets to wrap with shadow; alternatively use `MaterialStateProperty` for `elevation`/shadow so filled buttons get `AppShadows.accentButton` (may require custom `ButtonStyle` with decoration).
   - Easiest: ensure all FilledButtons that are primary CTAs are wrapped or styled in their widgets with `AppShadows.accentButton` (already done in C2, C8; add elsewhere as needed).

2. Add a comment in theme: “For accent button shadow use AppShadows.accentButton in widget layer.”

**Checkpoint:** Theme documents shadow usage; widgets already applying shadows are consistent.

---

### D2. Back-to-top FAB shadow

**File:** `lib/widgets/app_shell.dart`

**Actions:**

1. For `FloatingActionButton.small`: add `elevation` and `shadowColor`, or wrap in `Container(decoration: BoxDecoration(boxShadow: AppShadows.stickyCta))` if FAB supports it. Alternatively use `FloatingActionButton(..., elevation: 8, shadowColor: AppColors.accentGlow.withValues(alpha: 0.3))` for a slight accent tint.

**Checkpoint:** FAB has defined elevation/accent shadow.

---

### D3. Optional card hover (if desired)

**Files:** `lib/screens/home/widgets/events_section.dart`, `lib/screens/home/widgets/testimonials_section.dart`, etc.

**Actions:**

1. For event and testimonial cards: use `MouseRegion` or `InkWell` and when hovered replace `AppShadows.card` with `AppShadows.cardHover` (use stateful widget or `HoverVisibility`-style logic). Optional: subtle scale or border colour change.

**Checkpoint:** Cards respond to hover with stronger shadow (optional).

---

## Phase E: Final polish & accessibility

### E1. Contrast and muted text

**File:** `lib/theme/app_theme.dart`

**Actions:**

1. Ensure `ColorScheme.dark` uses `onSurfaceVariant` that meets WCAG AA on `surfaceDark` (e.g. grey ~0.7 luminance). Adjust `AppColors.onSurfaceVariant` or theme override if needed.
2. Check gold `AppColors.accent` on dark backgrounds (contrast ratio); if needed, use a slightly lighter gold for text or borders only.

**Checkpoint:** Contrast ratios checked (manually or with a checker).

---

### E2. Focus indicators

**File:** `lib/theme/app_theme.dart`

**Actions:**

1. In `AppTheme.dark()` set `focusColor` and `hoverColor` for buttons; ensure `OutlineInputBorder` and `InputDecoration` use a visible focus border (e.g. gold or borderLight) for form fields in Forecast popup.

**Checkpoint:** Keyboard/screen reader focus is visible.

---

### E3. Performance (blur)

**Files:** `lib/widgets/glass_container.dart`, `lib/widgets/app_drawer.dart`, `lib/widgets/app_header.dart`

**Actions:**

1. Optionally: in `GlassContainer`, if `MediaQuery.of(context).size.width < 600` (or a breakpoint), reduce `blurSigma` to 6.
2. Document: “Reduce blur on low-end or small screens if needed.”

**Checkpoint:** No jank on target devices; blur reduced on small screens if desired.

---

### E4. Optional light theme parity

**File:** `lib/app.dart`

**Actions:**

1. If you want a theme toggle: add a `ThemeMode` state (e.g. in `LocaleNotifier` or a new `ThemeNotifier`) and set `MaterialApp.router(themeMode: themeMode, theme: AppTheme.light()..., darkTheme: AppTheme.dark()...)`. Phase C/D would need light-theme equivalents for section backgrounds and card colours if you support switching.

**Checkpoint:** Optional; only if you need light/dark switch.

---

## Task checklist (copy and tick)

**Phase A**  
- [ ] A1 Extend AppColors  
- [ ] A2 Define AppShadows  
- [ ] A3 Add AppTheme.dark()  
- [ ] A4 Use dark theme in app  

**Phase B**  
- [ ] B1 Create GlassContainer  
- [ ] B2 Header glass + shadow  
- [ ] B3 Drawer glass  
- [ ] B4 Dropdown menus glass/translucent  
- [ ] B5 Sticky CTA glass + shadow  
- [ ] B6 Legal popup glass  
- [ ] B7 Forecast popup glass  

**Phase C**  
- [ ] C1 Scaffold background dark  
- [ ] C2 Hero gradient + button shadows  
- [ ] C3 Events section + cards  
- [ ] C4 Academies overlay + card shadows  
- [ ] C5 Consultations dark cards  
- [ ] C6 Story section dark  
- [ ] C7 Testimonials dark  
- [ ] C8 CTA section  
- [ ] C9 Footer  

**Phase D**  
- [ ] D1 Theme card/button shadows  
- [ ] D2 FAB shadow  
- [ ] D3 Optional card hover  

**Phase E**  
- [ ] E1 Contrast  
- [ ] E2 Focus indicators  
- [ ] E3 Blur performance  
- [ ] E4 Optional light theme  

---

## Suggested sprint order

1. **Sprint 1 (Foundation):** A1 → A2 → A3 → A4 → B1.  
   Outcome: Dark theme and glass widget ready.

2. **Sprint 2 (Glass UI):** B2 → B3 → B5 → B6 → B7 → B4.  
   Outcome: Header, drawer, sticky CTA, dialogs (and menus) use glass.

3. **Sprint 3 (Sections):** C1 → C2 → C3 → C4 → C5 → C6 → C7 → C8 → C9.  
   Outcome: Full page dark with consistent cards and shadows.

4. **Sprint 4 (Polish):** D1 → D2 → D3 → E1 → E2 → E3 → E4 (optional).  
   Outcome: Shadows and a11y/performance finalized.

You can implement phase by phase or sprint by sprint; each checkpoint keeps the app runnable and testable.
