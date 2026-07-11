import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/services/site_inspection_service.dart';

void main() {
  test('normalizeInspectorEmail trims and lowercases', () {
    expect(normalizeInspectorEmail('Sothyro@gmail.com'), 'sothyro@gmail.com');
    expect(normalizeInspectorEmail('  sothyro@gmail.com  '), 'sothyro@gmail.com');
    expect(normalizeInspectorEmail('STAFF@MASTERELF.COM'), 'staff@masterelf.com');
  });
}
