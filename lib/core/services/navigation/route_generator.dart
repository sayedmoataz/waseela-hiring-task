import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../routes/guards/i_guard.dart';
import '../../routes/route_config.dart';
import 'navigation_service.dart';

class RouteGenerator {
  final List<RouteConfig> routes;
  final Widget Function(String routeName)? unknownRoute;

  RouteGenerator({required this.routes, this.unknownRoute});

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final routeName = settings.name ?? '/';

    // Find route config
    final config = routes.firstWhere(
      (r) => r.name == routeName,
      orElse: () => RouteConfig(
        name: routeName,
        builder: (_, _) =>
            unknownRoute?.call(routeName) ?? _buildUnknownRoute(routeName),
      ),
    );

    return _buildRoute(config, settings);
  }

  Route<dynamic> _buildRoute(RouteConfig config, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) {
        return _buildPageWithGuards(context, config, settings.arguments);
      },
      transitionDuration:
          config.transitionDuration ?? const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return _buildTransition(
          config.transition,
          animation,
          secondaryAnimation,
          child,
        );
      },
    );
  }

  Widget _buildPageWithGuards(
    BuildContext context,
    RouteConfig config,
    Object? arguments,
  ) {
    if (config.guards != null && config.guards!.isNotEmpty) {
      return _GuardBuilder(
        guards: config.guards!,
        builder: (context) => _buildActualPage(context, config, arguments),
      );
    }

    return _buildActualPage(context, config, arguments);
  }

  Widget _buildActualPage(
    BuildContext context,
    RouteConfig config,
    Object? arguments,
  ) {
    // Extract bloc providers if passed
    List<BlocProvider>? passedProviders;
    Object? actualArguments = arguments;

    if (arguments is Map<String, dynamic> &&
        arguments.containsKey('routeArguments') &&
        arguments.containsKey('blocProviders')) {
      passedProviders = arguments['blocProviders'] as List<BlocProvider>?;
      actualArguments = arguments['routeArguments'];
    }

    // Build the page widget
    Widget page = config.builder(context, actualArguments);

    // Wrap with bloc providers if available
    final configProviders = config.providers?.call(context) ?? [];
    final allProviders = [...configProviders, ...?passedProviders];

    if (allProviders.isNotEmpty) {
      page = MultiBlocProvider(providers: allProviders, child: page);
    }

    return page;
  }

  Widget _buildTransition(
    TransitionType type,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    switch (type) {
      case TransitionType.fade:
        return FadeTransition(opacity: animation, child: child);

      case TransitionType.scale:
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          ),
          child: child,
        );

      case TransitionType.rotation:
        return RotationTransition(
          turns: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          ),
          child: child,
        );

      case TransitionType.slideUp:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        );

      case TransitionType.none:
        return child;

      case TransitionType.slide:
        return SlideTransition(
          position:
              Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOutCubic,
                ),
              ),
          child: child,
        );
    }
  }

  Widget _buildUnknownRoute(String routeName) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(child: Text('No route defined for $routeName')),
    );
  }
}

class _GuardBuilder extends StatefulWidget {
  final List<Guard> guards;
  final WidgetBuilder builder;

  const _GuardBuilder({required this.guards, required this.builder});

  @override
  State<_GuardBuilder> createState() => _GuardBuilderState();
}

class _GuardBuilderState extends State<_GuardBuilder> {
  bool? _isAuthorized;
  String? _redirectTo;
  Widget? _cachedPage;
  bool _hasRedirected = false;

  @override
  void initState() {
    super.initState();
    _checkGuards();
  }

  Future<void> _checkGuards() async {
    for (var guard in widget.guards) {
      final canActivate = await guard.canActivate(context);
      if (!canActivate) {
        if (mounted) {
          _redirectTo = guard.redirectTo;
          _isAuthorized = false;
          // Perform redirect immediately
          _performRedirect();
        }
        return;
      }
    }

    if (mounted) {
      // Only build the actual page AFTER all guards pass
      // This ensures the page widget tree (and its BlocProviders)
      // are not created until authentication is verified
      setState(() {
        _isAuthorized = true;
        _cachedPage = widget.builder(context);
      });
    }
  }

  void _performRedirect() {
    if (_hasRedirected || _redirectTo == null) return;
    _hasRedirected = true;

    // Use addPostFrameCallback to ensure we're not in build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        NavigationService.instance.navigateReplace(_redirectTo!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Still checking guards - show loading indicator
    if (_isAuthorized == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Guards failed - show empty widget while redirect happens
    if (_isAuthorized == false) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Guards passed - return the cached page
    // The page was already built in _checkGuards after validation passed
    return _cachedPage ?? const SizedBox.shrink();
  }
}
