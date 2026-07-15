import '../l10n/app_localizations.dart';

/// Single talisman product in the store grid.
class TalismanStoreItem {
  const TalismanStoreItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.hook,
    required this.price,
    this.coverAsset,
  });

  final String id;
  final String title;
  final String subtitle;
  final String hook;
  final String price;
  final String? coverAsset;
}

/// All nine talisman charms for the store grid.
List<TalismanStoreItem> buildTalismanStoreItems(AppLocalizations l10n) {
  return [
    TalismanStoreItem(
      id: 'talisman-1',
      title: l10n.talismanProduct1Title,
      subtitle: l10n.talismanProduct1Subtitle,
      hook: l10n.talismanProduct1Hook,
      price: l10n.talismanProductPrice,
    ),
    TalismanStoreItem(
      id: 'talisman-2',
      title: l10n.talismanProduct2Title,
      subtitle: l10n.talismanProduct2Subtitle,
      hook: l10n.talismanProduct2Hook,
      price: l10n.talismanProductPrice,
    ),
    TalismanStoreItem(
      id: 'talisman-3',
      title: l10n.talismanProduct3Title,
      subtitle: l10n.talismanProduct3Subtitle,
      hook: l10n.talismanProduct3Hook,
      price: l10n.talismanProductPrice,
    ),
    TalismanStoreItem(
      id: 'talisman-4',
      title: l10n.talismanProduct4Title,
      subtitle: l10n.talismanProduct4Subtitle,
      hook: l10n.talismanProduct4Hook,
      price: l10n.talismanProductPrice,
    ),
    TalismanStoreItem(
      id: 'talisman-5',
      title: l10n.talismanProduct5Title,
      subtitle: l10n.talismanProduct5Subtitle,
      hook: l10n.talismanProduct5Hook,
      price: l10n.talismanProductPrice,
    ),
    TalismanStoreItem(
      id: 'talisman-6',
      title: l10n.talismanProduct6Title,
      subtitle: l10n.talismanProduct6Subtitle,
      hook: l10n.talismanProduct6Hook,
      price: l10n.talismanProductPrice,
    ),
    TalismanStoreItem(
      id: 'talisman-7',
      title: l10n.talismanProduct7Title,
      subtitle: l10n.talismanProduct7Subtitle,
      hook: l10n.talismanProduct7Hook,
      price: l10n.talismanProductPrice,
    ),
    TalismanStoreItem(
      id: 'talisman-8',
      title: l10n.talismanProduct8Title,
      subtitle: l10n.talismanProduct8Subtitle,
      hook: l10n.talismanProduct8Hook,
      price: l10n.talismanProductPrice,
    ),
    TalismanStoreItem(
      id: 'talisman-9',
      title: l10n.talismanProduct9Title,
      subtitle: l10n.talismanProduct9Subtitle,
      hook: l10n.talismanProduct9Hook,
      price: l10n.talismanProductPrice,
    ),
  ];
}
