import 'dart:async';

import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../config/apps_showcase_content.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';
import '../../../utils/carousel_row_preloader.dart';
import '../../../utils/mobile_web_performance.dart';
import '../../../widgets/chinese_device_showcase.dart';
import '../../home/widgets/field_work_chinese_design.dart';
import 'apps_fullscreen_image.dart';

/// Unified Feature Atlas stage: one device cluster cycling all modules.
class AppsFeatureCarouselStage extends StatefulWidget {
  const AppsFeatureCarouselStage({super.key, required this.modules});

  final List<AppsFeatureGroup> modules;

  @override
  State<AppsFeatureCarouselStage> createState() => _AppsFeatureCarouselStageState();
}

class _AppsFeatureCarouselStageState extends State<AppsFeatureCarouselStage> {
  static const _ownerKey = 'apps-feature-carousel';
  static const _tickDuration = Duration(milliseconds: 2500);
  static const _tickDurationMobileWeb = Duration(milliseconds: 5000);
  static const _transitionDuration = Duration(milliseconds: 400);

  int _featureIndex = 0;
  int _assetIndex = 0;
  Timer? _timer;
  bool _inViewport = false;
  bool _hovered = false;

  AppsFeatureGroup get _current => widget.modules[_featureIndex];

  @override
  void didUpdateWidget(covariant AppsFeatureCarouselStage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.modules != widget.modules) {
      _featureIndex = 0;
      _assetIndex = 0;
    }
  }

  @override
  void dispose() {
    _stopTimer();
    CarouselRowPreloader.cancel(_ownerKey);
    VisibilityDetectorController.instance.forget(
      const ValueKey<String>('apps-feature-carousel'),
    );
    super.dispose();
  }

  void _syncTimer() {
    if (!mounted) return;
    if (_shouldRunTimer) {
      _startTimer();
    } else {
      _stopTimer();
    }
  }

  bool get _animationsEnabled {
    if (!mounted) return false;
    if (MobileWebPerformance.prefersReducedMotion(context)) return false;
    final mq = MediaQuery.maybeOf(context);
    return mq == null || !mq.disableAnimations;
  }

  bool get _shouldRunTimer =>
      _animationsEnabled && _inViewport && !_hovered && widget.modules.length > 1;

  Duration get _tickInterval {
    if (!mounted) return _tickDuration;
    return MobileWebPerformance.isMobileWeb(context)
        ? _tickDurationMobileWeb
        : _tickDuration;
  }

  void _startTimer() {
    _stopTimer();
    if (!_shouldRunTimer) return;
    _timer = Timer.periodic(_tickInterval, (_) => _onTick());
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted) return;
    final visible = info.visibleFraction > 0.15;
    if (visible == _inViewport) return;
    _inViewport = visible;
    if (visible) {
      _preloadFeatureAssets(_featureIndex);
    } else {
      CarouselRowPreloader.cancel(_ownerKey);
    }
    _syncTimer();
  }

  void _onTick() {
    if (!mounted || !_inViewport) return;
    final module = _current;
    final nextAssetIndex = _assetIndex + 1;
    if (nextAssetIndex >= module.assets.length) {
      final nextFeature = (_featureIndex + 1) % widget.modules.length;
      _preloadFeatureAssets(nextFeature);
      setState(() {
        _assetIndex = 0;
        _featureIndex = nextFeature;
      });
    } else {
      final nextPath = module.assets[nextAssetIndex % module.assets.length];
      _preloadAssetPaths([nextPath]);
      setState(() => _assetIndex = nextAssetIndex);
    }
  }

  void _selectFeature(int index) {
    if (index == _featureIndex) return;
    _preloadFeatureAssets(index);
    setState(() {
      _featureIndex = index;
      _assetIndex = 0;
    });
    _syncTimer();
  }

  void _preloadFeatureAssets(int featureIndex) {
    if (!mounted) return;
    final assets = widget.modules[featureIndex].assets;
    if (assets.isEmpty) return;
    final paths = <String>[
      assets[_assetIndex % assets.length],
      if (assets.length > 1) assets[(_assetIndex + 1) % assets.length],
    ];
    _preloadAssetPaths(paths);
  }

  void _preloadAssetPaths(List<String> paths) {
    if (!mounted || paths.isEmpty) return;
    final width = MediaQuery.sizeOf(context).width;
    unawaited(
      CarouselRowPreloader.preloadRow(
        ownerKey: _ownerKey,
        paths: paths,
        cardsPerPage: paths.length,
        mobileSequential:
            MobileWebPerformance.isMobileWeb(context) || Breakpoints.isMobile(width),
      ),
    );
  }

  (String, String, String) _staggeredAssets(AppsFeatureGroup module) {
    final n = module.assets.length;
    if (n == 0) return ('', '', '');
    final current = module.assets[_assetIndex % n];
    if (mounted && MobileWebPerformance.isMobileWeb(context)) {
      return (current, current, current);
    }
    return (
      current,
      module.assets[(_assetIndex + 1) % n],
      module.assets[(_assetIndex + 2) % n],
    );
  }

  void _openFullscreen(String asset) {
    if (asset.isEmpty) return;
    showAppsFullscreenImage(context, asset);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.modules.isEmpty) return const SizedBox.shrink();

    final module = _current;
    final (desktop, tablet, browser) = _staggeredAssets(module);
    final isMobile = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);

    return VisibilityDetector(
      key: const ValueKey<String>('apps-feature-carousel'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: _transitionDuration,
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Column(
              key: ValueKey<String>(module.id),
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  module.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: FieldWorkChinesePalette.ricePaper.withValues(
                      alpha: 0.95,
                    ),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  module.benefit,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariantDark,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          MouseRegion(
            onEnter: (_) {
              setState(() => _hovered = true);
              _syncTimer();
            },
            onExit: (_) {
              setState(() => _hovered = false);
              _syncTimer();
            },
            child: RepaintBoundary(
              child: ChineseDeviceClusterStage(
                desktopAsset: desktop,
                tabletAsset: tablet,
                browserAsset: browser,
                transitionDuration: _transitionDuration,
                onTap: () => _openFullscreen(desktop),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: isMobile ? 8 : 10,
            runSpacing: 10,
            children: [
              for (var i = 0; i < widget.modules.length; i++)
                _FeaturePill(
                  key: ValueKey<String>(widget.modules[i].id),
                  label: widget.modules[i].title,
                  selected: i == _featureIndex,
                  compact: isMobile,
                  onTap: () => _selectFeature(i),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < widget.modules.length; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _featureIndex ? 18 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: i == _featureIndex
                        ? AppColors.accent
                        : AppColors.accent.withValues(alpha: 0.28),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const ChineseMountingBar(),
        ],
      ),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  const _FeaturePill({
    super.key,
    required this.label,
    required this.selected,
    required this.compact,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.accent.withValues(alpha: 0.18)
          : FieldWorkChinesePalette.inkWash.withValues(alpha: 0.55),
      shape: StadiumBorder(
        side: BorderSide(
          color: selected
              ? AppColors.accent
              : AppColors.accent.withValues(alpha: 0.45),
          width: selected ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 10 : 14,
            vertical: compact ? 8 : 10,
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: selected ? AppColors.accent : AppColors.onPrimary,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              letterSpacing: 0.2,
              fontSize: compact ? 11 : 12,
            ),
          ),
        ),
      ),
    );
  }
}
