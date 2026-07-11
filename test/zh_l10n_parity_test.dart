import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Chinese arb has same keys as English template', () {
    final en = jsonDecode(
      File('lib/l10n/app_en.arb').readAsStringSync(),
    ) as Map<String, dynamic>;
    final zh = jsonDecode(
      File('lib/l10n/app_zh.arb').readAsStringSync(),
    ) as Map<String, dynamic>;

    final enKeys = en.keys
        .where((k) => !k.startsWith('@') && k != '@@locale')
        .toList()
      ..sort();
    final zhKeys = zh.keys
        .where((k) => !k.startsWith('@') && k != '@@locale')
        .toList()
      ..sort();

    expect(zhKeys, enKeys, reason: 'app_zh.arb must mirror app_en.arb keys');

    for (final key in enKeys) {
      final enVal = en[key] as String;
      final zhVal = zh[key] as String?;
      expect(zhVal, isNotNull, reason: 'Missing Chinese value for $key');
      final zhText = zhVal!;
      if (enVal.trim().isNotEmpty) {
        expect(zhText.trim().isNotEmpty, isTrue, reason: 'Empty Chinese for $key');
      }

      final enPh = RegExp(r'\{[^}]+\}').allMatches(enVal).map((m) => m.group(0)).toList()..sort();
      final zhPh = RegExp(r'\{[^}]+\}').allMatches(zhText).map((m) => m.group(0)).toList()..sort();
      expect(zhPh, enPh, reason: 'Placeholder mismatch for $key');
    }
  });
}
