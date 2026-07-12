import 'package:video_player/video_player.dart';

/// Native activity video via bundled assets.
class ActivityVideoPlatform {
  ActivityVideoPlatform._();

  static String videoPathForAsset(String videoAsset, double layoutWidth) =>
      videoAsset;

  static VideoPlayerController createController({
    required String videoAsset,
    required double layoutWidth,
  }) {
    return VideoPlayerController.asset(
      videoAsset,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
  }

  static Future<void> prewarmSpotlightVideos({
    required List<String> videoAssets,
    required double layoutWidth,
  }) async {}
}
