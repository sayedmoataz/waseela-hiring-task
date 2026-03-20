import '../../models/installment_plan_model.dart';
import '../../models/order_model.dart';
import '../../models/product_model.dart';

abstract class BnplRemoteDatasource {
  Future<List<ProductModel>> getProducts();
  Future<List<InstallmentPlanModel>> getInstallmentPlans();

  Future<OrderModel> createOrder({
    required String productId,
    required String planId,
    required double totalAmount,
    required double monthlyInstallment,
  });
}
