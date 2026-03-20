import '../../domain/entities/installment_plan_entity.dart';

class InstallmentPlanModel extends InstallmentPlanEntity {
  const InstallmentPlanModel({
    required super.months,
    required super.label,
    required super.interestRate,
    required super.processingFee,
  });

  factory InstallmentPlanModel.fromJson(Map<String, dynamic> json) {
    return InstallmentPlanModel(
      months: json['months'] as int? ?? 0,
      label: json['label'] as String? ?? '${json['months'] ?? 0} Months',
      interestRate: (json['interestRate'] as num? ?? 0).toDouble(),
      processingFee: (json['processingFee'] as num? ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'months': months,
      'label': label,
      'interestRate': interestRate,
      'processingFee': processingFee,
    };
  }

  factory InstallmentPlanModel.fromEntity(InstallmentPlanEntity e) =>
      InstallmentPlanModel(
        months: e.months,
        label: e.label,
        interestRate: e.interestRate,
        processingFee: e.processingFee,
      );
}
