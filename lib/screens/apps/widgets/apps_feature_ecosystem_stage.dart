import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';
import '../../../widgets/chinese_device_showcase.dart';
import '../../home/widgets/field_work_chinese_design.dart';
import 'apps_fullscreen_image.dart';

/// Overview hero showing Master Elf across desktop, tablet, and web.
class AppsFeatureEcosystemStage extends StatelessWidget {
  const AppsFeatureEcosystemStage({
    super.key,
    required this.platformsLabel,
    required this.asset,
    this.heroVideoAsset,
  });

  final String platformsLabel;
  final String asset;
  final String? heroVideoAsset;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _PlatformBand(label: platformsLabel),
        const SizedBox(height: 28),
        RepaintBoundary(
          child: ChineseDeviceEcosystemStage(
            asset: asset,
            heroVideoAsset: heroVideoAsset,
            onTap: () => showAppsFullscreenImage(context, asset),
          ),
        ),
      ],
    );
  }
}

class _PlatformBand extends StatelessWidget {
  const _PlatformBand({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 80) return const SizedBox.shrink();
        // Narrow layouts (mobile): icons — full label truncates in the pill.
        final useIcons = constraints.maxWidth < Breakpoints.mobile;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(child: _GoldRule(towardCenter: true)),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: useIcons ? 8 : 16,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: useIcons ? 12 : 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: FieldWorkChinesePalette.inkWash.withValues(
                    alpha: 0.72,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.45),
                  ),
                ),
                child: useIcons
                    ? Semantics(
                        label: label,
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LucideIcons.monitor,
                              size: 16,
                              color: AppColors.accent,
                            ),
                            SizedBox(width: 10),
                            Icon(
                              LucideIcons.tablet,
                              size: 16,
                              color: AppColors.accent,
                            ),
                            SizedBox(width: 10),
                            Icon(
                              LucideIcons.globe,
                              size: 16,
                              color: AppColors.accent,
                            ),
                          ],
                        ),
                      )
                    : Text(
                        label,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
              ),
            ),
            const Expanded(child: _GoldRule(towardCenter: false)),
          ],
        );
      },
    );
  }
}

class _GoldRule extends StatelessWidget {
  const _GoldRule({required this.towardCenter});

  final bool towardCenter;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.accent.withValues(alpha: 0.7);
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: towardCenter
              ? [Colors.transparent, accent]
              : [accent, Colors.transparent],
        ),
      ),
    );
  }
}
