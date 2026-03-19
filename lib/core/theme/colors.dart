import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ========== Brand / Primary (Blue Theme) ==========
  static const Color primary = Color(0xFF0066FF); // Main brand blue
  static const Color primaryLight = Color(0xFF3385FF); // Lighter shade
  static const Color primaryDark = Color(0xFF0052CC); // Darker shade
  static const Color primaryHover = Color(0xFFE6F0FF); // Hover/pressed state
  static const Color primaryContainer = Color(0xFFCCE0FF); // Container variant

  // ========== Neutrals ==========
  static const Color black = Color(0xFF000000);
  static const Color mainBlack = Color(0xFF1A1A1A);

  static const Color white = Color(0xFFFFFFFF);
  static const Color white10 = Color(0x1AFFFFFF); // 10% opacity

  // ========== Greys (refined for modern UI) ==========
  static const Color grey900 = Color(0xFF1C1C1E); // darkest
  static const Color grey800 = Color(0xFF373737);
  static const Color grey700 = Color(0xFF6E6E6E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey500 = Color(0xFF9E9E9E); // labels
  static const Color grey400 = Color(0xFFBDBDBD); // icons
  static const Color grey300 = Color(0xFFC4C4C4);
  static const Color grey200 = Color(0xFFE0E0E0);
  static const Color grey100 = Color(0xFFF5F5F5); // field backgrounds
  static const Color grey50 = Color(0xFFFAFAFA); // surface

  // Legacy grey names (for backward compatibility)
  static const Color greyNormal = grey900;
  static const Color greyMain = grey700;
  static const Color greyDark = grey800;
  static const Color greyMedium = grey600;
  static const Color greyLight = grey300;
  static const Color greyUltraLight = grey50;
  static const Color greyBackground = grey100;

  // ========== Supporting Colors ==========
  static const Color blueLight = Color(0xFFE7F3FF); // Light blue for highlights
  static const Color blueDark = Color(0xFF003D99); // Dark blue for accents

  // ========== Semantic ==========
  static const Color background = white;
  static const Color backgroundDark = grey900;

  static const Color surface = white;
  static const Color surfaceDark = Color(0xFF1A1A1A);
  static const Color surfaceVariant = grey50; // For cards, containers

  static const Color textPrimary = mainBlack;
  static const Color textSecondary = grey600;
  static const Color textDisabled = grey300;
  static const Color textOnPrimary = white; // Text on blue buttons
  static const Color textLabel = grey500; // For form labels

  static const Color border = grey300;
  static const Color borderLight = grey200;
  static const Color divider = grey200;

  // Input field specific
  static const Color inputFill = grey50; // Background for text fields
  static const Color inputBorder = grey300;
  static const Color inputBorderFocused = primary;
  static const Color inputIcon = grey400;

  // ========== Feedback ==========
  static const Color success = Color(0xFF19CF10); // Green
  static const Color successLight = Color(0xFFE8F5E7);

  static const Color error = Color(0xFFDC3545); // Red
  static const Color errorLight = Color(0xFFFFEBEE);

  static const Color warning = Color(0xFFFFC107); // Amber
  static const Color warningLight = Color(0xFFFFF8E1);

  static const Color info = primary; // Use primary blue for info
  static const Color infoLight = primaryHover;

  // ========== Shimmer ==========
  static const Color shimmerBase = grey200;
  static const Color shimmerHighlight = grey50;

  // ========== Overlay ==========
  static const Color overlay = Color(0x80000000); // 50% black
  static const Color overlayLight = Color(0x40000000); // 25% black

  // ========== Shadow ==========
  static const Color shadow = Color(0x1A000000); // 10% black
  static const Color shadowMedium = Color(0x33000000); // 20% black

  // ========== Helper Methods ==========

  /// Returns a color with specified opacity (0.0 - 1.0)
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  /// Returns the appropriate text color for the given background
  static Color textColorForBackground(Color backgroundColor) {
    // Calculate luminance
    final luminance = backgroundColor.computeLuminance();
    // Return black text for light backgrounds, white for dark
    return luminance > 0.5 ? textPrimary : white;
  }
}
