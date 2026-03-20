import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/typography.dart';
import '../../../../../core/utils/app_images.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../../../domain/entities/product_entity.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final bool isSelected;
  final VoidCallback? onTap;

  const ProductCard({
    required this.product,
    this.isSelected = false,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        final imageHeight = info.isNarrowScreen ? 180.0 : 220.0;

        return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: AppConstants.shortAnimationDuration,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.radiusLG),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
            child: Card(
              elevation: isSelected ? 4 : 2,
              margin: EdgeInsets.zero,
              shadowColor: AppColors.shadow,
              color: isSelected ? AppColors.primaryHover : AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusLG),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: imageHeight,
                    child: CachedImageWidget(
                      imageUrl: product.imageUrl,
                      errorImage: AppImages.logo,
                      width: double.infinity,
                      height: imageHeight,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(info.spacing(ResponsiveSpacing.md)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: AppTypography.h3.copyWith(
                            fontSize: info.responsiveFontSize(20),
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: info.spacing(ResponsiveSpacing.xs)),
                        Text(
                          'EGP ${product.price.toStringAsFixed(2)}',
                          style: AppTypography.h3.copyWith(
                            fontSize: info.responsiveFontSize(18),
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: info.spacing(ResponsiveSpacing.xs)),
                        Text(
                          product.description,
                          style: AppTypography.h3.copyWith(
                            fontSize: info.responsiveFontSize(14),
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
