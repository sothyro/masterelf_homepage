import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';

import 'error_service.dart';

/// Service for logging errors to analytics and monitoring systems.
/// All logging is done asynchronously to avoid blocking the UI thread.
class ErrorLoggingService {
  ErrorLoggingService._();

  static FirebaseAnalytics? _analytics;
  static bool _initialized = false;

  /// Initialize the logging service. Call this once at app startup.
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      if (Firebase.apps.isNotEmpty) {
        _analytics = FirebaseAnalytics.instance;
      }
      _initialized = true;
    } catch (_) {
      // Silently fail - logging shouldn't break the app
      _initialized = true;
    }
  }

  /// Log an error to analytics. This is fire-and-forget (non-blocking).
  static void logError(AppError error, {Map<String, dynamic>? additionalData}) {
    // Schedule in background to avoid blocking
    scheduleMicrotask(() => _logErrorAsync(error, additionalData));
  }

  /// Log an error asynchronously.
  static Future<void> _logErrorAsync(
    AppError error,
    Map<String, dynamic>? additionalData,
  ) async {
    try {
      if (_analytics == null) return;

      final parameters = <String, Object>{
        'error_category': error.category.name,
        'error_retryable': error.retryable.toString(),
        if (error.technicalMessage != null)
          'error_technical': error.technicalMessage!.length > 100
              ? error.technicalMessage!.substring(0, 100)
              : error.technicalMessage!,
        if (additionalData != null)
          ...additionalData.map((key, value) => MapEntry(key, value.toString())),
      };

      await _analytics!.logEvent(
        name: 'error_occurred',
        parameters: parameters,
      );
    } catch (_) {
      // Silently fail - logging shouldn't break the app
    }
  }

  /// Log a validation error.
  static void logValidationError(String field, String message) {
    logError(
      AppError.validation(message: message),
      additionalData: {'validation_field': field},
    );
  }

  /// Log a network error with context.
  static void logNetworkError(String operation, AppError error) {
    logError(
      error,
      additionalData: {'network_operation': operation},
    );
  }

  /// Log a form submission error.
  static void logFormError(String formName, AppError error) {
    logError(
      error,
      additionalData: {'form_name': formName},
    );
  }
}
