import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/config/field_work_activity_cards.dart';
import 'package:masterelf_homepage/config/field_work_content.dart';
import 'package:masterelf_homepage/l10n/app_localizations_en.dart';

/// Literal photo-caption phrases the rewrite should not use.
const _bannedLiteralPhrases = [
  'yellow scrolls',
  'White Shirt',
  'orchids',
  'gift baskets',
  'whole chicken',
  'mandala poster',
  'dragon wall',
  'Bassac',
  'N.22',
  'microphone',
  'noodle offerings',
  'green light awakens',
  'squat beside',
  'Pose with your master',
  'Seminar Graduation',
  'Front Row',
];

void main() {
  test('activity card copy avoids literal photo-caption phrases', () {
    final texts = <String>[];
    for (final card in kFieldWorkPhotoCards) {
      texts
        ..add(card.title.en)
        ..add(card.title.km)
        ..add(card.title.zh)
        ..add(card.subtitle.en)
        ..add(card.subtitle.km)
        ..add(card.subtitle.zh);
    }

    for (final phrase in _bannedLiteralPhrases) {
      for (final text in texts) {
        expect(
          text.toLowerCase(),
          isNot(contains(phrase.toLowerCase())),
          reason: 'Banned phrase "$phrase" found in: $text',
        );
      }
    }
  });

  test('home and field work share the same pillar copy source', () {
    final l10n = AppLocalizationsEn();
    final pillars = buildFieldWorkCoreActivities(l10n, 'en');

    expect(pillars.firstWhere((p) => p.id == 'feng-shui-site').title,
        'Unlock Your Property\'s Qi');
    expect(pillars.firstWhere((p) => p.id == 'activity-photo-28').title,
        'Commit With Clear Timing');
  });
}
