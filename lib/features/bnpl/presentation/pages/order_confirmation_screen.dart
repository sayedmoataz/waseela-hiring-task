import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/entities/product_entity.dart';
import '../bloc/order/order_bloc.dart';
import '../widgets/order/order_confirmation_widget.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final ProductEntity? product;
  final String planId;
  final double monthlyInstallment;
  final double totalAmount;

  const OrderConfirmationScreen({
    required this.product,
    required this.planId,
    required this.monthlyInstallment,
    required this.totalAmount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OrderBloc>(),
      child: OrderConfirmationWidget(
        product: product,
        planId: planId,
        monthlyInstallment: monthlyInstallment,
        totalAmount: totalAmount,
      ),
    );
  }
}
