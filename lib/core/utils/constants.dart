/// Application Constants
/// Centralized constant definitions
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  static const Duration retryDelay = Duration(seconds: 1);

  // image caching
  static const Duration fadeInDuration = Duration(milliseconds: 200);
  static const Duration fadeOutDuration = Duration(milliseconds: 200);
  static const int memCacheWidth = 100;
  static const int memCacheHeight = 100;
  static const int maxHeightDiskCache = 100;
  static const int maxWidthDiskCache = 100;

  // Pagination
  static const int defaultPageSize = 50;
  static const int maxPageSize = 100;

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  static const Duration dashboardLoadingDuration = Duration(milliseconds: 800);

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 16.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;

  // Border Radius
  static const double radiusSM = 4.0;
  static const double radiusMD = 8.0;
  static const double radiusLG = 12.0;
  static const double radiusXL = 16.0;
  static const double radiusRound = 999.0;

  // Icon Sizes
  static const double iconSizeSM = 16.0;
  static const double iconSizeMD = 24.0;
  static const double iconSizeLG = 32.0;
  static const double iconSizeXL = 48.0;

  // Font Sizes
  static const double fontSizeXS = 10.0;
  static const double fontSizeSM = 12.0;
  static const double fontSizeMD = 14.0;
  static const double fontSizeLG = 16.0;
  static const double fontSizeXL = 18.0;
  static const double fontSizeXXL = 20.0;
  static const double fontSizeH4 = 18.0;
  static const double fontSizeH3 = 20.0;
  static const double fontSizeH2 = 24.0;
  static const double fontSizeH1 = 32.0;

  // Line Heights
  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.5;
  static const double lineHeightLoose = 1.6;

  // Letter Spacing
  static const double letterSpacingTight = -0.5;
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingWide = 0.5;

  // Image Sizes
  static const double avatarSizeSM = 32.0;
  static const double avatarSizeMD = 48.0;
  static const double avatarSizeLG = 64.0;
  static const double avatarSizeXL = 96.0;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;


  // Date Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';

  // Regular Expressions
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final RegExp phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
  static final RegExp urlRegex = RegExp(
    r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
  );

  // Error Messages
  static const String genericErrorMessage =
      'Something went wrong. Please try again.';
  static const String networkErrorMessage =
      'No internet connection. Please check your network.';
  static const String timeoutErrorMessage =
      'Request timeout. Please try again.';
  static const String unauthorizedErrorMessage =
      'Unauthorized. Please login again.';

  static const String emailHint = 'tanyamyroniuk@gmail.com';
  static const String passwordHint = '••••••••';
  static const String fullNameHint = 'John Doe';
  static const String phoneNumberHint = '+201234567890';

}
