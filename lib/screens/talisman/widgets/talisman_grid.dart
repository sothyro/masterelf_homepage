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
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);
    final crossAxisCount = isMobile
        ? 1
        : Breakpoints.isTabletOnly(width)
            ? 2
            : 3;
    final childAspectRatio = crossAxisCount == 1 ? 1 / 1.15 : 1 / 1.55;
    final prefix = l10n.bookStorePricePrefix;
    final items = buildTalismanStoreItems(l10n);

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      childAspectRatio: childAspectRatio,
      children: [
        for (final item in items)
          TalismanProductCard(
            l10n: l10n,
            title: item.title,
            subtitle: item.subtitle,
            hook: item.hook,
            price: item.price,
            pricePrefix: prefix,
            compactButton: crossAxisCount == 2,
          ),
      ],
    );
  }
}
