import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_toast/custom_toast.dart';
import '../../../domain/entities/product_entity.dart';
import '../../bloc/installment/installment_bloc.dart';
import 'installment_error_widget.dart';
import 'installment_plan_body_widget.dart';
import 'installment_plans_shimmer.dart';

class InstallmentPlanWidget extends StatelessWidget {
  final ProductEntity product;
  final int initialSelectedMonths;

  const InstallmentPlanWidget({
    required this.product,
    required this.initialSelectedMonths,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text(AppStrings.installmentPlan),
        centerTitle: true,
      ),
      body: BlocConsumer<InstallmentBloc, InstallmentState>(
        listener: (context, state) {
          if (state is InstallmentError) {
            CustomToast.error(context, state.message);
          }
        },
        builder: (context, state) {
          return switch (state) {
            InstallmentInitial() => const InstallmentPlansShimmer(),
            InstallmentLoading() => const InstallmentPlansShimmer(),
            InstallmentLoaded() => InstallmentPlanBody(
              state: state,
              product: product,
              initialSelectedMonths: initialSelectedMonths,
            ),
            InstallmentError(:final message) => InstallmentErrorWidget(
              message: message,
              productPrice: product.price,
            ),
          };
        },
      ),
    );
  }
}
