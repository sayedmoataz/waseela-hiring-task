import 'package:flutter/material.dart';

class AppStrings {
  final BuildContext _context;

  AppStrings._(this._context);

  static AppStrings of(BuildContext context) => AppStrings._(context);

  // ===========================================================================
  // VALIDATION STRINGS (Static for use in static Validators)
  // ===========================================================================

  // Generic
  static String fieldRequired(String fieldName) => '$fieldName is required';
  static String minLength(String fieldName, int length) =>
      '$fieldName must be at least $length characters';
  static String maxLength(String fieldName, int length) =>
      '$fieldName must not exceed $length characters';
  static String mustBeNumber(String fieldName) =>
      '$fieldName must be a valid number';
  static String get defaultRequired => 'This field is required';

  // Date
  static const String dateRequired = 'Date is required';
  static const String dateFormat = 'Date must be in dd/MM/yyyy format';
  static const String dateInvalid = 'Invalid date';
  static const String dateMonthInvalid = 'Invalid month';
  static const String dateDayInvalid = 'Invalid day';

  // Time Ago
  static String timeAgoYears(int count) =>
      count == 1 ? '1 year ago' : '$count years ago';
  static String timeAgoMonths(int count) =>
      count == 1 ? '1 month ago' : '$count months ago';
  static String timeAgoDays(int count) =>
      count == 1 ? '1 day ago' : '$count days ago';
  static String timeAgoHours(int count) =>
      count == 1 ? '1 hour ago' : '$count hours ago';
  static String timeAgoMinutes(int count) =>
      count == 1 ? '1 minute ago' : '$count minutes ago';
  static const String timeAgoJustNow = 'Just now';

  String get openSettings => 'Open Settings';

  static const String enableBiometricLogin =
      'Enable biometric login for quick and secure access';
  static const String biometricAuthenticationFailed =
      'Biometric authentication failed';
}
