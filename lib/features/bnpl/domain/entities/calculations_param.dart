import 'package:equatable/equatable.dart';

import 'installment_plan_entity.dart';

class CalculateParams extends Equatable {
  final double price;
  final InstallmentPlanEntity plan;
  final DateTime startDate;

  CalculateParams({
    required this.price,
    required this.plan,
    DateTime? startDate,
  }) : startDate = startDate ?? DateTime.now();

  @override
  List<Object?> get props => [price, plan];
}
