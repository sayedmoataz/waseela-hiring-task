import 'package:dio/dio.dart';

import '../config/constants.dart';

/// Interceptor that automatically retries failed requests based on:
/// - Connection/timeout errors
/// - Specific HTTP status codes (408, 429, 500, 502, 503, 504)
///
/// Uses exponential backoff for retries.
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration initialDelay;
  final Set<int> retryableStatusCodes;
  final bool useExponentialBackoff;
  final Dio dio;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.initialDelay = const Duration(seconds: 1),
    Set<int>? retryableStatusCodes,
    this.useExponentialBackoff = true,
  }) : retryableStatusCodes =
           retryableStatusCodes ?? ResponseCode.retryableStatusCodes;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final extra = err.requestOptions.extra;
    final retries = extra['retries'] as int? ?? 0;

    if (retries >= maxRetries) {
      return handler.next(err);
    }

    if (!_shouldRetry(err)) {
      return handler.next(err);
    }

    // Increment retry count
    extra['retries'] = retries + 1;

    // Calculate delay with exponential backoff
    final delay = _calculateDelay(retries);
    await Future.delayed(delay);

    try {
      final response = await dio.fetch(err.requestOptions);
      return handler.resolve(response);
    } on DioException catch (e) {
      // Continue to next retry or fail
      return handler.next(e);
    }
  }

  /// Determine if the error should trigger a retry
  bool _shouldRetry(DioException err) {
    // Retry on connection/timeout errors
    if (_isConnectionError(err.type)) {
      return true;
    }

    // Retry on specific HTTP status codes
    final statusCode = err.response?.statusCode;
    if (statusCode != null && retryableStatusCodes.contains(statusCode)) {
      return true;
    }

    return false;
  }

  /// Check if the error is a connection-related error
  bool _isConnectionError(DioExceptionType type) {
    return type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.receiveTimeout ||
        type == DioExceptionType.sendTimeout;
  }

  /// Calculate retry delay with optional exponential backoff
  Duration _calculateDelay(int retryCount) {
    if (!useExponentialBackoff) {
      return initialDelay;
    }

    // Exponential backoff: initialDelay * 2^retryCount
    final multiplier = 1 << retryCount; // Equivalent to 2^retryCount
    return initialDelay * multiplier;
  }
}
