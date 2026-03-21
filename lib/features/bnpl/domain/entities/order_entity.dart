import 'package:equatable/equatable.dart';

enum OrderStatus { pending, approved }

class OrderEntity extends Equatable {
  final String id;
  final String productId;
  final String planId;
  final double totalAmount;
  final double monthlyInstallment;
  final OrderStatus status;
  final DateTime createdAt;

  const OrderEntity({
    required this.id,
    required this.productId,
    required this.planId,
    required this.totalAmount,
    required this.monthlyInstallment,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    productId,
    planId,
    totalAmount,
    monthlyInstallment,
    status,
    createdAt,
  ];
}
