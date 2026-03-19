import 'dart:async';

import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../network/network_info.dart';
import '../contracts/api_consumer.dart';

/// Manages a queue of API requests for offline-first handling.
/// Requests are queued when offline and processed automatically when connectivity resumes.
class RequestQueue {
  final NetworkInfo _networkInfo;
  final List<PendingRequest> _queue = [];
  StreamSubscription<InternetConnectionStatus>? _connectivitySubscription;
  bool _isProcessing = false;
  ApiConsumer? _consumer;

  RequestQueue(this._networkInfo) {
    _listenToConnectivity();
  }

  /// Get the API consumer used for processing queued requests
  ApiConsumer? get consumer => _consumer;

  /// Set the API consumer to use for processing queued requests
  set consumer(ApiConsumer consumer) => _consumer = consumer;

  void _listenToConnectivity() {
    _connectivitySubscription = _networkInfo.onStatusChange.listen((status) {
      if (status == InternetConnectionStatus.connected && _queue.isNotEmpty) {
        processQueue();
      }
    });
  }

  /// Enqueue a request to be processed when online
  /// Returns a Future that completes when the request is processed
  Future<T> enqueue<T>(QueuedRequest<T> request) {
    final completer = Completer<T>();
    _queue.add(PendingRequest<T>(request: request, completer: completer));

    // Try to process immediately if online
    _tryProcessQueue();

    return completer.future;
  }

  Future<void> _tryProcessQueue() async {
    if (await _networkInfo.isConnected) {
      processQueue();
    }
  }

  /// Process all queued requests
  Future<void> processQueue() async {
    if (_consumer == null || _isProcessing || _queue.isEmpty) return;

    _isProcessing = true;

    while (_queue.isNotEmpty) {
      final pending = _queue.first;

      try {
        final result = await _executeRequest(pending.request);
        _queue.removeAt(0);
        pending.complete(result);
      } catch (e) {
        // Check if still online
        final isConnected = await _networkInfo.isConnected;
        if (!isConnected) {
          // Stop processing, will resume when back online
          break;
        }
        // If online but failed, reject and remove
        _queue.removeAt(0);
        pending.completeError(e);
      }
    }

    _isProcessing = false;
  }

  Future<dynamic> _executeRequest(QueuedRequest request) async {
    final consumer = _consumer!;

    switch (request.method.toUpperCase()) {
      case 'GET':
        final result = await consumer.get(
          endpoint: request.endpoint,
          queryParameters: request.queryParameters,
          converter: request.converter,
        );
        return result.fold((l) => throw l, (r) => r);
      case 'POST':
        final result = await consumer.post(
          endpoint: request.endpoint,
          data: request.data,
          queryParameters: request.queryParameters,
          converter: request.converter,
        );
        return result.fold((l) => throw l, (r) => r);
      default:
        throw UnsupportedError('HTTP method ${request.method} not supported');
    }
  }

  /// Clear all pending requests
  void clear() {
    for (final pending in _queue) {
      pending.completeError(Exception('Request queue cleared'));
    }
    _queue.clear();
  }

  /// Dispose of resources
  void dispose() {
    _connectivitySubscription?.cancel();
    clear();
  }

  bool get isEmpty => _queue.isEmpty;
  int get length => _queue.length;
  bool get isProcessing => _isProcessing;
}

/// Represents a request to be queued
class QueuedRequest<T> {
  final String endpoint;
  final String method;
  final dynamic data;
  final Map<String, dynamic>? queryParameters;
  final T Function(dynamic) converter;

  const QueuedRequest({
    required this.endpoint,
    required this.method,
    required this.converter,
    this.data,
    this.queryParameters,
  });
}

/// Internal class to track pending requests with their completers
class PendingRequest<T> {
  final QueuedRequest<T> request;
  final Completer<T> completer;

  PendingRequest({required this.request, required this.completer});

  void complete(dynamic result) {
    if (!completer.isCompleted) {
      completer.complete(result as T);
    }
  }

  void completeError(dynamic error) {
    if (!completer.isCompleted) {
      completer.completeError(error);
    }
  }
}
