import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/services/local_storage/config/box_names.dart';
import '../../../../../core/services/local_storage/config/cache_keys.dart';
import '../../../../../core/services/local_storage/contracts/hive_consumer.dart';
import '../../models/installment_plan_model.dart';
import '../../models/product_model.dart';
import 'bnpl_local_datasource.dart';

class BnplLocalDatasourceImpl implements BnplLocalDatasource {
  final HiveConsumer _hiveConsumer;

  BnplLocalDatasourceImpl(this._hiveConsumer);

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    await _hiveConsumer.save(
      boxName: BoxNames.bnplCache,
      key: CacheKeys.cachedProducts,
      value: products.map((p) => p.toJson()).toList(),
    );
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getCachedProducts() async {
    final result = await _hiveConsumer.get(
      boxName: BoxNames.bnplCache,
      key: CacheKeys.cachedProducts,
      converter: (data) =>
          (data as List?)
              ?.map(
                (j) =>
                    ProductModel.fromJson(Map<String, dynamic>.from(j as Map)),
              )
              .toList() ??
          [],
    );

    return result.fold(Left.new, (data) => Right(data ?? []));
  }

  @override
  Future<void> cacheInstallmentPlans(List<InstallmentPlanModel> plans) async {
    await _hiveConsumer.save(
      boxName: BoxNames.bnplCache,
      key: CacheKeys.cachedInstallmentPlans,
      value: plans.map((p) => p.toJson()).toList(),
    );
  }

  @override
  Future<Either<Failure, List<InstallmentPlanModel>>> getCachedPlans() async {
    final result = await _hiveConsumer.get(
      boxName: BoxNames.bnplCache,
      key: CacheKeys.cachedInstallmentPlans,
      converter: (data) =>
          (data as List?)
              ?.map(
                (j) => InstallmentPlanModel.fromJson(
                  Map<String, dynamic>.from(j as Map),
                ),
              )
              .toList() ??
          [],
    );

    return result.fold(Left.new, (data) => Right(data ?? []));
  }

  @override
  Future<void> clearCache() async {
    await _hiveConsumer.clearBox(boxName: BoxNames.bnplCache);
  }
}
