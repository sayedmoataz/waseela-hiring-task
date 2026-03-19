import 'package:get_it/get_it.dart';
import '../services/services.dart';

final sl = GetIt.instance;

void initDataSources() {
  PerformanceService.instance.startOperation('DataSources Init');

  PerformanceService.instance.endOperation('DataSources Init');
}
