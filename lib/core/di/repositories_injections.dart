import 'package:injectable/injectable.dart';

import '../../features/bnpl/data/datasources/local/bnpl_local_datasource.dart';
import '../../features/bnpl/data/datasources/remote/bnpl_remote_datasource.dart';
import '../../features/bnpl/data/repositories/bnpl_repository_impl.dart';
import '../../features/bnpl/domain/repositories/bnpl_repository.dart';
import 'injection_container.dart';

@module
abstract class BnplRepositoriesModule {
  @LazySingleton(as: BnplRepository)
  BnplRepositoryImpl get bnplRepository =>
      BnplRepositoryImpl(sl<BnplRemoteDatasource>(), sl<BnplLocalDatasource>());
}
