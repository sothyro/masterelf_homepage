import 'package:flutter/material.dart';

import '../../config/app_content.dart';
import '../../config/events_data.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/breakpoints.dart';
import '../home/widgets/field_work_chinese_design.dart';
import '../store/widgets/store_page_hero.dart';
import 'widgets/event_registration_dialog.dart';
import 'widgets/events_completed_online_card.dart';
import 'widgets/events_completed_spotlight.dart';
import 'widgets/events_upcoming_spotlight.dart';
import 'widgets/events_why_attend_band.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  void _openRegistration(BuildContext context, EventItem event) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => EventRegistrationDialog(event: event),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);
    final isTablet = Breakpoints.isTabletOnly(width);

    final phoenix = getFeaturedCompletedEvent(l10n);
    final onlineEvents = getCompletedOnlineEvents(l10n);
    final upcoming = getUpcomingEvent(l10n);

    return Material(
      color: AppColors.backgroundDark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StorePageHero(
            title: l10n.eventsPageHeroHeadline,
            description: l10n.eventsPageHeroSubline,
            descriptionHighlight: l10n.eventsPageHeroHighlight,
            backgroundAsset: AppContent.assetEventHero,
            heroHeightNarrow: 540,
            heroHeightWide: 440,
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Positioned.fill(child: ChineseInkWashGlow()),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  isNarrow ? 16 : 32,
                  isNarrow ? 32 : 40,
                  isNarrow ? 16 : 32,
                  isNarrow ? 40 : 56,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FieldWorkChineseSectionHeader(
                          title: l10n.eventsUpcomingSpotlightHeading,
                          headline: upcoming.title,
                          subline: l10n.eventsUpcomingSpotlightSubline,
                          isMobile: isNarrow,
                        ),
                        SizedBox(height: isNarrow ? 24 : 32),
                        EventsUpcomingSpotlight(
                          event: upcoming,
                          l10n: l10n,
                          onRegister: () => _openRegistration(context, upcoming),
                        ),
                        SizedBox(height: isNarrow ? 48 : 64),
                        FieldWorkChineseSectionHeader(
                          title: l10n.events,
                          headline: l10n.eventsCompletedHeading,
                          subline: l10n.eventsCompletedSubline,
                          isMobile: isNarrow,
                        ),
                        SizedBox(height: isNarrow ? 24 : 32),
                        EventsCompletedSpotlight(event: phoenix, l10n: l10n),
                        SizedBox(height: isNarrow ? 28 : 36),
                        if (isNarrow)
                          Column(
                            children: [
                              for (var i = 0; i < onlineEvents.length; i++)
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: i < onlineEvents.length - 1 ? 16 : 0,
                                  ),
                                  child: EventsCompletedOnlineCard(
                                    event: onlineEvents[i],
                                    l10n: l10n,
                                  ),
                                ),
                            ],
                          )
                        else
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var i = 0; i < onlineEvents.length; i++) ...[
                                if (i > 0) const SizedBox(width: 20),
                                Expanded(
                                  child: EventsCompletedOnlineCard(
                                    event: onlineEvents[i],
                                    l10n: l10n,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        SizedBox(height: isNarrow ? 40 : 56),
                        EventsWhyAttendBand(l10n: l10n),
                        SizedBox(height: isTablet ? 32 : 48),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
