import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/config/app_content.dart';
import 'package:masterelf_homepage/services/activity_video_platform.dart';
import 'package:masterelf_homepage/utils/breakpoints.dart';

void main() {
  test('activityIndexFromAsset parses spotlight paths', () {
    expect(
      AppContent.activityIndexFromAsset(AppContent.assetActivityVideo03),
      3,
    );
    expect(AppContent.activityIndexFromAsset('invalid/path.mp4'), isNull);
  });

  test('videoPathForAsset returns asset path on native VM', () {
    expect(
      ActivityVideoPlatform.videoPathForAsset(
        AppContent.assetActivityVideo01,
        Breakpoints.mobile - 1,
      ),
      AppContent.assetActivityVideo01,
    );
  });

  test('activityVideoAssets lists all six spotlight clips', () {
    expect(AppContent.activityVideoAssets.length, 6);
  });
}
