import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/typography.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/constants.dart';

class OrderSummaryCard extends StatelessWidget {
  final double monthlyInstallment;
  final double? totalAmount;

  const OrderSummaryCard({
    required this.monthlyInstallment,
    super.key,
    this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
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
              Text(
                AppStrings.paymentSummary,
                style: AppTypography.h3.copyWith(
                  fontSize: info.responsiveFontSize(16),
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: info.spacing(ResponsiveSpacing.md)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.monthly,
                    style: AppTypography.labelMedium.copyWith(
                      fontSize: info.responsiveFontSize(14),
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    'EGP ${monthlyInstallment.toStringAsFixed(2)} / ${AppStrings.month}',
                    style: AppTypography.h3.copyWith(
                      fontSize: info.responsiveFontSize(16),
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              if (totalAmount != null) ...[
                SizedBox(height: info.spacing(ResponsiveSpacing.sm)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.total,
                      style: AppTypography.labelMedium.copyWith(
                        fontSize: info.responsiveFontSize(14),
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      'EGP ${totalAmount!.toStringAsFixed(2)}',
                      style: AppTypography.h3.copyWith(
                        fontSize: info.responsiveFontSize(16),
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
              SizedBox(height: info.spacing(ResponsiveSpacing.md)),
              Text(
                AppStrings.youCanTrackYourPaymentsInTheApp,
                style: AppTypography.labelMedium.copyWith(
                  fontSize: info.responsiveFontSize(12),
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
