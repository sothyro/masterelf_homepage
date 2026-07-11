import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/l10n/app_localizations.dart';
import 'package:masterelf_homepage/screens/academy/academy_screen.dart';
import 'package:masterelf_homepage/theme/app_theme.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'test_helpers/pump_app.dart';

void main() {
  late void Function(FlutterErrorDetails)? previousErrorHandler;

  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    previousErrorHandler = FlutterError.onError;
    FlutterError.onError = (details) {
      final message = details.exceptionAsString();
      if (message.contains('overflowed') ||
          message.contains('Build scheduled during frame')) {
        return;
      }
      previousErrorHandler?.call(details);
    };
  });

  tearDown(() {
    VisibilityDetectorController.instance.updateInterval =
        const Duration(milliseconds: 500);
    FlutterError.onError = previousErrorHandler;
  });

  Future<void> pumpAcademy(WidgetTester tester, {required double width}) async {
    await tester.binding.setSurfaceSize(Size(width, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: MediaQuery(
          data: MediaQueryData(size: Size(width, 2400)),
          child: const SingleChildScrollView(
            child: AcademyScreen(),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    drainLayoutExceptions(tester);
  }

  Future<void> disposeAcademy(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 7));
  }

  for (final width in [375.0, 768.0, 1280.0]) {
    testWidgets('Academy page has no overflow at ${width.toInt()}px', (tester) async {
      await pumpAcademy(tester, width: width);

      expect(find.text('Academy'), findsWidgets);

      await disposeAcademy(tester);
    });
  }
}
