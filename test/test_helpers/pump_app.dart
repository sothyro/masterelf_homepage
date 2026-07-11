import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:masterelf_homepage/app.dart';
import 'package:masterelf_homepage/app_bootstrap.dart';

bool _initialized = false;

void ensureTestAppInitialized() {
  if (_initialized) return;
  _initialized = true;
  initializeAppBootstrap('/');
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
  await tester.pump(const Duration(milliseconds: 500));
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

/// Pumps the full app at [width], navigates to [path], and drains layout overflows.
Future<void> pumpRouteAtWidth(
  WidgetTester tester,
  String path,
  double width, {
  double height = 2400,
}) async {
  await pumpMasterElfApp(tester, surfaceSize: Size(width, height));
  await navigateTo(tester, path);
  drainLayoutExceptions(tester);
}
