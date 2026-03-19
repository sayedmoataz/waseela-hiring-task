import 'package:dio/dio.dart';

/// Interceptor that manages request cancellation.
/// 
/// Features:
/// - Automatic cancel token creation per request
/// - Proper cleanup on completion/error
/// - Cancel all pending requests capability
/// - Cancel by tag support
class CancellationInterceptor extends Interceptor {
  final Map<String, CancelToken> _cancelTokensByPath = {};
  final Map<String, Set<CancelToken>> _cancelTokensByTag = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Create a new cancel token for this request
    final cancelToken = CancelToken();
    
    // Store by path
    final requestKey = _generateRequestKey(options);
    _cancelTokensByPath[requestKey] = cancelToken;

    // Store by tag if provided
    final tag = options.extra['cancelTag'] as String?;
    if (tag != null) {
      _cancelTokensByTag.putIfAbsent(tag, () => {}).add(cancelToken);
    }

    // Assign cancel token to the request
    options.cancelToken = cancelToken;

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _cleanup(response.requestOptions);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _cleanup(err.requestOptions);
    handler.next(err);
  }

  /// Clean up cancel tokens after request completion
  void _cleanup(RequestOptions options) {
    final requestKey = _generateRequestKey(options);
    final cancelToken = _cancelTokensByPath.remove(requestKey);

    // Remove from tag mapping if exists
    final tag = options.extra['cancelTag'] as String?;
    if (tag != null && cancelToken != null) {
      _cancelTokensByTag[tag]?.remove(cancelToken);
      if (_cancelTokensByTag[tag]?.isEmpty ?? false) {
        _cancelTokensByTag.remove(tag);
      }
    }
  }

  /// Generate a unique key for the request
  String _generateRequestKey(RequestOptions options) {
    return '${options.method}_${options.path}_${options.hashCode}';
  }

  /// Cancel all pending requests
  void cancelAll([String? reason]) {
    final cancelReason = reason ?? 'All requests cancelled';

    for (final token in _cancelTokensByPath.values) {
      if (!token.isCancelled) {
        token.cancel(cancelReason);
      }
    }

    _cancelTokensByPath.clear();
    _cancelTokensByTag.clear();
  }

  /// Cancel all requests with a specific tag
  void cancelByTag(String tag, [String? reason]) {
    final tokens = _cancelTokensByTag[tag];
    if (tokens == null) return;

    final cancelReason = reason ?? 'Requests with tag "$tag" cancelled';

    for (final token in tokens) {
      if (!token.isCancelled) {
        token.cancel(cancelReason);
      }
    }

    _cancelTokensByTag.remove(tag);
    
    // Clean up from path mapping
    _cancelTokensByPath.removeWhere((_, token) => tokens.contains(token));
  }

  /// Get count of pending requests
  int get pendingRequestCount => _cancelTokensByPath.length;

  /// Get count of pending requests by tag
  int getPendingCountByTag(String tag) {
    return _cancelTokensByTag[tag]?.length ?? 0;
  }

  /// Check if there are any pending requests
  bool get hasPendingRequests => _cancelTokensByPath.isNotEmpty;
}