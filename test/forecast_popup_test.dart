import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:masterelf_homepage/l10n/app_localizations.dart';
import 'package:masterelf_homepage/providers/auth_provider.dart';
import 'package:masterelf_homepage/services/auth_service.dart';
import 'package:masterelf_homepage/theme/app_theme.dart';
import 'package:masterelf_homepage/screens/home/widgets/field_work_chinese_design.dart';
import 'package:masterelf_homepage/widgets/forecast_popup.dart';
import 'package:masterelf_homepage/widgets/sticky_cta_bar.dart';
import 'package:provider/provider.dart';

class FakeLoggedOutAuthService implements AuthService {
  @override
  User? get currentUser => null;

  @override
  Stream<User?> get authStateChanges => Stream.value(null);

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {}

  @override
  Future<void> signOut() async {}
}

void main() {
  Future<void> pumpForecastDialog(
    WidgetTester tester, {
    required double width,
    double height = 900,
  }) async {
    await tester.binding.setSurfaceSize(Size(width, height));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: MediaQuery(
          data: MediaQueryData(size: Size(width, height)),
          child: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (_) => const ForecastPopup(),
                    );
                  },
                  child: const Text('Open forecast'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open forecast'));
    await tester.pumpAndSettle();
  }

  testWidgets('desktop shows list and detail side by side', (tester) async {
    await pumpForecastDialog(tester, width: 1280);

    expect(find.byType(ForecastPopup), findsOneWidget);
    expect(find.byType(ChineseDialogFrame), findsOneWidget);
    expect(find.text('Choose your animal'), findsOneWidget);
    expect(find.textContaining('12 ZODIACS FORECAST'), findsOneWidget);
    expect(find.text('Rat'), findsWidgets);
    expect(find.text('Read Full Articles (Facebook)'), findsOneWidget);

    await tester.tap(find.text('Ox').first);
    await tester.pumpAndSettle();

    expect(find.textContaining('牛'), findsWidgets);
    expect(find.text('Auspicious Stars'), findsOneWidget);
    expect(find.text('Inauspicious Stars'), findsOneWidget);
  });

  testWidgets('mobile list navigates to detail and back', (tester) async {
    await pumpForecastDialog(tester, width: 375, height: 800);

    expect(find.byType(ChineseDialogFrame), findsOneWidget);
    expect(find.text('Choose your animal'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Read Full Articles (Facebook)'), findsNothing);

    await tester.tap(find.text('Ox').first);
    await tester.pumpAndSettle();

    expect(find.text('Choose your animal'), findsNothing);
    expect(find.widgetWithText(FilledButton, 'Read Full Articles (Facebook)'), findsOneWidget);
    expect(find.textContaining('牛'), findsWidgets);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.text('Choose your animal'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Read Full Articles (Facebook)'), findsNothing);
  });

  testWidgets('StickyCtaBar opens ForecastPopup', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1280, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthProvider(authService: FakeLoggedOutAuthService()),
        child: MaterialApp(
          theme: AppTheme.dark(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: const Scaffold(
            body: Stack(
              children: [
                SizedBox.expand(),
                Align(
                  alignment: Alignment.centerRight,
                  child: StickyCtaBar(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(LucideIcons.megaphone));
    await tester.pumpAndSettle();

    expect(find.byType(ForecastPopup), findsOneWidget);
    expect(find.text('Choose your animal'), findsOneWidget);
  });
}
