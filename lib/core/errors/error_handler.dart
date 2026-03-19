import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../services/api/config/constants.dart';
import 'failure.dart';

class ErrorHandler {
  static ErrorHandlerConfig? errorHandlerConfig;

  /// Configure error handler (call this in main.dart or DI setup)
  static void configure(ErrorHandlerConfig config) {
    errorHandlerConfig = config;
  }

  /// Main error handling entry point
  static Failure handle(dynamic error, {StackTrace? stackTrace}) {
    // Log error if callback configured
    errorHandlerConfig?.onLogError?.call(error, stackTrace, {
      'error_type': error.runtimeType.toString(),
      'message': error.toString(),
    });

    if (error is DioException) {
      return _handleDioError(error);
    }

    if (error is HiveError) {
      return _handleHiveError(error);
    }

    // Handle common exceptions
    if (error is FormatException) {
      return ParseFailure(message: error.message);
    }

    if (error is TypeError) {
      return const ParseFailure(
        message: 'Data type mismatch during deserialization',
      );
    }

    return UnknownFailure(
      message: error.toString().isNotEmpty
          ? error.toString()
          : 'An unexpected error occurred.',
    );
  }

  static Failure _handleHiveError(HiveError error) {
    // Log detailed Hive error
    errorHandlerConfig?.onLogError?.call(error, error.stackTrace, {
      'message': error.message,
    });

    return HiveFailure(message: error.message);
  }

  static Failure _handleDioError(DioException error) {
    // Log detailed Dio error
    errorHandlerConfig?.onLogError?.call(error, error.stackTrace, {
      'dio_type': error.type.name,
      'path': error.requestOptions.path,
      'method': error.requestOptions.method,
      'status_code': error.response?.statusCode,
      'response_data': error.response?.data?.toString(),
    });

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return const TimeoutFailure(type: TimeoutType.connect);

      case DioExceptionType.sendTimeout:
        return const TimeoutFailure(type: TimeoutType.send);

      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure(type: TimeoutType.receive);

      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);

      case DioExceptionType.cancel:
        return const CancelFailure();

      case DioExceptionType.connectionError:
        return const NetworkFailure();

      default:
        return UnknownFailure(
          message: error.message ?? 'An unexpected error occurred.',
        );
    }
  }

  static Failure _handleBadResponse(Response? response) {
    if (response == null) {
      return const UnknownFailure(message: 'No response received from server.');
    }

    final statusCode =
        response.statusCode ?? ResponseCode.defaultError;
    final errorMessage =
        _extractErrorMessage(response.data) ??
        'Server error (Status: $statusCode)';

    // Handle 401 - Unauthorized using ResponseCode constant
    if (statusCode == ResponseCode.unauthorized) {
      errorHandlerConfig?.onUnauthorized?.call();
      return UnauthorizedFailure(message: errorMessage);
    }

    // Show error toast for non-401 errors (if configured)
    if (errorHandlerConfig?.onShowError != null &&
        errorMessage.isNotEmpty &&
        !_shouldSuppressError(response)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        errorHandlerConfig?.onShowError?.call(errorMessage);
      });
    }

    // Map status codes to typed failures using ResponseCode constants
    return switch (statusCode) {
      ResponseCode.badRequest => ServerFailure(
        message: errorMessage,
        code: statusCode,
      ),
      ResponseCode.forbidden => ForbiddenFailure(
        message: errorMessage,
      ),
      ResponseCode.notFound => NotFoundFailure(
        message: errorMessage,
      ),
      ResponseCode.validationError => ValidationFailure(
        message: errorMessage,
        errors: response.data is Map<String, dynamic> ? response.data : null,
      ),
      >= ResponseCode.internalServerError && < 600 => ServerFailure(
        message: errorMessage,
        code: statusCode,
      ),
      _ => ServerFailure(message: errorMessage, code: statusCode),
    };
  }

  /// Extract user-friendly error message from response
  static String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;

    if (data is Map<String, dynamic>) {
      const possibleKeys = [
        'message',
        'error',
        'errors',
        'detail',
        'msg',
        'description',
        'info',
        'status_message',
      ];

      for (var key in possibleKeys) {
        if (data.containsKey(key)) {
          final value = data[key];
          if (value is String && value.isNotEmpty) {
            return value;
          } else if (value is List && value.isNotEmpty) {
            return value.join('\n');
          } else if (value is Map<String, dynamic>) {
            return _extractErrorMessage(value);
          }
        }
      }

      // Recursively search nested maps
      for (var value in data.values) {
        if (value is Map<String, dynamic>) {
          final nestedMessage = _extractErrorMessage(value);
          if (nestedMessage != null) return nestedMessage;
        }
      }
    } else if (data is String && data.isNotEmpty) {
      return data;
    } else if (data is List && data.isNotEmpty) {
      return data.join('\n');
    }

    return null;
  }

  /// Check if error should be suppressed (endpoint-specific logic)
  static bool _shouldSuppressError(Response response) {
    // Example: Suppress "No active subscription" errors
    if (response.requestOptions.path.contains('/subscriptions')) {
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if (data['detail'] == 'No active subscription.') {
          return true;
        }
      }
    }
    return false;
  }
}

class ErrorHandlerConfig {
  final void Function(String message)? onShowError;
  final Future<void> Function()? onUnauthorized;
  final void Function(dynamic error, StackTrace?, Map<String, dynamic>)?
  onLogError;
  final Map<String, bool Function(Response)>? suppressionRules;
  final Map<int, String>? customStatusMessages;

  const ErrorHandlerConfig({
    this.onShowError,
    this.onUnauthorized,
    this.onLogError,
    this.suppressionRules,
    this.customStatusMessages,
  });
}
