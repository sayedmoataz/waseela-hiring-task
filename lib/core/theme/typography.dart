import 'package:flutter/material.dart';

import '../utils/constants.dart';

class AppTypography {
  AppTypography._();

  // Base Font Family
  static const String fontFamily = 'Poppins';

  // Heading Styles
  static TextStyle h1 = const TextStyle(
    fontFamily: fontFamily,
    fontSize: AppConstants.fontSizeH1,
    fontWeight: FontWeight.bold,
    letterSpacing: AppConstants.letterSpacingTight,
    height: AppConstants.lineHeightTight,
  );

  static TextStyle h2 = const TextStyle(
    fontFamily: fontFamily,
    fontSize: AppConstants.fontSizeH2,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.3,
    height: 1.3,
  );

  static TextStyle h3 = const TextStyle(
    fontFamily: fontFamily,
    fontSize: AppConstants.fontSizeH3,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.4,
  );

  static TextStyle h4 = const TextStyle(
    fontFamily: fontFamily,
    fontSize: AppConstants.fontSizeH4,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    height: 1.4,
  );

  static TextStyle h5 = const TextStyle(
    fontFamily: fontFamily,
    fontSize: AppConstants.fontSizeLG,
    fontWeight: FontWeight.w600,
    height: AppConstants.lineHeightNormal,
  );

  static TextStyle h6 = const TextStyle(
    fontFamily: fontFamily,
    fontSize: AppConstants.fontSizeMD,
    fontWeight: FontWeight.w600,
    height: AppConstants.lineHeightNormal,
  );

  // Body Text Styles
  static TextStyle bodyLarge = const TextStyle(
    fontFamily: fontFamily,
    fontSize: AppConstants.fontSizeLG,
    fontWeight: FontWeight.normal,
    height: AppConstants.lineHeightNormal,
    letterSpacing: 0.15,
  );

  static TextStyle bodyMedium = const TextStyle(
    fontFamily: fontFamily,
    fontSize: AppConstants.fontSizeMD,
    fontWeight: FontWeight.normal,
    height: AppConstants.lineHeightNormal,
    letterSpacing: 0.25,
  );

  static TextStyle bodySmall = const TextStyle(
    fontFamily: fontFamily,
    fontSize: AppConstants.fontSizeSM,
    fontWeight: FontWeight.normal,
    height: AppConstants.lineHeightNormal,
    letterSpacing: 0.4,
  );

  // Button Text Style
  static TextStyle button = const TextStyle(
    fontFamily: fontFamily,
    fontSize: AppConstants.fontSizeMD,
    fontWeight: FontWeight.w600,
    letterSpacing: AppConstants.letterSpacingWide,
  );

  // Caption Text Style
  static TextStyle caption = const TextStyle(
    fontFamily: fontFamily,
    fontSize: AppConstants.fontSizeSM,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.4,
    height: 1.3,
  );

  // Overline Text Style
  static TextStyle overline = const TextStyle(
    fontFamily: fontFamily,
    fontSize: AppConstants.fontSizeXS,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
    height: AppConstants.lineHeightLoose,
  );

  // Label Text Styles
  static TextStyle labelLarge = const TextStyle(
    fontFamily: fontFamily,
    fontSize: AppConstants.fontSizeMD,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static TextStyle labelMedium = const TextStyle(
    fontFamily: fontFamily,
    fontSize: AppConstants.fontSizeSM,
    fontWeight: FontWeight.w500,
    letterSpacing: AppConstants.letterSpacingWide,
  );

  static TextStyle labelSmall = const TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: AppConstants.letterSpacingWide,
  );
}
