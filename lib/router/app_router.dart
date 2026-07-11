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
import '../screens/consultations/inspection_dashboard_screen.dart';
import '../screens/consultations/site_inspection_screen.dart';
import '../screens/academy/academy_screen.dart';
import '../screens/journey/journey_screen.dart';
import '../screens/field_work/field_work_screen.dart';
import '../screens/field_work/field_work_detail_screen.dart';
import '../screens/field_work/activity_video_detail_screen.dart';
import '../screens/apps/apps_screen.dart';
import '../screens/books/book_store_screen.dart';
import '../screens/talisman/talisman_store_screen.dart';
import '../config/field_work_content.dart';
import '../config/store_routes.dart';
import '../providers/auth_provider.dart';
import '../l10n/app_localizations.dart';

final GlobalKey<NavigatorState> _rootNavKey = GlobalKey<NavigatorState>();

const String _basePathPrefix = '';

const Set<String> _knownPaths = {
  '/',
  '/about',
  '/journey',
  '/events',
  '/apps',
  '/books',
  '/talisman',
  '/academy',
  '/contact',
  '/consultations',
  '/consultations/dashboard',
  '/consultations/inspection-dashboard',
  '/consultations/site-inspection',
  '/field-work',
  '/not-found',
};

String normalizePath(String path) {
  if (path.isEmpty || path == '/') return '/';
  while (path.endsWith('/') && path.length > 1) {
    path = path.substring(0, path.length - 1);
  }
  return path;
}

String getInitialRouterLocation() {
  if (kIsWeb) {
    final uri = Uri.base;
    var path = uri.path;
    if (_basePathPrefix.isNotEmpty && path.startsWith(_basePathPrefix)) {
      path = path.substring(_basePathPrefix.length);
    }
    final normalizedPath = normalizePath(path);
    final query = uri.hasQuery ? '?${uri.query}' : '';
    final fragment = uri.fragment.isNotEmpty ? '#${uri.fragment}' : '';
    return normalizedPath + query + fragment;
  }
  return '/';
}

/// Creates the app router once. Pass [refreshListenable] (e.g. LocaleNotifier)
/// so route/redirect logic can react to changes without recreating the router.
GoRouter createAppRouter({
  Listenable? refreshListenable,
  String? initialLocation,
}) {
  return GoRouter(
    navigatorKey: _rootNavKey,
    initialLocation: initialLocation ?? getInitialRouterLocation(),
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final uri = state.uri;
      final rawPath = uri.path;
      final normalized = normalizePath(rawPath);

      if (rawPath != normalized) {
        final query = uri.hasQuery ? '?${uri.query}' : '';
        final fragment = uri.fragment.isNotEmpty ? '#${uri.fragment}' : '';
        return normalized + query + fragment;
      }

      if (normalized == '/' || _knownPaths.contains(normalized)) {
        if (normalized == '/apps' && uri.fragment.isNotEmpty) {
          final redirect = redirectLegacyAppsFragment(uri.fragment);
          if (redirect != null) {
            final query = uri.hasQuery ? '?${uri.query}' : '';
            return redirect + query;
          }
        }
        if (normalized == '/consultations/dashboard' ||
            normalized == '/consultations/inspection-dashboard' ||
            normalized == '/consultations/site-inspection') {
          final auth = context.read<AuthProvider>();
          if (!auth.isLoggedIn) return '/consultations';
        }
        return null;
      }
      if (normalized.startsWith('/consultations/site-inspection/') &&
          normalized.length > '/consultations/site-inspection/'.length) {
        final auth = context.read<AuthProvider>();
        if (!auth.isLoggedIn) return '/consultations';
        return null;
      }
      if (normalized.startsWith('/field-work/') &&
          normalized.length > '/field-work/'.length) {
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
          GoRoute(path: '/books', builder: (_, __) => const BookStoreScreen()),
          GoRoute(path: '/talisman', builder: (_, __) => const TalismanStoreScreen()),
          GoRoute(path: '/academy', builder: (_, __) => const AcademyScreen()),
          GoRoute(path: '/contact', builder: (_, __) => const ContactScreen()),
          GoRoute(
            path: '/consultations',
            builder: (_, state) => AppointmentsScreen(
              initialServiceId: state.uri.queryParameters['service'],
            ),
          ),
          GoRoute(path: '/consultations/dashboard', builder: (_, __) => const AppointmentsDashboardScreen()),
          GoRoute(path: '/consultations/inspection-dashboard', builder: (_, __) => const InspectionDashboardScreen()),
          GoRoute(
            path: '/consultations/site-inspection',
            builder: (_, __) => const SiteInspectionScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (_, state) {
                  final id = state.pathParameters['id'] ?? '';
                  return SiteInspectionScreen(inspectionId: id.isNotEmpty ? id : null);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/field-work',
            builder: (_, state) {
              final realm = FieldWorkRealm.fromQuery(state.uri.queryParameters['realm']);
              final videosOnly = state.uri.queryParameters['filter'] == 'videos';
              return FieldWorkScreen(
                initialRealm: realm,
                initialVideosOnly: videosOnly,
              );
            },
            routes: [
              GoRoute(
                path: 'video/:slug',
                builder: (context, state) {
                  final slug = state.pathParameters['slug'] ?? '';
                  final l10n = AppLocalizations.of(context)!;
                  final video = getLocalizedActivityVideoBySlug(slug, l10n);
                  if (video == null) {
                    return const _NotFoundScreen();
                  }
                  return ActivityVideoDetailScreen(video: video);
                },
              ),
              GoRoute(
                path: ':slug',
                builder: (_, state) {
                  final slug = state.pathParameters['slug'] ?? '';
                  final post = getFieldWorkPostBySlug(slug);
                  if (post == null) {
                    return const _NotFoundScreen();
                  }
                  return FieldWorkDetailScreen(post: post);
                },
              ),
            ],
          ),
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
