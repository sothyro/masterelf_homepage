import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';
import '../../home/widgets/field_work_chinese_design.dart';

/// Gold-outline seal pill category strip for the Apps page.
class AppsCategoryStrip extends StatelessWidget {
  const AppsCategoryStrip({super.key, required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);
    final items = [
      (l10n.marketplaceCategoryDigital, '/apps#master-elf'),
      (l10n.marketplaceCategoryBooks, '/books'),
      (l10n.marketplaceCategoryTalismans, '/talisman'),
    ];
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 10,
      children: items.map((e) {
        return Material(
          color: FieldWorkChinesePalette.inkWash.withValues(alpha: 0.55),
          shape: StadiumBorder(
            side: BorderSide(color: AppColors.accent.withValues(alpha: 0.55)),
          ),
          child: InkWell(
            onTap: () => context.go(e.$2),
            customBorder: const StadiumBorder(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isNarrow ? 16 : 20,
                vertical: isNarrow ? 10 : 12,
              ),
              child: Text(
                e.$1,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                    ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
