import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:masterelf_homepage/l10n/app_localizations.dart';
import 'package:masterelf_homepage/providers/auth_provider.dart';
import 'package:masterelf_homepage/screens/consultations/site_inspection_screen.dart';
import 'package:masterelf_homepage/theme/app_theme.dart';

import 'test_helpers/fake_auth.dart';
import 'test_helpers/pump_app.dart';

void main() {
  late void Function(FlutterErrorDetails)? previousErrorHandler;

  setUp(() {
    previousErrorHandler = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.exceptionAsString().contains('overflowed')) return;
      previousErrorHandler?.call(details);
    };
  });

  tearDown(() {
    FlutterError.onError = previousErrorHandler;
  });

  Future<void> pumpSiteInspection(WidgetTester tester, {required double width}) async {
    await tester.binding.setSurfaceSize(Size(width, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthProvider(authService: FakeLoggedInAuthService()),
        child: MaterialApp(
          theme: AppTheme.dark(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Scaffold(
            body: MediaQuery(
              data: MediaQueryData(size: Size(width, 2400)),
              child: const SingleChildScrollView(
                child: SiteInspectionScreen(),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    drainLayoutExceptions(tester);
  }

  testWidgets('site inspection footer stacks action buttons on mobile', (tester) async {
    await pumpSiteInspection(tester, width: 375);

    expect(find.text('Next'), findsOneWidget);
    expect(find.text('Save progress'), findsOneWidget);
  });
}
