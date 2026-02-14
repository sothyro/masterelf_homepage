import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;

import '../config/app_content.dart';
import '../models/appointment.dart';

/// Result of submitting an appointment booking.
/// When using Firestore, SMS is sent via PlasGate from a Cloud Function.
class BookingResult {
  const BookingResult({
    required this.success,
    this.errorMessage,
    this.bookingReference,
    this.appointmentId,
  });

  final bool success;
  final String? errorMessage;
  final String? bookingReference;
  final String? appointmentId;
}

/// Whether Firebase is available (initialized and usable).
bool get isFirebaseEnabled {
  try {
    return Firebase.apps.isNotEmpty;
  } catch (_) {
    return false;
  }
}

/// Normalize phone to E.164 for storage and PlasGate (e.g. 855xxxxxxxx).
String normalizePhone(String phone) {
  final digits = phone.replaceAll(RegExp(r'[\s\-\(\)\.]'), '');
  if (digits.startsWith('855')) return digits;
  if (digits.startsWith('0')) return '855${digits.substring(1)}';
  if (digits.length >= 9 && !digits.startsWith('+')) return '855$digits';
  return phone.startsWith('+') ? phone.replaceFirst('+', '') : phone;
}

String _randomBookingReference() {
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  final r = Random();
  return List.generate(6, (_) => chars[r.nextInt(chars.length)]).join();
}

/// Submits an appointment booking.
/// When Firebase is enabled: writes to Firestore; Cloud Function sends SMS via PlasGate.
/// When [AppContent.appointmentBookingApiUrl] is set and Firebase is not used: POSTs to legacy API.
/// Otherwise: demo mode (success after delay).
Future<BookingResult> submitAppointmentBooking({
  required String name,
  required String phone,
  required String serviceId,
  required String serviceName,
  required String date,
  required String time,
  String sessionType = 'VISIT',
  String? notes,
  int durationMinutes = defaultSessionDurationMinutes,
}) async {
  final normalizedPhone = normalizePhone(phone);
  final startTime = _parseStartTime(date, time);
  final endTime = startTime?.add(Duration(minutes: durationMinutes));
  final bookingRef = _randomBookingReference();

  if (isFirebaseEnabled) {
    try {
      final firestore = FirebaseFirestore.instance;
      final ref = firestore.collection('appointments').doc();
      final startTimestamp = startTime != null ? Timestamp.fromDate(startTime) : null;
      final endTimestamp = endTime != null ? Timestamp.fromDate(endTime) : null;
      final data = <String, dynamic>{
        'name': name.trim(),
        'phone': normalizedPhone,
        'serviceId': serviceId,
        'serviceName': serviceName,
        'date': date,
        'time': time,
        'sessionType': sessionType,
        'startTime': startTimestamp,
        'endTime': endTimestamp,
        'durationMinutes': durationMinutes,
        'breakAfterMinutes': defaultBreakAfterMinutes,
        'status': 'pending',
        'bookingReference': bookingRef,
        'createdAt': FieldValue.serverTimestamp(),
      };
      if (notes != null && notes.trim().isNotEmpty) {
        data['notes'] = notes.trim();
      }
      await ref.set(data);
      return BookingResult(
        success: true,
        bookingReference: bookingRef,
        appointmentId: ref.id,
      );
    } catch (e) {
      return BookingResult(success: false, errorMessage: e.toString());
    }
  }

  final baseUrl = AppContent.appointmentBookingApiUrl;
  if (baseUrl.isEmpty) {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    return const BookingResult(success: true);
  }

  try {
    final uri = Uri.parse(baseUrl);
    final body = jsonEncode({
      'name': name,
      'phone': normalizedPhone,
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

DateTime? _parseStartTime(String date, String time) {
  try {
    final parts = time.split(':');
    final hour = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0;
    final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    final dateParts = date.split('-');
    if (dateParts.length != 3) return null;
    final y = int.tryParse(dateParts[0]);
    final m = int.tryParse(dateParts[1]);
    final d = int.tryParse(dateParts[2]);
    if (y == null || m == null || d == null) return null;
    return DateTime(y, m, d, hour, minute);
  } catch (_) {
    return null;
  }
}

/// Fetches available slot start times (HH:mm) for the given date.
/// Uses Cloud Function when Firebase is enabled; otherwise returns default slots.
Future<List<String>> getAvailableSlots(String date) async {
  if (isFirebaseEnabled) {
    try {
      final result = await FirebaseFunctions.instance
          .httpsCallable('getAvailableSlots')
          .call({'date': date});
      final data = result.data as Map<String, dynamic>?;
      final list = data?['slots'] as List<dynamic>?;
      if (list != null) {
        return list.map((e) => e.toString()).toList();
      }
    } catch (e) {
      // Fallback to default slots on error
    }
  }
  // Default slots: 2h session, 1h break, 09:00–21:00 (21:00 special: 1h or 2h to 23:00)
  return ['09:00', '12:00', '15:00', '18:00', '21:00'];
}

/// Fetches bookings for the given phone number (via callable).
Future<List<AppointmentRecord>> getMyBookings(String phone) async {
  if (!isFirebaseEnabled) return [];
  try {
    final result = await FirebaseFunctions.instance
        .httpsCallable('getMyBookings')
        .call({'phone': phone});
    final data = result.data as Map<String, dynamic>?;
    final list = data?['bookings'] as List<dynamic>?;
    if (list == null) return [];
    return list
        .asMap()
        .entries
        .map((e) {
          final m = e.value as Map<String, dynamic>;
          final id = m['id'] as String? ?? '${e.key}';
          return AppointmentRecord.fromMap(id, m);
        })
        .toList();
  } catch (e) {
    rethrow;
  }
}

/// Cancels an appointment (callable verifies phone).
Future<void> cancelBooking(String appointmentId, String phone) async {
  if (!isFirebaseEnabled) throw StateError('Firebase not configured');
  await FirebaseFunctions.instance.httpsCallable('cancelBooking').call({
    'appointmentId': appointmentId,
    'phone': phone,
  });
}

/// Fetches all appointments for admin dashboard (requires authenticated user).
Future<List<AdminAppointmentRecord>> getAllAppointments({
  String? statusFilter,
  int limit = 100,
}) async {
  if (!isFirebaseEnabled) return [];
  try {
    final result = await FirebaseFunctions.instance
        .httpsCallable('getAllAppointments')
        .call({
      if (statusFilter != null && statusFilter.isNotEmpty) 'status': statusFilter,
      'limit': limit,
    });
    final data = result.data as Map<String, dynamic>?;
    final list = data?['appointments'] as List<dynamic>?;
    if (list == null) return [];
    return list
        .asMap()
        .entries
        .map((e) {
          final m = e.value as Map<String, dynamic>;
          final id = m['id'] as String? ?? '${e.key}';
          return AdminAppointmentRecord.fromMap(id, m);
        })
        .toList();
  } catch (e) {
    rethrow;
  }
}

/// Updates appointment status (admin only, requires authenticated user).
Future<void> updateAppointmentStatus(String appointmentId, String status) async {
  if (!isFirebaseEnabled) throw StateError('Firebase not configured');
  await FirebaseFunctions.instance.httpsCallable('updateAppointmentStatus').call({
    'appointmentId': appointmentId,
    'status': status,
  });
}

/// Updates appointment date and time (admin only, requires authenticated user).
Future<void> updateAppointment(String appointmentId, String date, String time) async {
  if (!isFirebaseEnabled) throw StateError('Firebase not configured');
  await FirebaseFunctions.instance.httpsCallable('updateAppointment').call({
    'appointmentId': appointmentId,
    'date': date,
    'time': time,
  });
}
