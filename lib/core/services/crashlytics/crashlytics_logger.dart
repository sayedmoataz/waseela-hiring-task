import 'package:flutter/material.dart';

import '../../config/app_config.dart';

class CrashlyticsLogger {
  CrashlyticsLogger._();

  /// Logs an error with contextual information.
  /// In production → would send to Crashlytics.
  /// In debug mode → prints detailed formatted log.
  ///
  /// - [error]: The error or exception to log.
  /// - [stackTrace]: The stack trace associated with the error.
  /// - [reason]: A brief description of why the error occurred.
  /// - [feature]: The feature or module name (e.g., 'bnpl_checkout').
  /// - [context]: Additional context tags (e.g., ['endpoint:/orders', 'userId:123']).
  /// - [fatal]: Whether the error is fatal (defaults to false).
  static void logError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
    String? feature,
    List<String> context = const [],
    bool fatal = false,
  }) {
    if (!AppConfig.enableLogging) return;

    final buffer = StringBuffer();

    buffer.writeln('┌─────────────────────────────────────────');
    buffer.writeln('│ 🔴 ERROR LOG ${fatal ? '[FATAL]' : '[NON-FATAL]'}');
    buffer.writeln('├─────────────────────────────────────────');

    if (feature != null) {
      buffer.writeln('│ 📦 Feature   : $feature');
    }

    if (reason != null) {
      buffer.writeln('│ 💬 Reason    : $reason');
    }

    buffer.writeln('│ ❌ Error     : $error');
    buffer.writeln('│ 🕐 Time      : ${DateTime.now().toIso8601String()}');

    if (context.isNotEmpty) {
      buffer.writeln('│ 🏷️  Context   :');
      for (final tag in context) {
        buffer.writeln('│    • $tag');
      }
    }

    if (stackTrace != null) {
      buffer.writeln('├─────────────────────────────────────────');
      buffer.writeln('│ 📋 StackTrace:');
      // Print only first 5 lines to avoid flooding the console
      final lines = stackTrace.toString().trim().split('\n');
      for (final line in lines.take(5)) {
        buffer.writeln('│   $line');
      }
      if (lines.length > 5) {
        buffer.writeln('│   ... (${lines.length - 5} more lines)');
      }
    }

    buffer.writeln('└─────────────────────────────────────────');

    debugPrint(buffer.toString());
  }

  /// Logs an informational message (non-error).
  static void logInfo(String message, {String? feature}) {
    if (!AppConfig.enableLogging) return;

    debugPrint(
      '┌─────────────────────────────────────────\n'
      '│ ℹ️  INFO ${feature != null ? '[$feature]' : ''}\n'
      '│ $message\n'
      '└─────────────────────────────────────────',
    );
  }
}

