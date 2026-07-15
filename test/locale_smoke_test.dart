import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/l10n/app_localizations.dart';
import 'package:masterelf_homepage/screens/events/events_load_coordinator.dart';
import 'package:masterelf_homepage/screens/field_work/field_work_load_coordinator.dart';
import 'package:masterelf_homepage/screens/consultations/site_inspection_screen.dart';
import 'package:masterelf_homepage/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:masterelf_homepage/providers/auth_provider.dart';

import 'test_helpers/fake_auth.dart';
import 'test_helpers/pump_app.dart';

void main() {
  late void Function(FlutterErrorDetails)? previousErrorHandler;

  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    previousErrorHandler = FlutterError.onError;
    FlutterError.onError = (details) {
      final message = details.exceptionAsString();
      if (message.contains('overflowed') ||
          message.contains('Build scheduled during frame') ||
          message.contains('deactivated widget')) {
        return;
      }
      previousErrorHandler?.call(details);
    };
  });

  tearDown(() {
    FlutterError.onError = previousErrorHandler;
    VisibilityDetectorController.instance.updateInterval =
        const Duration(milliseconds: 500);
  });

  testWidgets('Home screen shows Khmer navigation labels', (tester) async {
    await pumpMasterElfAppWithLocale(tester, 'km');
    await settleHomeScreenTimers(tester);
    drainLayoutExceptions(tester);

    expect(find.text('ទំព័រដើម'), findsWidgets);
  });

  testWidgets('Home screen shows Chinese navigation labels', (tester) async {
    await pumpMasterElfAppWithLocale(tester, 'zh');
    await settleHomeScreenTimers(tester);
    drainLayoutExceptions(tester);

    expect(find.text('首页'), findsWidgets);
  });

  testWidgets('Field work hub shows Khmer headline', (tester) async {
    await pumpMasterElfAppWithLocale(tester, 'km');
    await settleHomeScreenTimers(tester);
    drainLayoutExceptions(tester);
    await navigateTo(tester, '/field-work');
    await tester.pump(const Duration(seconds: 5));
    FieldWorkLoadCoordinator.resetForTesting();
    drainLayoutExceptions(tester);

    expect(find.text('ការងារពិត។ កន្លែងពិត។ លទ្ធផលពិត។'), findsWidgets);
  });

  testWidgets('Events screen shows Chinese event title', (tester) async {
    await pumpMasterElfAppWithLocale(tester, 'zh');
    await settleHomeScreenTimers(tester);
    drainLayoutExceptions(tester);
    await navigateTo(tester, '/events');
    await tester.pump(const Duration(seconds: 5));
    EventsLoadCoordinator.resetForTesting();
    drainLayoutExceptions(tester);

    expect(find.text('周期转换时，您应在场。'), findsWidgets);
  });

  testWidgets('Site inspection form shows Khmer save label', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1280, 3000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthProvider(authService: FakeLoggedInAuthService()),
        child: MaterialApp(
          theme: AppTheme.dark(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('km'),
          home: const Scaffold(
            body: SingleChildScrollView(
              child: SiteInspectionScreen(),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    VisibilityDetectorController.instance.notifyNow();
    await tester.pump(const Duration(milliseconds: 300));
    drainLayoutExceptions(tester);

    expect(find.text('រក្សាទុកវឌ្ឍនភាព'), findsOneWidget);
    expect(find.text('Save progress'), findsNothing);
  });

  testWidgets('Activity video detail shows localized Chinese title', (tester) async {
    await pumpMasterElfAppWithLocale(tester, 'zh');
    await settleHomeScreenTimers(tester);
    drainLayoutExceptions(tester);
    await navigateTo(tester, '/field-work/video/feng-shui-compass-on-site');
    await tester.pump(const Duration(seconds: 5));
    FieldWorkLoadCoordinator.resetForTesting();
    drainLayoutExceptions(tester);

    expect(find.text('风水实地勘察 — 现场罗盘'), findsOneWidget);
  });
}
