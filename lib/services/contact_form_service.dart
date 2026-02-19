import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';

import 'error_service.dart';

/// Result of submitting the contact form.
class ContactFormResult {
  const ContactFormResult({
    required this.success,
    this.submissionId,
    this.error,
  });

  final bool success;
  final String? submissionId;
  final AppError? error;

  /// Legacy support: returns error message if error exists.
  String? get errorMessage => error?.userMessage;
}

bool get _isFirebaseEnabled {
  try {
    return Firebase.apps.isNotEmpty;
  } catch (_) {
    return false;
  }
}

/// Submits the contact form via the submitContactForm callable.
/// When Firebase is not initialized, returns a failure result with a message.
Future<ContactFormResult> submitContactForm({
  required String name,
  required String email,
  required String message,
  String? phone,
  required int subjectIndex,
  String? subjectLabel,
}) async {
  if (!_isFirebaseEnabled) {
    return ContactFormResult(
      success: false,
      error: AppError(
        category: ErrorCategory.server,
        userMessage: 'Contact form is not available. Please email us directly.',
        retryable: false,
      ),
    );
  }

  try {
    final result = await FirebaseFunctions.instance
        .httpsCallable('submitContactForm')
        .call(<String, dynamic>{
      'name': name.trim(),
      'email': email.trim(),
      'message': message.trim(),
      if (phone != null && phone.trim().isNotEmpty) 'phone': phone.trim(),
      'subjectIndex': subjectIndex.clamp(0, 5),
      if (subjectLabel != null && subjectLabel.isNotEmpty) 'subjectLabel': subjectLabel.trim(),
    });

    final data = result.data as Map<dynamic, dynamic>?;
    final success = data?['success'] == true;
    final id = data?['id'] as String?;
    if (success) {
      return ContactFormResult(
        success: true,
        submissionId: id,
      );
    }
    return ContactFormResult(
      success: false,
      error: AppError(
        category: ErrorCategory.server,
        userMessage: 'Request failed. Please try again.',
        retryable: true,
      ),
    );
  } catch (e) {
    return ContactFormResult(
      success: false,
      error: AppError.fromException(e),
    );
  }
}
