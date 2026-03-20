import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/typography.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/constants.dart';

class SelectedPlanDetailsWidget extends StatelessWidget {
  final double monthlyAmount;
  final double totalAmount;
  final double totalFees;
  final ResponsiveInfo info;

  const SelectedPlanDetailsWidget({
    required this.monthlyAmount,
    required this.totalAmount,
    required this.totalFees,
    required this.info,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppConstants.radiusLG),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Padding(
        padding: EdgeInsets.all(info.spacing(ResponsiveSpacing.md)),
        child: Column(
          children: [
            DetailRow(
              label: AppStrings.monthlyInstallment,
              value: 'EGP ${monthlyAmount.toStringAsFixed(2)}',
              info: info,
            ),
            SizedBox(height: info.spacing(ResponsiveSpacing.sm)),
            DetailRow(
              label: AppStrings.totalAmount,
              value: 'EGP ${totalAmount.toStringAsFixed(2)}',
              info: info,
            ),
            SizedBox(height: info.spacing(ResponsiveSpacing.sm)),
            DetailRow(
              label: AppStrings.feesAndInterest,
              value: 'EGP ${totalFees.toStringAsFixed(2)}',
              info: info,
            ),
          ],
        ),
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final ResponsiveInfo info;

  const DetailRow({
    required this.label,
    required this.value,
    required this.info,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            fontSize: info.responsiveFontSize(14),
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            fontSize: info.responsiveFontSize(14),
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
