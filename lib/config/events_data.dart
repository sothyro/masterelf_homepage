import '../config/app_content.dart';
import '../l10n/app_localizations.dart';

enum EventStatus { completed, upcoming }

enum EventFormat { inPerson, online }

/// Shared event model for events page and homepage showcase.
class EventItem {
  const EventItem({
    required this.id,
    required this.status,
    required this.format,
    required this.title,
    required this.subtitle,
    required this.hook,
    required this.date,
    required this.location,
    required this.description,
    required this.imageAsset,
    this.limitedSeats = false,
    this.isFeaturedCompleted = false,
    this.earlyBirdEnds,
  });

  final String id;
  final EventStatus status;
  final EventFormat format;
  final String title;
  final String subtitle;
  final String hook;
  final String date;
  final String location;
  final String description;
  final String imageAsset;
  final bool limitedSeats;
  final bool isFeaturedCompleted;
  final String? earlyBirdEnds;
}

EventItem _phoenix2026(AppLocalizations l10n) => EventItem(
      id: 'phoenix-2026',
      status: EventStatus.completed,
      format: EventFormat.inPerson,
      title: l10n.event1Title,
      subtitle: l10n.event1Subtitle,
      hook: l10n.event1Hook,
      date: '31/01/2026',
      location: l10n.event1Location,
      description: l10n.event1Description,
      imageAsset: AppContent.assetEventMain,
      isFeaturedCompleted: true,
    );

EventItem _fengshui2026(AppLocalizations l10n) => EventItem(
      id: 'fengshui-2026',
      status: EventStatus.completed,
      format: EventFormat.online,
      title: l10n.event2Title,
      subtitle: l10n.event2Subtitle,
      hook: l10n.event2Hook,
      date: '31 Jan 2026',
      location: l10n.event2Location,
      description: l10n.event2Description,
      imageAsset: AppContent.assetEvent2026FengShui,
    );

EventItem _crimsonHorse(AppLocalizations l10n) => EventItem(
      id: 'crimson-horse',
      status: EventStatus.completed,
      format: EventFormat.online,
      title: l10n.event3Title,
      subtitle: l10n.event3Subtitle,
      hook: l10n.event3Hook,
      date: '1 - 2 Feb 2026',
      location: l10n.event3Location,
      description: l10n.event3Description,
      imageAsset: AppContent.assetEvent2026CrimsonHorse,
    );

EventItem _fireGoat2027(AppLocalizations l10n) => EventItem(
      id: 'fire-goat-2027',
      status: EventStatus.upcoming,
      format: EventFormat.inPerson,
      title: l10n.eventsGoat2027Title,
      subtitle: l10n.eventsGoat2027Subtitle,
      hook: l10n.eventsGoat2027Hook,
      date: l10n.eventsGoat2027Date,
      location: l10n.eventsGoat2027Location,
      description: l10n.eventsGoat2027Description,
      imageAsset: AppContent.assetEvent2027,
      limitedSeats: true,
    );

/// All events for legacy callers (completed first, then upcoming).
List<EventItem> getLocalizedEvents(AppLocalizations l10n) {
  return [
    _phoenix2026(l10n),
    _fengshui2026(l10n),
    _crimsonHorse(l10n),
    _fireGoat2027(l10n),
  ];
}

EventItem getFeaturedCompletedEvent(AppLocalizations l10n) => _phoenix2026(l10n);

List<EventItem> getCompletedEvents(AppLocalizations l10n) => [
      _phoenix2026(l10n),
      _fengshui2026(l10n),
      _crimsonHorse(l10n),
    ];

List<EventItem> getCompletedOnlineEvents(AppLocalizations l10n) => [
      _fengshui2026(l10n),
      _crimsonHorse(l10n),
    ];

EventItem getUpcomingEvent(AppLocalizations l10n) => _fireGoat2027(l10n);

EventItem getHomepageFeaturedEvent(AppLocalizations l10n) => _fireGoat2027(l10n);

List<EventItem> getHomepageCompletedEvents(AppLocalizations l10n) => [
      _phoenix2026(l10n),
      _fengshui2026(l10n),
      _crimsonHorse(l10n),
    ];
