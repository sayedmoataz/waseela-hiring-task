import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'navigation_service.dart';

extension NavigationExtensions on BuildContext {
  NavigationService get nav => NavigationService.instance;

  Future<T?> navigateTo<T>(String route, {Object? arguments}) {
    return nav.navigateTo<T>(route, arguments: arguments);
  }

  /// Navigate with existing blocs
  Future<T?> navigateToWithBlocs<T>(
    String route, {
    Object? arguments,
    List<BlocProvider>? providers,
  }) {
    return nav.navigateToWithBlocs<T>(
      route,
      arguments: arguments,
      additionalProviders: providers,
    );
  }

  /// Helper to get bloc and pass it
  BlocProvider<T> provideBlocValue<T extends BlocBase<Object?>>(T bloc) {
    return BlocProvider<T>.value(value: bloc);
  }

  void pop<T>([T? result]) => nav.pop<T>(result);

  bool get canPop => nav.canPop();
}

// Type-safe argument extensions
extension RouteArgumentsExtension on Object? {
  T? getArgument<T>(String key) {
    if (this is Map<String, dynamic>) {
      final map = this as Map<String, dynamic>;
      return map[key] as T?;
    }
    return null;
  }

  Map<String, dynamic>? get asMap {
    if (this is Map<String, dynamic>) {
      return this as Map<String, dynamic>;
    }
    return null;
  }
}
