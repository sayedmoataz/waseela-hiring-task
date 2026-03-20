import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'core/di/injection_container.dart' as di;
import 'core/services/services.dart';
import 'core/theme/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Start app startup timing
  PerformanceService.instance.startOperation('App Startup');

  // Set preferred orientations
  await PerformanceService.instance.measureAsync(
    'Set Orientations',
    () => SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]),
  );

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.primary,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize essential services before app render
  await di.InjectionContainer.init();

  // End essential startup timing
  PerformanceService.instance.endOperation('App Startup');

  runApp(const WaseelaApp());
}
