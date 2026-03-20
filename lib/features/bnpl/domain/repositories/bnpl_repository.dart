import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/installment_plan_entity.dart';
import '../entities/order_entity.dart';
import '../entities/product_entity.dart';

abstract class BnplRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts();
  Future<Either<Failure, List<InstallmentPlanEntity>>> getInstallmentPlans();

  Future<Either<Failure, OrderEntity>> createOrder({
    required String productId,
    required String planId,
    required double totalAmount,
    required double monthlyInstallment,
  });
}
