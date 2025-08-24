import 'api_client.dart';
import 'api_response.dart';
import '../error/errors.dart';

abstract class ApiService {
  final ApiClient client;

  const ApiService(this.client);

  // Generic GET method
  Future<Result<ApiResponse<T>>> get<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final result = await client.get<Map<String, dynamic>>(
        endpoint,
        headers: headers,
        queryParams: queryParams,
      );

      return result.fold(
        onSuccess: (jsonData) {
          final response = ApiResponse<T>.fromJson(jsonData, fromJson);
          return Success(response);
        },
        onFailure: (error) => Failure(error),
      );
    } catch (e) {
      return Failure(NetworkException(
        'GET request failed: ${e.toString()}',
        code: 'GET_FAILED',
      ));
    }
  }

  // Generic POST method
  Future<Result<ApiResponse<T>>> post<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final result = await client.post<Map<String, dynamic>>(
        endpoint,
        headers: headers,
        body: body,
        queryParams: queryParams,
      );

      return result.fold(
        onSuccess: (jsonData) {
          final response = ApiResponse<T>.fromJson(jsonData, fromJson);
          return Success(response);
        },
        onFailure: (error) => Failure(error),
      );
    } catch (e) {
      return Failure(NetworkException(
        'POST request failed: ${e.toString()}',
        code: 'POST_FAILED',
      ));
    }
  }

  // Generic PUT method
  Future<Result<ApiResponse<T>>> put<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final result = await client.put<Map<String, dynamic>>(
        endpoint,
        headers: headers,
        body: body,
        queryParams: queryParams,
      );

      return result.fold(
        onSuccess: (jsonData) {
          final response = ApiResponse<T>.fromJson(jsonData, fromJson);
          return Success(response);
        },
        onFailure: (error) => Failure(error),
      );
    } catch (e) {
      return Failure(NetworkException(
        'PUT request failed: ${e.toString()}',
        code: 'PUT_FAILED',
      ));
    }
  }

  // Generic DELETE method
  Future<Result<ApiResponse<T>>> delete<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final result = await client.delete<Map<String, dynamic>>(
        endpoint,
        headers: headers,
        queryParams: queryParams,
      );

      return result.fold(
        onSuccess: (jsonData) {
          final response = ApiResponse<T>.fromJson(jsonData, fromJson);
          return Success(response);
        },
        onFailure: (error) => Failure(error),
      );
    } catch (e) {
      return Failure(NetworkException(
        'DELETE request failed: ${e.toString()}',
        code: 'DELETE_FAILED',
      ));
    }
  }

  // Generic PATCH method
  Future<Result<ApiResponse<T>>> patch<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final result = await client.patch<Map<String, dynamic>>(
        endpoint,
        headers: headers,
        body: body,
        queryParams: queryParams,
      );

      return result.fold(
        onSuccess: (jsonData) {
          final response = ApiResponse<T>.fromJson(jsonData, fromJson);
          return Success(response);
        },
        onFailure: (error) => Failure(error),
      );
    } catch (e) {
      return Failure(NetworkException(
        'PATCH request failed: ${e.toString()}',
        code: 'PATCH_FAILED',
      ));
    }
  }

  // Handle API response with error checking
  Result<T> handleApiResponse<T>(ApiResponse<T> response) {
    if (response.success && response.hasData) {
      return Success(response.data!);
    } else {
      return Failure(BusinessException(
        response.errorMessage,
        operation: 'API_CALL',
        code: response.errorCode ?? 'API_ERROR',
        details: response.metadata,
      ));
    }
  }

  // Handle paginated response
  Result<PaginatedResponse<T>> handlePaginatedResponse<T>(
    ApiResponse<Map<String, dynamic>> response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (response.success && response.hasData) {
      try {
        final paginatedData = PaginatedResponse<T>.fromJson(
          response.data!,
          fromJson,
        );
        return Success(paginatedData);
      } catch (e) {
        return Failure(NetworkException(
          'Failed to parse paginated response: ${e.toString()}',
          code: 'PARSE_PAGINATION_ERROR',
        ));
      }
    } else {
      return Failure(BusinessException(
        response.errorMessage,
        operation: 'API_CALL',
        code: response.errorCode ?? 'API_ERROR',
        details: response.metadata,
      ));
    }
  }

  // Set authentication token
  void setAuthToken(String token) {
    client.setAuthToken(token);
  }

  // Clear authentication token
  void clearAuthToken() {
    client.clearAuthToken();
  }

  // Add interceptor
  void addInterceptor(dynamic interceptor) {
    client.addInterceptor(interceptor);
  }

  // Remove interceptor
  void removeInterceptor(dynamic interceptor) {
    client.removeInterceptor(interceptor);
  }

  // Get Dio instance for advanced usage
  dynamic get dio => client.dio;
}

// Paginated response wrapper
class PaginatedResponse<T> {
  final List<T> data;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const PaginatedResponse({
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final data = (json['data'] as List<dynamic>?)
        ?.map((item) => fromJson(item as Map<String, dynamic>))
        .toList() ?? [];

    return PaginatedResponse<T>(
      data: data,
      currentPage: json['current_page'] ?? json['page'] ?? 1,
      totalPages: json['total_pages'] ?? json['last_page'] ?? 1,
      totalItems: json['total'] ?? json['total_items'] ?? 0,
      itemsPerPage: json['per_page'] ?? json['items_per_page'] ?? 10,
      hasNextPage: json['has_next_page'] ?? (json['current_page'] ?? 1) < (json['total_pages'] ?? 1),
      hasPreviousPage: json['has_previous_page'] ?? (json['current_page'] ?? 1) > 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'current_page': currentPage,
      'total_pages': totalPages,
      'total': totalItems,
      'per_page': itemsPerPage,
      'has_next_page': hasNextPage,
      'has_previous_page': hasPreviousPage,
    };
  }

  bool get isEmpty => data.isEmpty;
  bool get isNotEmpty => data.isNotEmpty;
  int get length => data.length;
}
