import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';
import '../../../utils/mobile_web_performance.dart';
import 'bundle_cover_preview.dart';

/// Single book card with cover, title, price, and Add to Cart.
class BookStoreCard extends StatefulWidget {
  const BookStoreCard({
    super.key,
    required this.l10n,
    required this.asset,
    required this.title,
    required this.subtitle,
    required this.price,
    this.hook,
    this.coverAspectRatio = 3 / 4,
    this.showBestseller = false,
    this.isBundle = false,
    this.bundleCoverAssets,
    this.stretch = false,
  });

  final AppLocalizations l10n;
  final String asset;
  final String title;
  final String subtitle;
  final String price;
  final String? hook;
  final double coverAspectRatio;
  final bool showBestseller;
  final bool isBundle;
  final List<String>? bundleCoverAssets;
  final bool stretch;

  @override
  State<BookStoreCard> createState() => _BookStoreCardState();
}

class _BookStoreCardState extends State<BookStoreCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);
    final prefix = widget.l10n.bookStorePricePrefix;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        height: widget.stretch ? double.infinity : null,
        padding: EdgeInsets.all(isNarrow ? 16 : 20),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevatedDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered
                ? AppColors.accent.withValues(alpha: 0.5)
                : AppColors.borderDark,
            width: _hovered ? 2 : 1,
          ),
          boxShadow: _hovered ? AppShadows.cardHover : AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                if (widget.isBundle && widget.bundleCoverAssets != null)
                  BundleCoverPreview(
                    assets: widget.bundleCoverAssets!,
                    aspectRatio: widget.coverAspectRatio,
                  )
                else
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: widget.coverAspectRatio,
                      child: Image.asset(
                        widget.asset,
                        fit: BoxFit.cover,
                        cacheWidth: MobileWebPerformance.cardImageCacheWidth(
                          context,
                          isNarrow ? MediaQuery.sizeOf(context).width - 64 : 340,
                        ),
                        filterQuality:
                            MobileWebPerformance.imageFilterQuality(context),
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.borderDark,
                          child: Icon(
                            LucideIcons.bookOpen,
                            size: 48,
                            color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (widget.showBestseller)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: _badge(context, widget.l10n.bookStoreBestsellerBadge),
                  ),
                if (widget.isBundle)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: _badge(context, widget.l10n.bookStoreBundleBadge),
                  ),
              ],
            ),
            SizedBox(height: isNarrow ? 14 : 18),
            Text(
              widget.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
            if (widget.hook != null && widget.hook!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                widget.hook!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.accentLight.withValues(alpha: 0.85),
                      height: 1.4,
                      fontStyle: FontStyle.italic,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (widget.stretch) const Spacer(),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final stackPriceCta = constraints.maxWidth < 280 ||
                    Breakpoints.isSmall(MediaQuery.sizeOf(context).width);
                if (stackPriceCta) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '$prefix${widget.price}',
                        style: highlightStyleForLocale(
                          context,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _addToCartButton(context),
                    ],
                  );
                }
                return Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    Text(
                      '$prefix${widget.price}',
                      style: highlightStyleForLocale(
                        context,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accent,
                      ),
                    ),
                    _addToCartButton(context),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _addToCartButton(BuildContext context) {
    return FilledButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.l10n.bookStoreAddedToCart),
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
      icon: Icon(
        widget.isBundle ? LucideIcons.package : LucideIcons.shoppingCart,
        size: 18,
      ),
      label: Text(
        widget.isBundle
            ? widget.l10n.bookStoreAddBundleToCart
            : widget.l10n.bookStoreAddToCart,
      ),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.onAccent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _badge(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.onAccent,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
      ),
    );
  }
}
