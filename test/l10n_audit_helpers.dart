import 'dart:convert';
import 'dart:io';

/// Shared helpers for EN/KM localization audit tests.
class L10nAuditHelpers {
  L10nAuditHelpers._();

  static Map<String, dynamic> loadEn() => jsonDecode(
        File('lib/l10n/app_en.arb').readAsStringSync(),
      ) as Map<String, dynamic>;

  static Map<String, dynamic> loadKm() => jsonDecode(
        File('lib/l10n/app_km.arb').readAsStringSync(),
      ) as Map<String, dynamic>;

  /// Keys where Khmer may legitimately match English (prices, URLs, brands, etc.).
  static final intentionalKmMatchesEn = {
    'heroHeadline1Prefix',
    'masterElfSubscriptionPrice',
    'talismanProductPrice',
    'bookStoreBook1Price',
    'bookStoreBook2Price',
    'bookStoreBook3Price',
    'bookStoreBook4Price',
    'bookStoreBook5Price',
    'bookStoreBlessingBundlePrice',
    'bookStoreBlessingBundleOriginalPrice',
    'bookStorePeriod9Book1Price',
    'bookStorePeriod9Book2Price',
    'bookStorePricePrefix',
    'mediaPostsFacebookLink',
    'mediaPostsTelegramLink',
    'tooltipInstagram',
    'tooltipTikTok',
    'eventsVenueChipmong',
    'eventsVenueLegendCinema',
    for (var i = 1; i <= 24; i++)
      'solarTerm${i.toString().padLeft(2, '0')}',
  };

  /// Feng Shui 朱雀 — not Master Elf brand Phoenix.
  static const fengShuiPhoenixAllowlistKeys = {
    'inspectionPhoenixTitle',
  };

  static List<String> stringKeys(Map<String, dynamic> arb) => arb.keys
      .where((k) => !k.startsWith('@') && k != '@@locale')
      .cast<String>()
      .toList()
    ..sort();

  /// Keys where km value equals en (excluding intentional matches).
  static List<String> untranslatedKmKeys() {
    final en = loadEn();
    final km = loadKm();
    final out = <String>[];
    for (final key in stringKeys(en)) {
      if (intentionalKmMatchesEn.contains(key)) continue;
      if (en[key] == km[key]) out.add(key);
    }
    return out;
  }

  static const bannedKmTypoPatterns = [
    'មិះ',
    'រទេះ',
    'អ៉ីមែល',
    'ត្រវែងហុងស៊ុយ',
    'ថ្នាំបន្ថយ',
    'សមរភព',
    'ការបង្ហាញប្រាជ្ញា',
    'វិធីបន្ថយ',
    'ការត្រួតពិនិត្យហុងស៊ុយ',
    'ស៊េរីប្រាំពរ',
  ];

  /// Brand Phoenix must not appear; 朱雀 inspection label is allowlisted.
  static List<String> keysWithBrandPhoenixMisrender() {
    final km = loadKm();
    final out = <String>[];
    for (final key in stringKeys(km)) {
      if (fengShuiPhoenixAllowlistKeys.contains(key)) continue;
      final value = km[key] as String;
      if (value.contains('ភ្នុកស័រ')) out.add(key);
    }
    return out;
  }

  /// Glossary terms that should appear in cart-related Khmer copy.
  static const cartGlossaryTerm = 'កន្ត្រក';

  static const bannedAuditMisrender = 'ត្រវែងហុងស៊ុយ';
}
