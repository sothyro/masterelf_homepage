import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../l10n/app_localizations.dart';
import 'connectivity_service.dart';
import 'error_logging_service.dart';
import 'sentry_service.dart';

/// Categories of errors for better handling and user messaging.
enum ErrorCategory {
  network,
  validation,
  authentication,
  server,
  permission,
  notFound,
  rateLimit,
  unknown,
}

/// Structured error information with user-friendly messages.
class AppError {
  const AppError({
    required this.category,
    required this.userMessage,
    this.technicalMessage,
    this.retryable = false,
    this.originalError,
  });

  final ErrorCategory category;
  final String userMessage;
  final String? technicalMessage;
  final bool retryable;
  final Object? originalError;

  /// Creates an AppError from an exception with appropriate categorization.
  /// Automatically logs the error to analytics (non-blocking).
  factory AppError.fromException(
    Object error, {
    AppLocalizations? l10n,
    bool logError = true,
  }) {

    // Network errors
    if (error is SocketException || error is HttpException) {
      final appError = AppError(
        category: ErrorCategory.network,
        userMessage: l10n?.errorNetwork ?? 'Network connection failed. Please check your internet connection.',
        technicalMessage: error.toString(),
        retryable: true,
        originalError: error,
      );
      if (logError) {
        ErrorLoggingService.logNetworkError('socket_http', appError);
        SentryService.reportError(appError);
      }
      return appError;
    }

    // HTTP errors
    if (error is http.ClientException) {
      final appError = AppError(
        category: ErrorCategory.network,
        userMessage: l10n?.errorNetwork ?? 'Unable to connect to the server. Please try again.',
        technicalMessage: error.toString(),
        retryable: true,
        originalError: error,
      );
      if (logError) {
        ErrorLoggingService.logNetworkError('http_client', appError);
        SentryService.reportError(appError);
      }
      return appError;
    }

    // Timeout errors
    if (error.toString().contains('timeout') ||
        error.toString().contains('TimeoutException')) {
      final appError = AppError(
        category: ErrorCategory.network,
        userMessage: l10n?.errorTimeout ?? 'Request timed out. Please check your connection and try again.',
        technicalMessage: error.toString(),
        retryable: true,
        originalError: error,
      );
      if (logError) {
        ErrorLoggingService.logNetworkError('timeout', appError);
        SentryService.reportError(appError);
      }
      return appError;
    }

    // Firebase Auth errors
    if (error is FirebaseAuthException) {
      AppError appError;
      switch (error.code) {
        case 'user-not-found':
          appError = AppError(
            category: ErrorCategory.authentication,
            userMessage: l10n?.errorUserNotFound ?? 'No account found with this email.',
            technicalMessage: error.message,
            retryable: false,
            originalError: error,
          );
          break;
        case 'wrong-password':
          appError = AppError(
            category: ErrorCategory.authentication,
            userMessage: l10n?.errorWrongPassword ?? 'Incorrect password. Please try again.',
            technicalMessage: error.message,
            retryable: false,
            originalError: error,
          );
          break;
        case 'email-already-in-use':
          appError = AppError(
            category: ErrorCategory.validation,
            userMessage: l10n?.errorEmailInUse ?? 'This email is already registered.',
            technicalMessage: error.message,
            retryable: false,
            originalError: error,
          );
          break;
        case 'invalid-email':
          appError = AppError(
            category: ErrorCategory.validation,
            userMessage: l10n?.errorInvalidEmail ?? 'Invalid email address.',
            technicalMessage: error.message,
            retryable: false,
            originalError: error,
          );
          break;
        case 'too-many-requests':
          appError = AppError(
            category: ErrorCategory.rateLimit,
            userMessage: l10n?.errorTooManyRequests ?? 'Too many attempts. Please wait a moment and try again.',
            technicalMessage: error.message,
            retryable: true,
            originalError: error,
          );
          break;
        default:
          appError = AppError(
            category: ErrorCategory.authentication,
            userMessage: l10n?.errorAuthFailed ?? 'Authentication failed. Please try again.',
            technicalMessage: error.message ?? error.code,
            retryable: error.code == 'network-request-failed',
            originalError: error,
          );
      }
      if (logError) {
        ErrorLoggingService.logError(appError, additionalData: {'auth_code': error.code});
        SentryService.reportError(appError);
      }
      return appError;
    }

    // Firebase Functions errors
    if (error is FirebaseFunctionsException) {
      AppError appError;
      switch (error.code) {
        case 'unavailable':
        case 'deadline-exceeded':
          appError = AppError(
            category: ErrorCategory.network,
            userMessage: l10n?.errorServerUnavailable ?? 'Service temporarily unavailable. Please try again.',
            technicalMessage: error.message ?? error.details?.toString(),
            retryable: true,
            originalError: error,
          );
          break;
        case 'permission-denied':
          appError = AppError(
            category: ErrorCategory.permission,
            userMessage: l10n?.errorPermissionDenied ?? 'You do not have permission to perform this action.',
            technicalMessage: error.message ?? error.details?.toString(),
            retryable: false,
            originalError: error,
          );
          break;
        case 'not-found':
          appError = AppError(
            category: ErrorCategory.notFound,
            userMessage: l10n?.errorNotFound ?? 'The requested resource was not found.',
            technicalMessage: error.message ?? error.details?.toString(),
            retryable: false,
            originalError: error,
          );
          break;
        case 'invalid-argument':
          appError = AppError(
            category: ErrorCategory.validation,
            userMessage: l10n?.errorInvalidInput ?? 'Invalid input. Please check your information.',
            technicalMessage: error.message ?? error.details?.toString(),
            retryable: false,
            originalError: error,
          );
          break;
        default:
          appError = AppError(
            category: ErrorCategory.server,
            userMessage: l10n?.errorServerError ?? 'Server error occurred. Please try again later.',
            technicalMessage: error.message ?? error.details?.toString(),
            retryable: true,
            originalError: error,
          );
      }
      if (logError) {
        ErrorLoggingService.logError(appError, additionalData: {'function_code': error.code});
        SentryService.reportError(appError);
      }
      return appError;
    }

    // Firestore errors
    if (error is FirebaseException) {
      AppError appError;
      if (error.code == 'permission-denied') {
        appError = AppError(
          category: ErrorCategory.permission,
          userMessage: l10n?.errorPermissionDenied ?? 'You do not have permission to access this resource.',
          technicalMessage: error.message,
          retryable: false,
          originalError: error,
        );
      } else {
        appError = AppError(
          category: ErrorCategory.server,
          userMessage: l10n?.errorDatabaseError ?? 'Database error occurred. Please try again.',
          technicalMessage: error.message,
          retryable: true,
          originalError: error,
        );
      }
      if (logError) {
        ErrorLoggingService.logError(appError, additionalData: {'firestore_code': error.code});
        SentryService.reportError(appError);
      }
      return appError;
    }

    // Generic error handling
    final errorString = error.toString().toLowerCase();
    if (errorString.contains('network') || errorString.contains('connection')) {
      final appError = AppError(
        category: ErrorCategory.network,
        userMessage: l10n?.errorNetwork ?? 'Network error. Please check your connection.',
        technicalMessage: error.toString(),
        retryable: true,
        originalError: error,
      );
      if (logError) {
        ErrorLoggingService.logNetworkError('generic_network', appError);
        SentryService.reportError(appError);
      }
      return appError;
    }

    if (errorString.contains('validation') || errorString.contains('invalid')) {
      final appError = AppError(
        category: ErrorCategory.validation,
        userMessage: l10n?.errorInvalidInput ?? 'Invalid input. Please check your information.',
        technicalMessage: error.toString(),
        retryable: false,
        originalError: error,
      );
      if (logError) {
        ErrorLoggingService.logError(appError);
        SentryService.reportError(appError);
      }
      return appError;
    }

    // Unknown error
    final appError = AppError(
      category: ErrorCategory.unknown,
      userMessage: l10n?.errorUnknown ?? 'An unexpected error occurred. Please try again.',
      technicalMessage: error.toString(),
      retryable: false,
      originalError: error,
    );
    if (logError) {
      ErrorLoggingService.logError(appError);
      SentryService.reportError(appError);
    }
    return appError;
  }

  /// Creates a network error with retry capability.
  factory AppError.network({
    String? message,
    AppLocalizations? l10n,
    Object? originalError,
  }) {
    return AppError(
      category: ErrorCategory.network,
      userMessage: message ?? l10n?.errorNetwork ?? 'Network connection failed. Please check your internet connection.',
      technicalMessage: originalError?.toString(),
      retryable: true,
      originalError: originalError,
    );
  }

  /// Creates a validation error.
  factory AppError.validation({
    required String message,
    Object? originalError,
  }) {
    return AppError(
      category: ErrorCategory.validation,
      userMessage: message,
      technicalMessage: originalError?.toString(),
      retryable: false,
      originalError: originalError,
    );
  }

  @override
  String toString() => userMessage;
}

/// Helper function to execute async operations with error handling and retry logic.
/// Checks connectivity before operations and provides offline-aware error handling.
Future<T> executeWithRetry<T>({
  required Future<T> Function() operation,
  int maxRetries = 3,
  Duration retryDelay = const Duration(seconds: 2),
  bool Function(AppError)? shouldRetry,
  bool checkConnectivity = true,
  AppLocalizations? l10n,
}) async {
  // Check connectivity before attempting operation
  if (checkConnectivity) {
    final isOnline = await ConnectivityService.isOnline();
    if (!isOnline) {
      final offlineError = AppError(
        category: ErrorCategory.network,
        userMessage: l10n?.errorNetwork ??
            'No internet connection. Please check your network and try again.',
        retryable: true,
      );
      ErrorLoggingService.logNetworkError('offline_check', offlineError);
      // Don't report offline errors to Sentry (expected behavior)
      throw offlineError;
    }
  }

  int attempts = 0;
  AppError? lastError;

  while (attempts < maxRetries) {
    try {
      return await operation();
    } catch (e) {
      lastError = AppError.fromException(e, l10n: l10n);
      attempts++;

      // Check if we should retry
      final canRetry = lastError.retryable &&
          (shouldRetry == null || shouldRetry(lastError));

      if (!canRetry || attempts >= maxRetries) {
        throw lastError;
      }

      // Re-check connectivity before retrying
      if (checkConnectivity) {
        final isOnline = await ConnectivityService.isOnline();
        if (!isOnline) {
          final offlineError = AppError(
            category: ErrorCategory.network,
            userMessage: l10n?.errorNetwork ??
                'No internet connection. Please check your network and try again.',
            retryable: true,
          );
          ErrorLoggingService.logNetworkError('offline_retry', offlineError);
          // Don't report offline errors to Sentry (expected behavior)
          throw offlineError;
        }
      }

      // Wait before retrying
      await Future.delayed(retryDelay * attempts); // Exponential backoff
    }
  }

  throw lastError ??
      AppError(
        category: ErrorCategory.unknown,
        userMessage: 'An unexpected error occurred.',
      );
}
