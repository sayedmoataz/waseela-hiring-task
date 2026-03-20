import 'package:flutter/material.dart';

import '../../features/bnpl/domain/entities/repayment_schedule_entry.dart';

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
}

// Bnpl Num Extensions
extension BnplNumExtension on num {
  static List<RepaymentScheduleEntry> generateSchedule({
    required int months,
    required double monthlyAmount,
    DateTime? startDate,
  }) {
    final start = startDate ?? DateTime.now();

    return List.generate(months, (index) {
      final dueDate = DateTime(start.year, start.month + index + 1, start.day);

      return RepaymentScheduleEntry(
        installmentNumber: index + 1,
        dueDate: dueDate,
        amount: monthlyAmount,
      );
    });
  }
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
