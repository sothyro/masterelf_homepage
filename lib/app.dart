import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';
import 'theme/app_theme.dart';
import 'providers/locale_provider.dart';
import 'router/app_router.dart';

class MasterElfApp extends StatefulWidget {
  const MasterElfApp({super.key});

  @override
  State<MasterElfApp> createState() => _MasterElfAppState();
}

class _MasterElfAppState extends State<MasterElfApp> {
  GoRouter? _router;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocaleNotifier(),
      child: Consumer<LocaleNotifier>(
        builder: (context, localeNotifier, _) {
          // Create router once so navigation state is preserved on locale change.
          _router ??= createAppRouter(refreshListenable: localeNotifier);
          final theme = _themeForLocale(localeNotifier.locale.languageCode);
          return MaterialApp.router(
            title: 'Master Elf Feng Shui',
            debugShowCheckedModeBanner: false,
            theme: theme,
            darkTheme: theme,
            themeMode: ThemeMode.dark,
            locale: localeNotifier.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: _router!,
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
