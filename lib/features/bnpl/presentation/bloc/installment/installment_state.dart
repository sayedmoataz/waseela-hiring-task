part of 'installment_bloc.dart';

sealed class InstallmentState extends Equatable {
  const InstallmentState();

  @override
  List<Object?> get props => [];
}

final class InstallmentInitial extends InstallmentState {
  const InstallmentInitial();
}

final class InstallmentLoading extends InstallmentState {
  const InstallmentLoading();
}

final class InstallmentLoaded extends InstallmentState {
  final List<InstallmentPlanEntity> plans;
  final InstallmentPlanEntity? selectedPlan;
  final double monthlyInstallment;
  final double totalAmount;
  final double totalFees;
  final List<RepaymentScheduleEntry> repaymentSchedule;
  final Map<String, double> planMonthlyAmounts;

  const InstallmentLoaded({
    required this.plans,
    required this.monthlyInstallment,
    required this.totalAmount,
    required this.totalFees,
    required this.repaymentSchedule,
    required this.planMonthlyAmounts,
    this.selectedPlan,
  });

  static const _sentinel = Object();

  InstallmentLoaded copyWith({
    List<InstallmentPlanEntity>? plans,
    Object? selectedPlan = _sentinel,
    double? monthlyInstallment,
    double? totalAmount,
    double? totalFees,
    List<RepaymentScheduleEntry>? repaymentSchedule,
    Map<String, double>? planMonthlyAmounts,
  }) {
    return InstallmentLoaded(
      plans: plans ?? this.plans,
      selectedPlan: identical(selectedPlan, _sentinel)
          ? this.selectedPlan
          : selectedPlan as InstallmentPlanEntity?,
      monthlyInstallment: monthlyInstallment ?? this.monthlyInstallment,
      totalAmount: totalAmount ?? this.totalAmount,
      totalFees: totalFees ?? this.totalFees,
      repaymentSchedule: repaymentSchedule ?? this.repaymentSchedule,
      planMonthlyAmounts: planMonthlyAmounts ?? this.planMonthlyAmounts,
    );
  }

  @override
  List<Object?> get props => [
        plans,
        selectedPlan,
        monthlyInstallment,
        totalAmount,
        totalFees,
        repaymentSchedule,
        planMonthlyAmounts,
      ];
}

final class InstallmentError extends InstallmentState {
  final String message;

  const InstallmentError(this.message);

  @override
  List<Object?> get props => [message];
}
