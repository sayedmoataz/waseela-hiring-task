// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/bnpl/data/datasources/local/bnpl_local_datasource.dart'
    as _i347;
import '../../features/bnpl/data/datasources/remote/bnpl_remote_datasource.dart'
    as _i539;
import '../../features/bnpl/domain/repositories/bnpl_repository.dart' as _i197;
import '../../features/bnpl/domain/usecases/calculate_installment_usecase.dart'
    as _i96;
import '../../features/bnpl/presentation/bloc/installment/installment_bloc.dart'
    as _i837;
import '../../features/bnpl/presentation/bloc/order/order_bloc.dart' as _i936;
import '../../features/bnpl/presentation/bloc/product/product_bloc.dart'
    as _i991;
import '../services/services.dart' as _i264;
import 'datasources_injections.dart' as _i397;
import 'injection_container.dart' as _i809;
import 'repositories_injections.dart' as _i243;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt configureDependencies({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final bnplRepositoriesModule = _$BnplRepositoriesModule();
    final bnplDatasourcesModule = _$BnplDatasourcesModule();
    gh.factory<_i96.CalculateInstallmentUseCase>(
      () => _i96.CalculateInstallmentUseCase(),
    );
    gh.singleton<_i809.InjectionContainer>(() => _i809.InjectionContainer());
    gh.lazySingleton<_i197.BnplRepository>(
      () => bnplRepositoriesModule.bnplRepository,
    );
    gh.factory<_i991.ProductBloc>(
      () => _i991.ProductBloc(gh<_i197.BnplRepository>()),
    );
    gh.lazySingleton<_i347.BnplLocalDatasource>(
      () => bnplDatasourcesModule.bnplLocalDatasource,
    );
    gh.lazySingleton<_i539.BnplRemoteDatasource>(
      () => bnplDatasourcesModule.bnplRemoteDatasource,
    );
    gh.factory<_i837.InstallmentBloc>(
      () => _i837.InstallmentBloc(
        gh<_i197.BnplRepository>(),
        gh<_i96.CalculateInstallmentUseCase>(),
      ),
    );
    gh.factory<_i936.OrderBloc>(
      () => _i936.OrderBloc(
        gh<_i197.BnplRepository>(),
        gh<_i264.BiometricConsumer>(),
      ),
    );
    return this;
  }
}

class _$BnplRepositoriesModule extends _i243.BnplRepositoriesModule {}

class _$BnplDatasourcesModule extends _i397.BnplDatasourcesModule {}
