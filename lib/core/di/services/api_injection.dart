import '../../config/app_config.dart';
import '../../di/injection_container.dart';
import '../../network/network_info.dart';
import '../../services/api/config/error_logging_config.dart';
import '../../services/api/config/network_config.dart';
import '../../services/api/contracts/api_consumer.dart';
import '../../services/api/factory/network_service_factory.dart';
import '../../services/api/request_handler/request_queue.dart';
import '../../services/services.dart';

Future<void> initNetworking() async {
  PerformanceService.instance.startOperation('API Networking Init');

  final apiConsumer = NetworkServiceFactory.create(
    config: NetworkConfig(
      baseUrl: AppConfig.baseUrl,
      enableLogging: AppConfig.enableLogging,
    ),
    errorLogging: ErrorLoggingConfig(
      logError: (error, stackTrace, context) {
        CrashlyticsLogger.logError(
          error,
          stackTrace,
          reason: 'Network error: ${context['path']}',
        );
      },
    ),
  );

  sl.registerLazySingleton<ApiConsumer>(() => apiConsumer);

  // Register RequestQueue with NetworkInfo for auto-processing on reconnect
  final requestQueue = RequestQueue(sl<NetworkInfo>());
  requestQueue.consumer = apiConsumer;
  sl.registerLazySingleton<RequestQueue>(() => requestQueue);

  PerformanceService.instance.endOperation('API Networking Init');
}
