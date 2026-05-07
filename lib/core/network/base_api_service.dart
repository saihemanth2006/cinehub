import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../error/exceptions.dart';
import '../error/failures.dart';
import 'api_client.dart';
import 'api_response.dart';

/// Base API service providing reusable HTTP methods with automatic
/// error mapping from Dio exceptions → app-layer [Failure] types.
///
/// All feature-specific data sources extend this class to inherit:
/// - GET / POST / PATCH / DELETE with typed response deserialization
/// - Consistent exception-to-failure mapping
/// - Structured error parsing from backend error responses
/// - Pagination support built-in
///
/// ```dart
/// class AuthDataSource extends BaseApiService {
///   AuthDataSource(super.client);
///
///   Future<Either<Failure, AuthTokens>> login(LoginDto dto) =>
///       safeRequest(() => post('/auth/login', data: dto.toJson()));
/// }
/// ```
abstract class BaseApiService {
  final ApiClient client;

  BaseApiService(this.client);

  Dio get dio => client.dio;

  // ── Safe Request Wrapper ──────────────────────

  /// Wraps any async operation in try/catch, mapping all errors to [Failure].
  /// This is the primary entry point for all data source methods.
  Future<Either<Failure, T>> safeRequest<T>(
    Future<T> Function() request,
  ) async {
    try {
      final result = await request();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } on FormatException catch (e) {
      return Left(ServerFailure('Invalid response format: ${e.message}'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // ── HTTP Methods ──────────────────────────────

  /// GET request with automatic response parsing.
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
    _assertSuccess(response);
    return response;
  }

  /// POST request.
  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
    _assertSuccess(response);
    return response;
  }

  /// PATCH request.
  Future<Response<dynamic>> patch(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    final response = await dio.patch(path, data: data, options: options);
    _assertSuccess(response);
    return response;
  }

  /// DELETE request.
  Future<Response<dynamic>> delete(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    final response = await dio.delete(path, data: data, options: options);
    _assertSuccess(response);
    return response;
  }

  /// Multipart upload request.
  Future<Response<dynamic>> upload(
    String path, {
    required FormData formData,
    void Function(int, int)? onSendProgress,
  }) async {
    final response = await dio.post(
      path,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
      onSendProgress: onSendProgress,
    );
    _assertSuccess(response);
    return response;
  }

  // ── Response Helpers ──────────────────────────

  /// Extracts the `data` field from a standard API response.
  T extractData<T>(Response response, T Function(Map<String, dynamic>) fromJson) {
    final body = response.data as Map<String, dynamic>;
    final data = body['data'];
    if (data == null) {
      throw const ServerException('Response data is null');
    }
    if (data is Map<String, dynamic>) {
      return fromJson(data);
    }
    throw ServerException('Unexpected data type: ${data.runtimeType}');
  }

  /// Extracts a list of items from paginated API response.
  List<T> extractList<T>(
    Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final body = response.data as Map<String, dynamic>;
    final data = body['data'];
    if (data is List) {
      return data
          .cast<Map<String, dynamic>>()
          .map((item) => fromJson(item))
          .toList();
    }
    throw ServerException('Expected list, got: ${data.runtimeType}');
  }

  /// Extracts pagination metadata from response.
  PaginationMeta? extractPagination(Response response) {
    final body = response.data as Map<String, dynamic>;
    final meta = body['meta'];
    if (meta is Map<String, dynamic>) {
      final pagination = meta['pagination'];
      if (pagination is Map<String, dynamic>) {
        return PaginationMeta.fromJson(pagination);
      }
    }
    return null;
  }

  /// Extracts just the message string from response.
  String extractMessage(Response response) {
    final body = response.data as Map<String, dynamic>;
    return body['message'] as String? ?? 'Success';
  }

  // ── Internal ──────────────────────────────────

  /// Checks response status and throws typed exceptions for error codes.
  void _assertSuccess(Response response) {
    final statusCode = response.statusCode ?? 500;

    if (statusCode >= 200 && statusCode < 300) return;

    // Parse structured error from backend
    final body = response.data;
    String message = 'Request failed';
    String? code;
    List<FieldError>? fieldErrors;

    if (body is Map<String, dynamic>) {
      message = body['message'] as String? ?? message;
      code = body['code'] as String?;

      final errors = body['errors'];
      if (errors is List) {
        fieldErrors = errors
            .cast<Map<String, dynamic>>()
            .map((e) => FieldError.fromJson(e))
            .toList();
      }
    }

    switch (statusCode) {
      case 400:
        if (fieldErrors != null && fieldErrors.isNotEmpty) {
          throw ServerException(
            message,
            statusCode: 400,
          );
        }
        throw ServerException(message, statusCode: 400);
      case 401:
        throw AuthException(message);
      case 403:
        throw AuthException(message);
      case 404:
        throw ServerException(message, statusCode: 404);
      case 409:
        throw ServerException(message, statusCode: 409);
      case 422:
        throw ServerException(message, statusCode: 422);
      case 429:
        throw ServerException('Rate limit exceeded. Please wait.', statusCode: 429);
      default:
        throw ServerException(message, statusCode: statusCode);
    }
  }

  /// Maps Dio-level exceptions to app [Failure] types.
  Failure _mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('Connection timed out. Please try again.');
      case DioExceptionType.connectionError:
        return const NetworkFailure('Cannot connect to server. Check your internet.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 500;
        final body = e.response?.data;
        String message = 'Server error';
        if (body is Map<String, dynamic>) {
          message = body['message'] as String? ?? message;
        }
        if (statusCode == 401 || statusCode == 403) {
          return AuthFailure(message);
        }
        return ServerFailure(message, statusCode: statusCode);
      case DioExceptionType.cancel:
        return const ServerFailure('Request was cancelled');
      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          return const NetworkFailure();
        }
        return UnexpectedFailure(e.message ?? 'Unknown error');
      default:
        return UnexpectedFailure(e.message ?? 'Unknown error');
    }
  }
}
