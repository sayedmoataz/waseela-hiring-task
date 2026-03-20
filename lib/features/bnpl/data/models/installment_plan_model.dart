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
      months: json['months'] as int,
      label: json['label'] as String,
      interestRate: (json['interestRate'] as num).toDouble(),
      processingFee: (json['processingFee'] as num).toDouble(),
      minAmount: (json['minAmount'] as num).toDouble(),
      maxAmount: (json['maxAmount'] as num).toDouble(),
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
