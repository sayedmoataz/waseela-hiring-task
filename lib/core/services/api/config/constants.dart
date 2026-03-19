/// HTTP and custom response codes used throughout the network layer.
/// 
/// Centralized constants to ensure consistency and avoid magic numbers.
class ResponseCode {
  ResponseCode._();

  // ============= SUCCESS CODES =============
  /// Standard success response
  static const int success = 200;
  
  /// Resource created successfully
  static const int created = 201;
  
  /// Request processed but no content to return
  static const int noContent = 204;

  // ============= CLIENT ERROR CODES =============
  /// Invalid request syntax
  static const int badRequest = 400;
  
  /// Authentication required or failed
  static const int unauthorized = 401;
  
  /// Authenticated but not authorized
  static const int forbidden = 403;
  
  /// Resource not found
  static const int notFound = 404;
  
  /// Request conflicts with current state
  static const int conflict = 409;
  
  /// Request timeout
  static const int requestTimeout = 408;
  
  /// Too many requests (rate limiting)
  static const int tooManyRequests = 429;
  
  /// Validation failed
  static const int validationError = 422;

  // ============= SERVER ERROR CODES =============
  /// Generic server error
  static const int internalServerError = 500;
  
  /// Bad gateway
  static const int badGateway = 502;
  
  /// Service unavailable (temporary)
  static const int serviceUnavailable = 503;
  
  /// Gateway timeout
  static const int gatewayTimeout = 504;

  // ============= CUSTOM LOCAL CODES =============
  /// Connection timeout
  static const int connectTimeout = -1;
  
  /// Request cancelled
  static const int cancel = -2;
  
  /// Receive timeout
  static const int receiveTimeout = -3;
  
  /// Send timeout
  static const int sendTimeout = -4;
  
  /// Cache error
  static const int cacheError = -5;
  
  /// No internet connection
  static const int noInternetConnection = -6;
  
  /// Default/unknown error
  static const int defaultError = -7;

  // ============= HELPER METHODS =============
  
  /// Check if status code indicates success (2xx range)
  static bool isSuccess(int? statusCode) {
    return statusCode != null && statusCode >= 200 && statusCode < 300;
  }
  
  /// Check if status code is a client error (4xx range)
  static bool isClientError(int? statusCode) {
    return statusCode != null && statusCode >= 400 && statusCode < 500;
  }
  
  /// Check if status code is a server error (5xx range)
  static bool isServerError(int? statusCode) {
    return statusCode != null && statusCode >= 500 && statusCode < 600;
  }
  
  /// Check if status code is retryable
  static bool isRetryable(int? statusCode) {
    return statusCode != null && _retryableStatusCodes.contains(statusCode);
  }
  
  /// Status codes that should trigger automatic retry
  static const Set<int> _retryableStatusCodes = {
    requestTimeout,
    tooManyRequests,
    internalServerError,
    badGateway,
    serviceUnavailable,
    gatewayTimeout,
  };
  
  /// Get a set of retryable status codes
  static Set<int> get retryableStatusCodes => _retryableStatusCodes;
}