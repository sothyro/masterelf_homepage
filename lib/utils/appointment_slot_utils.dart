import '../models/appointment.dart';

/// Legacy default for appointments created before duration was stored.
const int legacySessionDurationMinutes = 120;

/// Position of an hourly slot within a multi-hour appointment span.
enum SpanPosition {
  none,
  start,
  middle,
  end,
}

String formatAppointmentDate(DateTime day) =>
    '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';

String formatTimeLabel(DateTime dt) =>
    '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

DateTime? _parseDate(String dateStr) {
  final parts = dateStr.split('-');
  if (parts.length != 3) return null;
  final y = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  final d = int.tryParse(parts[2]);
  if (y == null || m == null || d == null) return null;
  return DateTime(y, m, d);
}

DateTime appointmentStart(AdminAppointmentRecord appointment) {
  final parts = appointment.time.split(':');
  final hour = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0;
  final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
  final day = _parseDate(appointment.date) ?? DateTime.now();
  return DateTime(day.year, day.month, day.day, hour, minute);
}

int effectiveDurationMinutes(AdminAppointmentRecord appointment) {
  final stored = appointment.durationMinutes;
  if (stored != null && stored > 0) {
    return stored;
  }
  if (appointment.endTimeIso != null && appointment.endTimeIso!.isNotEmpty) {
    final end = DateTime.tryParse(appointment.endTimeIso!);
    if (end != null) {
      final start = appointmentStart(appointment);
      final minutes = end.difference(start).inMinutes;
      if (minutes > 0) return minutes;
    }
  }
  return legacySessionDurationMinutes;
}

DateTime appointmentEnd(AdminAppointmentRecord appointment) {
  if (appointment.endTimeIso != null && appointment.endTimeIso!.isNotEmpty) {
    final parsed = DateTime.tryParse(appointment.endTimeIso!);
    if (parsed != null) return parsed;
  }
  return appointmentStart(appointment)
      .add(Duration(minutes: effectiveDurationMinutes(appointment)));
}

DateTime slotStart(DateTime day, String slot) {
  final parts = slot.split(':');
  final hour = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0;
  final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
  return DateTime(day.year, day.month, day.day, hour, minute);
}

bool appointmentStartsAtSlot(
  AdminAppointmentRecord appointment,
  DateTime day,
  String slot,
) {
  if (appointment.status == 'cancelled') return false;
  if (appointment.date != formatAppointmentDate(day)) return false;
  return appointment.time == slot;
}

bool appointmentCoversSlot(
  AdminAppointmentRecord appointment,
  DateTime day,
  String slot,
) {
  if (appointment.status == 'cancelled') return false;
  if (appointment.date != formatAppointmentDate(day)) return false;

  final slotS = slotStart(day, slot);
  final slotE = slotS.add(const Duration(hours: 1));
  final apptS = appointmentStart(appointment);
  final apptE = appointmentEnd(appointment);
  return apptS.isBefore(slotE) && apptE.isAfter(slotS);
}

SpanPosition spanPosition(
  AdminAppointmentRecord appointment,
  DateTime day,
  String slot,
) {
  if (!appointmentCoversSlot(appointment, day, slot)) {
    return SpanPosition.none;
  }

  final slotS = slotStart(day, slot);
  final slotE = slotS.add(const Duration(hours: 1));
  final apptE = appointmentEnd(appointment);

  final isStart = appointmentStartsAtSlot(appointment, day, slot);
  final isEnd =
      apptE.isAfter(slotS) && (apptE.isBefore(slotE) || apptE.isAtSameMomentAs(slotE));

  if (isStart) return SpanPosition.start;
  if (isEnd) return SpanPosition.end;
  return SpanPosition.middle;
}

List<AdminAppointmentRecord> startingAppointmentsForSlot(
  List<AdminAppointmentRecord> appointments,
  DateTime day,
  String slot,
) {
  return appointments
      .where((a) => appointmentStartsAtSlot(a, day, slot))
      .toList();
}

List<AdminAppointmentRecord> continuationAppointmentsForSlot(
  List<AdminAppointmentRecord> appointments,
  DateTime day,
  String slot,
) {
  return appointments
      .where(
        (a) =>
            appointmentCoversSlot(a, day, slot) &&
            !appointmentStartsAtSlot(a, day, slot),
      )
      .toList();
}

bool slotIsOccupied(
  List<AdminAppointmentRecord> appointments,
  DateTime day,
  String slot,
) {
  return appointments.any((a) => appointmentCoversSlot(a, day, slot));
}
