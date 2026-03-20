import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';
import 'package:waseela/core/utils/extensions.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/typography.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/constants.dart';
import '../../../domain/entities/repayment_schedule_entry.dart';

class RepaymentScheduleWidget extends StatelessWidget {
  final List<RepaymentScheduleEntry> schedule;
  final ResponsiveInfo info;

  const RepaymentScheduleWidget({
    required this.schedule,
    required this.info,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.repaymentSchedule,
          style: AppTypography.h4.copyWith(
            fontSize: info.responsiveFontSize(18),
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: info.spacing(ResponsiveSpacing.sm)),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppConstants.radiusLG),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            children: [
              for (int i = 0; i < schedule.length; i++) ...[
                ScheduleRow(entry: schedule[i], info: info),
                if (i < schedule.length - 1)
                  Divider(
                    height: 1,
                    color: AppColors.divider,
                    indent: info.spacing(ResponsiveSpacing.md),
                    endIndent: info.spacing(ResponsiveSpacing.md),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class ScheduleRow extends StatelessWidget {
  final RepaymentScheduleEntry entry;
  final ResponsiveInfo info;

  const ScheduleRow({required this.entry, required this.info, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: info.spacing(ResponsiveSpacing.md),
        vertical: info.spacing(ResponsiveSpacing.sm),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.primaryHover,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${entry.installmentNumber}',
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: info.responsiveFontSize(12),
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: info.spacing(ResponsiveSpacing.sm)),
              Text(
                entry.dueDate.formattedDate,
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: info.responsiveFontSize(14),
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          Text(
            'EGP ${entry.amount.toStringAsFixed(2)}',
            style: AppTypography.bodyMedium.copyWith(
              fontSize: info.responsiveFontSize(14),
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
