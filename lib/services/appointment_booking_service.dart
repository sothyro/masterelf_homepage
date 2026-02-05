import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_content.dart';

/// Result of submitting an appointment booking.
/// Backend is expected to send SMS confirmation via Unimatrix to [phone].
class BookingResult {
  const BookingResult({required this.success, this.errorMessage});

  final bool success;
  final String? errorMessage;
}

/// Submits an appointment booking. When [AppContent.appointmentBookingApiUrl]
/// is set, POSTs to the backend; the backend should send SMS confirmation
/// using Unimatrix (https://unimtx.com/docs/api/send). When the URL is empty,
/// returns success without calling (demo mode).
Future<BookingResult> submitAppointmentBooking({
  required String name,
  required String phone,
  required String serviceId,
  required String serviceName,
  required String date,
  required String time,
}) async {
  final baseUrl = AppContent.appointmentBookingApiUrl;
  if (baseUrl.isEmpty) {
    // Demo mode: no backend; assume backend would send SMS via Unimatrix.
    await Future<void>.delayed(const Duration(milliseconds: 800));
    return const BookingResult(success: true);
  }

  try {
    final uri = Uri.parse(baseUrl);
    final body = jsonEncode({
      'name': name,
      'phone': _normalizePhone(phone),
      'serviceId': serviceId,
      'serviceName': serviceName,
      'date': date,
      'time': time,
    });
    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: body,
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return const BookingResult(success: true);
    }
    return BookingResult(
      success: false,
      errorMessage: 'Booking failed (${response.statusCode})',
    );
  } catch (e) {
    return BookingResult(
      success: false,
      errorMessage: e.toString(),
    );
  }
}

/// Normalize phone to E.164 for Unimatrix (backend may use this).
String _normalizePhone(String phone) {
  final digits = phone.replaceAll(RegExp(r'[\s\-\(\)\.]'), '');
  if (digits.startsWith('855')) return '+$digits';
  if (digits.startsWith('0')) return '+855${digits.substring(1)}';
  if (digits.length >= 9 && !digits.startsWith('+')) return '+855$digits';
  return phone.startsWith('+') ? phone : '+$phone';
}
