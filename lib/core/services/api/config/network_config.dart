import 'package:dio/dio.dart';

import '../../../utils/constants.dart';

/// Configuration class for network layer setup.
/// 
/// Provides validated, immutable configuration with sensible defaults.
class NetworkConfig {
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;
  final Map<String, String> defaultHeaders;
  final List<Interceptor> interceptors;
  final bool enableLogging;
  final bool enableRetry;
  final int maxRetries;
  final Duration retryDelay;
  final ResponseType defaultResponseType;
  final ValidateStatus? validateStatus;

  const NetworkConfig({
    required this.baseUrl,
    this.connectTimeout = AppConstants.connectionTimeout,
    this.receiveTimeout = AppConstants.receiveTimeout,
    this.sendTimeout = AppConstants.sendTimeout,
    Map<String, String>? defaultHeaders,
    this.interceptors = const [],
    this.enableLogging = false,
    this.enableRetry = true,
    this.maxRetries = 3,
    this.retryDelay = AppConstants.retryDelay,
    this.defaultResponseType = ResponseType.json,
    this.validateStatus,
  })  : defaultHeaders = defaultHeaders ?? const {},
        assert(maxRetries > 0, 'maxRetries must be positive'),
        assert(maxRetries <= 10, 'maxRetries should not exceed 10');

  /// Validate the configuration
  void validate() {
    if (baseUrl.isEmpty) {
      throw ArgumentError('baseUrl cannot be empty');
    }

    if (!baseUrl.startsWith('http://') && !baseUrl.startsWith('https://')) {
      throw ArgumentError('baseUrl must start with http:// or https://');
    }

    if (connectTimeout.inSeconds <= 0) {
      throw ArgumentError('connectTimeout must be positive');
    }

    if (receiveTimeout.inSeconds <= 0) {
      throw ArgumentError('receiveTimeout must be positive');
    }

    if (sendTimeout.inSeconds <= 0) {
      throw ArgumentError('sendTimeout must be positive');
    }
  }

  /// Create a copy with modified parameters
  NetworkConfig copyWith({
    String? baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    Map<String, String>? defaultHeaders,
    List<Interceptor>? interceptors,
    bool? enableLogging,
    bool? enableRetry,
    int? maxRetries,
    Duration? retryDelay,
    ResponseType? defaultResponseType,
    ValidateStatus? validateStatus,
  }) {
    return NetworkConfig(
      baseUrl: baseUrl ?? this.baseUrl,
      connectTimeout: connectTimeout ?? this.connectTimeout,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
      sendTimeout: sendTimeout ?? this.sendTimeout,
      defaultHeaders: defaultHeaders ?? this.defaultHeaders,
      interceptors: interceptors ?? this.interceptors,
      enableLogging: enableLogging ?? this.enableLogging,
      enableRetry: enableRetry ?? this.enableRetry,
      maxRetries: maxRetries ?? this.maxRetries,
      retryDelay: retryDelay ?? this.retryDelay,
      defaultResponseType: defaultResponseType ?? this.defaultResponseType,
      validateStatus: validateStatus ?? this.validateStatus,
    );
  }
}