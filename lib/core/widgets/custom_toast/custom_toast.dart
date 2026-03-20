import 'package:flutter/material.dart';

import '../../theme/colors.dart';

/// Toast types for different visual styles
enum ToastType {
  /// Simple info/blank toast
  info,

  /// Success toast with green checkmark
  success,

  /// Error toast with red X icon
  error,

  /// Loading toast with spinner
  loading,
}

/// Toast position on screen
enum ToastPosition {
  /// Top of screen (default)
  top,

  /// Center of screen
  center,

  /// Bottom of screen
  bottom,
}

/// Custom toast widget that displays an overlay notification
class CustomToast extends StatelessWidget {
  final String message;
  final ToastType type;

  const CustomToast({
    required this.message,
    this.type = ToastType.info,
    super.key,
  });

  /// Shows a toast overlay that auto-dismisses
  static void show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.info,
    ToastPosition position = ToastPosition.top,
    Duration duration = const Duration(seconds: 3),
    bool dismissible = false,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => _ToastOverlay(
        message: message,
        type: type,
        position: position,
        onDismiss: () => entry.remove(),
        duration: duration,
        dismissible: dismissible,
      ),
    );

    overlay.insert(entry);
  }

  /// Shows a success toast
  static void success(
    BuildContext context,
    String message, {
    ToastPosition position = ToastPosition.top,
  }) {
    show(
      context,
      message: message,
      type: ToastType.success,
      position: position,
    );
  }

  /// Shows an error toast
  static void error(
    BuildContext context,
    String message, {
    ToastPosition position = ToastPosition.top,
  }) {
    show(context, message: message, type: ToastType.error, position: position);
  }

  /// Shows an info/blank toast
  static void info(
    BuildContext context,
    String message, {
    ToastPosition position = ToastPosition.top,
  }) {
    show(context, message: message, position: position);
  }

  /// Shows a loading toast
  ///
  /// Returns an [OverlayEntry] that can be dismissed by calling `.remove()`
  /// final loading = CustomToast.loading(context);
  /// loading.remove();
  ///
  /// Options:
  /// - [duration]: If provided, auto-dismisses after this duration. Default is no auto-dismiss.
  /// - [dismissible]: If true, user can tap the toast to dismiss it.
  /// - [position]: Where to show the toast (top, center, bottom).
  static OverlayEntry loading(
    BuildContext context, {
    String message = 'Loading...',
    ToastPosition position = ToastPosition.top,
    Duration? duration,
    bool dismissible = false,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => _ToastOverlay(
        message: message,
        type: ToastType.loading,
        position: position,
        onDismiss: () => entry.remove(),
        duration: duration ?? Duration.zero,
        dismissible: dismissible,
      ),
    );

    overlay.insert(entry);
    return entry;
  }

  @override
  Widget build(BuildContext context) {
    return _ToastContent(message: message, type: type);
  }
}

/// Internal overlay widget with animation
class _ToastOverlay extends StatefulWidget {
  final String message;
  final ToastType type;
  final ToastPosition position;
  final VoidCallback onDismiss;
  final Duration duration;
  final bool dismissible;

  const _ToastOverlay({
    required this.message,
    required this.type,
    required this.position,
    required this.onDismiss,
    required this.duration,
    required this.dismissible,
  });

  @override
  State<_ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<_ToastOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: _getSlideBegin(),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    // Auto-dismiss after duration
    if (widget.duration > Duration.zero) {
      Future.delayed(widget.duration, _dismiss);
    }
  }

  Offset _getSlideBegin() {
    switch (widget.position) {
      case ToastPosition.top:
        return const Offset(0, -1);
      case ToastPosition.center:
        return Offset.zero;
      case ToastPosition.bottom:
        return const Offset(0, 1);
    }
  }

  void _dismiss() {
    if (!mounted) return;
    _controller.reverse().then((_) {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    Widget toastContent = Material(
      color: Colors.transparent,
      child: _ToastContent(message: widget.message, type: widget.type),
    );

    // Wrap with GestureDetector if dismissible
    if (widget.dismissible) {
      toastContent = GestureDetector(onTap: _dismiss, child: toastContent);
    }

    final Widget animatedContent = SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(child: toastContent),
      ),
    );

    switch (widget.position) {
      case ToastPosition.top:
        return Positioned(
          top: mediaQuery.padding.top + 16,
          left: 24,
          right: 24,
          child: animatedContent,
        );

      case ToastPosition.center:
        return Positioned.fill(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: widget.dismissible
                    ? GestureDetector(onTap: _dismiss, child: toastContent)
                    : toastContent,
              ),
            ),
          ),
        );

      case ToastPosition.bottom:
        return Positioned(
          bottom: mediaQuery.padding.bottom + 16,
          left: 24,
          right: 24,
          child: animatedContent,
        );
    }
  }
}

/// Toast content widget
class _ToastContent extends StatelessWidget {
  final String message;
  final ToastType type;

  const _ToastContent({required this.message, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIcon(),
          if (type != ToastType.info) const SizedBox(width: 12),
          Flexible(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    switch (type) {
      case ToastType.success:
        return Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: AppColors.success,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: AppColors.white, size: 18),
        );

      case ToastType.error:
        return Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: AppColors.error,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.close, color: AppColors.white, size: 18),
        );

      case ToastType.loading:
        return const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppColors.greyMedium,
          ),
        );

      case ToastType.info:
        return const SizedBox.shrink();
    }
  }
}
