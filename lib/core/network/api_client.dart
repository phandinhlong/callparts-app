import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import '../error/errors.dart';

class ApiClient {
  final String baseUrl;
  final Duration timeout;
  final Map<String, String> defaultHeaders;
  final Dio _dio;

  ApiClient({
    required this.baseUrl,
    this.timeout = const Duration(seconds: 30),
    Map<String, String>? headers,
    Dio? dio,
  }) : 
    defaultHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...?headers,
    },
    _dio = dio ?? Dio() {
    _setupDio();
  }

  void _setupDio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = timeout;
    _dio.options.receiveTimeout = timeout;
    _dio.options.sendTimeout = timeout;
    
    // Add default headers
    _dio.options.headers.addAll(defaultHeaders);
    
    // Add response interceptor for error handling
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add request timestamp
          options.headers['X-Request-Timestamp'] = DateTime.now().millisecondsSinceEpoch.toString();
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) {
          // Convert DioException to NetworkException
          final networkException = _convertDioErrorToNetworkException(error);
          handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              response: error.response,
              type: error.type,
              error: networkException,
            ),
          );
        },
      ),
    );
  }

  // GET request
  Future<Result<T>> get<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    return _makeRequest<T>(
      'GET',
      endpoint,
      headers: headers,
      queryParams: queryParams,
      fromJson: fromJson,
    );
  }

  // POST request
  Future<Result<T>> post<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    return _makeRequest<T>(
      'POST',
      endpoint,
      headers: headers,
      body: body,
      queryParams: queryParams,
      fromJson: fromJson,
    );
  }

  // PUT request
  Future<Result<T>> put<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    return _makeRequest<T>(
      'PUT',
      endpoint,
      headers: headers,
      body: body,
      queryParams: queryParams,
      fromJson: fromJson,
    );
  }

  // DELETE request
  Future<Result<T>> delete<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    return _makeRequest<T>(
      'DELETE',
      endpoint,
      headers: headers,
      queryParams: queryParams,
      fromJson: fromJson,
    );
  }

  // PATCH request
  Future<Result<T>> patch<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    return _makeRequest<T>(
      'PATCH',
      endpoint,
      headers: headers,
      body: body,
      queryParams: queryParams,
      fromJson: fromJson,
    );
  }

  // Generic request method
  Future<Result<T>> _makeRequest<T>(
    String method,
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      // Prepare options
      final options = Options(
        method: method,
        headers: headers,
      );

      // Make request
      final response = await _dio.request(
        endpoint,
        options: options,
        data: body,
        queryParameters: queryParams,
      );

      // Handle response
      return _handleResponse<T>(response, fromJson);
      
    } on DioException catch (e) {
      if (e.error is AppException) {
        return Failure(e.error as AppException);
      }
      return Failure(_convertDioErrorToNetworkException(e));
    } on SocketException {
      return Failure(NetworkException.connectionError());
    } on FormatException {
      return Failure(NetworkException(
        'Invalid response format',
        code: 'INVALID_FORMAT',
      ));
    } catch (e) {
      if (e is AppException) {
        return Failure(e);
      }
      return Failure(NetworkException(
        'Unexpected error: ${e.toString()}',
        code: 'UNEXPECTED_ERROR',
      ));
    }
  }

  // Handle Dio response
  Result<T> _handleResponse<T>(
    Response response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    // Check if response is successful
    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      try {
        if (response.data == null) {
          return Success(null as T);
        }

        // Handle different response data types
        if (response.data is Map<String, dynamic>) {
          final jsonData = response.data as Map<String, dynamic>;
          
          if (fromJson != null) {
            final data = fromJson(jsonData);
            return Success(data);
          } else {
            return Success(jsonData as T);
          }
        } else if (response.data is List) {
          // Handle list responses
          if (fromJson != null) {
            // This would need a different approach for lists
            return Success(response.data as T);
          } else {
            return Success(response.data as T);
          }
        } else {
          // Handle primitive types
          return Success(response.data as T);
        }
      } catch (e) {
        return Failure(NetworkException(
          'Failed to parse response: ${e.toString()}',
          code: 'PARSE_ERROR',
          details: response.data?.toString(),
        ));
      }
    } else {
      // Handle error status codes
      return Failure(NetworkException.fromStatusCode(
        response.statusCode ?? 0,
        message: _getErrorMessage(response),
      ));
    }
  }

  // Get error message from response
  String _getErrorMessage(Response response) {
    try {
      if (response.data != null) {
        if (response.data is Map<String, dynamic>) {
          final json = response.data as Map<String, dynamic>;
          return json['message'] ?? json['error'] ?? 'Request failed';
        } else {
          return response.data.toString();
        }
      }
    } catch (e) {
      // Ignore parsing errors for error messages
    }
    
    return 'Request failed with status ${response.statusCode}';
  }

  // Convert DioException to NetworkException
  NetworkException _convertDioErrorToNetworkException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException.timeout();
      
      case DioExceptionType.badResponse:
        if (error.response != null) {
          return NetworkException.fromStatusCode(
            error.response!.statusCode ?? 0,
            message: _getErrorMessage(error.response!),
          );
        }
        return NetworkException(
          'Bad response',
          code: 'BAD_RESPONSE',
        );
      
      case DioExceptionType.cancel:
        return NetworkException(
          'Request cancelled',
          code: 'CANCELLED',
        );
      
      case DioExceptionType.connectionError:
        return NetworkException.connectionError();
      
      case DioExceptionType.badCertificate:
        return NetworkException(
          'Bad certificate',
          code: 'BAD_CERTIFICATE',
        );
      
      case DioExceptionType.unknown:
      default:
        if (error.error is AppException) {
          return NetworkException(
            error.error.toString(),
            code: 'DIO_ERROR',
          );
        }
        return NetworkException(
          'Network error: ${error.message}',
          code: 'DIO_ERROR',
        );
    }
  }

  // Add authentication header
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Remove authentication header
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  // Add interceptor
  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  // Remove interceptor
  void removeInterceptor(Interceptor interceptor) {
    _dio.interceptors.remove(interceptor);
  }

  // Clear all interceptors
  void clearInterceptors() {
    _dio.interceptors.clear();
  }

  // Get Dio instance for advanced usage
  Dio get dio => _dio;

  // Close Dio client
  void dispose() {
    _dio.close();
  }
}
