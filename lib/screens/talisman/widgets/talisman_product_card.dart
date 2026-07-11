import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';

class TalismanProductCard extends StatefulWidget {
  const TalismanProductCard({
    super.key,
    required this.l10n,
    required this.title,
    required this.subtitle,
    required this.hook,
    required this.price,
    required this.pricePrefix,
    this.compactButton = false,
  });

  final AppLocalizations l10n;
  final String title;
  final String subtitle;
  final String hook;
  final String price;
  final String pricePrefix;
  final bool compactButton;

  @override
  State<TalismanProductCard> createState() => _TalismanProductCardState();
}

class _TalismanProductCardState extends State<TalismanProductCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(isNarrow ? 12 : 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevatedDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered ? AppColors.accent.withValues(alpha: 0.5) : AppColors.borderDark,
            width: _hovered ? 2 : 1,
          ),
          boxShadow: _hovered ? AppShadows.cardHover : AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: isNarrow ? 1.35 : 1.2,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    LucideIcons.sparkles,
                    size: 40,
                    color: AppColors.accent.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
            SizedBox(height: isNarrow ? 10 : 12),
            Text(
              widget.title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              widget.subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariantDark,
                    height: 1.4,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (widget.hook.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                widget.hook,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.accentLight.withValues(alpha: 0.85),
                      height: 1.4,
                      fontStyle: FontStyle.italic,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, constraints) {
                final stackPriceCta = constraints.maxWidth < 220;
                final priceText = Text(
                  '${widget.pricePrefix}${widget.price}',
                  style: highlightStyleForLocale(
                    context,
                    fontSize: isNarrow ? 18 : 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                  ),
                );
                final cartButton = FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(widget.l10n.marketplaceAddedToCart),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppColors.surfaceElevatedDark,
                        action: SnackBarAction(
                          label: widget.l10n.buttonOk,
                          textColor: AppColors.accent,
                          onPressed: () {},
                        ),
                      ),
                    );
                  },
                  icon: const Icon(LucideIcons.shoppingCart, size: 16),
                  label: Text(
                    widget.compactButton
                        ? widget.l10n.buttonAdd
                        : widget.l10n.bookStoreAddToCart,
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.onAccent,
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.compactButton ? 10 : 14,
                      vertical: widget.compactButton ? 8 : 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );

                if (stackPriceCta) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      priceText,
                      const SizedBox(height: 8),
                      cartButton,
                    ],
                  );
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(child: priceText),
                    const SizedBox(width: 8),
                    Flexible(child: cartButton),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
