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

## Configuration

- **App copy & URLs**: `lib/config/app_content.dart`  
- **Appointment API**: set `AppContent.appointmentBookingApiUrl` for live booking; leave empty for demo mode.  
- **Localizations**: edit `lib/l10n/app_*.arb`, then run `flutter gen-l10n`.  

## Resources

- [Flutter documentation](https://docs.flutter.dev/)
- [Flutter web](https://docs.flutter.dev/platform-integration/web)
