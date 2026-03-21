import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../network/network_info.dart';
import '../services/navigation/navigation_service.dart';
import '../services/performance/performance_service.dart';

import 'services/api_injection.dart';
import 'services/biometric_injection.dart';
import 'services/local_storage_injection.dart';
import 'injection_container.config.dart';

final sl = GetIt.instance;

@Singleton()
class InjectionContainer {
  static Future<void> init() async {
    sl.registerLazySingleton<PerformanceService>(PerformanceService.new);

    sl.registerLazySingleton<NavigationService>(
      () => NavigationService.instance,
    );
    sl.registerLazySingleton(InternetConnectionChecker.createInstance);
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

    await dotenv.load();
    await initLocalStorage();
    await initBiometric();
    initNetworking();

    PerformanceService.instance.startOperation('Injectable Init');
    configureDependencies();
    PerformanceService.instance.endOperation('Injectable Init');
  }
}

@InjectableInit(
  initializerName: 'configureDependencies',
  preferRelativeImports: true,
)
Future<void> configureDependencies() async => sl.configureDependencies();
