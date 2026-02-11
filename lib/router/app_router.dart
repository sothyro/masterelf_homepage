import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../widgets/app_shell.dart';
import '../screens/home/home_screen.dart';
import '../screens/about/about_screen.dart';
import '../screens/events/events_screen.dart';
import '../screens/contact/contact_screen.dart';
import '../screens/appointments/appointments_screen.dart';
import '../screens/appointments/appointments_dashboard_screen.dart';
import '../screens/academy/academy_screen.dart';
import '../screens/journey/journey_screen.dart';
import '../screens/method/method_screen.dart';
import '../screens/apps/apps_screen.dart';
import '../providers/auth_provider.dart';
import '../l10n/app_localizations.dart';

final GlobalKey<NavigatorState> _rootNavKey = GlobalKey<NavigatorState>();

const Set<String> _knownPaths = {
  '/',
  '/about',
  '/journey',
  '/method',
  '/events',
  '/apps',
  '/academy',
  '/contact',
  '/appointments',
  '/appointments/dashboard',
  '/not-found',
};

/// Creates the app router once. Pass [refreshListenable] (e.g. LocaleNotifier)
/// so route/redirect logic can react to changes without recreating the router.
GoRouter createAppRouter({Listenable? refreshListenable}) {
  return GoRouter(
    navigatorKey: _rootNavKey,
    initialLocation: '/',
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final path = state.uri.path;
      if (path.isEmpty || _knownPaths.contains(path)) {
        if (path == '/appointments/dashboard') {
          final auth = context.read<AuthProvider>();
          if (!auth.isLoggedIn) return '/appointments';
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
          GoRoute(path: '/method', builder: (_, __) => const MethodScreen()),
          GoRoute(path: '/events', builder: (_, __) => const EventsScreen()),
          GoRoute(path: '/apps', builder: (_, __) => const AppsScreen()),
          GoRoute(path: '/academy', builder: (_, __) => const AcademyScreen()),
          GoRoute(path: '/contact', builder: (_, __) => const ContactScreen()),
          GoRoute(path: '/appointments', builder: (_, __) => const AppointmentsScreen()),
          GoRoute(path: '/appointments/dashboard', builder: (_, __) => const AppointmentsDashboardScreen()),
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
