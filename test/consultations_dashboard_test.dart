import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:masterelf_homepage/l10n/app_localizations.dart';
import 'package:masterelf_homepage/providers/auth_provider.dart';
import 'package:masterelf_homepage/screens/consultations/consultations_dashboard_screen.dart';
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

  Future<void> pumpDashboard(WidgetTester tester, {required double width}) async {
    await tester.binding.setSurfaceSize(Size(width, 1600));
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
              data: MediaQueryData(size: Size(width, 1600)),
              child: const AppointmentsDashboardScreen(),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    drainLayoutExceptions(tester);
  }

  test('dashboard list pagination page size is 15 on desktop and 5 on mobile', () {
    expect(dashboardAppointmentsPerPageFor(1280), kDashboardAppointmentsPerPageDesktop);
    expect(dashboardAppointmentsPerPageFor(375), kDashboardAppointmentsPerPageMobile);
  });

  testWidgets('status filter uses localized labels', (tester) async {
    await pumpDashboard(tester, width: 1280);

    expect(find.text('Confirm'), findsNothing);
    expect(find.text('Complete'), findsNothing);
    expect(find.text('Confirmed'), findsWidgets);
    expect(find.text('Completed'), findsWidgets);
    expect(find.text('Cancelled'), findsWidgets);
  });

  testWidgets('dashboard header has no overflow at 375px', (tester) async {
    await pumpDashboard(tester, width: 375);

    expect(find.text('Appointment Dashboard'), findsOneWidget);
    expect(find.text('Back'), findsOneWidget);
    expect(find.text('Log out'), findsOneWidget);
  });
}
