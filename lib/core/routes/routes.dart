import '../../features/bnpl/presentation/pages/installment_plan_screen.dart';
import '../../features/bnpl/presentation/pages/order_confirmation_screen.dart';
import '../../features/bnpl/presentation/pages/product_checkout_screen.dart';
import 'route_config.dart';

final routes = [
  RouteConfig(
    name: Routes.productCheckout,
    builder: (_, _) => const ProductCheckoutScreen(),
  ),
  RouteConfig(
    name: Routes.installmentPlan,
    builder: (_, _) => const InstallmentPlanScreen(),
  ),
  RouteConfig(
    name: Routes.orderConfirmation,
    builder: (_, _) => const OrderConfirmationScreen(),
  ),
];

/// Application Routes
class Routes {
  Routes._();

  static const String productCheckout = '/productCheckout';
  static const String installmentPlan = '/installmentPlan';
  static const String orderConfirmation = '/orderConfirmation';
}

class RouteArguments {}
