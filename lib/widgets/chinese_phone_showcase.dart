import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../screens/home/widgets/field_work_chinese_design.dart';
import '../theme/app_theme.dart';
import '../utils/breakpoints.dart';
import '../utils/mobile_web_performance.dart';

/// A single screenshot inside a gold-trimmed Chinese phone bezel.
///
/// Reusable anywhere you need a portrait app mockup with hover glow
/// and optional tap handling.
class ChinesePhoneFrame extends StatefulWidget {
  const ChinesePhoneFrame({
    super.key,
    required this.asset,
    required this.width,
    required this.height,
    this.rotation = 0,
    this.elevation = 3,
    this.onTap,
    this.fit = BoxFit.cover,
  });

  final String asset;
  final double width;
  final double height;
  final double rotation;
  final double elevation;
  final VoidCallback? onTap;
  final BoxFit fit;

  /// Default portrait aspect ratio used by [ChinesePhoneShowcase].
  static const aspectRatio = 1 / 1.95;

  @override
  State<ChinesePhoneFrame> createState() => _ChinesePhoneFrameState();
}

class _ChinesePhoneFrameState extends State<ChinesePhoneFrame> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bezelRadius = widget.width * 0.12;
    final innerRadius = bezelRadius * 0.75;

    final phone = MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        width: widget.width,
        height: widget.height,
        transform: Matrix4.identity()
          ..rotateZ(widget.rotation)
          // ignore: deprecated_member_use
          ..scale(_hovered ? 1.03 : 1.0),
        transformAlignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(bezelRadius),
          color: FieldWorkChinesePalette.ink,
          border: Border.all(
            color: _hovered
                ? AppColors.accent.withValues(alpha: 0.85)
                : AppColors.accent.withValues(alpha: 0.45),
            width: _hovered ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.45),
              blurRadius: 20 + widget.elevation * 2,
              offset: Offset(0, 6 + widget.elevation),
              spreadRadius: -2,
            ),
            if (_hovered)
              BoxShadow(
                color: AppColors.accentGlow.withValues(alpha: 0.22),
                blurRadius: 28,
                spreadRadius: 0,
              ),
          ],
        ),
        padding: EdgeInsets.all(widget.width * 0.04),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(innerRadius),
          child: ChineseCornerBrackets(
            length: 10,
            inset: 4,
            strokeWidth: 1,
            child: Image.asset(
              widget.asset,
              fit: widget.fit,
              width: double.infinity,
              height: double.infinity,
              cacheWidth: MobileWebPerformance.mockupPixelCacheWidth(
                context,
                widget.width,
              ),
              filterQuality: MobileWebPerformance.mockupFilterQuality(context),
              errorBuilder: (_, __, ___) => Center(
                child: Icon(
                  LucideIcons.smartphone,
                  size: widget.width * 0.3,
                  color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.onTap != null) {
      return GestureDetector(onTap: widget.onTap, child: phone);
    }
    return phone;
  }
}

/// One or two phone screenshots on an ink-wash glow stage.
///
/// - **Mobile:** side-by-side with slight rotation
/// - **Desktop:** fanned overlap with depth
///
/// Example:
/// ```dart
/// ChinesePhoneShowcase(
///   assets: [AppContent.assetPeriod9_1, AppContent.assetPeriod9_2],
///   onScreenshotTap: (asset) => showAppsFullscreenImage(context, asset),
/// )
/// ```
class ChinesePhoneShowcase extends StatelessWidget {
  const ChinesePhoneShowcase({
    super.key,
    required this.assets,
    this.onScreenshotTap,
    this.phoneWidth,
  });

  final List<String> assets;
  final void Function(String asset)? onScreenshotTap;

  /// Override auto-sized phone width; height follows [ChinesePhoneFrame.aspectRatio].
  final double? phoneWidth;

  @override
  Widget build(BuildContext context) {
    if (assets.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final isMobile = maxWidth < Breakpoints.mobile;
        final isTablet = Breakpoints.isTabletOnly(maxWidth);

        final resolvedPhoneWidth =
            phoneWidth ??
            (isMobile
                ? ((maxWidth - 12) / 2).clamp(0.0, 180.0)
                : isTablet
                ? 200.0
                : 240.0);
        final phoneHeight = resolvedPhoneWidth / ChinesePhoneFrame.aspectRatio;
        final stageHeight = phoneHeight + (isMobile ? 24 : 48);

        return SizedBox(
          height: stageHeight,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              const Positioned.fill(child: _InkWashGlow()),
              if (assets.length == 1)
                ChinesePhoneFrame(
                  asset: assets.first,
                  width: resolvedPhoneWidth,
                  height: phoneHeight,
                  onTap: onScreenshotTap != null
                      ? () => onScreenshotTap!(assets.first)
                      : null,
                )
              else if (isMobile)
                _MobilePair(
                  assets: assets.take(2).toList(),
                  phoneWidth: resolvedPhoneWidth,
                  phoneHeight: phoneHeight,
                  onScreenshotTap: onScreenshotTap,
                )
              else
                _DesktopFan(
                  assets: assets.take(2).toList(),
                  phoneWidth: resolvedPhoneWidth,
                  phoneHeight: phoneHeight,
                  onScreenshotTap: onScreenshotTap,
                ),
            ],
          ),
        );
      },
    );
  }
}

class _InkWashGlow extends StatelessWidget {
  const _InkWashGlow();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.85,
          colors: [
            AppColors.accent.withValues(alpha: 0.14),
            AppColors.accent.withValues(alpha: 0.04),
            Colors.transparent,
          ],
          stops: const [0.0, 0.45, 1.0],
        ),
      ),
    );
  }
}

class _MobilePair extends StatelessWidget {
  const _MobilePair({
    required this.assets,
    required this.phoneWidth,
    required this.phoneHeight,
    this.onScreenshotTap,
  });

  final List<String> assets;
  final double phoneWidth;
  final double phoneHeight;
  final void Function(String asset)? onScreenshotTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ChinesePhoneFrame(
          asset: assets[0],
          width: phoneWidth,
          height: phoneHeight,
          rotation: -0.04,
          elevation: 2,
          onTap: onScreenshotTap != null
              ? () => onScreenshotTap!(assets[0])
              : null,
        ),
        const SizedBox(width: 12),
        ChinesePhoneFrame(
          asset: assets[1],
          width: phoneWidth,
          height: phoneHeight,
          rotation: 0.04,
          elevation: 4,
          onTap: onScreenshotTap != null
              ? () => onScreenshotTap!(assets[1])
              : null,
        ),
      ],
    );
  }
}

class _DesktopFan extends StatelessWidget {
  const _DesktopFan({
    required this.assets,
    required this.phoneWidth,
    required this.phoneHeight,
    this.onScreenshotTap,
  });

  final List<String> assets;
  final double phoneWidth;
  final double phoneHeight;
  final void Function(String asset)? onScreenshotTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: phoneWidth * 1.85,
      height: phoneHeight,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: Transform.rotate(
              angle: -0.08,
              child: ChinesePhoneFrame(
                asset: assets[0],
                width: phoneWidth,
                height: phoneHeight,
                elevation: 2,
                onTap: onScreenshotTap != null
                    ? () => onScreenshotTap!(assets[0])
                    : null,
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 8,
            child: Transform.rotate(
              angle: 0.08,
              child: ChinesePhoneFrame(
                asset: assets[1],
                width: phoneWidth,
                height: phoneHeight,
                elevation: 6,
                onTap: onScreenshotTap != null
                    ? () => onScreenshotTap!(assets[1])
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Ornamental gold rule with a centered label — opens a scroll-stage section.
class ChineseScrollStageBand extends StatelessWidget {
  const ChineseScrollStageBand({
    super.key,
    required this.label,
    this.icon = LucideIcons.smartphone,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                AppColors.accent.withValues(alpha: 0.5),
                AppColors.accent,
                AppColors.accent.withValues(alpha: 0.5),
                Colors.transparent,
              ],
              stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 14,
              color: AppColors.accent.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.6,
                  color: AppColors.accent.withValues(alpha: 0.75),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              icon,
              size: 14,
              color: AppColors.accent.withValues(alpha: 0.7),
            ),
          ],
        ),
      ],
    );
  }
}
