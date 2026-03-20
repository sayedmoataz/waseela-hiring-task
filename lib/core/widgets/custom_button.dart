import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final Widget? image;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;
  final bool isOutlined;
  final Color? color;
  final double? width;
  final double height;
  final double borderRadius;
  final Color? textColor;
  final Color? iconColor;
  final double? iconSize;
  final double? fontSize;

  const CustomButton({
    required this.onPressed,
    super.key,
    this.text,
    this.image,
    this.isLoading = false,
    this.isEnabled = true,
    this.isOutlined = false,
    this.color,
    this.width,
    this.height = 56,
    this.fontSize,
    this.borderRadius = 16,
    this.textColor,
    this.iconColor,
    this.iconSize,
  }) : assert(
         text != null || image != null,
         'Either text or icon must be provided',
       );

  bool get _isIconOnly => image != null && text == null;
  bool get _isDisabled => !isEnabled || isLoading;

  @override
  Widget build(BuildContext context) {
    final buttonColor = _isDisabled
        ? (color ?? AppColors.primaryHover)
        : (color ?? AppColors.primary);

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: isOutlined
          ? OutlinedButton(
              onPressed: _isDisabled ? null : onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: buttonColor, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                padding: _isIconOnly ? EdgeInsets.zero : null,
              ),
              child: _buildChild(),
            )
          : ElevatedButton(
              onPressed: _isDisabled ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                elevation: _isDisabled ? 0 : 4,
                shadowColor: buttonColor.withOpacity(0.4),
                padding: _isIconOnly ? EdgeInsets.zero : null,
              ),
              child: _buildChild(),
            ),
    );
  }

  Widget _buildChild() {
    if (isLoading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          color: AppColors.primary,
          strokeWidth: 2.5,
        ),
      );
    }

    // Icon only
    if (image != null && text == null) {
      return image!;
    }

    // Text only or Text with Icon
    return ResponsiveBuilder(
      builder: (context, info) {
        final textWidget = Text(
          text!,
          style: TextStyle(
            fontSize: info.responsiveFontSize(fontSize ?? 16),
            fontWeight: FontWeight.w900,
            color: textColor ?? AppColors.textPrimary,
          ),
        );

        // Text with Icon
        if (image != null) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [image!, const SizedBox(width: 8), textWidget],
          );
        }

        return textWidget;
      },
    );
  }
}
