import 'package:injectable/injectable.dart';
import '../../features/bnpl/data/datasources/local/bnpl_local_datasource.dart';
import '../../features/bnpl/data/datasources/local/bnpl_local_datasource_impl.dart';
import '../../features/bnpl/data/datasources/remote/bnpl_remote_datasource.dart';
import '../../features/bnpl/data/datasources/remote/bnpl_remote_datasource_impl.dart';
import '../services/api/contracts/api_consumer.dart';
import '../services/local_storage/contracts/hive_consumer.dart';
import 'injection_container.dart';

@module
abstract class BnplDatasourcesModule {
  @LazySingleton(as: BnplRemoteDatasource)
  BnplRemoteDatasourceImpl get bnplRemoteDatasource =>
      BnplRemoteDatasourceImpl(sl<ApiConsumer>());

  @LazySingleton(as: BnplLocalDatasource)
  BnplLocalDatasourceImpl get bnplLocalDatasource =>
      BnplLocalDatasourceImpl(sl<HiveConsumer>());
}
