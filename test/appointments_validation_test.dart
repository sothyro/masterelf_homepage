import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:masterelf_homepage/l10n/app_localizations.dart';
import 'package:masterelf_homepage/utils/validators.dart';

void main() {
  test('details step phone validation rejects short numbers', () {
    final l10n = lookupAppLocalizations(const Locale('en'));
    final result = Validators.phone('123', l10n: l10n);
    expect(result.isValid, false);
    expect(result.errorMessage, l10n.validationPhoneTooShort);
  });

  test('details step phone validation rejects empty phone', () {
    final l10n = lookupAppLocalizations(const Locale('en'));
    final result = Validators.phone('', l10n: l10n);
    expect(result.isValid, false);
    expect(result.errorMessage, l10n.validationPhoneRequired);
  });

  test('details step phone validation accepts valid international phone', () {
    final l10n = lookupAppLocalizations(const Locale('en'));
    expect(Validators.phone('85512345678', l10n: l10n).isValid, true);
  });
}
