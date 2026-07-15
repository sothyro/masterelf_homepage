import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:masterelf_homepage/app.dart';
import 'package:masterelf_homepage/app_bootstrap.dart';
import 'package:masterelf_homepage/screens/apps/apps_load_coordinator.dart';
import 'package:masterelf_homepage/screens/field_work/field_work_load_coordinator.dart';
import 'package:masterelf_homepage/screens/home/home_load_coordinator.dart';
import 'package:masterelf_homepage/utils/scroll_activity_gate.dart';

bool _initialized = false;

void ensureTestAppInitialized() {
  if (_initialized) return;
  _initialized = true;
  initializeAppBootstrap('/');
}

/// Returns the first pending layout exception, if any.
Object? takeLayoutException(WidgetTester tester) => tester.takeException();

void assertNoLayoutOverflow(WidgetTester tester) {
  final exception = takeLayoutException(tester);
  if (exception != null) {
    fail('Layout exception: $exception');
  }
}

void drainLayoutExceptions(WidgetTester tester) {
  while (tester.takeException() != null) {}
}

Future<void> pumpMasterElfApp(
  WidgetTester tester, {
  Size surfaceSize = const Size(1280, 2000),
}) async {
  ensureTestAppInitialized();
  await tester.binding.setSurfaceSize(surfaceSize);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(const MasterElfApp());
  await tester.pump();
  await resetAppToHome(tester);
  await settleHomeScreenTimers(tester);
  drainLayoutExceptions(tester);
  await tester.pump(const Duration(milliseconds: 100));
}

/// Pumps the full app with a specific locale via [localeNotifier].
Future<void> pumpMasterElfAppWithLocale(
  WidgetTester tester,
  String languageCode, {
  Size surfaceSize = const Size(1280, 2000),
}) async {
  ensureTestAppInitialized();
  localeNotifier.setLocaleFromCode(languageCode);
  addTearDown(() => localeNotifier.setLocaleFromCode('en'));
  await pumpMasterElfApp(tester, surfaceSize: surfaceSize);
}

Future<void> navigateTo(WidgetTester tester, String path) async {
  final context = tester.element(find.byType(Scaffold).first);
  GoRouter.of(context).go(path);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

/// Resets the global router to home so tests do not inherit a stale route.
Future<void> resetAppToHome(WidgetTester tester) async {
  if (find.byType(Scaffold).evaluate().isEmpty) return;
  final context = tester.element(find.byType(Scaffold).first);
  GoRouter.of(context).go('/');
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
  drainLayoutExceptions(tester);
}

/// Lets [HomeScreen] progressive section timers finish before leaving `/`.
Future<void> settleHomeScreenTimers(WidgetTester tester) async {
  for (var i = 0; i < 16; i++) {
    await tester.pump(const Duration(milliseconds: 250));
  }
  await tester.pump(const Duration(seconds: 5));
  HomeLoadCoordinator.resetForTesting();
  AppsLoadCoordinator.resetForTesting();
  FieldWorkLoadCoordinator.resetForTesting();
  ScrollActivityGate.resetForTesting();
}

/// Pumps the full app at [width], navigates to [path], and asserts no layout overflows.
Future<void> pumpRouteAtWidth(
  WidgetTester tester,
  String path,
  double width, {
  double height = 2400,
  bool drainOverflows = false,
}) async {
  await pumpMasterElfApp(tester, surfaceSize: Size(width, height));
  await resetAppToHome(tester);
  if (path.split('#').first != '/') {
    await settleHomeScreenTimers(tester);
    drainLayoutExceptions(tester);
  }
  await navigateTo(tester, path);
  await tester.pump(const Duration(milliseconds: 300));
  drainLayoutExceptions(tester);
  final routePath = path.split('#').first;
  if (routePath == '/apps' || routePath == '/field-work') {
    await tester.pump(const Duration(seconds: 5));
    AppsLoadCoordinator.resetForTesting();
    FieldWorkLoadCoordinator.resetForTesting();
    ScrollActivityGate.resetForTesting();
  }
  if (drainOverflows) {
    drainLayoutExceptions(tester);
  } else {
    assertNoLayoutOverflow(tester);
  }
}

/// Pumps a route at [width] with [languageCode] and asserts no layout overflows.
Future<void> pumpRouteAtWidthWithLocale(
  WidgetTester tester,
  String path,
  double width,
  String languageCode, {
  double height = 2400,
}) async {
  await pumpMasterElfAppWithLocale(
    tester,
    languageCode,
    surfaceSize: Size(width, height),
  );
  await resetAppToHome(tester);
  if (path.split('#').first != '/') {
    await settleHomeScreenTimers(tester);
    drainLayoutExceptions(tester);
  }
  await navigateTo(tester, path);
  await tester.pump(const Duration(milliseconds: 300));
  drainLayoutExceptions(tester);
  final routePath = path.split('#').first;
  if (routePath == '/apps' || routePath == '/field-work') {
    await tester.pump(const Duration(seconds: 5));
    AppsLoadCoordinator.resetForTesting();
    FieldWorkLoadCoordinator.resetForTesting();
  }
  assertNoLayoutOverflow(tester);
}
