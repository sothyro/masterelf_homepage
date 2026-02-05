import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_content.dart';
import '../../../config/events_data.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';

class EventsSection extends StatelessWidget {
  const EventsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      color: AppColors.surfaceDark,
      padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                l10n.sectionExperienceHeading,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Text(
                l10n.comingUpNext,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              RepaintBoundary(
                child: SizedBox(
                  height: 340,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: kAllEvents.length,
                    cacheExtent: 400,
                    separatorBuilder: (_, __) => const SizedBox(width: 24),
                    itemBuilder: (context, index) {
                    final e = kAllEvents[index];
                    return _EventCard(
                      title: e.title,
                      date: e.date,
                      location: e.location,
                      description: e.description,
                      limitedSeats: e.limitedSeats,
                      onViewEvent: () => context.push('/events'),
                    );
                  },
                ),
              ),
            ),
              const SizedBox(height: 28),
              TextButton(
                onPressed: () => context.push('/events'),
                child: Text(
                  l10n.exploreAllEvents,
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventCard extends StatefulWidget {
  const _EventCard({
    required this.title,
    required this.date,
    required this.location,
    required this.description,
    required this.limitedSeats,
    required this.onViewEvent,
  });

  final String title;
  final String date;
  final String location;
  final String description;
  final bool limitedSeats;
  final VoidCallback onViewEvent;

  @override
  State<_EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<_EventCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final shadow = _isHovered ? AppShadows.cardHover : AppShadows.card;
    final borderColor = _isHovered ? AppColors.borderLight.withValues(alpha: 0.5) : AppColors.borderDark;

    return SizedBox(
      width: 340,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onViewEvent,
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevatedDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: 1),
                boxShadow: shadow,
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        AppContent.assetEventCard,
                        fit: BoxFit.cover,
                        cacheWidth: 680,
                        cacheHeight: 280,
                        errorBuilder: (_, __, ___) => const SizedBox.expand(),
                      ),
                      if (widget.limitedSeats)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              l10n.limitedSeats,
                              style: const TextStyle(color: AppColors.onAccent, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.onPrimary,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.onPrimary.withValues(alpha: 0.6)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              widget.date,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.onPrimary.withValues(alpha: 0.8),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on_outlined, size: 14, color: AppColors.onPrimary.withValues(alpha: 0.6)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              widget.location,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.onPrimary.withValues(alpha: 0.8),
                                fontSize: 13,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onPrimary.withValues(alpha: 0.9),
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.viewEvent,
                            style: const TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const Icon(Icons.arrow_forward, size: 18, color: AppColors.accent),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}
