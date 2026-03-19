import 'package:get_it/get_it.dart';

import '../services/services.dart';


final sl = GetIt.instance;

void initRepositories() {
  PerformanceService.instance.startOperation('Repositories Init');

  PerformanceService.instance.endOperation('Repositories Init');
}
