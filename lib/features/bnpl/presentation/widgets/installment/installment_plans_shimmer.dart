import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/utils/constants.dart';

class InstallmentPlansShimmer extends StatelessWidget {
  const InstallmentPlansShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        final hPadding = info.horizontalPadding();
        final vSpacing = info.spacing(ResponsiveSpacing.md);
        final lgSpacing = info.spacing(ResponsiveSpacing.lg);

        return Shimmer.fromColors(
          baseColor: AppColors.shimmerBase,
          highlightColor: AppColors.shimmerHighlight,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: hPadding,
              vertical: vSpacing,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header skeleton
                const _ShimmerBox(width: 250, height: 24),
                SizedBox(height: info.spacing(ResponsiveSpacing.sm)),
                const _ShimmerBox(width: 180, height: 16),
                SizedBox(height: lgSpacing),

                // 3 Installment plan card skeletons
                const _ShimmerBox(width: double.infinity, height: 80),
                SizedBox(height: info.spacing(ResponsiveSpacing.md)),
                const _ShimmerBox(width: double.infinity, height: 80),
                SizedBox(height: info.spacing(ResponsiveSpacing.md)),
                const _ShimmerBox(width: double.infinity, height: 80),
                SizedBox(height: lgSpacing),

                // Confirm CTA button skeleton
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
