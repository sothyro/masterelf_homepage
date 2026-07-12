import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'breakpoints.dart';

/// Shared mobile-web performance policy (memory + animation budgets).
class MobileWebPerformance {
  MobileWebPerformance._();

  static const Duration _backgroundPreloadDeferWeb = Duration(seconds: 3);
  static const Duration _heroMedallionAnimationDeferWeb = Duration(milliseconds: 1500);

  /// True when running in a mobile-width browser tab.
  static bool isMobileWeb(BuildContext context) {
    if (!kIsWeb) return false;
    final width = MediaQuery.sizeOf(context).width;
    return Breakpoints.isMobile(width);
  }

  /// True when running in a mobile-width browser tab (no [BuildContext]).
  static bool isMobileWebWidth(double width) => kIsWeb && Breakpoints.isMobile(width);

  /// Like [isMobileWeb] but usable before any [MediaQuery] exists
  /// (e.g. during bootstrap preload).
  static bool isMobileWebViewport() {
    if (!kIsWeb) return false;
    final view = WidgetsBinding.instance.platformDispatcher.implicitView;
    if (view == null) return false;
    final width = view.physicalSize.width / view.devicePixelRatio;
    return Breakpoints.isMobile(width);
  }

  /// Hero video is pre-warmed during bootstrap on all web viewports.
  static bool shouldPrewarmHeroVideo() => kIsWeb;

  /// Decode width cap for [Image.asset] to limit GPU memory on mobile web.
  static int devicePixelCacheWidth(BuildContext context, double layoutWidth) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    return (layoutWidth * dpr).round().clamp(320, 1200);
  }

  /// Decode target for crisp UI mockups inside device / phone bezels.
  ///
  /// Uses full device-pixel resolution (with a safety cap on web). Decorative
  /// hero imagery should keep using [devicePixelCacheWidth] instead.
  static int? mockupPixelCacheWidth(BuildContext context, double layoutWidth) {
    if (layoutWidth <= 0) return null;
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final pixels = (layoutWidth * dpr).round();
    if (!kIsWeb) return null;
    if (isMobileWeb(context)) {
      return pixels.clamp(480, 2048);
    }
    return pixels.clamp(640, 4096);
  }

  /// Matching height cap when the mockup layout height is known (portrait phones).
  static int? mockupPixelCacheHeight(BuildContext context, double layoutHeight) {
    if (layoutHeight <= 0) return null;
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final pixels = (layoutHeight * dpr).round();
    if (!kIsWeb) return null;
    if (isMobileWeb(context)) {
      return pixels.clamp(480, 4096);
    }
    return pixels.clamp(640, 8192);
  }

  /// Poster is shown only until the hero video is ready (or if load fails).
  static bool preferPosterOnlyHeroVideo(BuildContext context) => false;

  /// Skip marquee / carousel auto-advance on mobile web or reduced motion.
  static bool disableHeavyAnimations(BuildContext context) {
    if (isMobileWeb(context)) return true;
    final mq = MediaQuery.maybeOf(context);
    return mq != null && mq.disableAnimations;
  }

  /// Defer non-critical background preload after bootstrap on web.
  static Duration backgroundPreloadDefer() {
    return kIsWeb ? _backgroundPreloadDeferWeb : Duration.zero;
  }

  /// Defer hero medallion orbit animation on mobile web until first paint settles.
  static Duration heroMedallionAnimationDefer() {
    return kIsWeb ? _heroMedallionAnimationDeferWeb : Duration.zero;
  }

  /// Filter quality for large decorative images on mobile web.
  static FilterQuality imageFilterQuality(BuildContext context) {
    return isMobileWeb(context) ? FilterQuality.medium : FilterQuality.high;
  }

  /// Always render product mockup screenshots at full quality.
  static FilterQuality mockupFilterQuality(BuildContext context) =>
      FilterQuality.high;
}
