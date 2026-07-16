import 'dart:io';

/// Max allowed file size for the mobile web hero video (~1.5 MB target).
const int maxHeroVideo480Bytes = 3 * 1024 * 1024;

/// Max allowed file size for the desktop web hero video (~2.75 MB target).
const int maxHeroVideo720Bytes = 5 * 1024 * 1024;

/// Max allowed file size for the native hero asset (~2.75 MB target).
const int maxNativeHeroVideo720Bytes = 5 * 1024 * 1024;

/// Max allowed file size for the apps overview demo video (~1.74 MB target).
const int maxAppPageVideoBytes = 3 * 1024 * 1024;

/// Max allowed file size for mobile web activity spotlight videos (~3 MB).
const int maxActivityVideo480Bytes = 4 * 1024 * 1024;

/// Max allowed file size for 720p activity spotlight videos (~5.5 MB).
const int maxActivityVideo720Bytes = 6 * 1024 * 1024;

const _coreReleaseVideoFiles = <({String path, int maxBytes})>[
  (path: 'web/videos/videobackground720.mp4', maxBytes: maxHeroVideo720Bytes),
  (path: 'web/videos/videobackground480.mp4', maxBytes: maxHeroVideo480Bytes),
  (
    path: 'assets/videos/videobackground720.mp4',
    maxBytes: maxNativeHeroVideo720Bytes,
  ),
  (path: 'assets/videos/appads.mp4', maxBytes: maxAppPageVideoBytes),
];

List<({String path, int maxBytes})> get _activityReleaseVideoFiles {
  final files = <({String path, int maxBytes})>[];
  for (var n = 1; n <= 6; n++) {
    files.add((
      path: 'assets/videos/activities/$n.mp4',
      maxBytes: maxActivityVideo720Bytes,
    ));
    files.add((
      path: 'web/videos/activities/$n.mp4',
      maxBytes: maxActivityVideo480Bytes,
    ));
    files.add((
      path: 'web/videos/activities/$n-720.mp4',
      maxBytes: maxActivityVideo720Bytes,
    ));
  }
  return files;
}

List<({String path, int maxBytes})> get releaseVideoFiles => [
  ..._coreReleaseVideoFiles,
  ..._activityReleaseVideoFiles,
];

/// Returns false when any required release video is missing or too large.
bool verifyReleaseVideos({void Function(String message)? logError}) {
  var ok = true;
  void fail(String message) {
    ok = false;
    logError?.call(message);
  }

  for (final entry in releaseVideoFiles) {
    final file = File(entry.path);
    if (!file.existsSync()) {
      fail('Missing required release video: ${entry.path}');
      continue;
    }
    final size = file.lengthSync();
    if (size > entry.maxBytes) {
      final sizeMb = (size / (1024 * 1024)).toStringAsFixed(2);
      final maxMb = (entry.maxBytes / (1024 * 1024)).toStringAsFixed(0);
      fail(
        'Release video too large: ${entry.path} ($sizeMb MB; max $maxMb MB). '
        'Re-encode with ffmpeg (see README.md).',
      );
    }
  }

  return ok;
}

/// Returns false when any required web hero video is missing or too large.
bool verifyWebHeroVideos({void Function(String message)? logError}) =>
    verifyReleaseVideos(logError: logError);
