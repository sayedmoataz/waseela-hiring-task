import 'app_strings.dart';

/// Form Validators
/// Provides validation functions for common form fields
/// Context-free validators that can be used in any layer of the application
class Validators {
  // Private constructor to prevent instantiation
  Validators._();

  /// Validates if field is not empty
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired(fieldName ?? 'This field');
    }
    return null;
  }

  /// Validates minimum length
  static String? minLength(String? value, int length, {String? fieldName}) {
    final field = fieldName ?? 'This field';
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired(field);
    }

    if (value.length < length) {
      return AppStrings.minLength(field, length);
    }

    return null;
  }

  /// Validates maximum length
  static String? maxLength(String? value, int length, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (value.length > length) {
      return AppStrings.maxLength(fieldName ?? 'This field', length);
    }

    return null;
  }

  /// Validates numeric input
  static String? numeric(String? value, {String? fieldName}) {
    final field = fieldName ?? 'This field';
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired(field);
    }

    if (double.tryParse(value) == null) {
      return AppStrings.mustBeNumber(field);
    }

    return null;
  }

  /// Validates date format (dd/MM/yyyy)
  static String? date(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.dateRequired;
    }

    final dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');

    if (!dateRegex.hasMatch(value)) {
      return AppStrings.dateFormat;
    }

    final parts = value.split('/');
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) {
      return AppStrings.dateInvalid;
    }

    if (month < 1 || month > 12) {
      return AppStrings.dateMonthInvalid;
    }

    if (day < 1 || day > 31) {
      return AppStrings.dateDayInvalid;
    }

    return null;
  }

  /// Combines multiple validators
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) {
          return result;
        }
      }
      return null;
    };
  }
}
