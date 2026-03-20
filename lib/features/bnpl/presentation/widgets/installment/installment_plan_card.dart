import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/typography.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/constants.dart';
import '../../../domain/entities/installment_plan_entity.dart';

class InstallmentPlanCard extends StatelessWidget {
  final InstallmentPlanEntity plan;
  final bool isSelected;
  final VoidCallback onTap;
  final double monthlyAmount;

  const InstallmentPlanCard({
    required this.plan,
    required this.isSelected,
    required this.onTap,
    required this.monthlyAmount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.radiusLG),
          child: Container(
            padding: EdgeInsets.all(info.spacing(ResponsiveSpacing.md)),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryHover : AppColors.surface,
              borderRadius: BorderRadius.circular(AppConstants.radiusLG),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.label,
                      style: AppTypography.h4.copyWith(
                        fontSize: info.responsiveFontSize(18),
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: info.spacing(ResponsiveSpacing.xs)),
                    Text(
                      '${AppStrings.interest} ${plan.interestRate * 100}%',
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: info.responsiveFontSize(12),
                        color: AppColors.success,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text(
                  'EGP ${monthlyAmount.toStringAsFixed(2)} / ${AppStrings.month}',
                  style: AppTypography.h4.copyWith(
                    fontSize: info.responsiveFontSize(16),
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
