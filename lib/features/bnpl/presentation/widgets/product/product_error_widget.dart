import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/typography.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../bloc/product/product_bloc.dart';

class ProductErrorWidget extends StatelessWidget {
  final String message;

  const ProductErrorWidget({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(info.spacing(ResponsiveSpacing.lg)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: AppConstants.iconSizeXL,
                  color: AppColors.error,
                ),
                SizedBox(height: info.spacing(ResponsiveSpacing.md)),
                Text(
                  AppStrings.somethingWentWrong,
                  style: AppTypography.h4.copyWith(
                    fontSize: info.responsiveFontSize(18),
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: info.spacing(ResponsiveSpacing.sm)),
                Text(
                  message,
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: info.responsiveFontSize(14),
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: info.spacing(ResponsiveSpacing.lg)),
                CustomButton(
                  text: AppStrings.retry,
                  textColor: AppColors.white,
                  color: AppColors.primary,
                  width: 160,
                  onPressed: () =>
                      context.read<ProductBloc>().add(const ProductFetched()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
