import '../../domain/entities/installment_plan_entity.dart';

class InstallmentPlanModel extends InstallmentPlanEntity {
  const InstallmentPlanModel({
    required super.months,
    required super.label,
    required super.interestRate,
    required super.processingFee,
    required super.minAmount,
    required super.maxAmount,
  });

  factory InstallmentPlanModel.fromJson(Map<String, dynamic> json) {
    return InstallmentPlanModel(
      months: json['months'] as int? ?? 0,
      label: json['label'] as String? ?? '${json['months'] ?? 0} Months',
      interestRate: (json['interestRate'] as num? ?? 0).toDouble(),
      processingFee: (json['processingFee'] as num? ?? 0).toDouble(),
      minAmount: (json['minAmount'] as num? ?? 0).toDouble(),
      maxAmount: (json['maxAmount'] as num? ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'months': months,
      'label': label,
      'interestRate': interestRate,
      'processingFee': processingFee,
      'minAmount': minAmount,
      'maxAmount': maxAmount,
    };
  }

  factory InstallmentPlanModel.fromEntity(InstallmentPlanEntity e) =>
      InstallmentPlanModel(
        months: e.months,
        label: e.label,
        interestRate: e.interestRate,
        processingFee: e.processingFee,
        minAmount: e.minAmount,
        maxAmount: e.maxAmount,
      );
}
