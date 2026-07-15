import 'package:flutter/material.dart';

import '../../config/app_content.dart';
import '../../config/events_data.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_asset_preloader.dart';
import '../../utils/breakpoints.dart';
import '../../utils/mobile_web_performance.dart';
import '../../widgets/consultation_closing_cta.dart';
import '../../widgets/editorial_page_hero.dart';
import '../home/widgets/field_work_chinese_design.dart';
import 'events_load_coordinator.dart';
import 'widgets/event_registration_dialog.dart';
import 'widgets/events_completed_online_card.dart';
import 'widgets/events_completed_spotlight.dart';
import 'widgets/events_deferred_section.dart';
import 'widgets/events_upcoming_spotlight.dart';
import 'widgets/events_why_attend_band.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final _upcomingKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    AppAssetPreloader.preloadEventsPageAssets();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      EventsLoadCoordinator.armAfterReveal();
    });
  }

  void _openRegistration(BuildContext context, EventItem event) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => EventRegistrationDialog(event: event),
    );
  }

  void _scrollToUpcoming() {
    final context = _upcomingKey.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      alignment: 0.08,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);
    final isTablet = Breakpoints.isTabletOnly(width);
    final isDesktop = Breakpoints.isDesktop(width);

    final phoenix = getFeaturedCompletedEvent(l10n);
    final onlineEvents = getCompletedOnlineEvents(l10n);
    final upcoming = getUpcomingEvent(l10n);

    return Material(
      color: AppColors.backgroundDark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RepaintBoundary(
            child: EditorialPageHero(
              isDesktop: isDesktop,
              backgroundAsset: AppContent.assetEventHero,
              backgroundCacheWidth:
                  MobileWebPerformance.heroBackgroundCacheWidth(context),
              label: l10n.eventsPageHeroHeadline,
              headline: l10n.eventsPageHeroSubline,
              body: l10n.eventsPageHeroBody,
              primaryCta: l10n.eventsPageHeroPrimaryCta,
              secondaryCta: l10n.eventsPageHeroSecondaryCta,
              onPrimary: () => _openRegistration(context, upcoming),
              onSecondary: _scrollToUpcoming,
            ),
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
                        RepaintBoundary(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              KeyedSubtree(
                                key: _upcomingKey,
                                child: FieldWorkChineseSectionHeader(
                                  title: l10n.eventsUpcomingSpotlightHeading,
                                  headline: upcoming.title,
                                  subline: l10n.eventsUpcomingSpotlightSubline,
                                  isMobile: isNarrow,
                                  centerEmblem:
                                      EventsUpcomingSeal(size: isNarrow ? 32 : 38),
                                ),
                              ),
                              SizedBox(height: isNarrow ? 24 : 32),
                              EventsUpcomingSpotlight(
                                event: upcoming,
                                l10n: l10n,
                                onRegister: () =>
                                    _openRegistration(context, upcoming),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: isNarrow ? 48 : 64),
                        EventsDeferredSection(
                          sectionKey: 'completed-spotlight',
                          placeholderHeight: isNarrow ? 700 : 900,
                          child: RepaintBoundary(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                FieldWorkChineseSectionHeader(
                                  title: l10n.events,
                                  headline: l10n.eventsCompletedHeading,
                                  subline: l10n.eventsCompletedSubline,
                                  isMobile: isNarrow,
                                  centerEmblem:
                                      EventsArchiveSeal(size: isNarrow ? 32 : 38),
                                ),
                                SizedBox(height: isNarrow ? 24 : 32),
                                EventsCompletedSpotlight(event: phoenix, l10n: l10n),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: isNarrow ? 28 : 36),
                        EventsDeferredSection(
                          sectionKey: 'online-cards',
                          placeholderHeight: 500,
                          child: RepaintBoundary(
                            child: isNarrow
                                ? Column(
                                    children: [
                                      for (var i = 0; i < onlineEvents.length; i++)
                                        Padding(
                                          padding: EdgeInsets.only(
                                            bottom: i < onlineEvents.length - 1
                                                ? 16
                                                : 0,
                                          ),
                                          child: EventsCompletedOnlineCard(
                                            event: onlineEvents[i],
                                            l10n: l10n,
                                          ),
                                        ),
                                    ],
                                  )
                                : Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      for (var i = 0;
                                          i < onlineEvents.length;
                                          i++) ...[
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
                          ),
                        ),
                        SizedBox(height: isNarrow ? 40 : 56),
                        EventsDeferredSection(
                          sectionKey: 'why-attend',
                          placeholderHeight: 280,
                          child: RepaintBoundary(
                            child: EventsWhyAttendBand(
                              l10n: l10n,
                              isMobile: isNarrow,
                              onRegister: () =>
                                  _openRegistration(context, upcoming),
                            ),
                          ),
                        ),
                        SizedBox(height: isNarrow ? 32 : 48),
                        ConsultationClosingCta(
                          heading: l10n.eventsClosingHeading,
                          body: l10n.eventsClosingBody,
                          isMobile: isNarrow,
                        ),
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
