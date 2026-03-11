# Inspection Dashboard – Development Plan

## Overview

This plan adds an **Inspection Dashboard** where users can view existing inspections, edit or continue them, or start new ones. The current 18-step inspection form is preserved, with a **Save** button added on every step so users can save progress and return later.

---

## 1. Current State Summary

| Component | Current Behavior |
|-----------|------------------|
| **Form** | `SiteInspectionScreen` – 18 steps (Header + Sections 1–17) |
| **Save** | Only on step 18 (last step) |
| **Service** | `saveSiteInspection()` – Create only, no Read/Update/Delete |
| **Firestore** | `site_inspections` collection, read/write for authenticated users |
| **Navigation** | Direct to `/consultations/site-inspection` from consultations screen |
| **Logo** | `assets/icons/logomono.png` via `AppContent.assetLogo` |

---

## 2. Terminology

Use **"inspection"** consistently in:

- UI labels (e.g. "Inspection Dashboard", "My Inspections", "Save inspection")
- Routes (e.g. `/consultations/inspection-dashboard`)
- Code (e.g. `inspectionId`, `listInspections`)
- Localization keys (e.g. `inspectionDashboardTitle`)

---

## 3. CRUD Operations (Database Layer)

### 3.1 Firestore Document Structure

```
site_inspections/{inspectionId}
├── formData: Map<String, dynamic>     // All form fields
├── inspectorEmail: string
├── inspectionName: string             // Display name (projectName or fallback)
├── lastStep: int                      // 0–17, for resume
├── createdAt: Timestamp
└── updatedAt: Timestamp
```

**Inspection name rules:**

- Primary: `projectName` (trimmed)
- Fallback: `"Inspection {createdAt date}"` if `projectName` is empty

### 3.2 Service API (`site_inspection_service.dart`)

| Operation | Function | Description |
|-----------|----------|-------------|
| **Create** | `createInspection(formData, inspectorEmail)` | New document, returns `inspectionId` |
| **Read (list)** | `listInspections(inspectorEmail)` | List inspections for user, ordered by `updatedAt` desc |
| **Read (single)** | `getInspection(inspectionId)` | Fetch one inspection by ID |
| **Update** | `updateInspection(inspectionId, formData, lastStep)` | Update existing inspection |
| **Delete** | `deleteInspection(inspectionId)` | Delete inspection (optional, for cleanup) |

### 3.3 Firestore Security Rules

Existing rules already allow read/write for authenticated users:

```
match /site_inspections/{docId} {
  allow read, write: if request.auth != null;
}
```

Add query constraints if needed (e.g. filter by `inspectorEmail` in app code).

---

## 4. Routing

| Route | Screen | Purpose |
|-------|--------|---------|
| `/consultations/inspection-dashboard` | `InspectionDashboardScreen` | List inspections, "New Inspection" |
| `/consultations/site-inspection` | `SiteInspectionScreen` | New inspection (no ID) |
| `/consultations/site-inspection/:id` | `SiteInspectionScreen` | Edit/continue existing inspection |

Update `_knownPaths` and redirect logic in `app_router.dart` for auth.

---

## 5. Inspection Dashboard Screen

### 5.1 Layout

- Header: "Inspection Dashboard" + subtitle
- Back button → `/consultations`
- **New Inspection** button (primary)
- Grid/list of inspection cards

### 5.2 Inspection Card

Each card shows:

- **Master Elf logo** (`LogoWithShapeShadow` with `AppContent.assetLogo`)
- **Inspection name** (from `inspectionName` or `projectName`)
- **Secondary info** (optional): last updated date, step progress
- **Action**: Tap card or "Edit" / "Continue" button → navigate to `/consultations/site-inspection/:id`

### 5.3 Empty State

When no inspections:

- Message: "No inspections yet"
- CTA: "Start your first inspection"

### 5.4 Responsive

- Mobile: single column cards
- Desktop: grid (e.g. 2–3 columns)

---

## 6. Inspection Form Changes

### 6.1 Preserve 18 Steps

- Keep all 18 steps and section content unchanged.
- No changes to step structure or field definitions.

### 6.2 Save Button on Every Step

- Add a **Save** button visible on all steps (not only step 18).
- Placement: e.g. next to Back/Next in the bottom row.
- Behavior:
  - **New inspection**: Create document, show success, stay on form or offer "Go to Dashboard".
  - **Edit inspection**: Update document, show success, stay on form.

### 6.3 Edit Mode (Load Existing)

- When route has `:id`:
  - Call `getInspection(id)` on init.
  - Populate `_formData` and controllers from `formData`.
  - Set `_step` from `lastStep` (or 0 if missing).
  - Store `_inspectionId` for updates.

### 6.4 Save Logic

- **New** (`_inspectionId == null`): `createInspection()` → store returned `inspectionId`, switch to update mode.
- **Edit** (`_inspectionId != null`): `updateInspection()` with current `formData` and `_step`.

### 6.5 Success State

- After save: show success message.
- Options: "Continue editing", "Go to Inspection Dashboard", "New Inspection" (only when creating).

---

## 7. Navigation Flow

```
Consultations Screen (logged in)
    │
    ├── "Go to Dashboard" → /consultations/dashboard (appointments)
    │
    └── "Site inspection" → /consultations/inspection-dashboard  ← NEW (replace direct link)
                                │
                                ├── "New Inspection" → /consultations/site-inspection
                                │
                                └── [Inspection Card] → /consultations/site-inspection/:id
```

**Change:** The "Site inspection" button on the consultations screen should go to the Inspection Dashboard first, not directly to the form.

---

## 8. Implementation Order

### Phase 1: Service & Data

1. Extend `site_inspection_service.dart`:
   - `listInspections(inspectorEmail)`
   - `getInspection(inspectionId)`
   - `createInspection(...)` (extract from current save)
   - `updateInspection(inspectionId, formData, lastStep)`
   - `deleteInspection(inspectionId)` (optional)
2. Ensure `inspectionName` and `lastStep` are stored on create/update.

### Phase 2: Inspection Dashboard

3. Create `InspectionDashboardScreen`:
   - Load inspections for current user.
   - Render cards with logo + name.
   - Handle empty state.
   - Wire "New Inspection" and card taps.
4. Add route `/consultations/inspection-dashboard`.
5. Update consultations screen: "Site inspection" → Inspection Dashboard.

### Phase 3: Form Enhancements

6. Update `SiteInspectionScreen`:
   - Accept optional `inspectionId` from route.
   - Load inspection when editing.
   - Add Save button on every step.
   - Use create vs update based on `_inspectionId`.
   - Persist `lastStep` on save.
7. Add route `/consultations/site-inspection/:id`.

### Phase 4: Polish

8. Add/update localization keys for:
   - `inspectionDashboardTitle`
   - `inspectionDashboardSubtitle`
   - `inspectionNewInspection`
   - `inspectionEdit` / `inspectionContinue`
   - `inspectionNoInspections`
   - `inspectionStartFirst`
   - `inspectionSaveProgress`
9. Ensure all user-facing strings use "inspection" consistently.
10. Test full flow: new → save → dashboard → edit → save.

---

## 9. Files to Create/Modify

| File | Action |
|------|--------|
| `lib/services/site_inspection_service.dart` | Extend with CRUD |
| `lib/screens/consultations/inspection_dashboard_screen.dart` | **Create** |
| `lib/screens/consultations/site_inspection_screen.dart` | Modify (edit mode, Save on all steps) |
| `lib/router/app_router.dart` | Add routes, update redirects |
| `lib/screens/consultations/consultations_screen.dart` | Point "Site inspection" to dashboard |
| `lib/l10n/app_en.arb` (and km, zh) | Add new strings |
| `lib/config/app_content.dart` | No change (logo already defined) |

---

## 10. Consistency Checklist

- [ ] All CRUD operations implemented and used correctly
- [ ] "Inspection" used consistently in UI and code
- [ ] 18 steps unchanged
- [ ] Save available on every step
- [ ] Dashboard shows logo + inspection name on each card
- [ ] New vs edit flow works end-to-end
- [ ] Firestore rules remain valid
- [ ] Localization updated for en, km, zh
