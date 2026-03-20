import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failure.dart';
import '../../models/installment_plan_model.dart';
import '../../models/product_model.dart';

abstract class BnplLocalDatasource {
  Future<void> cacheProducts(List<ProductModel> products);
  Future<Either<Failure, List<ProductModel>>> getCachedProducts();

  Future<void> cacheInstallmentPlans(List<InstallmentPlanModel> plans);
  Future<Either<Failure, List<InstallmentPlanModel>>> getCachedPlans();

  Future<void> clearCache();
}
