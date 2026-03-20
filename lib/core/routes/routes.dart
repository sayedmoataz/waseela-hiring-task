import '../../features/bnpl/presentation/pages/installment_plan_screen.dart';
import '../../features/bnpl/presentation/pages/order_confirmation_screen.dart';
import '../../features/bnpl/presentation/pages/product_checkout_screen.dart';
import '../../features/bnpl/domain/entities/product_entity.dart';
import '../services/navigation/navigation_extensions.dart';
import 'route_config.dart';

final routes = [
  RouteConfig(
    name: Routes.productCheckout,
    builder: (_, _) => const ProductCheckoutScreen(),
  ),
  RouteConfig(
    name: Routes.installmentPlan,
    builder: (context, arguments) {
      final ProductEntity? product =
          arguments?.getArgument<ProductEntity>(RouteArguments.product);
      final int selectedMonths =
          arguments?.getArgument<int>(RouteArguments.selectedMonths) ?? 6;
      
      return InstallmentPlanScreen(
        product: product!,
        initialSelectedMonths: selectedMonths,
      );
    },
  ),
  RouteConfig(
    name: Routes.orderConfirmation,
    builder: (context, arguments) {
      final String productId =
          arguments?.getArgument<String>(RouteArguments.productId) ?? '';
      final String planId = arguments?.getArgument<String>(RouteArguments.planId) ?? '';
      final double monthlyInstallment =
          arguments?.getArgument<double>(RouteArguments.monthlyInstallment) ?? 0.0;
      final double totalAmount =
          arguments?.getArgument<double>(RouteArguments.totalAmount) ?? 0.0;

      return OrderConfirmationScreen(
        productId: productId,
        planId: planId,
        monthlyInstallment: monthlyInstallment,
        totalAmount: totalAmount,
      );
    },
  ),
];

class Routes {
  Routes._();

  static const String productCheckout = '/productCheckout';
  static const String installmentPlan = '/installmentPlan';
  static const String orderConfirmation = '/orderConfirmation';
}

class RouteArguments {
  static const String productId = 'productId';
  static const String productPrice = 'productPrice';
  static const String planId = 'planId';
  static const String monthlyInstallment = 'monthlyInstallment';
  static const String totalAmount = 'totalAmount';
  static const String product = 'product';
  static const String selectedMonths = 'selectedMonths';
}
