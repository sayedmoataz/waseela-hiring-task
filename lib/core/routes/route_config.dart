
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'guards/i_guard.dart';

/// Configuration for individual routes
class RouteConfig {
  final String name;
  final Widget Function(BuildContext, Object?) builder;
  final TransitionType transition;
  final Duration? transitionDuration;
  final bool requiresAuth;
  final List<Guard>? guards;
  final List<BlocProvider> Function(BuildContext context)? providers;

  const RouteConfig({
    required this.name,
    required this.builder,
    this.transition = TransitionType.slide,
    this.transitionDuration,
    this.requiresAuth = false,
    this.guards,
    this.providers,
  });
}

/// Available transition types
enum TransitionType { slide, fade, scale, rotation, slideUp, none }
