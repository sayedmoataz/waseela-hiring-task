import '../../../../../core/services/api/contracts/api_consumer.dart';
import '../../../../../core/services/api/server_strings.dart';
import '../../../../../core/services/crashlytics/crashlytics_logger.dart';
import '../../../domain/entities/order_entity.dart';
import '../../models/installment_plan_model.dart';
import '../../models/order_model.dart';
import '../../models/product_model.dart';
import 'bnpl_remote_datasource.dart';

class BnplRemoteDatasourceImpl implements BnplRemoteDatasource {
  final ApiConsumer _apiConsumer;

  BnplRemoteDatasourceImpl(this._apiConsumer);

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final responseOrFailure = await _apiConsumer.get(
        endpoint: ServerStrings.products,
        converter: (data) => data as List,
      );

      return responseOrFailure.fold(
        (failure) => throw failure,
        (list) => list.map((json) => ProductModel.fromJson(json as Map<String, dynamic>)).toList(),
      );
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(e, stackTrace, feature: 'bnpl');
      rethrow;
    }
  }

  @override
  Future<List<InstallmentPlanModel>> getInstallmentPlans() async {
    try {
      final responseOrFailure = await _apiConsumer.get(
        endpoint: ServerStrings.installmentPlans,
        converter: (data) => data as List,
      );

      return responseOrFailure.fold(
        (failure) => throw failure,
        (list) => list.map((json) => InstallmentPlanModel.fromJson(json as Map<String, dynamic>)).toList(),
      );
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(e, stackTrace, feature: 'bnpl');
      rethrow;
    }
  }

  @override
  Future<OrderModel> createOrder({
    required String productId,
    required String planId,
    required double totalAmount,
    required double monthlyInstallment,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      final isApproved = DateTime.now().millisecond % 10 < 8;
      
      return OrderModel(
        id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
        productId: productId,
        planId: planId,
        totalAmount: totalAmount,
        monthlyInstallment: monthlyInstallment,
        status: isApproved ? OrderStatus.approved : OrderStatus.pending,
        createdAt: DateTime.now(),
      );
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(e, stackTrace, feature: 'bnpl');
      rethrow;
    }
  }
}
