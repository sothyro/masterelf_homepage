import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:masterelf_homepage/l10n/app_localizations.dart';
import 'package:masterelf_homepage/theme/app_theme.dart';
import 'package:masterelf_homepage/widgets/khmer_aware_text.dart';

void main() {
  testWidgets('Latin-only text displays correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: const Scaffold(
          body: KhmerAwareText('Hello world'),
        ),
      ),
    );

    expect(find.text('Hello world'), findsOneWidget);
    expect(find.byType(KhmerAwareText), findsOneWidget);
  });

  testWidgets('mixed Latin/Khmer renders Khmer runes when locale is en', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: const Scaffold(
          body: KhmerAwareText('Siem Reap សៀមរាប'),
        ),
      ),
    );

    expect(find.textContaining('សៀមរាប'), findsOneWidget);
    expect(find.textContaining('Siem Reap'), findsOneWidget);
  });

  testWidgets('Khmer locale shows Khmer text', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('km'),
        home: const Scaffold(
          body: KhmerAwareText('សៀមរាប'),
        ),
      ),
    );

    expect(find.text('សៀមរាប'), findsOneWidget);
  });
}
