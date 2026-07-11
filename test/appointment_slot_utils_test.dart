import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/models/appointment.dart';
import 'package:masterelf_homepage/utils/appointment_slot_utils.dart';

AdminAppointmentRecord _record({
  required String date,
  required String time,
  int? durationMinutes,
  String? endTimeIso,
  String status = 'pending',
}) {
  return AdminAppointmentRecord(
    id: 'test-id',
    bookingReference: 'TEST01',
    serviceName: 'Bazi Reading',
    date: date,
    time: time,
    status: status,
    durationMinutes: durationMinutes,
    endTimeIso: endTimeIso,
    name: 'Testing 8H',
  );
}

void main() {
  final day = DateTime(2026, 7, 12);

  group('appointmentCoversSlot', () {
    test('8h at 08:00 covers 08:00 through 15:00 but not 16:00', () {
      final appointment = _record(
        date: '2026-07-12',
        time: '08:00',
        durationMinutes: 480,
      );

      for (final hour in [8, 9, 10, 11, 12, 13, 14, 15]) {
        final slot = '${hour.toString().padLeft(2, '0')}:00';
        expect(
          appointmentCoversSlot(appointment, day, slot),
          isTrue,
          reason: '$slot should be covered',
        );
      }
      expect(appointmentCoversSlot(appointment, day, '16:00'), isFalse);
    });

    test('1h at 09:00 covers only 09:00', () {
      final appointment = _record(
        date: '2026-07-12',
        time: '09:00',
        durationMinutes: 60,
      );

      expect(appointmentCoversSlot(appointment, day, '09:00'), isTrue);
      expect(appointmentCoversSlot(appointment, day, '08:00'), isFalse);
      expect(appointmentCoversSlot(appointment, day, '10:00'), isFalse);
    });

    test('cancelled appointment covers nothing', () {
      final appointment = _record(
        date: '2026-07-12',
        time: '08:00',
        durationMinutes: 480,
        status: 'cancelled',
      );

      expect(appointmentCoversSlot(appointment, day, '08:00'), isFalse);
    });

    test('legacy record without duration fields uses 120 min fallback', () {
      final appointment = _record(
        date: '2026-07-12',
        time: '08:00',
      );

      expect(effectiveDurationMinutes(appointment), 120);
      expect(appointmentCoversSlot(appointment, day, '08:00'), isTrue);
      expect(appointmentCoversSlot(appointment, day, '09:00'), isTrue);
      expect(appointmentCoversSlot(appointment, day, '10:00'), isFalse);
    });
  });

  group('spanPosition', () {
    test('returns start, middle, and end for 8h booking', () {
      final appointment = _record(
        date: '2026-07-12',
        time: '08:00',
        durationMinutes: 480,
      );

      expect(spanPosition(appointment, day, '08:00'), SpanPosition.start);
      expect(spanPosition(appointment, day, '12:00'), SpanPosition.middle);
      expect(spanPosition(appointment, day, '15:00'), SpanPosition.end);
      expect(spanPosition(appointment, day, '16:00'), SpanPosition.none);
    });

    test('single-hour booking is start only', () {
      final appointment = _record(
        date: '2026-07-12',
        time: '09:00',
        durationMinutes: 60,
      );

      expect(spanPosition(appointment, day, '09:00'), SpanPosition.start);
      expect(spanPosition(appointment, day, '10:00'), SpanPosition.none);
    });
  });

  group('slot lists', () {
    test('starting and continuation helpers partition covered slots', () {
      final appointments = [
        _record(date: '2026-07-12', time: '08:00', durationMinutes: 480),
      ];

      expect(
        startingAppointmentsForSlot(appointments, day, '08:00'),
        hasLength(1),
      );
      expect(
        continuationAppointmentsForSlot(appointments, day, '09:00'),
        hasLength(1),
      );
      expect(
        continuationAppointmentsForSlot(appointments, day, '08:00'),
        isEmpty,
      );
      expect(slotIsOccupied(appointments, day, '15:00'), isTrue);
      expect(slotIsOccupied(appointments, day, '16:00'), isFalse);
    });
  });
}
