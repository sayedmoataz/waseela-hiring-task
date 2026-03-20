part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

final class OrderSubmitted extends OrderEvent {
  final String productId;
  final String planId;
  final double totalAmount;
  final double monthlyInstallment;

  const OrderSubmitted({
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

final class OrderReset extends OrderEvent {
  const OrderReset();
}
