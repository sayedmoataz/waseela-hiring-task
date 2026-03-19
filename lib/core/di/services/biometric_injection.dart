import '../../config/app_config.dart';
import '../../services/local_storage/contracts/hive_consumer.dart';
import '../../services/services.dart';
import '../injection_container.dart';

Future<void> initBiometric() async {
  PerformanceService.instance.startOperation('Biometric Init');
  sl.registerLazySingleton<BiometricConsumer>(
    () => BiometricFactory.create(enableLogging: AppConfig.enableLogging),
  );

  sl.registerLazySingleton<BiometricPreferences>(
    () => BiometricPreferences(sl<HiveConsumer>()),
  );
  PerformanceService.instance.endOperation('Biometric Init');
}
