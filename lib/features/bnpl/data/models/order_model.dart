import '../../domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.productId,
    required super.planId,
    required super.totalAmount,
    required super.monthlyInstallment,
    required super.status,
    required super.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      productId: json['productId'] as String,
      planId: json['planId'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      monthlyInstallment: (json['monthlyInstallment'] as num).toDouble(),
      status: (json['status'] as String) == 'approved'
          ? OrderStatus.approved
          : OrderStatus.pending,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'planId': planId,
      'totalAmount': totalAmount,
      'monthlyInstallment': monthlyInstallment,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory OrderModel.fromEntity(OrderEntity e) => OrderModel(
    id: e.id,
    productId: e.productId,
    planId: e.planId,
    totalAmount: e.totalAmount,
    monthlyInstallment: e.monthlyInstallment,
    status: e.status,
    createdAt: e.createdAt,
  );
}
