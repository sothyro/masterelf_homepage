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

const List<EventItem> kAllEvents = [
  EventItem(
    title: 'Master Elf - The Rise of Phoenix 2026',
    date: '31/01/2026',
    location: 'Phnom Penh',
    description: 'The Master Revelation.',
    limitedSeats: true,
  ),
  EventItem(
    title: 'Feng Shui & Astrology 2026',
    date: '31 Jan 2026',
    location: 'Resorts World Sentosa, Singapore',
    description: 'The Singapore Edition of Feng Shui & Astrology 2026 live event.',
  ),
  EventItem(
    title: 'Crimson Horse QiMen',
    date: '1 - 2 Feb 2026',
    location: 'Resorts World Singapore',
    description: 'The Art of War In The Year of the Fire Horse',
  ),
];
