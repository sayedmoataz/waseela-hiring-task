import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig._();

  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'https://fallback.mockapi.io/api/v1';

  static bool get enableLogging => dotenv.env['ENABLE_LOGGING'] == 'true' || kDebugMode;

  static bool get isProduction => dotenv.env['APP_ENV'] == 'production';
}
