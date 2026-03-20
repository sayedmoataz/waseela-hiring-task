import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/typography.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/constants.dart';

class SelectedPlanSummary extends StatelessWidget {
  final int months;
  final double monthlyAmount;
  final double totalPrice;
  final ResponsiveInfo info;

  const SelectedPlanSummary({
    required this.months,
    required this.monthlyAmount,
    required this.totalPrice,
    required this.info,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(info.spacing(ResponsiveSpacing.md)),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppConstants.radiusLG),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: AppConstants.iconSizeSM,
              ),
              SizedBox(width: info.spacing(ResponsiveSpacing.xs)),
              Text(
                AppStrings.selectedPlan,
                style: AppTypography.labelMedium.copyWith(
                  fontSize: info.responsiveFontSize(12),
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: info.spacing(ResponsiveSpacing.sm)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$months ${AppStrings.months}',
                style: AppTypography.bodySmall.copyWith(
                  fontSize: info.responsiveFontSize(14),
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                'EGP ${monthlyAmount.toStringAsFixed(2)} / ${AppStrings.month}',
                style: AppTypography.h4.copyWith(
                  fontSize: info.responsiveFontSize(14),
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: info.spacing(ResponsiveSpacing.xs)),
          const Divider(color: AppColors.divider),
          SizedBox(height: info.spacing(ResponsiveSpacing.xs)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppStrings.totalAmount}:',
                style: AppTypography.labelMedium.copyWith(
                  fontSize: info.responsiveFontSize(14),
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'EGP ${totalPrice.toStringAsFixed(2)}',
                style: AppTypography.h4.copyWith(
                  fontSize: info.responsiveFontSize(16),
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
