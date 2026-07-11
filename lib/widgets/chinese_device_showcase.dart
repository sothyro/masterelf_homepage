import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:video_player/video_player.dart';

import '../screens/home/widgets/field_work_chinese_design.dart';
import '../theme/app_theme.dart';
import '../utils/breakpoints.dart';

/// Device frames used to present the Master Elf web application.
enum ChineseDeviceType { desktop, tablet, browser }

/// A screenshot presented inside a Chinese-styled desktop, tablet, or browser.
class ChineseDeviceFrame extends StatefulWidget {
  const ChineseDeviceFrame({
    super.key,
    required this.asset,
    required this.type,
    required this.width,
    this.videoAsset,
    this.onTap,
    this.elevation = 3,
    this.fit = BoxFit.cover,
  });

  final String asset;
  final String? videoAsset;
  final ChineseDeviceType type;
  final double width;
  final VoidCallback? onTap;
  final double elevation;
  final BoxFit fit;

  static const double screenAspectRatio = 5 / 4;

  /// Predictable frame height for scroll strips and positioned stages.
  static double heightForWidth(ChineseDeviceType type, double width) {
    final screenHeight = width / screenAspectRatio;
    return switch (type) {
      ChineseDeviceType.desktop => screenHeight + width * 0.19,
      ChineseDeviceType.tablet => screenHeight + width * 0.07,
      ChineseDeviceType.browser => screenHeight + width * 0.095,
    };
  }

  @override
  State<ChineseDeviceFrame> createState() => _ChineseDeviceFrameState();
}

class _ChineseDeviceFrameState extends State<ChineseDeviceFrame> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final frameHeight = ChineseDeviceFrame.heightForWidth(
      widget.type,
      widget.width,
    );
    final frame = MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.018 : 1,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        alignment: Alignment.bottomCenter,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.width,
          height: frameHeight,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.42),
                blurRadius: 18 + widget.elevation * 2,
                offset: Offset(0, 6 + widget.elevation),
                spreadRadius: -3,
              ),
              if (_hovered)
                BoxShadow(
                  color: AppColors.accentGlow.withValues(alpha: 0.22),
                  blurRadius: 30,
                ),
            ],
          ),
          child: FittedBox(
            fit: BoxFit.contain,
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: widget.width,
              height: frameHeight,
              child: switch (widget.type) {
                ChineseDeviceType.desktop => _DesktopMonitor(
                  asset: widget.asset,
                  videoAsset: widget.videoAsset,
                  width: widget.width,
                  hovered: _hovered,
                  fit: widget.fit,
                ),
                ChineseDeviceType.tablet => _TabletFrame(
                  asset: widget.asset,
                  videoAsset: widget.videoAsset,
                  width: widget.width,
                  hovered: _hovered,
                  fit: widget.fit,
                ),
                ChineseDeviceType.browser => _BrowserFrame(
                  asset: widget.asset,
                  videoAsset: widget.videoAsset,
                  width: widget.width,
                  hovered: _hovered,
                  fit: widget.fit,
                ),
              },
            ),
          ),
        ),
      ),
    );

    if (widget.onTap == null) return frame;
    return Semantics(
      button: true,
      label: 'Open screenshot',
      child: GestureDetector(onTap: widget.onTap, child: frame),
    );
  }
}

class _DesktopMonitor extends StatelessWidget {
  const _DesktopMonitor({
    required this.asset,
    required this.width,
    required this.hovered,
    required this.fit,
    this.videoAsset,
  });

  final String asset;
  final String? videoAsset;
  final double width;
  final bool hovered;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final bezel = width * 0.025;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: width,
          padding: EdgeInsets.fromLTRB(bezel, bezel, bezel, bezel * 1.35),
          decoration: BoxDecoration(
            color: FieldWorkChinesePalette.ink,
            borderRadius: BorderRadius.circular(width * 0.035),
            border: Border.all(
              color: _frameBorder(hovered),
              width: hovered ? 2 : 1.4,
            ),
          ),
          child: _DeviceScreen(
            asset: asset,
            videoAsset: videoAsset,
            fit: fit,
            cornerLength: 14,
          ),
        ),
        Container(
          width: width * 0.16,
          height: width * 0.105,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                FieldWorkChinesePalette.ink,
                AppColors.accent.withValues(alpha: 0.35),
                FieldWorkChinesePalette.ink,
              ],
            ),
            border: Border.symmetric(
              vertical: BorderSide(
                color: AppColors.accent.withValues(alpha: 0.4),
              ),
            ),
          ),
        ),
        Container(
          width: width * 0.38,
          height: width * 0.045,
          decoration: BoxDecoration(
            color: FieldWorkChinesePalette.ink,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(width * 0.025),
              bottom: Radius.circular(width * 0.012),
            ),
            border: Border.all(color: AppColors.accent.withValues(alpha: 0.45)),
          ),
        ),
      ],
    );
  }
}

class _TabletFrame extends StatelessWidget {
  const _TabletFrame({
    required this.asset,
    required this.width,
    required this.hovered,
    required this.fit,
    this.videoAsset,
  });

  final String asset;
  final String? videoAsset;
  final double width;
  final bool hovered;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final bezel = width * 0.032;
    return Container(
      width: width,
      padding: EdgeInsets.fromLTRB(bezel, bezel, bezel, bezel * 1.55),
      decoration: BoxDecoration(
        color: FieldWorkChinesePalette.ink,
        borderRadius: BorderRadius.circular(width * 0.07),
        border: Border.all(
          color: _frameBorder(hovered),
          width: hovered ? 2 : 1.4,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _DeviceScreen(
            asset: asset,
            videoAsset: videoAsset,
            fit: fit,
            cornerLength: 12,
          ),
          SizedBox(height: bezel * 0.55),
          Container(
            width: width * 0.13,
            height: 3,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrowserFrame extends StatelessWidget {
  const _BrowserFrame({
    required this.asset,
    required this.width,
    required this.hovered,
    required this.fit,
    this.videoAsset,
  });

  final String asset;
  final String? videoAsset;
  final double width;
  final bool hovered;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final barHeight = width * 0.07;
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: FieldWorkChinesePalette.ink,
        borderRadius: BorderRadius.circular(width * 0.035),
        border: Border.all(
          color: _frameBorder(hovered),
          width: hovered ? 2 : 1.4,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: barHeight,
            child: Row(
              children: [
                SizedBox(width: width * 0.03),
                for (final opacity in const [0.9, 0.65, 0.4]) ...[
                  Container(
                    width: width * 0.018,
                    height: width * 0.018,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accent.withValues(alpha: opacity),
                    ),
                  ),
                  SizedBox(width: width * 0.012),
                ],
                SizedBox(width: width * 0.02),
                Expanded(
                  child: Container(
                    height: barHeight * 0.52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundDark.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(barHeight),
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.22),
                      ),
                    ),
                    child: Text(
                      'masterelf.app',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.onSurfaceVariantDark,
                        fontSize: (width * 0.024).clamp(8, 12),
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: width * 0.05),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              width * 0.018,
              0,
              width * 0.018,
              width * 0.018,
            ),
            child: _DeviceScreen(
              asset: asset,
              videoAsset: videoAsset,
              fit: fit,
              cornerLength: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceScreen extends StatelessWidget {
  const _DeviceScreen({
    required this.asset,
    required this.fit,
    required this.cornerLength,
    this.videoAsset,
  });

  final String asset;
  final String? videoAsset;
  final BoxFit fit;
  final double cornerLength;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: ChineseDeviceFrame.screenAspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: ChineseCornerBrackets(
          length: cornerLength,
          inset: 5,
          strokeWidth: 1,
          child: videoAsset != null
              ? _DeviceVideoScreen(
                  videoAsset: videoAsset!,
                  posterAsset: asset,
                  fit: fit,
                )
              : Image.asset(
                  asset,
                  fit: fit,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (_, __, ___) => Center(
                    child: Icon(
                      LucideIcons.monitor,
                      size: 42,
                      color: AppColors.onSurfaceVariantDark.withValues(
                        alpha: 0.5,
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class _DeviceVideoScreen extends StatefulWidget {
  const _DeviceVideoScreen({
    required this.videoAsset,
    required this.posterAsset,
    required this.fit,
  });

  final String videoAsset;
  final String posterAsset;
  final BoxFit fit;

  @override
  State<_DeviceVideoScreen> createState() => _DeviceVideoScreenState();
}

class _DeviceVideoScreenState extends State<_DeviceVideoScreen> {
  bool _muted = true;
  VideoPlayerController? _videoController;
  bool _videoReady = false;
  void Function()? _loopListener;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _initVideo();
    });
  }

  Future<void> _initVideo() async {
    try {
      final controller = VideoPlayerController.asset(
        widget.videoAsset,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
      await controller.initialize();
      if (!mounted) {
        controller.dispose();
        return;
      }
      controller.setLooping(true);
      controller.setVolume(_muted ? 0 : 1);
      void listener() {
        final duration = controller.value.duration;
        if (duration.inMilliseconds <= 0) return;
        final pos = controller.value.position.inMilliseconds;
        final end = duration.inMilliseconds - 200;
        if (pos >= end) {
          controller.seekTo(Duration.zero);
          controller.play();
        }
      }

      _loopListener = listener;
      controller.addListener(_loopListener!);
      await controller.play();
      if (!mounted) {
        controller.removeListener(_loopListener!);
        controller.dispose();
        return;
      }
      setState(() {
        _videoController = controller;
        _videoReady = true;
      });
    } catch (_) {
      if (mounted) setState(() => _videoReady = false);
    }
  }

  void _toggleMute() {
    if (_videoController == null) return;
    setState(() {
      _muted = !_muted;
      _videoController!.setVolume(_muted ? 0 : 1);
    });
  }

  @override
  void dispose() {
    final c = _videoController;
    if (c != null && _loopListener != null) {
      c.removeListener(_loopListener!);
    }
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ready =
        _videoReady &&
        _videoController != null &&
        _videoController!.value.isInitialized;

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(
          color: AppColors.surfaceElevatedDark,
          child: ready
              ? FittedBox(
                  fit: widget.fit,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: _videoController!.value.size.width,
                    height: _videoController!.value.size.height,
                    child: VideoPlayer(_videoController!),
                  ),
                )
              : Image.asset(
                  widget.posterAsset,
                  fit: widget.fit,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (_, __, ___) => Center(
                    child: Icon(
                      LucideIcons.monitorPlay,
                      size: 36,
                      color: AppColors.accent.withValues(alpha: 0.6),
                    ),
                  ),
                ),
        ),
        Positioned(
          top: 6,
          right: 6,
          child: Material(
            color: Colors.black.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              onTap: _toggleMute,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  _muted ? LucideIcons.volumeX : LucideIcons.volume2,
                  size: 16,
                  color: AppColors.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Color _frameBorder(bool hovered) => hovered
    ? AppColors.accent.withValues(alpha: 0.88)
    : AppColors.accent.withValues(alpha: 0.46);

/// A single device centered on an ink-wash stage.
class ChineseDeviceShowcase extends StatelessWidget {
  const ChineseDeviceShowcase({
    super.key,
    required this.asset,
    required this.type,
    this.onTap,
    this.deviceWidth,
  });

  final String asset;
  final ChineseDeviceType type;
  final VoidCallback? onTap;
  final double? deviceWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width =
            deviceWidth ?? (constraints.maxWidth * 0.82).clamp(240, 640);
        return Stack(
          alignment: Alignment.center,
          children: [
            const Positioned.fill(child: _DeviceInkGlow()),
            ChineseDeviceFrame(
              asset: asset,
              type: type,
              width: width.toDouble(),
              onTap: onTap,
            ),
          ],
        );
      },
    );
  }
}

/// Cross-platform hero with desktop, browser, and tablet presentations.
class ChineseDeviceEcosystemStage extends StatelessWidget {
  const ChineseDeviceEcosystemStage({
    super.key,
    required this.asset,
    this.heroVideoAsset,
    this.onTap,
  });

  final String asset;
  final String? heroVideoAsset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        if (width < Breakpoints.mobile) {
          return _MobileEcosystem(
            asset: asset,
            heroVideoAsset: heroVideoAsset,
            width: width,
            onTap: onTap,
          );
        }
        if (width < Breakpoints.tablet) {
          return _TabletEcosystem(
            asset: asset,
            heroVideoAsset: heroVideoAsset,
            width: width,
            onTap: onTap,
          );
        }
        return _DesktopEcosystem(
          asset: asset,
          heroVideoAsset: heroVideoAsset,
          width: width,
          onTap: onTap,
        );
      },
    );
  }
}

ChineseDeviceFrame _ecosystemDesktopFrame({
  required String asset,
  required String? heroVideoAsset,
  required double width,
  required VoidCallback? onTap,
  double elevation = 6,
}) {
  return ChineseDeviceFrame(
    asset: asset,
    videoAsset: heroVideoAsset,
    type: ChineseDeviceType.desktop,
    width: width,
    onTap: heroVideoAsset != null ? null : onTap,
    elevation: elevation,
  );
}

class _MobileEcosystem extends StatelessWidget {
  const _MobileEcosystem({
    required this.asset,
    required this.width,
    this.heroVideoAsset,
    this.onTap,
  });

  final String asset;
  final String? heroVideoAsset;
  final double width;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final desktopWidth = (width * 0.9).clamp(260, 420).toDouble();
    final secondaryWidth = (width * 0.72).clamp(220, 340).toDouble();
    return Stack(
      alignment: Alignment.center,
      children: [
        const Positioned.fill(child: _DeviceInkGlow()),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ecosystemDesktopFrame(
              asset: asset,
              heroVideoAsset: heroVideoAsset,
              width: desktopWidth,
              onTap: onTap,
              elevation: 6,
            ),
            const SizedBox(height: 18),
            ChineseDeviceFrame(
              asset: asset,
              type: ChineseDeviceType.tablet,
              width: secondaryWidth,
              onTap: onTap,
            ),
            const SizedBox(height: 18),
            ChineseDeviceFrame(
              asset: asset,
              type: ChineseDeviceType.browser,
              width: secondaryWidth,
              onTap: onTap,
            ),
          ],
        ),
      ],
    );
  }
}

class _TabletEcosystem extends StatelessWidget {
  const _TabletEcosystem({
    required this.asset,
    required this.width,
    this.heroVideoAsset,
    this.onTap,
  });

  final String asset;
  final String? heroVideoAsset;
  final double width;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final desktopWidth = (width * 0.72).clamp(420, 560).toDouble();
    final secondaryWidth = (width * 0.39).clamp(250, 320).toDouble();
    return Stack(
      alignment: Alignment.center,
      children: [
        const Positioned.fill(child: _DeviceInkGlow()),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ecosystemDesktopFrame(
              asset: asset,
              heroVideoAsset: heroVideoAsset,
              width: desktopWidth,
              onTap: onTap,
              elevation: 6,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ChineseDeviceFrame(
                  asset: asset,
                  type: ChineseDeviceType.browser,
                  width: secondaryWidth,
                  onTap: onTap,
                ),
                const SizedBox(width: 20),
                ChineseDeviceFrame(
                  asset: asset,
                  type: ChineseDeviceType.tablet,
                  width: secondaryWidth,
                  onTap: onTap,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _DesktopEcosystem extends StatelessWidget {
  const _DesktopEcosystem({
    required this.asset,
    required this.width,
    this.heroVideoAsset,
    this.onTap,
  });

  final String asset;
  final String? heroVideoAsset;
  final double width;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final desktopWidth = (width * 0.47).clamp(470, 580).toDouble();
    final sideWidth = (width * 0.29).clamp(285, 355).toDouble();
    final stageHeight =
        ChineseDeviceFrame.heightForWidth(
          ChineseDeviceType.desktop,
          desktopWidth,
        ) +
        24;

    return SizedBox(
      height: stageHeight,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          const Positioned.fill(child: _DeviceInkGlow()),
          Positioned(
            left: 0,
            top: stageHeight * 0.18,
            child: Transform.rotate(
              angle: -0.035,
              child: ChineseDeviceFrame(
                asset: asset,
                type: ChineseDeviceType.browser,
                width: sideWidth,
                onTap: onTap,
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: stageHeight * 0.2,
            child: Transform.rotate(
              angle: 0.035,
              child: ChineseDeviceFrame(
                asset: asset,
                type: ChineseDeviceType.tablet,
                width: sideWidth,
                onTap: onTap,
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: _ecosystemDesktopFrame(
              asset: asset,
              heroVideoAsset: heroVideoAsset,
              width: desktopWidth,
              onTap: onTap,
              elevation: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceInkGlow extends StatelessWidget {
  const _DeviceInkGlow();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          radius: 0.82,
          colors: [
            AppColors.accent.withValues(alpha: 0.14),
            AppColors.accent.withValues(alpha: 0.04),
            Colors.transparent,
          ],
          stops: const [0, 0.48, 1],
        ),
      ),
    );
  }
}
