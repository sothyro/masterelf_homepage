import '../l10n/app_localizations.dart';

/// Shared event model and placeholder list (INFORMATION_NEEDED §10 / Joey Yap style).
class EventItem {
  const EventItem({
    required this.title,
    required this.date,
    required this.location,
    required this.description,
    this.limitedSeats = false,
    this.earlyBirdEnds,
  });

  final String title;
  final String date;
  final String location;
  final String description;
  final bool limitedSeats;
  final String? earlyBirdEnds;
}

/// Returns localized event list for the given localizations.
List<EventItem> getLocalizedEvents(AppLocalizations l10n) {
  return [
    EventItem(
      title: l10n.event1Title,
      date: '31/01/2026',
      location: l10n.event1Location,
      description: l10n.event1Description,
      limitedSeats: true,
    ),
    EventItem(
      title: l10n.event2Title,
      date: '31 Jan 2026',
      location: l10n.event2Location,
      description: l10n.event2Description,
    ),
    EventItem(
      title: l10n.event3Title,
      date: '1 - 2 Feb 2026',
      location: l10n.event3Location,
      description: l10n.event3Description,
    ),
  ];
}
