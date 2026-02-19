import 'dart:async';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:sentry_flutter/sentry_flutter.dart';

import 'error_service.dart';

/// Service for error reporting to Sentry.
/// All reporting is done asynchronously to avoid blocking the UI thread.
class SentryService {
  SentryService._();

  static bool _initialized = false;

  /// Initialize Sentry. Call this once at app startup.
  /// Pass your Sentry DSN or leave empty to disable Sentry.
  static Future<void> initialize({String? dsn}) async {
    if (_initialized) return;
    if (dsn == null || dsn.isEmpty) {
      _initialized = true;
      return;
    }

    try {
      await SentryFlutter.init(
        (options) {
          options.dsn = dsn;
          options.tracesSampleRate = 0.1; // Sample 10% of transactions
          options.environment = kDebugMode ? 'development' : 'production';
          // Filtering is done in reportError() method instead of beforeSend
          // to avoid type compatibility issues across Sentry versions
        },
        appRunner: () {
          // App will be started by main() after Sentry initialization
        },
      );
      _initialized = true;
    } catch (_) {
      // Silently fail - Sentry shouldn't break the app
      _initialized = true;
    }
  }

  /// Report an error to Sentry. This is fire-and-forget (non-blocking).
  static void reportError(AppError error, {StackTrace? stackTrace}) {
    // Schedule in background to avoid blocking
    scheduleMicrotask(() => _reportErrorAsync(error, stackTrace));
  }

  /// Report an error asynchronously.
  static Future<void> _reportErrorAsync(
    AppError error,
    StackTrace? stackTrace,
  ) async {
    try {
      if (!_initialized) return;

      // Only report server errors and unknown errors to Sentry
      // Skip validation errors and expected network errors
      if (error.category == ErrorCategory.validation ||
          (error.category == ErrorCategory.network && error.retryable)) {
        return;
      }

      await Sentry.captureException(
        error.originalError ?? error,
        stackTrace: stackTrace,
        hint: Hint.withMap({
          'error_category': error.category.name,
          'user_message': error.userMessage,
          'technical_message': error.technicalMessage,
          'retryable': error.retryable,
        }),
      );
    } catch (_) {
      // Silently fail - error reporting shouldn't break the app
    }
  }

  /// Report a critical error immediately (blocking).
  /// Use sparingly for truly critical errors that need immediate attention.
  static Future<void> reportCriticalError(
    AppError error, {
    StackTrace? stackTrace,
  }) async {
    try {
      if (!_initialized) return;
      await Sentry.captureException(
        error.originalError ?? error,
        stackTrace: stackTrace,
        hint: Hint.withMap({
          'error_category': error.category.name,
          'user_message': error.userMessage,
          'critical': true,
        }),
      );
    } catch (_) {
      // Silently fail
    }
  }
}
