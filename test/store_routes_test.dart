import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/config/store_routes.dart';

void main() {
  test('redirectLegacyAppsFragment maps book fragments to /books', () {
    expect(redirectLegacyAppsFragment('books'), '/books');
    expect(redirectLegacyAppsFragment('book-3'), '/books#book-3');
    expect(redirectLegacyAppsFragment('blessing-bundle'), '/books#blessing-bundle');
    expect(redirectLegacyAppsFragment('period9-2'), '/books#period9-2');
  });

  test('redirectLegacyAppsFragment maps talisman to /talisman', () {
    expect(redirectLegacyAppsFragment('talisman'), '/talisman');
  });

  test('redirectLegacyAppsFragment keeps apps-only fragments', () {
    expect(redirectLegacyAppsFragment('master-elf'), isNull);
    expect(redirectLegacyAppsFragment('period9'), isNull);
    expect(redirectLegacyAppsFragment(''), isNull);
  });
}
