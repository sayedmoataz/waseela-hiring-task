
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../network/network_info.dart';
import '../services/navigation/navigation_service.dart';
import '../services/performance/performance_service.dart';
import 'blocs_injections.dart';
import 'datasources_injections.dart';
import 'repositories_injections.dart';
import 'services/api_injection.dart';
import 'services/biometric_injection.dart';
import 'services/local_storage_injection.dart';

final sl = GetIt.instance;

/// Initialize essential services before app render
/// These are critical services needed for the app to start
Future<void> initEssentialServices() async {
  PerformanceService.instance.startOperation('Essential Services Init');

  //! Core Services
  sl.registerLazySingleton<PerformanceService>(
    () => PerformanceService.instance,
  );
  sl.registerLazySingleton<NavigationService>(() => NavigationService.instance);

  //! Network
  sl.registerLazySingleton(InternetConnectionChecker.createInstance);
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! Local Storage (Hive)
  await initLocalStorage();

  //! Biometric
  await initBiometric();

  initNetworking();

  //! DataSources
  initDataSources();

  //! Repositories
  initRepositories();

  //! BLoCs / Cubits
  initBlocs();

  PerformanceService.instance.endOperation('Essential Services Init');
}
