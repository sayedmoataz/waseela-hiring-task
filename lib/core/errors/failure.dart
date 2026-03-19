import 'package:equatable/equatable.dart';
import '../services/api/config/constants.dart';

/// Base Failure class - Represents all possible failures
sealed class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Server-related failures
final class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

/// Network connectivity failures
final class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Please check your network.',
    super.code = ResponseCode.noInternetConnection, 
  });
}

/// Request timeout failures
final class TimeoutFailure extends Failure {
  final TimeoutType type;
  
  const TimeoutFailure({
    required this.type,
    super.message = 'Request timeout. Please try again.',
  }) : super(
    code: type == TimeoutType.connect ? ResponseCode.connectTimeout 
        : type == TimeoutType.send ? ResponseCode.sendTimeout 
        : ResponseCode.receiveTimeout, 
  );

  @override
  List<Object?> get props => [message, code, type];
}

enum TimeoutType { connect, send, receive }

/// Authentication failures
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Unauthorized. Please login again.',
    super.code = ResponseCode.unauthorized, 
  });
}

/// Permission failures
final class ForbiddenFailure extends Failure {
  const ForbiddenFailure({
    super.message = 'Access forbidden.',
    super.code = ResponseCode.forbidden, 
  });
}

/// Resource not found failures
final class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'Resource not found.',
    super.code = ResponseCode.notFound, 
  });
}

/// Validation failures with field-level errors
final class ValidationFailure extends Failure {
  final Map<String, dynamic>? errors;

  const ValidationFailure({
    super.message = 'Validation failed.',
    this.errors,
    super.code = ResponseCode.validationError, 
  });

  @override
  List<Object?> get props => [message, code, errors];
}

/// Request cancellation failures
final class CancelFailure extends Failure {
  const CancelFailure({
    super.message = 'Request was cancelled.',
    super.code = ResponseCode.cancel, 
  });
}

/// Cache-related failures
final class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Failed to load cached data.',
    super.code = ResponseCode.cacheError, 
  });
}

/// Parse/serialization failures
final class ParseFailure extends Failure {
  const ParseFailure({
    super.message = 'Failed to parse response data.',
  });
}

/// Unknown/unexpected failures
final class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred.',
    super.code = ResponseCode.defaultError, 
  });
}

/// Hive-related failures
final class HiveFailure extends Failure {
  const HiveFailure({
    super.message = 'Failed to load cached data.',
    super.code = ResponseCode.cacheError,
  });
}
