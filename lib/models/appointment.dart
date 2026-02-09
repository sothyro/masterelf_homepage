/// Default session duration and break (used for slot generation).
const int defaultSessionDurationMinutes = 120;
const int defaultBreakAfterMinutes = 30;

/// Stored appointment as returned from Firestore / callables.
class AppointmentRecord {
  const AppointmentRecord({
    required this.id,
    required this.bookingReference,
    required this.serviceName,
    required this.date,
    required this.time,
    this.startTimeIso,
    required this.status,
  });

  final String id;
  final String bookingReference;
  final String serviceName;
  final String date;
  final String time;
  final String? startTimeIso;
  final String status;

  factory AppointmentRecord.fromMap(String id, Map<String, dynamic> map) {
    return AppointmentRecord(
      id: id,
      bookingReference: map['bookingReference'] as String? ?? (id.length >= 6 ? id.substring(id.length - 6).toUpperCase() : id),
      serviceName: map['serviceName'] as String? ?? '',
      date: map['date'] as String? ?? '',
      time: map['time'] as String? ?? '',
      startTimeIso: map['startTime'] as String?,
      status: map['status'] as String? ?? 'pending',
    );
  }
}
