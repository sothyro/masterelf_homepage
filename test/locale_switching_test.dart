import 'package:flutter_test/flutter_test.dart';

import 'package:masterelf_homepage/providers/locale_provider.dart';

void main() {
  test('setLocaleFromCode switches to Khmer', () {
    final notifier = LocaleNotifier();
    expect(notifier.locale.languageCode, 'en');

    notifier.setLocaleFromCode('km');
    expect(notifier.locale.languageCode, 'km');
  });
}
