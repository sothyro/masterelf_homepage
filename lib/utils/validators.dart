import '../l10n/app_localizations.dart';

/// Validation result with optional error message.
class ValidationResult {
  const ValidationResult({
    required this.isValid,
    this.errorMessage,
  });

  final bool isValid;
  final String? errorMessage;

  static const valid = ValidationResult(isValid: true);
}

/// Form validation utilities with localized error messages.
class Validators {
  Validators._();

  /// Validates email address format.
  static ValidationResult email(String? value, {AppLocalizations? l10n}) {
    if (value == null || value.trim().isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage: l10n?.validationEmailRequired ?? 'Email is required',
      );
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return ValidationResult(
        isValid: false,
        errorMessage: l10n?.validationEmailInvalid ?? 'Please enter a valid email address',
      );
    }

    return ValidationResult.valid;
  }

  /// Validates phone number (supports international formats).
  static ValidationResult phone(String? value, {AppLocalizations? l10n}) {
    if (value == null || value.trim().isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage: l10n?.validationPhoneRequired ?? 'Phone number is required',
      );
    }

    // Remove all non-digit characters for validation
    final digits = value.replaceAll(RegExp(r'[\s\-\(\)\.\+]'), '');

    // Check minimum length (at least 8 digits for most countries)
    if (digits.length < 8) {
      return ValidationResult(
        isValid: false,
        errorMessage: l10n?.validationPhoneTooShort ?? 'Phone number is too short',
      );
    }

    // Check maximum length (15 digits is E.164 max)
    if (digits.length > 15) {
      return ValidationResult(
        isValid: false,
        errorMessage: l10n?.validationPhoneTooLong ?? 'Phone number is too long',
      );
    }

    // Check if it's all digits
    if (!RegExp(r'^\d+$').hasMatch(digits)) {
      return ValidationResult(
        isValid: false,
        errorMessage: l10n?.validationPhoneInvalid ?? 'Please enter a valid phone number',
      );
    }

    return ValidationResult.valid;
  }

  /// Validates name (non-empty, reasonable length).
  static ValidationResult name(String? value, {AppLocalizations? l10n}) {
    if (value == null || value.trim().isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage: l10n?.validationNameRequired ?? 'Name is required',
      );
    }

    final trimmed = value.trim();

    if (trimmed.length < 2) {
      return ValidationResult(
        isValid: false,
        errorMessage: l10n?.validationNameTooShort ?? 'Name must be at least 2 characters',
      );
    }

    if (trimmed.length > 100) {
      return ValidationResult(
        isValid: false,
        errorMessage: l10n?.validationNameTooLong ?? 'Name is too long',
      );
    }

    return ValidationResult.valid;
  }

  /// Validates message/description text.
  static ValidationResult message(String? value, {AppLocalizations? l10n}) {
    if (value == null || value.trim().isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage: l10n?.validationMessageRequired ?? 'Message is required',
      );
    }

    final trimmed = value.trim();

    if (trimmed.length < 10) {
      return ValidationResult(
        isValid: false,
        errorMessage: l10n?.validationMessageTooShort ?? 'Message must be at least 10 characters',
      );
    }

    if (trimmed.length > 2000) {
      return ValidationResult(
        isValid: false,
        errorMessage: l10n?.validationMessageTooLong ?? 'Message is too long (maximum 2000 characters)',
      );
    }

    return ValidationResult.valid;
  }

  /// Validates required field (non-empty).
  static ValidationResult required(
    String? value,
    String fieldName, {
    AppLocalizations? l10n,
  }) {
    if (value == null || value.trim().isEmpty) {
      final message = l10n != null ? l10n.validationRequired(fieldName) : '$fieldName is required';
      return ValidationResult(
        isValid: false,
        errorMessage: message,
      );
    }

    return ValidationResult.valid;
  }

  /// Validates date is not in the past.
  static ValidationResult dateNotPast(DateTime? value, {AppLocalizations? l10n}) {
    if (value == null) {
      return ValidationResult(
        isValid: false,
        errorMessage: l10n?.validationDateRequired ?? 'Date is required',
      );
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDate = DateTime(value.year, value.month, value.day);

    if (selectedDate.isBefore(today)) {
      return ValidationResult(
        isValid: false,
        errorMessage: l10n?.validationDateNotPast ?? 'Please select a date in the future',
      );
    }

    return ValidationResult.valid;
  }

  /// Validates time slot is available (basic check).
  static ValidationResult timeSlot(String? value, {AppLocalizations? l10n}) {
    if (value == null || value.trim().isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage: l10n?.validationTimeRequired ?? 'Time slot is required',
      );
    }

    // Basic time format validation (HH:mm)
    final timeRegex = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');
    if (!timeRegex.hasMatch(value.trim())) {
      return ValidationResult(
        isValid: false,
        errorMessage: l10n?.validationTimeInvalid ?? 'Please select a valid time slot',
      );
    }

    return ValidationResult.valid;
  }

  /// Validates password strength.
  /// Returns validation result with strength feedback.
  static ValidationResult password(String? value, {AppLocalizations? l10n}) {
    if (value == null || value.trim().isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage: l10n?.validationPasswordRequired ?? 'Password is required',
      );
    }

    final password = value.trim();
    final errors = <String>[];

    if (password.length < 8) {
      errors.add(l10n?.validationPasswordTooShort ?? 'Password must be at least 8 characters');
    }
    if (password.length > 128) {
      errors.add(l10n?.validationPasswordTooLong ?? 'Password is too long (maximum 128 characters)');
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      errors.add(l10n?.validationPasswordNoUpperCase ?? 'Password must contain at least one uppercase letter');
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      errors.add(l10n?.validationPasswordNoLowerCase ?? 'Password must contain at least one lowercase letter');
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      errors.add(l10n?.validationPasswordNoNumber ?? 'Password must contain at least one number');
    }

    if (errors.isNotEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage: errors.join('. '),
      );
    }

    return ValidationResult.valid;
  }

  /// Validates URL format.
  static ValidationResult url(String? value, {AppLocalizations? l10n}) {
    if (value == null || value.trim().isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage: l10n?.validationUrlRequired ?? 'URL is required',
      );
    }

    final url = value.trim();

    // Basic URL validation regex
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(url)) {
      return ValidationResult(
        isValid: false,
        errorMessage: l10n?.validationUrlInvalid ?? 'Please enter a valid URL (must start with http:// or https://)',
      );
    }

    return ValidationResult.valid;
  }
}
