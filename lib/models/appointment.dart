export '../config/booking_config.dart'
    show
        defaultBreakAfterMinutes,
        defaultSessionDurationMinutes,
        minSessionDurationMinutes,
        maxSessionDurationMinutes,
        businessOpenHour,
        businessCloseHour,
        selectableDurationsMinutes,
        generateHourlySlotLabels,
        durationHoursLabel;

/// Session type: ONLINE or VISIT.
const String sessionTypeOnline = 'ONLINE';
const String sessionTypeVisit = 'VISIT';

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
    this.sessionType = 'VISIT',
  });

  final String id;
  final String bookingReference;
  final String serviceName;
  final String date;
  final String time;
  final String? startTimeIso;
  final String status;
  final String sessionType;

  factory AppointmentRecord.fromMap(String id, Map<String, dynamic> map) {
    return AppointmentRecord(
      id: id,
      bookingReference: map['bookingReference'] as String? ?? (id.length >= 6 ? id.substring(id.length - 6).toUpperCase() : id),
      serviceName: map['serviceName'] as String? ?? '',
      date: map['date'] as String? ?? '',
      time: map['time'] as String? ?? '',
      startTimeIso: map['startTime'] as String?,
      status: map['status'] as String? ?? 'pending',
      sessionType: map['sessionType'] as String? ?? 'VISIT',
    );
  }
}

/// Admin view of an appointment (includes name, phone, SMS status, etc.).
class AdminAppointmentRecord extends AppointmentRecord {
  const AdminAppointmentRecord({
    required super.id,
    required super.bookingReference,
    required super.serviceName,
    required super.date,
    required super.time,
    super.startTimeIso,
    required super.status,
    super.sessionType = 'VISIT',
    this.name = '',
    this.phone = '',
    this.createdAtIso,
    this.notes = '',
    this.durationMinutes,
    this.endTimeIso,
    this.smsStatus,
    this.smsErrorReason,
    this.smsErrorBody,
  }) : super();

  final String name;
  final String phone;
  final String? createdAtIso;
  final String notes;
  final int? durationMinutes;
  final String? endTimeIso;
  /// SMS status from Cloud Function: sent, failed, skipped, error.
  final String? smsStatus;
  /// Reason when SMS failed or skipped (e.g. invalid_phone, config, api_error).
  final String? smsErrorReason;
  /// Short error message from PlasGate or config (for debugging).
  final String? smsErrorBody;

  factory AdminAppointmentRecord.fromMap(String id, Map<String, dynamic> map) {
    return AdminAppointmentRecord(
      id: id,
      bookingReference: map['bookingReference'] as String? ?? (id.length >= 6 ? id.substring(id.length - 6).toUpperCase() : id),
      serviceName: map['serviceName'] as String? ?? '',
      date: map['date'] as String? ?? '',
      time: map['time'] as String? ?? '',
      startTimeIso: map['startTime'] as String?,
      status: map['status'] as String? ?? 'pending',
      sessionType: map['sessionType'] as String? ?? 'VISIT',
      name: map['name'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      createdAtIso: map['createdAt'] as String?,
      notes: map['notes'] as String? ?? '',
      durationMinutes: map['durationMinutes'] as int?,
      endTimeIso: map['endTime'] as String?,
      smsStatus: map['smsStatus'] as String?,
      smsErrorReason: map['smsErrorReason'] as String?,
      smsErrorBody: map['smsErrorBody'] as String?,
    );
  }
}
