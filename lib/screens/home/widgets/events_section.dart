import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config/app_content.dart';
import '../../../config/events_data.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';
import '../../../widgets/majestic_orbital_card_frame.dart';
import 'field_work_chinese_design.dart';

class EventsSection extends StatelessWidget {
  const EventsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);
    final headlinePrefix = l10n.sectionExperienceHeadingPrefix;
    final headlineHighlight = l10n.sectionExperienceHeadingHighlight;

    final featuredEvent = getHomepageFeaturedEvent(l10n);
    final otherEvents = getHomepageCompletedEvents(l10n);

    final paddingH = isNarrow ? 16.0 : 24.0;
    final sectionHeadline =
        '$headlinePrefix$headlineHighlight'.trim();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Positioned.fill(child: ChineseInkWashGlow()),
        Padding(
          padding: EdgeInsets.symmetric(vertical: isNarrow ? 48 : 64, horizontal: paddingH),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FieldWorkChineseSectionHeader(
                    title: l10n.eventsSectionTitle,
                    headline: sectionHeadline,
                    subline: l10n.eventsSectionSubline,
                    isMobile: isNarrow,
                    centerEmblem: _EventsSectionSeal(isMobile: isNarrow),
                  ),
                  const SizedBox(height: 48),
              if (isNarrow)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RepaintBoundary(child: _buildComingUpNextBlock(context, l10n, featuredEvent)),
                    const SizedBox(height: 24),
                    _buildExploreAllEventsButton(context, l10n),
                  ],
                )
              else
                _DesktopEventsLayout(
                  left: _buildComingUpNextBlock(
                    context,
                    l10n,
                    featuredEvent,
                    showExploreButton: true,
                  ),
                  right: (height) => _buildAllUpcomingBlock(
                    context,
                    l10n,
                    otherEvents,
                    matchedHeight: height,
                  ),
                ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExploreAllEventsButton(BuildContext context, AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: () => context.push('/events'),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.onAccent,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          l10n.exploreAllEvents,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildComingUpNextBlock(
    BuildContext context,
    AppLocalizations l10n,
    EventItem? featured, {
    bool showExploreButton = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _EventsChineseSubHeader(label: l10n.comingUpNext),
        const SizedBox(height: 16),
        if (featured != null)
          RepaintBoundary(
            child: _FeaturedEventCard(
            title: featured.title,
            date: featured.date,
            location: featured.location,
            description: featured.description,
            imageAsset: featured.imageAsset,
            limitedSeats: featured.limitedSeats,
            onViewEvent: () => context.push('/events'),
            ),
          )
        else
          const SizedBox(height: 200),
        if (showExploreButton) ...[
          const SizedBox(height: 24),
          _buildExploreAllEventsButton(context, l10n),
        ],
      ],
    );
  }

  Widget _buildAllUpcomingBlock(
    BuildContext context,
    AppLocalizations l10n,
    List<EventItem> events, {
    double? matchedHeight,
  }) {
    final header = _EventsChineseSubHeader(label: l10n.allUpcomingEvents);

    final exploreButton = _buildExploreAllEventsButton(context, l10n);

    if (events.isEmpty) {
      return const SizedBox.shrink();
    }

    if (matchedHeight != null) {
      return SizedBox(
        height: matchedHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            header,
            const SizedBox(height: 16),
            Expanded(
              child: Column(
                children: [
                  for (var i = 0; i < events.length; i++) ...[
                    Expanded(
                      child: RepaintBoundary(
                        child: _CompactEventCard(
                          title: events[i].title,
                          date: events[i].date,
                          location: events[i].location,
                          description: events[i].description,
                          imageAsset: events[i].imageAsset,
                          limitedSeats: events[i].limitedSeats,
                          expandToFill: true,
                          onViewEvent: () => context.push('/events'),
                        ),
                      ),
                    ),
                    if (i < events.length - 1) const SizedBox(height: 8),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        header,
        const SizedBox(height: 16),
        RepaintBoundary(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: events.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final e = events[index];
              return RepaintBoundary(
                child: _CompactEventCard(
                  title: e.title,
                  date: e.date,
                  location: e.location,
                  description: e.description,
                  imageAsset: e.imageAsset,
                  limitedSeats: e.limitedSeats,
                  onViewEvent: () => context.push('/events'),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        exploreButton,
      ],
    );
  }
}

/// Desktop two-column layout: sidebar height tracks the featured column.
/// Sidebar sits behind orbital rings.
class _DesktopEventsLayout extends StatefulWidget {
  const _DesktopEventsLayout({
    required this.left,
    required this.right,
  });

  final Widget left;
  final Widget Function(double height) right;

  @override
  State<_DesktopEventsLayout> createState() => _DesktopEventsLayoutState();
}

class _DesktopEventsLayoutState extends State<_DesktopEventsLayout> {
  final GlobalKey _leftKey = GlobalKey();
  double? _leftHeight;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_measureLeftHeight);
  }

  @override
  void didUpdateWidget(covariant _DesktopEventsLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback(_measureLeftHeight);
  }

  void _measureLeftHeight(Duration _) {
    final renderBox = _leftKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;
    final height = renderBox.size.height;
    if (_leftHeight != height && mounted) {
      setState(() => _leftHeight = height);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(flex: 5, child: SizedBox.shrink()),
            const SizedBox(width: 32),
            Expanded(
              flex: 4,
              child: _leftHeight != null
                  ? RepaintBoundary(child: widget.right(_leftHeight!))
                  : const SizedBox.shrink(),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: RepaintBoundary(
                child: KeyedSubtree(
                  key: _leftKey,
                  child: widget.left,
                ),
              ),
            ),
            const SizedBox(width: 32),
            const Expanded(flex: 4, child: SizedBox.shrink()),
          ],
        ),
      ],
    );
  }
}

/// Large featured event card for "Coming Up Next".
class _FeaturedEventCard extends StatefulWidget {
  const _FeaturedEventCard({
    required this.title,
    required this.date,
    required this.location,
    required this.description,
    required this.imageAsset,
    required this.limitedSeats,
    required this.onViewEvent,
  });

  final String title;
  final String date;
  final String location;
  final String description;
  final String imageAsset;
  final bool limitedSeats;
  final VoidCallback onViewEvent;

  @override
  State<_FeaturedEventCard> createState() => _FeaturedEventCardState();
}

class _FeaturedEventCardState extends State<_FeaturedEventCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMobile = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);
    final borderColor = _hovered
        ? AppColors.borderLight.withValues(alpha: 0.6)
        : AppColors.borderDark;
    final shadow = _hovered ? AppShadows.eventCardHover : AppShadows.eventCard;

    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: _hovered ? 1.5 : 1),
        boxShadow: shadow,
      ),
      clipBehavior: Clip.none,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: isMobile ? 10 : 0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final orbitExtent = isMobile
                    ? mobileOrbitalExtentScale(constraints.maxWidth)
                    : 1.0;
                return MajesticOrbitalCardFrame(
                  aspectRatio: 16 / 9,
                  imageAsset: widget.imageAsset,
                  cardBodyScale:
                      isMobile ? kMobileOrbitalCardBodyScale : 1.0,
                  orbitExtentScale: orbitExtent,
                  topRight: widget.limitedSeats
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.accent,
                                AppColors.accentLight.withValues(alpha: 0.95),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentGlow.withValues(alpha: 0.45),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            l10n.limitedSeats,
                            style: const TextStyle(
                              color: AppColors.onAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                        )
                      : null,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.onPrimary,
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: AppColors.onPrimary.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.date,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onPrimary.withValues(alpha: 0.85),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: AppColors.onPrimary.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.location,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onPrimary.withValues(alpha: 0.85),
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.9),
                    height: 1.4,
                    fontSize: 14,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onViewEvent,
          borderRadius: BorderRadius.circular(16),
          child: card,
        ),
      ),
    );
  }
}

/// Compact event card for "All Upcoming Events" list.
class _CompactEventCard extends StatefulWidget {
  const _CompactEventCard({
    required this.title,
    required this.date,
    required this.location,
    required this.description,
    required this.imageAsset,
    required this.limitedSeats,
    required this.onViewEvent,
    this.expandToFill = false,
  });

  final String title;
  final String date;
  final String location;
  final String description;
  final String imageAsset;
  final bool limitedSeats;
  final VoidCallback onViewEvent;
  final bool expandToFill;

  @override
  State<_CompactEventCard> createState() => _CompactEventCardState();
}

class _CompactEventCardState extends State<_CompactEventCard> {
  bool _hovered = false;

  static const double _desktopImageWidth = 125;
  static const double _desktopImageHeight = _desktopImageWidth * 5 / 4;

  bool get _squareSourceCrop => widget.imageAsset == AppContent.assetEventMain;

  Widget _imageError(BuildContext _, Object __, StackTrace? ___) {
    return Container(color: AppColors.primary.withValues(alpha: 0.2));
  }

  /// Square (1:1) posters are center-cropped into the shared 4:5 portrait frame.
  Widget _buildFeatureImage() {
    if (_squareSourceCrop) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          final width = constraints.maxWidth;
          final side = height.isFinite && height > 0 ? height : width * 5 / 4;
          return ClipRect(
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: side,
                height: side,
                child: Image.asset(
                  widget.imageAsset,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  cacheWidth: 600,
                  errorBuilder: _imageError,
                ),
              ),
            ),
          );
        },
      );
    }

    return Image.asset(
      widget.imageAsset,
      fit: BoxFit.cover,
      alignment: Alignment.center,
      cacheWidth: 480,
      cacheHeight: 600,
      errorBuilder: _imageError,
    );
  }

  Widget _buildFeatureImageFrame({required bool isMobile}) {
    final image = RepaintBoundary(child: _buildFeatureImage());

    if (isMobile) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
        child: AspectRatio(
          aspectRatio: 4 / 5,
          child: Stack(
            fit: StackFit.expand,
            children: [
              image,
              if (widget.limitedSeats)
                Positioned(top: 8, right: 8, child: _buildLimitedSeatsChip(AppLocalizations.of(context)!)),
            ],
          ),
        ),
      );
    }

    if (widget.expandToFill) {
      return ClipRRect(
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight;
            final width = height.isFinite && height > 0
                ? (height * 4 / 5).clamp(0.0, _desktopImageWidth)
                : _desktopImageWidth;
            final resolvedHeight =
                height.isFinite && height > 0 ? height : _desktopImageHeight;
            return SizedBox(
              width: width,
              height: resolvedHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  image,
                  if (widget.limitedSeats)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: _buildLimitedSeatsChip(AppLocalizations.of(context)!),
                    ),
                ],
              ),
            );
          },
        ),
      );
    }

    return ClipRRect(
      borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
      child: SizedBox(
        width: _desktopImageWidth,
        height: _desktopImageHeight,
        child: Stack(
          fit: StackFit.expand,
          children: [
            image,
            if (widget.limitedSeats)
              Positioned(
                top: 6,
                right: 6,
                child: _buildLimitedSeatsChip(AppLocalizations.of(context)!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLimitedSeatsChip(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGlow.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        l10n.limitedSeats,
        style: const TextStyle(
          color: AppColors.onAccent,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);
    final borderColor = _hovered
        ? AppColors.borderLight.withValues(alpha: 0.5)
        : AppColors.borderDark;
    final shadow = _hovered ? AppShadows.eventCardHover : AppShadows.eventCard;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onViewEvent,
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            width: widget.expandToFill && !isMobile ? double.infinity : null,
            height: widget.expandToFill && !isMobile ? double.infinity : null,
            decoration: BoxDecoration(
              color: AppColors.surfaceElevatedDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: _hovered ? 1.5 : 1),
              boxShadow: shadow,
            ),
            clipBehavior: Clip.antiAlias,
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildFeatureImageFrame(isMobile: true),
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.onPrimary,
                                height: 1.25,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.calendar_today_outlined, size: 12,
                                    color: AppColors.onPrimary.withValues(alpha: 0.7)),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    widget.date,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.onPrimary.withValues(alpha: 0.85),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.location_on_outlined, size: 12,
                                    color: AppColors.onPrimary.withValues(alpha: 0.7)),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    widget.location,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.onPrimary.withValues(alpha: 0.85),
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.description,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.onPrimary.withValues(alpha: 0.9),
                                height: 1.3,
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: widget.expandToFill
                        ? CrossAxisAlignment.stretch
                        : CrossAxisAlignment.start,
                    children: [
                      _buildFeatureImageFrame(isMobile: false),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(widget.expandToFill ? 12 : 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: widget.expandToFill
                                ? MainAxisAlignment.center
                                : MainAxisAlignment.start,
                            children: [
                              Text(
                                    widget.title,
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.onPrimary,
                                      height: 1.25,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.calendar_today_outlined, size: 12,
                                          color: AppColors.onPrimary.withValues(alpha: 0.7)),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          widget.date,
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: AppColors.onPrimary.withValues(alpha: 0.85),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.location_on_outlined, size: 12,
                                          color: AppColors.onPrimary.withValues(alpha: 0.7)),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          widget.location,
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: AppColors.onPrimary.withValues(alpha: 0.85),
                                            fontSize: 12,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    widget.description,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.onPrimary.withValues(alpha: 0.9),
                                      height: 1.3,
                                      fontSize: 12,
                                    ),
                                    maxLines: widget.expandToFill ? 1 : 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// Events section seal (会) for the ornamental header band.
class _EventsSectionSeal extends StatelessWidget {
  const _EventsSectionSeal({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final size = isMobile ? 36.0 : 44.0;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.accentLight.withValues(alpha: 0.65), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGlow.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        '会',
        style: GoogleFonts.notoSerifSc(
          fontSize: size * 0.52,
          fontWeight: FontWeight.w700,
          color: AppColors.onAccent,
          height: 1,
        ),
      ),
    );
  }
}

/// Column sub-header with gold mounting bar (Coming Up Next / All Upcoming).
class _EventsChineseSubHeader extends StatelessWidget {
  const _EventsChineseSubHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent,
                border: Border.all(color: AppColors.accentLight.withValues(alpha: 0.75)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentGlow.withValues(alpha: 0.35),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: FieldWorkChinesePalette.ricePaper.withValues(alpha: 0.95),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.35,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const ChineseMountingBar(),
      ],
    );
  }
}
