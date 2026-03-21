import 'package:equatable/equatable.dart';

class CreateOrderParams extends Equatable {
  final String productId;
  final String planId;
  final double totalAmount;
  final double monthlyInstallment;

  const CreateOrderParams({
    required this.productId,
    required this.planId,
    required this.totalAmount,
    required this.monthlyInstallment,
  });

  @override
  List<Object?> get props => [
    productId,
    planId,
    totalAmount,
    monthlyInstallment,
  ];
}
