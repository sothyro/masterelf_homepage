/// Shared booking schedule constants (mirror values in functions/index.js).
const int minSessionDurationMinutes = 60;
const int maxSessionDurationMinutes = 480;
const int defaultSessionDurationMinutes = 60;
const int defaultBreakAfterMinutes = 0;
const int businessOpenHour = 8;
const int businessCloseHour = 22;
const int slotIntervalMinutes = 60;

/// Selectable session lengths in 1-hour steps (1h–8h).
const List<int> selectableDurationsMinutes = [
  60,
  120,
  180,
  240,
  300,
  360,
  420,
  480,
];

/// Hourly start-time labels from open hour through last valid 1h start (e.g. 08:00–21:00).
List<String> generateHourlySlotLabels() {
  final slots = <String>[];
  for (var hour = businessOpenHour; hour < businessCloseHour; hour++) {
    slots.add('${hour.toString().padLeft(2, '0')}:00');
  }
  return slots;
}

int durationHoursLabel(int durationMinutes) =>
    (durationMinutes / 60).round();
