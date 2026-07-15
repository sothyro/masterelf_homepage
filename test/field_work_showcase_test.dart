import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/config/field_work_content.dart';
import 'package:masterelf_homepage/l10n/app_localizations_en.dart';

void main() {
  test('buildFieldWorkCategoryPillars returns four pillars with expected links', () {
    final l10n = AppLocalizationsEn();
    final pillars = buildFieldWorkCategoryPillars(l10n);

    expect(pillars.length, 4);
    expect(pillars[0].linkPath, '/field-work?realm=site');
    expect(pillars[1].linkPath, '/field-work?realm=office');
    expect(pillars[2].linkPath, '/field-work?realm=ritual');
    expect(pillars[3].linkPath, '/consultations?service=dateselection');
    expect(pillars[0].title, 'Feng Shui site visit');
    expect(pillars[3].title, 'Date Selection (择日)');
    expect(pillars[0].coverImage, 'assets/images/activities/fengshui.webp');
    expect(pillars[1].coverImage, 'assets/images/activities/consultation.webp');
    expect(pillars[2].coverImage, 'assets/images/activities/maosan.webp');
    expect(pillars[3].coverImage, 'assets/images/activities/dateselection.webp');
    expect(pillars[0].realm, FieldWorkRealm.site);
    expect(pillars[2].realm, FieldWorkRealm.ritual);
  });
}
