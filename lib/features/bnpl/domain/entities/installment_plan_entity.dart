import 'package:equatable/equatable.dart';

class InstallmentPlanEntity extends Equatable {
  final int months;
  final String label;
  final double interestRate;
  final double processingFee;
  final double minAmount;
  final double maxAmount;

  const InstallmentPlanEntity({
    required this.months,
    required this.label,
    required this.interestRate,
    required this.processingFee,
    required this.minAmount,
    required this.maxAmount,
  });

  @override
  List<Object?> get props =>
      [months, label, interestRate, processingFee, minAmount, maxAmount];
}

