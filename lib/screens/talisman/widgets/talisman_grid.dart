import 'package:flutter/material.dart';

import '../../../config/talisman_store_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/breakpoints.dart';
import 'talisman_product_card.dart';

class TalismanGrid extends StatelessWidget {
  const TalismanGrid({super.key, required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final prefix = l10n.bookStorePricePrefix;
    final items = buildTalismanStoreItems(l10n);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width < Breakpoints.mobile
            ? 1
            : width < Breakpoints.tablet
                ? 2
                : 3;

        final cards = [
          for (final item in items)
            TalismanProductCard(
              l10n: l10n,
              title: item.title,
              subtitle: item.subtitle,
              hook: item.hook,
              price: item.price,
              pricePrefix: prefix,
              compactButton: crossAxisCount >= 2,
              coverAsset: item.coverAsset,
            ),
        ];

        if (crossAxisCount == 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < cards.length; i++) ...[
                if (i > 0) const SizedBox(height: 20),
                cards[i],
              ],
            ],
          );
        }

        final cellWidth =
            (width - (crossAxisCount - 1) * 20) / crossAxisCount;
        if (cellWidth < 240) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < cards.length; i++) ...[
                if (i > 0) const SizedBox(height: 20),
                cards[i],
              ],
            ],
          );
        }

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: crossAxisCount == 2 ? 1 / 1.65 : 1 / 1.55,
          children: cards,
        );
      },
    );
  }
}
