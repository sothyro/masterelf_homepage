import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';
import 'theme/app_theme.dart';
import 'providers/locale_provider.dart';
import 'router/app_router.dart';

class MasterElfApp extends StatelessWidget {
  const MasterElfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocaleNotifier(),
      child: Consumer<LocaleNotifier>(
        builder: (context, localeNotifier, _) {
          final theme = AppTheme.light().copyWith(
            textTheme: textThemeForLocale(localeNotifier.locale.languageCode),
          );
          return MaterialApp.router(
            title: 'Master Elf Feng Shui',
            debugShowCheckedModeBanner: false,
            theme: theme,
            locale: localeNotifier.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: createAppRouter(),
          );
        },
      ),
    );
  }
}
