import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/typography.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../bloc/product/product_bloc.dart';

class ProductEmptyWidget extends StatelessWidget {
  const ProductEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProductBloc>().add(const ProductFetched());
      },
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(context.spacing(ResponsiveSpacing.lg)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: context.responsiveFontSize(18),
                color: AppColors.grey400,
              ),
              SizedBox(height: context.spacing(ResponsiveSpacing.md)),
              Text(
                AppStrings.noProductsFound,
                style: AppTypography.h4.copyWith(
                  fontSize: context.responsiveFontSize(18),
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: context.spacing(ResponsiveSpacing.xs)),
              Text(
                AppStrings.pleaseCheckBackLater,
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: context.responsiveFontSize(14),
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
