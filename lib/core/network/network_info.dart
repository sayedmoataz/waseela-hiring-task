import 'package:internet_connection_checker/internet_connection_checker.dart';

/// Network Information Interface
/// Provides network connectivity status
abstract class NetworkInfo {
  /// Checks if device is connected to internet
  Future<bool> get isConnected;

  /// Stream of connectivity changes (broadcast, shared across listeners)
  Stream<InternetConnectionStatus> get onStatusChange;
}

/// Implementation of NetworkInfo using internet_connection_checker.
///
/// The [onStatusChange] stream is converted to a **broadcast stream**
/// and cached so that all subscribers (ConnectivityWrapper, RequestQueue,
/// NotificationStatusService) share the same underlying stream instead of
/// each triggering independent connectivity checks.
class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  /// Cached broadcast stream – created lazily on first access.
  late final Stream<InternetConnectionStatus> _statusStream = connectionChecker
      .onStatusChange
      .asBroadcastStream();

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;

  @override
  Stream<InternetConnectionStatus> get onStatusChange => _statusStream;
}
