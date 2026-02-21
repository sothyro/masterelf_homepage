# Master Elf Feng Shui – Company Website

Flutter web app for Master Elf Feng Shui: consultations, courses, events, and Chinese metaphysics resources (BaZi, Qi Men, Feng Shui). Localized in English, Khmer, and Chinese.

## Getting started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable, with web support)
- Dart 3.9+

### Run locally

```bash
# Install dependencies
flutter pub get

# Run on web (Chrome by default)
flutter run -d chrome

# Or build for production
flutter build web
```

Output is in `build/web/`. Serve with any static host or use `dart run webdev serve` for local preview.

### Tests

```bash
flutter test
```

### Lint / analyze

```bash
flutter analyze
```

## Project structure

- `lib/` – app code  
  - `config/` – content and event data  
  - `l10n/` – localized strings (ARB + generated)  
  - `router/` – GoRouter setup and 404 handling  
  - `screens/` – route screens and home sections  
  - `theme/` – colors, typography, theme  
  - `widgets/` – shared UI (header, footer, shell, dialogs)  
  - `services/` – e.g. appointment booking API  
- `assets/` – images, icons, video  
- `web/` – `index.html`, PWA manifest, favicon  
  - `web/videos/` – hero video for web (e.g. `videobackground720.mp4`); copy from `assets/videos/` if missing so the release build serves it as a static file.  

## Configuration

- **App copy & URLs**: `lib/config/app_content.dart`  
- **Appointment API**: set `AppContent.appointmentBookingApiUrl` for live booking; leave empty for demo mode.  
- **Localizations**: edit `lib/l10n/app_*.arb`, then run `flutter gen-l10n`.  

## Firebase / Firestore

### Two separate entities

| Collection              | Purpose                    | Used by                          |
|-------------------------|----------------------------|----------------------------------|
| **`appointments`**       | Consultation bookings     | Consultations page, admin dashboard, SMS (PlasGate) |
| **`contact_submissions`** | Contact form messages    | Contact page only                |

They do not share data or logic. Contact form submissions do not affect the booking system.

### Notifying the team when someone submits the contact form

1. **Option A – Check Firestore manually**  
   In [Firebase Console](https://console.firebase.google.com) → Firestore → `contact_submissions`. New documents appear as soon as a user submits.

2. **Option B – Email notification (automatic)**  
   When a document is created in `contact_submissions`, a Cloud Function can send an email to your team.

   - Sign up at [Resend](https://resend.com) and create an API key.
   - Set Firebase secrets (from project root):
     ```bash
     firebase functions:secrets:set RESEND_API_KEY
     firebase functions:secrets:set CONTACT_NOTIFY_EMAIL
     ```
     When prompted, enter your Resend API key and the email address that should receive contact form notifications (e.g. `team@masterelf.vip`).
   - Redeploy functions. From project root, first install dependencies in `functions`, then deploy:
     ```powershell
     cd functions; npm ci; cd ..
     firebase deploy --only functions
     ```
     (PowerShell: use `;` to chain commands. If you see "Couldn't find firebase-functions", run `npm ci` inside `functions` before deploying.)

   Each new submission will trigger an email to `CONTACT_NOTIFY_EMAIL` with the sender’s name, email, phone, subject, and message.  
   Resend’s free tier allows sending from `onboarding@resend.dev`; for a custom “From” address, verify your domain in Resend.

## Resources

- [Flutter documentation](https://docs.flutter.dev/)
- [Flutter web](https://docs.flutter.dev/platform-integration/web)
