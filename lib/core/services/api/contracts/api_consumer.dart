import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../errors/failure.dart';

/// Abstract contract for API consumer implementations.
///
/// Provides both raw data access and wrapped response methods.
// ignore: unintended_html_in_doc_comment
/// All methods return Either<Failure, T> for functional error handling.
abstract class ApiConsumer {
  // ============= RAW DATA METHODS =============
  // Use these when you want direct access to response data

  /// Perform a GET request and return raw data
  Future<Either<Failure, T>> get<T>({
    required String endpoint,
    required T Function(dynamic) converter,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Options? options,
  });

  /// Perform a POST request and return raw data
  Future<Either<Failure, T>> post<T>({
    required String endpoint,
    required T Function(dynamic) converter,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Options? options,
  });

  // ============= REQUEST MANAGEMENT =============

  /// Cancel all pending requests
  void cancelAllRequests([String? reason]);

  /// Get the number of pending requests
  int get pendingRequestCount;
}
