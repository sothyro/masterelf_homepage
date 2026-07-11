import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/config/field_work_activity_cards.dart';
import 'package:masterelf_homepage/config/field_work_content.dart';
import 'package:masterelf_homepage/l10n/app_localizations_en.dart';

void main() {
  test('kFieldWorkPhotoCards has 29 unique entries with valid assets', () {
    expect(kFieldWorkPhotoCards.length, 29);

    final ids = <String>{};
    for (final card in kFieldWorkPhotoCards) {
      expect(ids.add(card.id), isTrue, reason: 'Duplicate id: ${card.id}');
      expect(card.photoNum, inInclusiveRange(1, 29));
      expect(
        File(card.coverImage).existsSync(),
        isTrue,
        reason: 'Missing asset: ${card.coverImage}',
      );
    }
  });

  test('buildFieldWorkCoreActivities returns 33 pillars', () {
    final l10n = AppLocalizationsEn();
    final pillars = buildFieldWorkCoreActivities(l10n, 'en');

    expect(pillars.length, 33);
    expect(pillars.take(4).map((p) => p.id).toList(), [
      'feng-shui-site',
      'consultations',
      'mao-shan-blessing',
      'date-selection',
    ]);
    expect(pillars.skip(4).every((p) => p.id.startsWith('activity-photo-')), isTrue);
  });

  test('photo cards resolve localized copy for km and zh', () {
    final card = kFieldWorkPhotoCards.first;
    final pillarKm = card.toPillar('km');
    final pillarZh = card.toPillar('zh');

    expect(pillarKm.title, isNot(equals(card.title.en)));
    expect(pillarZh.title, isNot(equals(card.title.en)));
    expect(pillarKm.realm, FieldWorkRealm.site);
    expect(pillarKm.linkPath, contains('fengshui'));
  });
}
