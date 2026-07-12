import 'dart:async';

import 'dart:js_interop';

import 'package:video_player/video_player.dart';
import 'package:web/web.dart' as web;

import '../config/app_content.dart';
import '../utils/breakpoints.dart';

/// Web activity videos via static `/videos/activities/` (faststart MP4 + AAC).
class ActivityVideoPlatform {
  ActivityVideoPlatform._();

  static String videoPathForAsset(String videoAsset, double layoutWidth) {
    final index = AppContent.activityIndexFromAsset(videoAsset);
    if (index == null) return videoAsset;
    return Breakpoints.isMobile(layoutWidth)
        ? AppContent.webActivityVideo480(index)
        : AppContent.webActivityVideo720(index);
  }

  static Uri videoUriForAsset(String videoAsset, double layoutWidth) =>
      Uri.base.resolve(videoPathForAsset(videoAsset, layoutWidth));

  static VideoPlayerController createController({
    required String videoAsset,
    required double layoutWidth,
  }) {
    return VideoPlayerController.networkUrl(
      videoUriForAsset(videoAsset, layoutWidth),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
  }

  /// Warm HTTP cache for the first spotlight clips on field-work visit.
  static Future<void> prewarmSpotlightVideos({
    required List<String> videoAssets,
    required double layoutWidth,
  }) async {
    for (final asset in videoAssets.take(2)) {
      final url = videoUriForAsset(asset, layoutWidth).toString();
      try {
        await web.window.fetch(url.toJS).toDart;
      } catch (_) {
        // Best-effort warm; playback still lazy-loads on visibility.
      }
    }
  }
}
