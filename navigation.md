## Navigation & URL Handling (Based on `stonechat_communications`)

This document explains how the `stonechat_communications` project makes **browser navigation and deep links work correctly on web** using `go_router`, so that:

- **Pasting or opening a URL** (like `/events` or `/book`) opens the correct page.
- **Refreshing** the browser while on a deep link keeps you on that page.
- **Trailing slashes** (`/events/`) do not cause 404s or white screens.
- **Unknown paths** show a proper in-app 404, not a blank page or redirect to home.

Use this as a guide to implement the same behavior in your other Flutter web app.

---

## 1. Core ideas

- **Path-based URLs**: Use `usePathUrlStrategy()` so the browser shows clean paths like `/events` instead of `/#/events`.
- **Capture the initial URL once, at startup**: Read `Uri.base` **in `main()`** immediately after initialization and pass that path all the way into the router as `initialLocation`.
- **Normalize paths**: Strip trailing slashes (so `/events/` and `/events` are treated the same).
- **Central redirect logic**:
  - Redirect trailing-slash URLs to their canonical form.
  - Redirect truly unknown paths to an in-app 404 route.
- **SPA hosting rule**: Ensure your hosting redirects all paths to `index.html` so the Flutter app always boots, and the router decides what to show.

---

## 2. What `stonechat_communications` does

### 2.1. Dependencies

In `pubspec.yaml`:

- **Router**: `go_router`
- **Web URL strategy**: `flutter_web_plugins`

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_web_plugins:
    sdk: flutter
  go_router: ^14.6.2
  # ...other deps...
```

### 2.2. `main.dart`: capture initial URL once

Key points:

- Switch to path URLs.
- Initialize bindings.
- Read the initial browser URL via a helper (`getInitialRouterLocation()` from the router file).
- Pass that value down into the app.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app.dart';
import 'router/app_router.dart';

void main() async {
  // 1. Use path-based URLs: /events, /book, etc.
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Capture initial URL immediately.
  final initialLocation = getInitialRouterLocation();

  // 3. Do your async init (Firebase, services, etc.)...

  runApp(HeroVideoBootstrap(initialLocation: initialLocation));
}
```

The important part for your other project: **do not let the router decide its initial location later in the widget tree**. Capture it here and pass it down.

### 2.3. App entry widget: pass `initialLocation` into router

`StonechatApp` receives `initialLocation` and uses it **once** to create the `GoRouter`:

```dart
class StonechatApp extends StatefulWidget {
  const StonechatApp({super.key, required this.initialLocation});

  // Captured at startup (e.g. browser URL on web).
  final String initialLocation;

  @override
  State<StonechatApp> createState() => _StonechatAppState();
}

class _StonechatAppState extends State<StonechatApp> {
  GoRouter? _router;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // ...providers...
      child: Consumer2<LocaleNotifier, AuthProvider>(
        builder: (context, localeNotifier, authProvider, _) {
          // Create router only once; reuse across rebuilds.
          _router ??= createAppRouter(
            refreshListenable: Listenable.merge([localeNotifier, authProvider]),
            initialLocation: widget.initialLocation, // <- important
          );

          return MaterialApp.router(
            // ...
            routerConfig: _router!,
          );
        },
      ),
    );
  }
}
```

**In your other project**, you want the same pattern:

- `MyApp(initialLocation: initialLocationFromMain)`.
- Inside `MyApp`, create the `GoRouter` once with that `initialLocation`.

### 2.4. Router: normalize paths and handle 404s

In `lib/router/app_router.dart`, the project:

1. Keeps a set of **known paths**.
2. Provides `normalizePath()` to strip trailing slashes.
3. Provides `getInitialRouterLocation()` which:
   - On web: reads `Uri.base`, normalizes the path, and preserves query/fragment.
   - On other platforms: defaults to `/`.
4. Configures `GoRouter` with:
   - `initialLocation`.
   - A `redirect` that:
     - Canonicalizes trailing slashes.
     - Enforces auth for some routes.
     - Sends unknown paths to `/not-found`.

#### Known paths

```dart
const Set<String> _knownPaths = {
  '/',
  '/journey',
  '/events',
  '/apps',
  '/book',
  '/contact',
  '/consultations',
  '/consultations/dashboard',
  '/not-found',
};
```

In your other project, define a similar set with **all** routes you expect to handle.

#### Path normalization

```dart
String normalizePath(String path) {
  if (path.isEmpty || path == '/') return '/';
  return path.endsWith('/') ? path.substring(0, path.length - 1) : path;
}
```

Use this everywhere you compare paths.

#### Initial location from `Uri.base`

```dart
import 'package:flutter/foundation.dart' show kIsWeb;

String getInitialRouterLocation() {
  if (kIsWeb) {
    final uri = Uri.base;
    final path = normalizePath(uri.path);
    final query = uri.hasQuery ? '?${uri.query}' : '';
    final fragment = uri.fragment.isNotEmpty ? '#${uri.fragment}' : '';
    return path + query + fragment;
  }
  return '/';
}
```

For your other project:

- Copy this function (or adapt it).
- If your app runs under a subpath (e.g. `/app/`), you may need to strip that prefix from `uri.path` before normalizing.

#### `GoRouter` configuration

```dart
GoRouter createAppRouter({
  Listenable? refreshListenable,
  String? initialLocation,
}) {
  return GoRouter(
    navigatorKey: _rootNavKey,
    initialLocation: initialLocation ?? getInitialRouterLocation(),
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final path = state.uri.path;
      final normalized = normalizePath(path);

      // 1. Redirect /events/ -> /events, preserving query + fragment.
      if (path != normalized) {
        final q = state.uri.query.isEmpty ? '' : '?${state.uri.query}';
        final f = state.uri.fragment.isEmpty ? '' : '#${state.uri.fragment}';
        return normalized + q + f;
      }

      // 2. Known paths are allowed.
      if (normalized.isEmpty || _knownPaths.contains(normalized)) {
        // Example: protect a dashboard route behind auth.
        // If not logged in, redirect elsewhere.
        // (You can remove this if not needed.)
        // if (normalized == '/dashboard' && !auth.isLoggedIn) {
        //   return '/login';
        // }
        return null; // no redirect
      }

      // 3. Everything else -> in-app 404.
      return '/not-found';
    },
    routes: [
      // Use a ShellRoute if you want a shared header/footer.
      ShellRoute(
        // builder: (_, __, child) => AppShell(child: child),
        routes: [
          GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
          // ...other routes...
          GoRoute(path: '/not-found', builder: (_, __) => const NotFoundScreen()),
        ],
      ),
    ],
  );
}
```

**For your other project**, the minimal checklist:

- **[ ]** Implement `normalizePath()`.
- **[ ]** Implement `getInitialRouterLocation()` using `Uri.base`.
- **[ ]** Declare `_knownPaths` with all valid paths.
- **[ ]** Use `initialLocation` from `main()` when creating the router.
- **[ ]** In `redirect`, normalize paths and send unknown ones to an in-app 404.

---

## 3. Hosting / server configuration

For web hosting, `stonechat_communications` uses a standard SPA rule so that all paths serve `index.html`, and Flutter + `go_router` take over:

- On Netlify-like hosts: `_redirects` file:

```text
/* /index.html 200
```

- On other hosts, the equivalent rewrite/fallback rule.

**Without this**, direct links to `/events` or `/book` can 404 at the server level **before** Flutter loads, which looks like a white screen.

In your other project, ensure:

- **[ ]** Any path like `/your-route`, `/your-route/`, `/nested/path` is rewritten to `index.html`.
- **[ ]** Caching/CDN rules don’t prevent `index.html` from being served for deep links.

---

## 4. Common failure modes and how this setup avoids them

- **Symptom: Pasting `/some-page` opens home instead.**  
  **Cause:** Router created with `initialLocation: '/'` and ignores `Uri.base`.  
  **Fix (what this project does):** Capture `getInitialRouterLocation()` in `main()` and pass it down to the router.

- **Symptom: `/events/` opens 404 or blank.**  
  **Cause:** Route list only contains `/events`; `/events/` is treated as an unknown path.  
  **Fix:** Use `normalizePath()` and redirect `/events/` → `/events`.

- **Symptom: Refreshing on a deep link goes to home or white screen.**  
  **Cause:** Either the server doesn’t serve `index.html` for that path, or the router ignores the current URL.  
  **Fix:** Add SPA server rewrite and use the startup-captured initial location as shown above.

---

## 5. Quick integration checklist for your other project

- **Routing setup**
  - **[ ]** Add `go_router` and `flutter_web_plugins` to `pubspec.yaml`.
  - **[ ]** Call `usePathUrlStrategy()` in `main()` for clean paths.
  - **[ ]** Implement `normalizePath()` and `getInitialRouterLocation()` as above.
  - **[ ]** In `main()`, capture `final initialLocation = getInitialRouterLocation();` and pass it into your root app widget.
  - **[ ]** In your root app (`MyApp`), create the `GoRouter` **once** using that `initialLocation`.
  - **[ ]** Implement a `redirect` that:
    - Canonicalizes trailing slashes.
    - Sends unknown paths to an in-app `NotFoundScreen`.

- **Hosting**
  - **[ ]** Configure your host to rewrite all paths to `index.html` (SPA rule).
  - **[ ]** Test deep links manually:
    - Open `/some-route` in a new tab.
    - Refresh on that route.
    - Paste a URL with a trailing slash.
    - Open an unknown path and confirm you see the 404 screen.

