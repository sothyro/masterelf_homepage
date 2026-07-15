import 'dart:async';

import 'package:flutter/widgets.dart';
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
String _bootstrapInitialLocation = '/';

/// Initial route the app was opened with; used to decide whether the
/// bootstrap loader should wait for the homepage render gate.
String get bootstrapInitialLocation => _bootstrapInitialLocation;

void initializeAppBootstrap(String initialLocation) {
  if (_bootstrapInitialized) return;
  _bootstrapInitialized = true;
  _bootstrapInitialLocation = initialLocation;
  localeNotifier = LocaleNotifier();
  authProvider = AuthProvider();
  appRouter = createAppRouter(
    initialLocation: initialLocation,
    refreshListenable: Listenable.merge([localeNotifier, authProvider]),
  );
}

/// Signals when the homepage has fully mounted and painted, so the bootstrap
/// loader stays visible until scrolling won't stutter from in-flight builds.
class HomeReadiness {
  HomeReadiness._();

  // Created lazily so it is bound to the zone that actually awaits/completes
  // it (matters in widget tests, where setUp runs outside the test zone).
  static Completer<void>? _completer;
  static bool _settling = false;

  static Completer<void> get _gate => _completer ??= Completer<void>();

  /// When true, [markAllSectionsMounted] is a no-op (timeout-path tests only).
  @visibleForTesting
  static bool holdForTesting = false;

  static bool get isReady => _completer?.isCompleted ?? false;

  /// Completes once critical homepage sections are mounted and two further
  /// frames have been painted (layout + raster settled).
  static Future<void> get ready => _gate.future;

  /// Call when Hero, Events, Academies, and Consultations are in the tree.
  static void markCriticalHomeContentReady() {
    if (_gate.isCompleted || _settling || holdForTesting) return;
    _settling = true;
    final binding = WidgetsBinding.instance;
    binding.addPostFrameCallback((_) {
      binding.addPostFrameCallback((_) {
        _settling = false;
        if (!_gate.isCompleted) _gate.complete();
      });
      binding.scheduleFrame();
    });
    binding.scheduleFrame();
  }

  /// Legacy alias — prefer [markCriticalHomeContentReady].
  static void markAllSectionsMounted() => markCriticalHomeContentReady();

  /// If [HomeScreen] unmounts while settling, complete the gate so bootstrap
  /// does not hang until timeout.
  static void onHomeScreenDisposed() {
    if (_settling && !_gate.isCompleted) {
      _settling = false;
      _gate.complete();
    }
  }

  @visibleForTesting
  static void reset() {
    _settling = false;
    holdForTesting = false;
    _completer = null;
  }
}
