import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_bootstrap.dart';
import 'l10n/app_localizations.dart';
import 'services/connectivity_service.dart';
import 'theme/app_theme.dart';
import 'providers/locale_provider.dart';
import 'providers/auth_provider.dart';

class MasterElfApp extends StatefulWidget {
  const MasterElfApp({super.key});

  @override
  State<MasterElfApp> createState() => _MasterElfAppState();
}

class _MasterElfAppState extends State<MasterElfApp> {
  @override
  void dispose() {
    ConnectivityService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: localeNotifier),
        ChangeNotifierProvider.value(value: authProvider),
      ],
      child: Consumer<LocaleNotifier>(
        builder: (context, localeNotifier, _) {
          final theme = _themeForLocale(localeNotifier.locale.languageCode);
          return MaterialApp.router(
            title: lookupAppLocalizations(localeNotifier.locale).appTitle,
            debugShowCheckedModeBanner: false,
            theme: theme,
            darkTheme: theme,
            themeMode: ThemeMode.dark,
            locale: localeNotifier.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }

  static final Map<String, ThemeData> _themeCache = {};

  static ThemeData _themeForLocale(String languageCode) {
    return _themeCache.putIfAbsent(
      languageCode,
      () => AppTheme.dark().copyWith(
        textTheme: textThemeForLocale(languageCode),
      ),
    );
  }
}
