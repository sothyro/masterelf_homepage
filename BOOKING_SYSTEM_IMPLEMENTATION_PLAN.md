# Booking / Appointment System – Implementation Plan

This document describes the full implementation for the Master Elf consultation booking system with **Firestore**, **PlasGate SMS**, and a **booking management dashboard**, while keeping and improving the existing "Book Consultation" flow.

---

## 1. Requirements Summary

| Requirement | Approach |
|-------------|----------|
| Keep existing "Book Consultation" flow | Retain 4-step wizard; improve validation, slot logic, and success state |
| Real SMS on successful booking | PlasGate REST API called from Firebase Cloud Functions (no API keys in client) |
| Firestore as backend | `appointments` collection; Cloud Functions for SMS and optional callables |
| Booking management dashboard | Section below the form: "View your bookings" by phone (via callable for security) |
| Session duration 2 hours, 30 min break | Slot algorithm and stored `durationMinutes` / `breakAfterMinutes`; time picker shows only available slots |

---

## 2. Architecture Overview

```
[Flutter Web]  →  Firestore (create appointment)
                        ↓
              Cloud Function: onCreate(appointment)
                        ↓
                   PlasGate REST API  →  SMS to client

[Flutter Web]  →  Callable: getMyBookings(phone)  →  Firestore (read by phone)
[Flutter Web]  →  Callable: cancelBooking(id, phone)  →  Firestore (update status)
```

- **Client** never holds PlasGate keys; it only writes to Firestore (with rules) and calls HTTPS callables.
- **SMS** is sent only after a document is successfully created in Firestore (onCreate trigger).
- **Dashboard** uses callables so we never expose full collection reads to the client.

---

## 3. Firestore Data Model

### Collection: `appointments`

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | Client name |
| `phone` | string | E.164 normalized (e.g. 85512222211) |
| `serviceId` | string | e.g. destiny, event, space, timing |
| `serviceName` | string | Display name of consultation type |
| `date` | string | ISO date YYYY-MM-DD |
| `time` | string | HH:mm (start time of slot) |
| `startTime` | Timestamp | Session start (date + time) for queries |
| `endTime` | Timestamp | startTime + 2 hours |
| `durationMinutes` | number | 120 (default) |
| `breakAfterMinutes` | number | 30 (used for slot generation) |
| `status` | string | pending \| confirmed \| cancelled |
| `smsSentAt` | Timestamp? | Set by Cloud Function after sending SMS |
| `smsStatus` | string? | e.g. sent, failed |
| `createdAt` | Timestamp | Server timestamp |
| `bookingReference` | string | Short code (e.g. last 6 of doc ID) for display and lookup |

### Security Rules

- **Create**: Allow unauthenticated create with validated fields (name, phone, serviceId, serviceName, date, time, startTime, endTime, durationMinutes, status, createdAt).
- **Read/Update/Delete**: Deny direct client access; use Cloud Functions (callables) to read by phone or cancel by id+phone.

---

## 4. Slot Logic (2h Session, 30min Break)

- **Business rules**: Each session = **2 hours**. **30 minutes** break between sessions.
- **Example slots** (if business hours 09:00–17:00): 09:00, 11:30, 14:00 (next would be 16:30, end 18:30).
- **Implementation**:
  - Flutter: When user selects a date, call a **callable** (e.g. `getAvailableSlots(date)`) that:
    - Reads all appointments for that date with status in [pending, confirmed],
    - Builds occupied ranges [startTime, endTime],
    - Returns list of slot start times (e.g. 09:00, 11:30, 14:00) that don’t overlap.
  - Alternatively, client can fetch “appointments for date” via callable and compute slots in Flutter (same logic). Prefer one callable `getAvailableSlots(date)` that returns only slot times for simplicity and to avoid exposing other clients’ data.
- **Default duration** in UI and in stored document: **120** minutes. Break is not stored per appointment; it’s only used when generating the next available slot.

---

## 5. PlasGate Integration (Cloud Function)

- **Trigger**: Firestore `onCreate` on `appointments/{id}`.
- **Steps**:
  1. Read new document; validate required fields.
  2. Build SMS text: e.g. "Master Elf: Your consultation (Service) is confirmed on Date at Time. Ref: XXXXXX."
  3. Call PlasGate REST:  
     `POST https://cloudapi.plasgate.com/rest/send?private_key=...`  
     Header: `X-Secret: <secret>`  
     Body: `{ "sender": "MasterElf", "to": "<phone without +>", "content": "..." }`
  4. Update document: `smsSentAt`, `smsStatus` (sent/failed).
- **Secrets**: Store `PLASGATE_PRIVATE_KEY` and `PLASGATE_SECRET` in Firebase (Secret Manager or environment config).

---

## 6. Flutter App Changes

### 6.1 Dependencies

- `firebase_core`, `cloud_firestore`
- Optional: `cloud_functions` for callables (`getMyBookings`, `getAvailableSlots`, `cancelBooking`)

### 6.2 Config

- Firebase config in app (e.g. `lib/firebase_options.dart` from FlutterFire CLI or env).
- Keep `AppContent.appointmentBookingApiUrl` for backward compatibility or remove if fully moving to Firestore.

### 6.3 Booking Flow (existing flow, improved)

1. **Step 1 – Service**: Unchanged (consultation type).
2. **Step 2 – Date & time**:
   - User selects date first.
   - Time selection: show only **available slots** for that date (from callable or client-side logic with data from callable). Default session duration 2 hours; next slot = +2h + 30min.
3. **Step 3 – Details**: Name, phone (with validation and E.164 normalization).
4. **Step 4 – Confirm**: Show summary including slot (start–end), duration 2h, and “SMS will be sent to your phone”.
5. **Submit**: Write document to Firestore `appointments` with status `pending`, `startTime`/`endTime`, `durationMinutes: 120`, `bookingReference` (e.g. last 6 of auto-generated doc ID we don’t have yet – can be generated in Cloud Function after create and stored in update, or use a short random code in client).
   - **Booking reference**: Generate on client (e.g. 6-char alphanumeric) and save in document; show on success screen.
6. **Success**: Show “Booking confirmed”, “SMS sent via PlasGate to your phone”, and booking reference. Option “Book another” / “View my bookings”.

### 6.4 Booking Management Dashboard (below Book Consultation)

- **Placement**: Directly below the “Book Consultation” block (above “Every Move Can Be A Smart Move”).
- **Content**:
  - Heading: “View your bookings”.
  - Input: Phone number (and optional booking reference).
  - Button: “Find my bookings”.
  - Result: List of appointments for that phone (from callable `getMyBookings(phone)`): date, time, service, status, reference. Option to “Cancel” (callable `cancelBooking(id, phone)` with verification).
- **Security**: No direct Firestore read by phone; all via callables so only that phone’s bookings are returned.

### 6.5 Success Screen and Copy

- Replace “Powered by Unimatrix” with “SMS confirmation sent via PlasGate.”
- Mention 2-hour session and booking reference in success message/l10n.

---

## 7. Cloud Functions Summary

| Function | Type | Purpose |
|----------|------|---------|
| `onAppointmentCreated` | Firestore onCreate | Send SMS via PlasGate; set `smsSentAt`, `smsStatus`; optionally set `bookingReference` if generated server-side |
| `getAvailableSlots` | Callable | Input: date. Returns list of slot start times (e.g. ["09:00","11:30","14:00"]) for that date |
| `getMyBookings` | Callable | Input: phone. Returns list of appointments for that phone (sanitized) |
| `cancelBooking` | Callable | Input: appointmentId, phone. Verifies phone matches; sets status to cancelled |

---

## 8. Standard Steps / Best Practices

- **Idempotency**: Avoid duplicate bookings for same slot; in `getAvailableSlots` consider only non-cancelled appointments; optionally in Cloud Function onCreate check for overlapping slot before sending SMS.
- **Rate limiting**: Optional rate limit on callables (e.g. per phone or per IP) to avoid abuse.
- **Validation**: Validate phone format and required fields in Firestore rules and in Cloud Functions.
- **SMS content**: Keep under 160 chars for single segment where possible; include brand, date, time, reference.
- **Error handling**: If PlasGate fails, still save appointment; set `smsStatus: 'failed'` and optionally retry or alert admin.
- **Privacy**: Never return other clients’ data; callables filter strictly by phone.
- **Localization**: Use app locale for SMS language if needed (optional; can start with English only for SMS).

---

## 9. Implementation Order

1. **Firebase project**: Create project; enable Firestore; deploy Cloud Functions (Node) with `onAppointmentCreated` (PlasGate), then add callables.
2. **Firestore rules**: Deploy rules (create only for `appointments`; no direct read/update/delete from client).
3. **Flutter**: Add Firebase and Firestore; implement create-appointment flow with `startTime`/`endTime`/`durationMinutes`/`bookingReference`; then add `getAvailableSlots` and time-picker slots.
4. **Flutter**: Add dashboard section and callables `getMyBookings`, `cancelBooking`.
5. **L10n**: New strings for dashboard, slot duration note, PlasGate mention.
6. **Testing**: Book appointment → check Firestore doc and SMS; view bookings by phone; cancel.

---

## 10. Files to Add or Modify

| Location | Action |
|----------|--------|
| `BOOKING_SYSTEM_IMPLEMENTATION_PLAN.md` | Created (this file) |
| `functions/` | New: Node.js Cloud Functions (PlasGate + callables) |
| `firestore.rules` | New: create-only + no client read/list |
| `lib/firebase_options.dart` | New (or env): Firebase config |
| `lib/services/appointment_booking_service.dart` | Refactor: Firestore create + callables for slots/bookings/cancel |
| `lib/screens/appointments/appointments_screen.dart` | Slot picker, dashboard, success copy |
| `lib/config/app_content.dart` | Optional: remove or keep legacy API URL |
| `lib/l10n/app_*.arb` + generated | New keys: dashboard, session duration, PlasGate |
| `pubspec.yaml` | Add firebase_core, cloud_firestore, cloud_functions |

This plan yields a single, consistent system: Book Consultation → Firestore → SMS via PlasGate, plus a secure, phone-based booking dashboard and 2h/30min slot logic.

---

## 11. Setup Checklist

1. **Firebase project**
   - Create a project at [Firebase Console](https://console.firebase.google.com).
   - Enable Firestore and set region.
   - Run `dart run flutterfire_cli:flutterfire configure` (or add Firebase to the app and paste config into `lib/firebase_options.dart`).

2. **Deploy Firestore**
   - `firebase deploy --only firestore` (rules + indexes).

3. **Cloud Functions**
   - `cd functions && npm install && cd ..`
   - Set PlasGate credentials (e.g. Firebase config or Secret Manager):
     - `firebase functions:config:set plasgate.private_key="YOUR_KEY" plasgate.secret="YOUR_SECRET"`
     - Or use Secret Manager and `defineSecret` in code.
   - `firebase deploy --only functions`

4. **Flutter Web**
   - Ensure `web/index.html` includes the Firebase SDK scripts (already added).
   - Run the app; when `firebase_options.dart` has a real project ID, booking will use Firestore and SMS will be sent via PlasGate on new appointments.
