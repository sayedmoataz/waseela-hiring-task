import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../errors/error_handler.dart';
import '../../../errors/failure.dart';
import '../config/constants.dart';
import '../config/network_config.dart';
import '../contracts/api_consumer.dart';
import '../interceptors/cancellation_interceptor.dart';

/// Dio-based implementation of ApiConsumer.

class DioConsumer implements ApiConsumer {
  final Dio _dio;
  final CancellationInterceptor _cancellationInterceptor;

  DioConsumer(
    NetworkConfig config, {
    CancellationInterceptor? cancellationInterceptor,
  }) : _cancellationInterceptor =
           cancellationInterceptor ?? CancellationInterceptor(),
       _dio = _createDio(config) {
    // Validate config before setup
    config.validate();

    // Add interceptors...
    _setupInterceptors(config);
  }

  /// Create Dio instance with base options
  static Dio _createDio(NetworkConfig config) {
    return Dio(
      BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: config.connectTimeout,
        receiveTimeout: config.receiveTimeout,
        sendTimeout: config.sendTimeout,
        responseType: config.defaultResponseType,
        validateStatus: config.validateStatus,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          ...config.defaultHeaders,
        },
      ),
    );
  }

  /// Setup Dio interceptors based on config
  void _setupInterceptors(NetworkConfig config) {
    _dio.interceptors.add(_cancellationInterceptor);

    for (var interceptor in config.interceptors) {
      _dio.interceptors.add(interceptor);
    }

    if (config.enableLogging) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      );
    }
  }

  /// Core request handler with error mapping and type-safe conversion
  Future<Either<Failure, T>> _request<T>({
    required Future<Response> Function() request,
    required T Function(dynamic) converter,
  }) async {
    try {
      final response = await request();

      if (!ResponseCode.isSuccess(response.statusCode)) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }

      final data = converter(response.data);
      return Right(data);
    } catch (e) {
      return Left(ErrorHandler.handle(e, stackTrace: StackTrace.current));
    }
  }

  @override
  Future<Either<Failure, T>> get<T>({
    required String endpoint,
    required T Function(dynamic) converter,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Options? options,
  }) async {
    return _request(
      request: () => _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: _buildOptions(headers, options),
      ),
      converter: converter,
    );
  }

  @override
  Future<Either<Failure, T>> post<T>({
    required String endpoint,
    required T Function(dynamic) converter,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Options? options,
  }) async {
    return _request(
      request: () => _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _buildOptions(headers, options),
      ),
      converter: converter,
    );
  }

  @override
  void cancelAllRequests([String? reason]) {
    _cancellationInterceptor.cancelAll(reason);
  }

  @override
  int get pendingRequestCount => _cancellationInterceptor.pendingRequestCount;

  /// Build Dio Options from headers and custom options
  Options _buildOptions(Map<String, String>? headers, Options? options) {
    if (options != null) {
      return options.copyWith(headers: {...?options.headers, ...?headers});
    }
    return Options(headers: headers);
  }

  /// Expose the underlying Dio instance for advanced use cases
  Dio get dio => _dio;
}
