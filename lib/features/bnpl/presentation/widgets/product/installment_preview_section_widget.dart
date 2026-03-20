import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/typography.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../domain/entities/installment_plan_entity.dart';
import 'plan_card_widget.dart';
import 'selected_plan_details_widget.dart';

class InstallmentPreviewSection extends StatelessWidget {
  final List<InstallmentPlanEntity> plans;
  final ResponsiveInfo info;
  final int selectedMonths;
  final ValueChanged<int> onPlanSelected;
  final double monthlyAmount;
  final double totalAmount;
  final double totalFees;

  const InstallmentPreviewSection({
    required this.plans,
    required this.info,
    required this.selectedMonths,
    required this.onPlanSelected,
    required this.monthlyAmount,
    required this.totalAmount,
    required this.totalFees,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.payLaterWithInstallments,
          style: AppTypography.h4.copyWith(
            fontSize: info.responsiveFontSize(18),
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: info.spacing(ResponsiveSpacing.sm)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: plans.map((plan) {
              final isSelected = plan.months == selectedMonths;
              return Padding(
                padding: EdgeInsetsDirectional.only(
                  end: info.spacing(ResponsiveSpacing.sm),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: info.responsiveValue(
                      mobile: 80,
                      tablet: 100,
                    ),
                  ),
                  child: PlanCardWidget(
                    option: plan,
                    isSelected: isSelected,
                    info: info,
                    onTap: () => onPlanSelected(plan.months),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: info.spacing(ResponsiveSpacing.md)),
        SelectedPlanDetailsWidget(
          monthlyAmount: monthlyAmount,
          totalAmount: totalAmount,
          totalFees: totalFees,
          info: info,
        ),
      ],
    );
  }
}
