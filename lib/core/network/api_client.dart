import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import 'api_exceptions.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  
  late final Dio dio;

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(milliseconds: ApiConfig.connectTimeout),
        receiveTimeout: const Duration(milliseconds: ApiConfig.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Automatically inject JWT token from SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options); // continue
      },
      onResponse: (response, handler) {
        // You can handle global response formatting here if needed
        return handler.next(response); // continue
      },
      onError: (DioException e, handler) {
        // Centralized error handling
        String message = 'An unexpected error occurred';
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout) {
          message = 'Connection timed out';
        } else if (e.type == DioExceptionType.connectionError) {
          message = 'No internet connection or server unreachable';
        } else if (e.response != null) {
          // Try to extract error message from response body
          final data = e.response?.data;
          if (data is Map<String, dynamic> && data['error'] != null) {
            message = data['error'].toString();
          } else {
            message = 'Server Error: ${e.response?.statusCode}';
          }
        }
        
        // Return a custom exception
        final customError = DioException(
          requestOptions: e.requestOptions,
          error: ApiException(message, statusCode: e.response?.statusCode),
          response: e.response,
          type: e.type,
        );
        return handler.next(customError);
      },
    ));
  }

  // Helper methods to abstract away Dio specifics from the UI/Providers
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      _throwCustomException(e);
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await dio.post(path, data: data);
    } catch (e) {
      _throwCustomException(e);
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await dio.put(path, data: data);
    } catch (e) {
      _throwCustomException(e);
    }
  }

  Future<Response> delete(String path, {dynamic data}) async {
    try {
      return await dio.delete(path, data: data);
    } catch (e) {
      _throwCustomException(e);
    }
  }

  Never _throwCustomException(dynamic e) {
    if (e is DioException && e.error is ApiException) {
      throw e.error!;
    }
    throw ApiException(e.toString());
  }
}
