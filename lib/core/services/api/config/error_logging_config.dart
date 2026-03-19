/// Configuration for error logging interceptor
class ErrorLoggingConfig {
  final void Function(
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic> context,
  ) logError;

  const ErrorLoggingConfig({
    required this.logError,
  });
}