import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app.dart';
import 'app_bootstrap.dart';
import 'firebase_options.dart';
import 'router/app_router.dart';
import 'services/connectivity_service.dart';
import 'services/error_logging_service.dart';
import 'services/error_service.dart';
import 'services/hero_video_platform.dart';
import 'screens/home/home_load_coordinator.dart';
import 'utils/app_asset_preloader.dart';
import 'utils/hero_video_preloader.dart';

void main() async {
  // Use path-based URLs (e.g. /consultations) so direct links open the correct page.
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  final initialLocation = getInitialRouterLocation();
  // Initialize Firebase and logging in parallel before app starts.
  await Future.wait([
    _initFirebase(),
    ErrorLoggingService.initialize(),
  ]);
  ConnectivityService.initialize();
  // Create providers and router at top level so URL routing works on mobile
  // (paste/refresh preserves the correct page instead of redirecting to home).
  initializeAppBootstrap(initialLocation);
  runApp(const HeroVideoBootstrap());
}

/// Initialize Firebase only when options are configured (not placeholder).
Future<void> _initFirebase() async {
  try {
    final options = DefaultFirebaseOptions.currentPlatform;
    if (options.projectId.isEmpty || options.projectId == 'your-project-id') {
      return;
    }
    await Firebase.initializeApp(options: options);
  } catch (_) {
    // Run without Firebase (demo mode for booking)
  }
}

/// Keeps the loading screen visible until critical images, fonts, and the
/// eager homepage (Hero + Events) have painted. Hero video prewarms in
/// parallel and does not gate dismiss — poster shows until playable.
class HeroVideoBootstrap extends StatefulWidget {
  const HeroVideoBootstrap({super.key});


  @override
  State<HeroVideoBootstrap> createState() => _HeroVideoBootstrapState();
}

class _HeroVideoBootstrapState extends State<HeroVideoBootstrap> {
  static const Duration _fadeDuration = Duration(milliseconds: 400);
  static const Duration _bootstrapTimeout = Duration(seconds: 12);

  /// App mounts under the overlay once fonts are ready so the homepage
  /// builds while the hero video pre-warms.
  static const double _mountAppAtProgress = 0.75;

  double _progress = 0.0;
  bool _appMounted = false;
  bool _fadeOut = false;
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    // Homepage: wait for paint only. Deep links: assets/fonts only.
    final isHome = bootstrapInitialLocation == '/';
    final Future<void>? homeGate = isHome ? HomeReadiness.ready : null;
    AppAssetPreloader.preloadAll(
      _onPreloadProgress,
      waitForFirstPaint: homeGate,
      prewarmHeroVideo: isHome,
    ).timeout(
      _bootstrapTimeout,
      onTimeout: () => _forceReveal(timedOut: true),
    ).catchError((_) {
      _forceReveal(timedOut: false);
    });
  }

  void _onPreloadProgress(double progress) {
    if (!mounted || _dismissed) return;
    setState(() {
      _progress = progress;
      if (progress >= _mountAppAtProgress) _appMounted = true;
      if (progress >= 1.0) _fadeOut = true;
    });
    if (progress >= 1.0) _scheduleDismiss();
  }

  /// Timeout/error fallback: reveal the app (hero falls back to its poster).
  void _forceReveal({required bool timedOut}) {
    if (!mounted || _dismissed) return;
    if (timedOut) {
      ErrorLoggingService.logError(
        const AppError(
          category: ErrorCategory.unknown,
          userMessage: 'Loading took too long.',
          technicalMessage: 'Bootstrap preload timed out; revealed with fallbacks.',
        ),
        additionalData: {'stage': 'bootstrap_timeout'},
      );
    }
    setState(() {
      _progress = 1.0;
      _appMounted = true;
      _fadeOut = true;
    });
    _scheduleDismiss();
  }

  void _scheduleDismiss() {
    Future<void>.delayed(_fadeDuration, () {
      if (!mounted || _dismissed) return;
      setState(() => _dismissed = true);
      // Retry autoplay now that the loading overlay is gone; browsers often
      // block muted autoplay while the page is still "obscured".
      unawaited(HeroVideoPlatform.resume());
      // Progressive-load routes arm coordinators on mount; homepage arms here
      // so background preload never races hero video under the overlay.
      final entryPath = bootstrapInitialLocation.split('#').first;
      if (entryPath == '/') {
        HomeLoadCoordinator.armAfterReveal();
      } else if (entryPath != '/apps' && entryPath != '/field-work') {
        AppAssetPreloader.startBackgroundPreload();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          if (_appMounted) const MasterElfApp(),
          if (!_dismissed)
            IgnorePointer(
              ignoring: _fadeOut,
              child: AnimatedOpacity(
                opacity: _fadeOut ? 0.0 : 1.0,
                duration: _fadeDuration,
                child: HeroLoadingScreen(progress: _progress),
              ),
            ),
        ],
      ),
    );
  }
}
