import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../bloc/installment/installment_bloc.dart';
import '../../domain/entities/product_entity.dart';
import '../widgets/installment/installment_plan_widget.dart';

class InstallmentPlanScreen extends StatelessWidget {
  final ProductEntity product;
  final int initialSelectedMonths;

  const InstallmentPlanScreen({
    required this.product,
    required this.initialSelectedMonths,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<InstallmentBloc>()
            ..add(InstallmentPlansRequested(productPrice: product.price)),
      child: InstallmentPlanWidget(
        product: product,
        initialSelectedMonths: initialSelectedMonths,
      ),
    );
  }
}
