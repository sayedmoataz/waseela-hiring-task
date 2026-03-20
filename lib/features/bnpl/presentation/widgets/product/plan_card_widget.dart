import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/typography.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/constants.dart';
import '../../../domain/entities/installment_plan_entity.dart';

class PlanCardWidget extends StatelessWidget {
  final InstallmentPlanEntity option;
  final bool isSelected;
  final ResponsiveInfo info;
  final VoidCallback onTap;

  const PlanCardWidget({
    required this.option,
    required this.isSelected,
    required this.info,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.shortAnimationDuration,
        padding: EdgeInsets.symmetric(
          vertical: info.spacing(ResponsiveSpacing.md),
          horizontal: info.spacing(ResponsiveSpacing.sm),
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: AppConstants.iconSizeSM,
              color: isSelected ? AppColors.white : AppColors.primary,
            ),
            SizedBox(height: info.spacing(ResponsiveSpacing.xs)),
            Text(
              '${option.months}',
              style: AppTypography.h3.copyWith(
                fontSize: info.responsiveFontSize(22),
                color: isSelected ? AppColors.white : AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              AppStrings.months,
              style: AppTypography.bodySmall.copyWith(
                fontSize: info.responsiveFontSize(12),
                color: isSelected
                    ? AppColors.white.withOpacity(0.85)
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
