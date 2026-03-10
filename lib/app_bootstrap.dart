import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';


import 'providers/auth_provider.dart';
import 'providers/locale_provider.dart';
import 'router/app_router.dart';

/// Top-level router and providers so the router persists across refreshes and
/// correctly handles pasted URLs on mobile. Nested routers lose the current
/// route on refresh (Flutter #114597).
late final GoRouter appRouter;
late final LocaleNotifier localeNotifier;
late final AuthProvider authProvider;

bool _bootstrapInitialized = false;

void initializeAppBootstrap(String initialLocation) {
  if (_bootstrapInitialized) return;
  _bootstrapInitialized = true;
  localeNotifier = LocaleNotifier();
  authProvider = AuthProvider();
  appRouter = createAppRouter(
    initialLocation: initialLocation,
    refreshListenable: Listenable.merge([localeNotifier, authProvider]),
  );
}
