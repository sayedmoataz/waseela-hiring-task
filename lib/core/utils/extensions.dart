import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/colors.dart';
import 'app_strings.dart';

/// String Extensions
extension StringExtension on String {
  /// Capitalizes first letter of the string
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalizes first letter of each word
  String capitalizeWords() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  /// Checks if string is a valid email
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Checks if string is a valid phone number
  bool get isValidPhone {
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    return phoneRegex.hasMatch(this);
  }

  /// Checks if string is a valid URL
  bool get isValidUrl {
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    return urlRegex.hasMatch(this);
  }

  /// Removes all whitespace from string
  String removeWhitespace() {
    return replaceAll(RegExp(r'\s+'), '');
  }

  /// Truncates string to specified length with ellipsis
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$ellipsis';
  }

  /// Cleans phone number by removing non-digit characters except +
  String get cleanPhoneNumber => replaceAll(RegExp(r'[^\d+]'), '');

  /// Adds commas to the number
  String addCommas() {
    final number = num.tryParse(this);
    if (number == null) return this;
    return NumberFormat.decimalPattern().format(number);
  }
}

/// DateTime Extensions
extension DateTimeExtension on DateTime {
  /// Formats date as 'dd/MM/yyyy'
  String get formattedDate {
    return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
  }

  /// Formats time as 'HH:mm'
  String get formattedTime {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  /// Formats datetime as 'dd/MM/yyyy HH:mm'
  String get formattedDateTime {
    return '$formattedDate $formattedTime';
  }

  /// Checks if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Checks if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Returns time ago string (e.g., '2 hours ago')
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return AppStrings.timeAgoYears(years);
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return AppStrings.timeAgoMonths(months);
    } else if (difference.inDays > 0) {
      final days = difference.inDays;
      return AppStrings.timeAgoDays(days);
    } else if (difference.inHours > 0) {
      final hours = difference.inHours;
      return AppStrings.timeAgoHours(hours);
    } else if (difference.inMinutes > 0) {
      final minutes = difference.inMinutes;
      return AppStrings.timeAgoMinutes(minutes);
    } else {
      return AppStrings.timeAgoJustNow;
    }
  }

  /// Returns compact time ago string (e.g., '2d', '3h', '5m')
  /// Useful for UI elements with limited space
  String get timeAgoShort {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Now';
    }
  }

  /// Returns time ago with custom localized label for days
  /// Example: timeAgoWithLabel('days') returns '2 days'
  String timeAgoWithLabel(String daysLabel) {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 0) {
      return '${difference.inDays} $daysLabel';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Now';
    }
  }
}

/// List Extensions
extension ListExtension<T> on List<T> {
  /// Returns true if list is null or empty
  bool get isNullOrEmpty => isEmpty;

  /// Returns true if list is not null and not empty
  bool get isNotNullOrEmpty => isNotEmpty;

  /// Returns first element or null if list is empty
  T? get isFirstOrNull => isEmpty ? null : first;

  /// Returns last element or null if list is empty
  T? get isLastOrNull => isEmpty ? null : last;
}

/// Color Extensions
extension ColorExtension on String {
  Color toColor() {
    try {
      final hex = replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return AppColors.primary;
    }
  }
}

// Bnpl Num Extensions
extension BnplNumExtension on num {
  String toEGP() => 'EGP ${toStringAsFixed(2)}';
  String toInstallmentLabel(int months) => '${toEGP()} × $months months';
}

// BuildContext Extensions
extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
}