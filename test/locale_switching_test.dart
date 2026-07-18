import 'package:flutter_test/flutter_test.dart';

import 'package:masterelf_homepage/providers/locale_provider.dart';

void main() {
  test('setLocaleFromCode switches to Khmer', () {
    final notifier = LocaleNotifier();
    expect(notifier.locale.languageCode, 'en');

    notifier.setLocaleFromCode('km');
    expect(notifier.locale.languageCode, 'km');
  });

  test('setLocaleFromCode round-trips en → km → en', () {
    final notifier = LocaleNotifier();
    expect(notifier.locale.languageCode, 'en');

    notifier.setLocaleFromCode('km');
    expect(notifier.locale.languageCode, 'km');

    notifier.setLocaleFromCode('en');
    expect(notifier.locale.languageCode, 'en');
  });

  test('setLocaleFromCode round-trips en → zh → en', () {
    final notifier = LocaleNotifier();
    expect(notifier.locale.languageCode, 'en');

    notifier.setLocaleFromCode('zh');
    expect(notifier.locale.languageCode, 'zh');

    notifier.setLocaleFromCode('en');
    expect(notifier.locale.languageCode, 'en');
  });
}
