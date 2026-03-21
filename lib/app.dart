import 'dart:io';

import 'package:flutter/material.dart';

import 'core/config/app_config.dart';
import 'core/routes/routes.dart';
import 'core/services/services.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_strings.dart';

class WaseelaApp extends StatefulWidget {
  const WaseelaApp({super.key});

  @override
  State<WaseelaApp> createState() => _WaseelaAppState();
}

class _WaseelaAppState extends State<WaseelaApp> {
  @override
  void initState() {
    super.initState();

    // Initialize routes registry
    NavigationService.instance.initRoutes(routes);

    // Initialize remaining services after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (AppConfig.enableLogging) {
        PerformanceService.instance.printReport();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: Platform.isAndroid ? true : false,
      child: MaterialApp(
        navigatorKey: NavigationService.instance.navigationKey,
        navigatorObservers: [NavigationService.instance.routeObserver],
        onGenerateRoute: RouteGenerator(routes: routes).onGenerateRoute,
        onGenerateTitle: (context) => AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: Routes.productCheckout,
      ),
    );
  }
}
