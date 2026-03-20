import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/colors.dart';
import '../utils/app_images.dart';
import '../utils/constants.dart';

class CachedImageWidget extends StatelessWidget {
  final String imageUrl;
  final String? errorImage;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? placeholderColor;
  final Widget? placeholder;
  final Widget? errorWidget;
  final double borderRadius;

  const CachedImageWidget({
    required this.imageUrl,
    super.key,
    this.width,
    this.errorImage,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholderColor,
    this.placeholder,
    this.errorWidget,
    this.borderRadius = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) =>
            errorWidget ?? _buildShimmerEffect(width, height),
        errorWidget: (context, url, error) =>
            errorWidget ??
            Center(
              child: SizedBox(
                width: context.spacing(ResponsiveSpacing.xxl),
                height: context.spacing(ResponsiveSpacing.xxl),
                child: Image.asset(
                  AppImages.logo,
                  width: context.spacing(ResponsiveSpacing.xxl),
                  height: context.spacing(ResponsiveSpacing.xxl),
                ),
              ),
            ),
        fadeInDuration: AppConstants.fadeInDuration,
        fadeOutDuration: AppConstants.fadeOutDuration,
        memCacheWidth: AppConstants.memCacheWidth,
        memCacheHeight: AppConstants.memCacheHeight,
        maxHeightDiskCache: AppConstants.maxHeightDiskCache,
        maxWidthDiskCache: AppConstants.maxWidthDiskCache,
      ),
    );
  }
}

Widget _buildShimmerEffect(double? width, double? height) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMD),
      ),
      child: Container(
        width: width ?? 100,
        height: height ?? 100,
        color: AppColors.white,
      ),
    ),
  );
}
