import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/installment_plan_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/bnpl_repository.dart';
import '../datasources/local/bnpl_local_datasource.dart';
import '../datasources/remote/bnpl_remote_datasource.dart';

class BnplRepositoryImpl implements BnplRepository {
  final BnplRemoteDatasource _remote;
  final BnplLocalDatasource _local;

  BnplRepositoryImpl(this._remote, this._local);

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      final products = await _remote.getProducts();
      await _local.cacheProducts(products);
      return Right(products);
    } catch (e, stackTrace) {
      final cached = await _local.getCachedProducts();
      return cached.fold(
        (_) => Left(ErrorHandler.handle(e, stackTrace: stackTrace)),
        Right.new,
      );
    }
  }

  @override
  Future<Either<Failure, List<InstallmentPlanEntity>>>
  getInstallmentPlans() async {
    try {
      final plans = await _remote.getInstallmentPlans();
      await _local.cacheInstallmentPlans(plans);
      return Right(plans);
    } catch (e, stackTrace) {
      final cached = await _local.getCachedPlans();
      return cached.fold(
        (_) => Left(ErrorHandler.handle(e, stackTrace: stackTrace)),
        Right.new,
      );
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> createOrder({
    required String productId,
    required String planId,
    required double totalAmount,
    required double monthlyInstallment,
  }) async {
    try {
      final order = await _remote.createOrder(
        productId: productId,
        planId: planId,
        totalAmount: totalAmount,
        monthlyInstallment: monthlyInstallment,
      );
      return Right(order);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace: stackTrace));
    }
  }
}
