import 'package:dio/dio.dart';

import '../config/error_logging_config.dart';
import '../config/network_config.dart';
import '../contracts/api_consumer.dart';
import '../implementation/dio_consumer.dart';
import '../interceptors/cancellation_interceptor.dart';
import '../interceptors/error_logging_interceptor.dart';
import '../interceptors/retry_interceptor.dart';

/// Factory for creating configured ApiConsumer instances.

class NetworkServiceFactory {
  /// Create a fully configured ApiConsumer instance
  static ApiConsumer create({
    required NetworkConfig config,
    ErrorLoggingConfig? errorLogging,
  }) {
    final interceptors = <Interceptor>[];

    // Create cancellation interceptor (needed by DioConsumer)
    final cancellationInterceptor = CancellationInterceptor();

    // Add retry interceptor
    if (config.enableRetry) {
      interceptors.add(
        RetryInterceptor(
          dio: Dio(),
          maxRetries: config.maxRetries,
          initialDelay: config.retryDelay,
        ),
      );
    }

    // Add error logging interceptor
    if (errorLogging != null) {
      interceptors.add(
        ErrorLoggingInterceptor(logError: errorLogging.logError),
      );
    }

    // Create config with all interceptors
    final finalConfig = config.copyWith(
      interceptors: [...interceptors, ...config.interceptors],
    );

    return DioConsumer(
      finalConfig,
      cancellationInterceptor: cancellationInterceptor,
    );
  }
}
