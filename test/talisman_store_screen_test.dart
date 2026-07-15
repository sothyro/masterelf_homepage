import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/l10n/app_localizations.dart';
import 'package:masterelf_homepage/screens/talisman/talisman_store_screen.dart';
import 'package:masterelf_homepage/screens/talisman/talisman_load_coordinator.dart';
import 'package:masterelf_homepage/utils/app_asset_preloader.dart';
import 'package:masterelf_homepage/screens/talisman/widgets/talisman_grid.dart';
import 'package:masterelf_homepage/theme/app_theme.dart';

void main() {
  setUp(() {
    TalismanLoadCoordinator.resetForTesting();
    AppAssetPreloader.resetForTesting();
    AppAssetPreloader.disableBackgroundFontsForTesting = true;
  });

  Future<void> settleTalismanTimers(WidgetTester tester) async {
    await tester.pump(TalismanLoadCoordinator.idleFallback);
    await tester.pump(const Duration(seconds: 5));
  }

  Future<void> pumpTalismanStore(
    WidgetTester tester, {
    required double width,
  }) async {
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
            child: TalismanStoreScreen(),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    await settleTalismanTimers(tester);
  }

  testWidgets('TalismanStoreScreen has no overflow at mobile width', (tester) async {
    await pumpTalismanStore(tester, width: 375);
    expect(find.byType(TalismanStoreScreen), findsOneWidget);
    expect(find.byType(TalismanGrid), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('TalismanStoreScreen has no overflow at desktop width', (tester) async {
    await pumpTalismanStore(tester, width: 1280);
    expect(find.byType(TalismanStoreScreen), findsOneWidget);
    expect(find.byType(TalismanGrid), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
