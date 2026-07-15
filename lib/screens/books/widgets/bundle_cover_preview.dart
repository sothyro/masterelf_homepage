import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../theme/app_theme.dart';
import '../../../utils/mobile_web_performance.dart';

/// Composite preview of all five blessing covers for the bundle card.
class BundleCoverPreview extends StatelessWidget {
  const BundleCoverPreview({
    super.key,
    required this.assets,
    required this.aspectRatio,
  });

  final List<String> assets;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.accent.withValues(alpha: 0.18),
                AppColors.surfaceElevatedDark,
                AppColors.backgroundDark,
              ],
            ),
            border: Border.all(color: AppColors.accent.withValues(alpha: 0.35)),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: _miniCover(context, assets[0])),
                    const SizedBox(width: 6),
                    Expanded(child: _miniCover(context, assets[1])),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: _miniCover(context, assets[2])),
                    const SizedBox(width: 6),
                    Expanded(child: _miniCover(context, assets[3])),
                    const SizedBox(width: 6),
                    Expanded(child: _miniCover(context, assets[4])),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _miniCover(BuildContext context, String asset) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.asset(
        asset,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        cacheWidth: MobileWebPerformance.cardImageCacheWidth(context, 80),
        filterQuality: MobileWebPerformance.imageFilterQuality(context),
        errorBuilder: (_, __, ___) => Container(
          color: AppColors.borderDark,
          child: Icon(
            LucideIcons.bookOpen,
            size: 20,
            color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
