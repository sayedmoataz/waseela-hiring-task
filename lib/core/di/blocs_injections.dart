import 'package:get_it/get_it.dart';

import '../services/services.dart';


final sl = GetIt.instance;

void initBlocs() {
  PerformanceService.instance.startOperation('BLoCs Init');

  PerformanceService.instance.endOperation('BLoCs Init');
}
