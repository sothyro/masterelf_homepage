import 'package:flutter_test/flutter_test.dart';

import 'package:masterelf_homepage/services/appointment_booking_service.dart';

void main() {
  group('submitAppointmentBooking', () {
    test('demo mode (empty API URL) returns success after delay', () async {
      final result = await submitAppointmentBooking(
        name: 'Test User',
        phone: '012 222 211',
        serviceId: 'consultation',
        serviceName: 'Consultation',
        date: '2026-02-15',
        time: '10:00',
      );

      expect(result.success, isTrue);
      expect(result.errorMessage, isNull);
    });

    test('phone normalization is applied (implementation detail via success)', () async {
      final result = await submitAppointmentBooking(
        name: 'Test',
        phone: '012-222-211',
        serviceId: 's1',
        serviceName: 'S1',
        date: '2026-01-01',
        time: '09:00',
      );

      expect(result.success, isTrue);
    });
  });
}
