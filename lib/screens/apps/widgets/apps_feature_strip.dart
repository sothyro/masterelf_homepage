import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../config/apps_showcase_content.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';
import '../../../widgets/chinese_device_showcase.dart';
import '../../home/widgets/field_work_chinese_design.dart';
import 'apps_fullscreen_image.dart';

/// Feature group strip: scrollable filmstrip or centered 3-up fit-width row.
class AppsFeatureStrip extends StatefulWidget {
  const AppsFeatureStrip({
    super.key,
    required this.title,
    required this.benefit,
    required this.assets,
    required this.deviceType,
    required this.layout,
  });

  final String title;
  final String benefit;
  final List<String> assets;
  final ChineseDeviceType deviceType;
  final AppsGroupLayout layout;

  @override
  State<AppsFeatureStrip> createState() => _AppsFeatureStripState();
}

class _AppsFeatureStripState extends State<AppsFeatureStrip> {
  final ScrollController _scrollController = ScrollController();
  bool _canScrollLeft = false;
  bool _canScrollRight = false;

  bool get _isScrollable => widget.layout == AppsGroupLayout.strip;

  @override
  void initState() {
    super.initState();
    if (_isScrollable) {
      _scrollController.addListener(_updateScrollButtons);
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _updateScrollButtons(),
      );
    }
  }

  @override
  void dispose() {
    if (_isScrollable) {
      _scrollController.removeListener(_updateScrollButtons);
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _updateScrollButtons() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    final left = pos.pixels > 8;
    final right = pos.pixels < pos.maxScrollExtent - 8;
    if (left != _canScrollLeft || right != _canScrollRight) {
      setState(() {
        _canScrollLeft = left;
        _canScrollRight = right;
      });
    }
  }

  void _scrollBy(double delta) {
    if (!_scrollController.hasClients) return;
    final target = (_scrollController.offset + delta).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < Breakpoints.mobile;
        final isDesktop = Breakpoints.isDesktop(width);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: FieldWorkChinesePalette.ricePaper.withValues(
                  alpha: 0.95,
                ),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.benefit,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariantDark,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 16),
            if (_isScrollable)
              _ScrollableStrip(
                assets: widget.assets,
                deviceType: widget.deviceType,
                width: width,
                isMobile: isMobile,
                isDesktop: isDesktop,
                scrollController: _scrollController,
                canScrollLeft: _canScrollLeft,
                canScrollRight: _canScrollRight,
                onScrollBy: _scrollBy,
              )
            else
              _TriptychRow(
                assets: widget.assets,
                deviceType: widget.deviceType,
                width: width,
                isMobile: isMobile,
              ),
            const SizedBox(height: 8),
            const ChineseMountingBar(),
          ],
        );
      },
    );
  }
}

class _TriptychRow extends StatelessWidget {
  const _TriptychRow({
    required this.assets,
    required this.deviceType,
    required this.width,
    required this.isMobile,
  });

  final List<String> assets;
  final ChineseDeviceType deviceType;
  final double width;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final gap = isMobile ? 10.0 : 16.0;
    final count = assets.length.clamp(1, 3);
    final cardWidth = ((width - gap * (count - 1)) / count).clamp(96.0, 340.0);
    final frameHeight = ChineseDeviceFrame.heightForWidth(
      deviceType,
      cardWidth,
    );

    return SizedBox(
      height: frameHeight + 4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < assets.length; i++)
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: i == 0 ? 0 : gap / 2,
                  right: i == assets.length - 1 ? 0 : gap / 2,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final slotWidth = constraints.maxWidth;
                    final frameWidth = slotWidth.clamp(96.0, 340.0);
                    return Center(
                      child: ChineseDeviceFrame(
                        asset: assets[i],
                        type: deviceType,
                        width: frameWidth,
                        onTap: () =>
                            showAppsFullscreenImage(context, assets[i]),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ScrollableStrip extends StatelessWidget {
  const _ScrollableStrip({
    required this.assets,
    required this.deviceType,
    required this.width,
    required this.isMobile,
    required this.isDesktop,
    required this.scrollController,
    required this.canScrollLeft,
    required this.canScrollRight,
    required this.onScrollBy,
  });

  final List<String> assets;
  final ChineseDeviceType deviceType;
  final double width;
  final bool isMobile;
  final bool isDesktop;
  final ScrollController scrollController;
  final bool canScrollLeft;
  final bool canScrollRight;
  final void Function(double delta) onScrollBy;

  @override
  Widget build(BuildContext context) {
    final cardWidth = isMobile
        ? (width * 0.86).clamp(260.0, 380.0)
        : isDesktop
        ? 360.0
        : 320.0;
    final gap = isMobile ? 12.0 : 16.0;
    final frameHeight = ChineseDeviceFrame.heightForWidth(
      deviceType,
      cardWidth,
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: frameHeight + 8,
          child: ListView.separated(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: isDesktop ? 4 : 0),
            itemCount: assets.length,
            separatorBuilder: (_, __) => SizedBox(width: gap),
            itemBuilder: (context, index) {
              final asset = assets[index];
              return Align(
                alignment: Alignment.topCenter,
                child: ChineseDeviceFrame(
                  asset: asset,
                  type: deviceType,
                  width: cardWidth,
                  onTap: () => showAppsFullscreenImage(context, asset),
                ),
              );
            },
          ),
        ),
        if (isDesktop && canScrollLeft)
          Positioned(
            left: 0,
            child: _ScrollChevron(
              icon: LucideIcons.chevronLeft,
              onPressed: () => onScrollBy(-(cardWidth + gap)),
            ),
          ),
        if (isDesktop && canScrollRight)
          Positioned(
            right: 0,
            child: _ScrollChevron(
              icon: LucideIcons.chevronRight,
              onPressed: () => onScrollBy(cardWidth + gap),
            ),
          ),
      ],
    );
  }
}

class _ScrollChevron extends StatelessWidget {
  const _ScrollChevron({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: FieldWorkChinesePalette.ink.withValues(alpha: 0.75),
      shape: const CircleBorder(side: BorderSide(color: AppColors.accent)),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 22, color: AppColors.accent),
        ),
      ),
    );
  }
}
