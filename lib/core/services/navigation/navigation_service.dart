import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../routes/route_config.dart';

class NavigationService {
  NavigationService._();
  static final instance = NavigationService._();

  /// Root navigator key (for global navigation)
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>(
    debugLabel: 'rootNavigator',
  );

  /// Nested navigator key (for tab/nested navigation)
  final GlobalKey<NavigatorState> nestedNavigationKey =
      GlobalKey<NavigatorState>(debugLabel: 'nestedNavigator');

  /// Route observer for lifecycle tracking
  final routeObserver = RouteObserver<Route<dynamic>>();

  /// Routes registry for guard checking
  List<RouteConfig> _routes = [];

  /// Current route name
  String? _currentRoute;
  String? get currentRoute => _currentRoute;

  /// Navigation history
  final List<String> _history = [];
  List<String> get history => List.unmodifiable(_history);

  /// Get current context (use carefully!)
  BuildContext? get context => navigationKey.currentContext;
  BuildContext? get nestedContext => nestedNavigationKey.currentContext;

  /// Route change callbacks
  final List<void Function(String?)> _routeListeners = [];

  /// Initialize routes registry for guard checking
  // ignore: use_setters_to_change_properties
  void initRoutes(List<RouteConfig> routeConfigs) => _routes = routeConfigs;

  /// Get route config by name
  RouteConfig? _getRouteConfig(String routeName) {
    try {
      return _routes.firstWhere((r) => r.name == routeName);
    } catch (_) {
      return null;
    }
  }

  /// Check all guards for a route, returns the redirect route if any guard fails
  Future<String?> _checkGuards(String routeName, BuildContext context) async {
    final config = _getRouteConfig(routeName);
    if (config == null || config.guards == null || config.guards!.isEmpty) {
      return null; // No guards, proceed
    }

    for (final guard in config.guards!) {
      final canActivate = await guard.canActivate(context);
      if (!canActivate) {
        return guard.redirectTo; // Return redirect route
      }
    }
    return null; // All guards passed
  }

  void addRouteListener(void Function(String?) listener) {
    _routeListeners.add(listener);
  }

  void removeRouteListener(void Function(String?) listener) {
    _routeListeners.remove(listener);
  }

  void _notifyRouteChange(String? route) {
    _currentRoute = route;
    if (route != null) _history.add(route);
    for (var listener in _routeListeners) {
      listener(route);
    }
  }

  // --------------------------------------------------------------------------
  // Navigation Methods
  // --------------------------------------------------------------------------

  /// Navigate to a named route (with guard checking)
  /// If guards fail, navigates to the redirect route instead
  Future<T?> navigateTo<T>(
    String routeName, {
    Object? arguments,
    bool useRootNavigator = true,
    bool checkGuards = true,
  }) async {
    final key = useRootNavigator ? navigationKey : nestedNavigationKey;
    final ctx = key.currentContext;

    // Check guards before navigating
    if (checkGuards && ctx != null) {
      final redirectRoute = await _checkGuards(routeName, ctx);
      if (redirectRoute != null) {
        // Guard failed, redirect instead
        _notifyRouteChange(redirectRoute);
        return key.currentState?.pushNamed<T>(
          redirectRoute,
          arguments: arguments,
        );
      }
    }

    _notifyRouteChange(routeName);
    return key.currentState?.pushNamed<T>(routeName, arguments: arguments);
  }

  /// Navigate and replace current route (with guard checking)
  Future<T?> navigateReplace<T, TO>(
    String routeName, {
    Object? arguments,
    TO? result,
    bool checkGuards = true,
  }) async {
    final ctx = navigationKey.currentContext;

    // Check guards before navigating
    if (checkGuards && ctx != null) {
      final redirectRoute = await _checkGuards(routeName, ctx);
      if (redirectRoute != null) {
        // Guard failed, redirect instead
        _notifyRouteChange(redirectRoute);
        return navigationKey.currentState?.pushReplacementNamed<T, void>(
          redirectRoute,
        );
      }
    }

    _notifyRouteChange(routeName);
    return navigationKey.currentState?.pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  /// Navigate and remove all previous routes (with guard checking)
  Future<T?> navigateAndRemoveUntil<T>(
    String routeName, {
    Object? arguments,
    bool Function(Route<dynamic>)? predicate,
    bool checkGuards = true,
  }) async {
    final ctx = navigationKey.currentContext;

    // Check guards before navigating
    if (checkGuards && ctx != null) {
      final redirectRoute = await _checkGuards(routeName, ctx);
      if (redirectRoute != null) {
        // Guard failed, redirect instead
        _notifyRouteChange(redirectRoute);
        return navigationKey.currentState?.pushNamedAndRemoveUntil<T>(
          redirectRoute,
          predicate ?? (route) => false,
        );
      }
    }

    _notifyRouteChange(routeName);
    return navigationKey.currentState?.pushNamedAndRemoveUntil<T>(
      routeName,
      predicate ?? (route) => false,
      arguments: arguments,
    );
  }

  /// Navigate with bloc providers
  Future<T?> navigateToWithBlocs<T>(
    String routeName, {
    Object? arguments,
    List<BlocProvider>? additionalProviders,
    bool useRootNavigator = true,
  }) async {
    _notifyRouteChange(routeName);
    final key = useRootNavigator ? navigationKey : nestedNavigationKey;

    return key.currentState?.pushNamed<T>(
      routeName,
      arguments: {
        'routeArguments': arguments,
        'blocProviders': additionalProviders,
      },
    );
  }

  /// Navigate using Route object
  Future<T?> push<T>(Route<T> route, {bool useRootNavigator = true}) async {
    final key = useRootNavigator ? navigationKey : nestedNavigationKey;
    return key.currentState?.push<T>(route);
  }

  /// Pop current route
  void pop<T>([T? result]) {
    if (canPop()) {
      navigationKey.currentState?.pop<T>(result);
      if (_history.isNotEmpty) _history.removeLast();
    }
  }

  /// Pop until specific route
  void popUntil(String routeName) {
    navigationKey.currentState?.popUntil(ModalRoute.withName(routeName));
  }

  /// Pop until predicate is true
  void popUntilPredicate(bool Function(Route<dynamic>) predicate) {
    navigationKey.currentState?.popUntil(predicate);
  }

  /// Check if can pop
  bool canPop() => navigationKey.currentState?.canPop() ?? false;

  /// Maybe pop (checks if route can be popped)
  Future<bool> maybePop<T>([T? result]) async {
    return await navigationKey.currentState?.maybePop<T>(result) ?? false;
  }

  /// Show modal bottom sheet
  Future<T?> showBottomSheet<T>({
    required Widget child,
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
  }) async {
    final ctx = context;
    if (ctx == null) return null;
    return showModalBottomSheet<T>(
      context: ctx,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      builder: (_) => child,
    );
  }

  /// Show dialog
  Future<T?> showDialogCustom<T>({
    required Widget child,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) async {
    final ctx = context;
    if (ctx == null) return null;
    return showDialog<T>(
      context: ctx,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (_) => child,
    );
  }

  /// Clear navigation history
  void clearHistory() {
    _history.clear();
  }

  /// Helper method to get existing bloc from context
  static T getBloc<T extends BlocBase>(BuildContext context) {
    return context.read<T>();
  }
}
