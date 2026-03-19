import 'package:dio/dio.dart';

/// Interceptor that logs errors with contextual information.

class ErrorLoggingInterceptor extends Interceptor {
  final void Function(
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic> context,
  )? logError;

  ErrorLoggingInterceptor({this.logError});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (logError != null) {
      final context = _buildErrorContext(err);
      logError!(err, err.stackTrace, context);
    }
    
    handler.next(err);
  }

  /// Build a detailed context map for the error
  Map<String, dynamic> _buildErrorContext(DioException err) {
    return {
      // Request information
      'path': err.requestOptions.path,
      'method': err.requestOptions.method,
      'base_url': err.requestOptions.baseUrl,
      'full_url': err.requestOptions.uri.toString(),
      
      // Error details
      'error_type': err.type.name,
      'error_message': err.message,
      
      // Response information (if available)
      'status_code': err.response?.statusCode,
      'status_message': err.response?.statusMessage,
      'response_data': _sanitizeResponseData(err.response?.data),
      
      // Request data (sanitized for sensitive information)
      'request_data': _sanitizeRequestData(err.requestOptions.data),
      'query_parameters': err.requestOptions.queryParameters,
      
      // Timing
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Sanitize response data to avoid logging sensitive information
  dynamic _sanitizeResponseData(dynamic data) {
    if (data == null) return null;
    
    // Limit size to prevent logging huge responses
    final dataString = data.toString();
    if (dataString.length > 1000) {
      return '${dataString.substring(0, 1000)}... (truncated)';
    }
    
    return data;
  }

  /// Sanitize request data to avoid logging passwords, tokens, etc.
  dynamic _sanitizeRequestData(dynamic data) {
    if (data == null) return null;
    
    if (data is Map) {
      final sanitized = Map<String, dynamic>.from(data);
      
      // List of sensitive field names to redact
      const sensitiveFields = [
        'password',
        'token',
        'secret',
        'api_key',
        'apiKey',
        'access_token',
        'refresh_token',
        'credit_card',
        'ssn',
      ];
      
      for (final field in sensitiveFields) {
        if (sanitized.containsKey(field)) {
          sanitized[field] = '***REDACTED***';
        }
      }
      
      return sanitized;
    }
    
    return data;
  }
}