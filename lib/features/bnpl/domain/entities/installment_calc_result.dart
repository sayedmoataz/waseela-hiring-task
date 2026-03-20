import 'package:equatable/equatable.dart';

import 'repayment_schedule_entry.dart';

class InstallmentCalculationResult extends Equatable {
  final double monthlyInstallment;
  final double totalAmount;
  final double totalFees;
  final List<RepaymentScheduleEntry> repaymentSchedule;

  const InstallmentCalculationResult({
    required this.monthlyInstallment,
    required this.totalAmount,
    required this.totalFees,
    required this.repaymentSchedule,
  });

  @override
  List<Object?> get props =>
      [monthlyInstallment, totalAmount, totalFees, repaymentSchedule];
}