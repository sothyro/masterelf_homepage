import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Khmer arb has same keys as English template', () {
    final en = jsonDecode(
      File('lib/l10n/app_en.arb').readAsStringSync(),
    ) as Map<String, dynamic>;
    final km = jsonDecode(
      File('lib/l10n/app_km.arb').readAsStringSync(),
    ) as Map<String, dynamic>;

    final enKeys = en.keys
        .where((k) => !k.startsWith('@') && k != '@@locale')
        .toList()
      ..sort();
    final kmKeys = km.keys
        .where((k) => !k.startsWith('@') && k != '@@locale')
        .toList()
      ..sort();

    expect(kmKeys, enKeys, reason: 'app_km.arb must mirror app_en.arb keys');

    for (final key in enKeys) {
      final enVal = en[key] as String;
      final kmVal = km[key] as String?;
      expect(kmVal, isNotNull, reason: 'Missing Khmer value for $key');
      final kmText = kmVal!;
      if (enVal.trim().isNotEmpty) {
        expect(kmText.trim().isNotEmpty, isTrue, reason: 'Empty Khmer for $key');
      }

      final enPh = RegExp(r'\{[^}]+\}').allMatches(enVal).map((m) => m.group(0)).toList()..sort();
      final kmPh = RegExp(r'\{[^}]+\}').allMatches(kmText).map((m) => m.group(0)).toList()..sort();
      expect(kmPh, enPh, reason: 'Placeholder mismatch for $key');
    }
  });

  test('Khmer arb has no known typo patterns', () {
    final km = jsonDecode(
      File('lib/l10n/app_km.arb').readAsStringSync(),
    ) as Map<String, dynamic>;
    final badPatterns = ['មិះ', 'រទេះ', 'អ៉ីមែល'];
    for (final entry in km.entries) {
      if (entry.key.startsWith('@') || entry.key == '@@locale') continue;
      final value = entry.value as String;
      for (final bad in badPatterns) {
        expect(
          value.contains(bad),
          isFalse,
          reason: 'Key ${entry.key} contains typo pattern "$bad": $value',
        );
      }
    }
  });
}
