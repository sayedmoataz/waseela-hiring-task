import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/utils/constants.dart';

class ProductCheckoutShimmer extends StatelessWidget {
  const ProductCheckoutShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        final imageHeight = info.isNarrowScreen ? 180.0 : 220.0;
        final hPadding = info.horizontalPadding();
        final spacing = info.spacing(ResponsiveSpacing.md);
        final spacingSm = info.spacing(ResponsiveSpacing.sm);
        final spacingLg = info.spacing(ResponsiveSpacing.lg);

        return Shimmer.fromColors(
          baseColor: AppColors.shimmerBase,
          highlightColor: AppColors.shimmerHighlight,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: hPadding,
              vertical: spacing,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image skeleton
                _ShimmerBox(
                  width: double.infinity,
                  height: imageHeight,
                  radius: AppConstants.radiusLG,
                ),
                SizedBox(height: spacingLg),

                // Product name skeleton
                const _ShimmerBox(width: double.infinity, height: 24),
                SizedBox(height: spacingSm),
                const _ShimmerBox(width: 160, height: 24),
                SizedBox(height: spacing),

                // Price skeleton
                const _ShimmerBox(width: 120, height: 20),
                SizedBox(height: spacingSm),

                // Description skeleton
                const _ShimmerBox(width: double.infinity, height: 14),
                SizedBox(height: spacingSm),
                const _ShimmerBox(width: double.infinity, height: 14),
                SizedBox(height: spacingSm),
                const _ShimmerBox(width: 200, height: 14),
                SizedBox(height: spacingLg),

                // Installment section skeleton
                const _ShimmerBox(width: 200, height: 20),
                SizedBox(height: spacing),
                const _ShimmerBox(
                  width: double.infinity,
                  height: 120,
                  radius: AppConstants.radiusLG,
                ),
                SizedBox(height: spacingLg),

                // CTA button skeleton
                const _ShimmerBox(
                  width: double.infinity,
                  height: 56,
                  radius: AppConstants.radiusXL,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const _ShimmerBox({
    required this.width,
    required this.height,
    this.radius = AppConstants.radiusMD,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
