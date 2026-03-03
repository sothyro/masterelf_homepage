import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../widgets/app_shell.dart';
import '../screens/home/home_screen.dart';
import '../screens/about/about_screen.dart';
import '../screens/events/events_screen.dart';
import '../screens/contact/contact_screen.dart';
import '../screens/consultations/consultations_screen.dart';
import '../screens/consultations/consultations_dashboard_screen.dart';
import '../screens/academy/academy_screen.dart';
import '../screens/journey/journey_screen.dart';
import '../screens/apps/apps_screen.dart';
import '../providers/auth_provider.dart';
import '../l10n/app_localizations.dart';

final GlobalKey<NavigatorState> _rootNavKey = GlobalKey<NavigatorState>();

const Set<String> _knownPaths = {
  '/',
  '/about',
  '/journey',
  '/events',
  '/apps',
  '/academy',
  '/contact',
  '/consultations',
  '/consultations/dashboard',
  '/not-found',
};

/// Initial location for the router. On web, use the current browser URL path
/// (and query/fragment) so direct links (e.g. /consultations, /apps#books) open
/// the correct page instead of resetting to / after load.
String get _initialLocation {
  if (!kIsWeb) return '/';
  final base = Uri.base;
  if (base.path.isEmpty || base.path == '/') return '/';
  final buf = StringBuffer(base.path);
  if (base.query.isNotEmpty) buf.write('?${base.query}');
  if (base.fragment.isNotEmpty) buf.write('#${base.fragment}');
  return buf.toString();
}

/// Creates the app router once. Pass [refreshListenable] (e.g. LocaleNotifier)
/// so route/redirect logic can react to changes without recreating the router.
GoRouter createAppRouter({Listenable? refreshListenable}) {
  return GoRouter(
    navigatorKey: _rootNavKey,
    initialLocation: _initialLocation,
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      // Normalize: trim trailing slash so /consultations/ matches /consultations
      final raw = state.uri.path.replaceAll(RegExp(r'/+$'), '');
      final path = raw.isEmpty ? '/' : raw;
      if (path == '/' || _knownPaths.contains(path)) {
        if (path == '/consultations/dashboard') {
          final auth = context.read<AuthProvider>();
          if (!auth.isLoggedIn) return '/consultations';
        }
        return null;
      }
      return '/not-found';
    },
    routes: [
      ShellRoute(
        builder: (_, __, child) => AppShell(child: child),
        routes: [
          GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
          GoRoute(path: '/about', builder: (_, __) => const AboutScreen()),
          GoRoute(path: '/journey', builder: (_, __) => const JourneyScreen()),
          GoRoute(path: '/events', builder: (_, __) => const EventsScreen()),
          GoRoute(path: '/apps', builder: (_, __) => const AppsScreen()),
          GoRoute(path: '/academy', builder: (_, __) => const AcademyScreen()),
          GoRoute(path: '/contact', builder: (_, __) => const ContactScreen()),
          GoRoute(
            path: '/consultations',
            builder: (_, state) => AppointmentsScreen(
              initialServiceId: state.uri.queryParameters['service'],
            ),
          ),
          GoRoute(path: '/consultations/dashboard', builder: (_, __) => const AppointmentsDashboardScreen()),
          GoRoute(path: '/not-found', builder: (_, __) => const _NotFoundScreen()),
        ],
      ),
    ],
  );
}

/// Shown when the route is not found (404). Rendered inside the shell (header + footer).
class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.pageNotFoundTitle,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.pageNotFoundMessage,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.85),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.home_outlined),
              label: Text(l10n.backToHome),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.onAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
