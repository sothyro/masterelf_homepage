import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/l10n/app_localizations.dart';
import 'package:masterelf_homepage/screens/talisman/talisman_store_screen.dart';
import 'package:masterelf_homepage/screens/talisman/widgets/talisman_product_card.dart';
import 'package:masterelf_homepage/theme/app_theme.dart';

void main() {
  Future<void> pumpTalismanStore(WidgetTester tester, {required double width}) async {
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
  }

  testWidgets('TalismanStoreScreen renders nine product cards with marketing bands', (tester) async {
    await pumpTalismanStore(tester, width: 1280);

    expect(find.byType(TalismanStoreScreen), findsOneWidget);
    expect(find.text('Talisman Store'), findsWidgets);
    expect(find.text('Sacred charms, chosen with devotion'), findsOneWidget);
    expect(find.text('Nine Sacred Charms'), findsOneWidget);
    expect(find.text('Faith you can hold close'), findsOneWidget);
    expect(find.text('Seeking a blessing for something specific?'), findsOneWidget);
    expect(find.byType(TalismanProductCard), findsNWidgets(9));
    expect(
      find.text('Shield against harm—carry heaven\'s guard wherever you go.'),
      findsOneWidget,
    );
  });

  testWidgets('TalismanStoreScreen uses full Add to Cart label on mobile', (tester) async {
    await pumpTalismanStore(tester, width: 375);

    expect(find.byType(TalismanStoreScreen), findsOneWidget);
    expect(find.text('Sacred charms, chosen with devotion'), findsOneWidget);
    expect(find.text('Faith you can hold close'), findsOneWidget);
    expect(find.text('Add to Cart'), findsNWidgets(9));
    expect(find.text('Add'), findsNothing);
  });
}
