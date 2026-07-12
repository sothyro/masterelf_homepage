import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';
import '../../../widgets/app_shell_scroll_scope.dart';

/// Category pills: Digital apps, Books, Talismans.
class MarketplaceCategoryStrip extends StatelessWidget {
  const MarketplaceCategoryStrip({super.key, required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);
    final items = [
      (l10n.marketplaceCategoryDigital, '/apps'),
      (l10n.marketplaceCategoryBooks, '/books'),
      (l10n.marketplaceCategoryTalismans, '/talisman'),
    ];
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 10,
      children: items.map((e) {
        return ActionChip(
          label: Text(e.$1),
          onPressed: () => goShellRoute(context, e.$2),
          backgroundColor: AppColors.surfaceElevatedDark,
          side: BorderSide(color: AppColors.borderLight.withValues(alpha: 0.4)),
          labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.onPrimary,
              ),
          padding: EdgeInsets.symmetric(
            horizontal: isNarrow ? 14 : 18,
            vertical: isNarrow ? 8 : 10,
          ),
        );
      }).toList(),
    );
  }
}
