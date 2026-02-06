import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_shell.dart';
import '../screens/home/home_screen.dart';
import '../screens/about/about_screen.dart';
import '../screens/events/events_screen.dart';
import '../screens/contact/contact_screen.dart';
import '../screens/appointments/appointments_screen.dart';
import '../screens/academy/academy_screen.dart';
import '../screens/journey/journey_screen.dart';
import '../screens/method/method_screen.dart';
import '../screens/apps/apps_screen.dart';

final GlobalKey<NavigatorState> _rootNavKey = GlobalKey<NavigatorState>();

/// Creates the app router once. Pass [refreshListenable] (e.g. LocaleNotifier)
/// so route/redirect logic can react to changes without recreating the router.
GoRouter createAppRouter({Listenable? refreshListenable}) {
  return GoRouter(
    navigatorKey: _rootNavKey,
    initialLocation: '/',
    refreshListenable: refreshListenable,
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
        ],
      ),
    ],
  );
}
