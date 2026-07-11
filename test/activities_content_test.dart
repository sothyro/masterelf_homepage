import 'package:flutter_test/flutter_test.dart';

import 'package:masterelf_homepage/config/app_content.dart';
import 'package:masterelf_homepage/config/field_work_content.dart';

void main() {
  group('kActivityVideoSpotlights', () {
    test('has six spotlight videos with activity video paths', () {
      expect(kActivityVideoSpotlights.length, 6);
      expect(
        kActivityVideoSpotlights.map((v) => v.videoAsset).toList(),
        [
          AppContent.assetActivityVideo01,
          AppContent.assetActivityVideo02,
          AppContent.assetActivityVideo03,
          AppContent.assetActivityVideo04,
          AppContent.assetActivityVideo05,
          AppContent.assetActivityVideo06,
        ],
      );
    });

    test('getActivityVideoBySlug finds known slug', () {
      final video = getActivityVideoBySlug('feng-shui-compass-on-site');
      expect(video, isNotNull);
      expect(video!.posterImage, AppContent.assetActivityFengShui);
      expect(video.detailPath(), '/field-work/video/feng-shui-compass-on-site');
    });

    test('spotlight posters are unique and use category plus field photos', () {
      final posters = kActivityVideoSpotlights.map((v) => v.posterImage).toList();
      expect(posters.toSet().length, 6);
      expect(posters, containsAll([
        AppContent.assetActivityFengShui,
        AppContent.assetActivityConsultation,
        AppContent.assetActivityMaoShan,
        AppContent.assetActivityDateSelection,
        AppContent.assetActivityPhoto(15),
        AppContent.assetActivityPhoto(27),
      ]));
    });

    test('returns null for unknown slug', () {
      expect(getActivityVideoBySlug('missing'), isNull);
    });
  });
}
