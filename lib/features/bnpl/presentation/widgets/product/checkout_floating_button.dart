import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';
import 'package:waseela/core/services/navigation/navigation_extensions.dart';

import '../../../../../core/routes/routes.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../domain/entities/product_entity.dart';

class CheckoutFloatingButton extends StatelessWidget {
  final ProductEntity selectedProduct;
  final int selectedMonths;

  const CheckoutFloatingButton({
    required this.selectedProduct,
    required this.selectedMonths,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.safePadding,
      child: CustomButton(
        text: AppStrings.chooseInstallmentPlan,
        textColor: AppColors.white,
        onPressed: () {
          context.navigateTo(
            Routes.installmentPlan,
            arguments: {
              RouteArguments.product: selectedProduct,
              RouteArguments.selectedMonths: selectedMonths,
            },
          );
        },
      ),
    );
  }
}
