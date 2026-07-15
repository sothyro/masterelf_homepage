import 'package:flutter_test/flutter_test.dart';

import 'l10n_audit_helpers.dart';

void main() {
  test('Khmer arb has same keys as English template', () {
    final en = L10nAuditHelpers.loadEn();
    final km = L10nAuditHelpers.loadKm();

    final enKeys = L10nAuditHelpers.stringKeys(en);
    final kmKeys = L10nAuditHelpers.stringKeys(km);

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
    final km = L10nAuditHelpers.loadKm();
    for (final entry in km.entries) {
      if (entry.key.startsWith('@') || entry.key == '@@locale') continue;
      final value = entry.value as String;
      for (final bad in L10nAuditHelpers.bannedKmTypoPatterns) {
        expect(
          value.contains(bad),
          isFalse,
          reason: 'Key ${entry.key} contains typo pattern "$bad": $value',
        );
      }
    }
  });

  test('Khmer arb avoids audit mistranslation for Feng Shui', () {
    final km = L10nAuditHelpers.loadKm();
    for (final entry in km.entries) {
      if (entry.key.startsWith('@') || entry.key == '@@locale') continue;
      final value = entry.value as String;
      expect(
        value.contains(L10nAuditHelpers.bannedAuditMisrender),
        isFalse,
        reason: 'Key ${entry.key} uses "ត្រវែង" for audit: $value',
      );
    }
  });

  test('Khmer arb uses brand Phoenix not literal bird term outside 朱雀', () {
    final offenders = L10nAuditHelpers.keysWithBrandPhoenixMisrender();
    expect(
      offenders,
      isEmpty,
      reason: 'Brand Phoenix should be មយូរ៉ា, not ភ្នុកស័រ: ${offenders.join(', ')}',
    );
  });

  test('Known priority keys have correct Khmer semantics', () {
    final en = L10nAuditHelpers.loadEn();
    final km = L10nAuditHelpers.loadKm();

    final heading = km['talismanStoreCollectionHeading'] as String;
    expect(heading, contains('អថ័ន'));
    expect(heading, contains('ទាំង៩'));
    expect(heading, isNot(contains('ប្រាំបួន')));

    final intro = km['talismanStoreCollectionIntro'] as String;
    expect(intro, contains('ទាំង៩'));
    expect(intro, isNot(contains('បំណងប្រាំបួន')));

    final marketing = km['bookStoreSectionMarketing'] as String;
    expect(marketing, contains('បណ្ណាល័យ'));
    expect(marketing, isNot(contains('យុគទី ៩ (Period 9)')));
    expect(en['bookStoreSectionMarketing'], contains('curated library'));

    final spotlight = km['fieldWorkVideoSpotlight2Title'] as String;
    expect(spotlight, contains('សាវនកម្មហុងស៊ុយ'));
    expect(spotlight, isNot(contains('ត្រវែង')));
    expect(spotlight, isNot(contains('ត្រួតពិនិត្យហុងស៊ុយ')));

    final eventTitle = km['event1Title'] as String;
    expect(eventTitle, contains('មយូរ៉ា'));

    final shelfHeading = km['bookStoreShelfPanoramaTopHeading'] as String;
    expect(shelfHeading, contains('ពរជ័យប្រាំប្រការ'));

    final revelation = km['eventsPageHeroBody'] as String;
    expect(revelation, contains('ការបង្ហាញខ្លួន'));
    expect(revelation, isNot(contains('ការបង្ហាញប្រាជ្ញា')));
  });

  test('Cart-related Khmer uses glossary term កន្ត្រក', () {
    final km = L10nAuditHelpers.loadKm();
    final cartKeys = [
      'bookStoreAddToCart',
      'bookStoreAddedToCart',
      'marketplaceAddedToCart',
      'talismanStoreSpotlightDesc',
    ];
    for (final key in cartKeys) {
      final value = km[key] as String;
      expect(
        value.contains(L10nAuditHelpers.cartGlossaryTerm),
        isTrue,
        reason: '$key should use ${L10nAuditHelpers.cartGlossaryTerm}: $value',
      );
      expect(value.contains('រទេះ'), isFalse, reason: '$key uses cart typo');
    }
  });

  test('Talisman remedies use វត្ថុសិរី', () {
    final km = L10nAuditHelpers.loadKm();
    for (final key in [
      'talismanStoreSpotlightDesc',
      'talismanStoreTrustBody',
    ]) {
      final value = km[key] as String;
      expect(value, contains('វត្ថុសិរី'), reason: '$key: $value');
    }
  });

  test('Untranslated Khmer keys stay within intentional allowlist', () {
    final untranslated = L10nAuditHelpers.untranslatedKmKeys();
    expect(
      untranslated,
      isEmpty,
      reason: 'Unexpected km==en keys: ${untranslated.join(', ')}',
    );
  });
}
