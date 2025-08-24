import 'dart:convert';
import 'package:dio/dio.dart';
import '../error/errors.dart';

abstract class ApiInterceptor {
  // Called before making the request
  Future<RequestOptions> onRequest(RequestOptions options);
  
  // Called after receiving the response
  Future<Response> onResponse(Response response);
  
  // Called when an error occurs
  Future<void> onError(DioException error, RequestOptions options);
}

// Default interceptor implementation
class DefaultApiInterceptor implements ApiInterceptor {
  @override
  Future<RequestOptions> onRequest(RequestOptions options) async {
    // Add timestamp
    options.headers['X-Request-Timestamp'] = DateTime.now().millisecondsSinceEpoch.toString();
    
    // Add request ID for tracking
    options.headers['X-Request-ID'] = _generateRequestId();
    
    // Log request
    _logRequest(options);
    
    return options;
  }

  @override
  Future<Response> onResponse(Response response) async {
    // Log response
    _logResponse(response);
    
    // Check for rate limiting headers
    _checkRateLimiting(response);
    
    return response;
  }

  @override
  Future<void> onError(DioException error, RequestOptions options) async {
    // Log error
    _logError(error, options);
    
    // Handle specific error types
    if (error.type == DioExceptionType.badResponse) {
      _handleHttpError(error, options);
    }
  }

  // Generate unique request ID
  String _generateRequestId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecond}';
  }

  // Log request details
  void _logRequest(RequestOptions options) {
    print('🌐 API Request: ${options.method} ${options.path}');
    print('   Headers: ${options.headers}');
    if (options.data != null) {
      print('   Body: ${options.data}');
    }
    if (options.queryParameters.isNotEmpty) {
      print('   Query: ${options.queryParameters}');
    }
  }

  // Log response details
  void _logResponse(Response response) {
    print('📡 API Response: ${response.statusCode} ${response.statusMessage}');
    print('   URL: ${response.requestOptions.path}');
    print('   Headers: ${response.headers.map}');
    if (response.data != null) {
      try {
        if (response.data is Map || response.data is List) {
          print('   Body: ${jsonEncode(response.data)}');
        } else {
          print('   Body: ${response.data}');
        }
      } catch (e) {
        print('   Body: ${response.data}');
      }
    }
  }

  // Log error details
  void _logError(DioException error, RequestOptions options) {
    print('❌ API Error: ${error.message}');
    print('   Request: ${options.method} ${options.path}');
    print('   Error Type: ${error.type}');
    if (error.response != null) {
      print('   Status Code: ${error.response!.statusCode}');
    }
  }

  // Check rate limiting headers
  void _checkRateLimiting(Response response) {
    final remaining = response.headers.value('X-RateLimit-Remaining');
    final reset = response.headers.value('X-RateLimit-Reset');
    
    if (remaining != null && int.tryParse(remaining) != null) {
      final remainingCount = int.parse(remaining);
      if (remainingCount <= 5) {
        print('⚠️  Rate limit warning: $remainingCount requests remaining');
      }
    }
    
    if (reset != null) {
      print('🕐 Rate limit resets at: $reset');
    }
  }

  // Handle HTTP errors
  void _handleHttpError(DioException error, RequestOptions options) {
    if (error.response != null) {
      switch (error.response!.statusCode) {
        case 401:
          print('🔐 Unauthorized request - token may be expired');
          break;
        case 403:
          print('🚫 Forbidden request - insufficient permissions');
          break;
        case 429:
          print('⏰ Rate limited - too many requests');
          break;
        case 500:
          print('💥 Server error - retry later');
          break;
      }
    }
  }
}

// Authentication interceptor
class AuthInterceptor implements ApiInterceptor {
  final String? Function() getToken;
  final VoidCallback? onTokenExpired;

  AuthInterceptor({
    required this.getToken,
    this.onTokenExpired,
  });

  @override
  Future<RequestOptions> onRequest(RequestOptions options) async {
    final token = getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return options;
  }

  @override
  Future<Response> onResponse(Response response) async {
    // Check for 401 response and trigger token refresh
    if (response.statusCode == 401) {
      onTokenExpired?.call();
    }
    return response;
  }

  @override
  Future<void> onError(DioException error, RequestOptions options) async {
    // Handle authentication errors
    if (error.type == DioExceptionType.badResponse && 
        error.response?.statusCode == 401) {
      onTokenExpired?.call();
    }
  }
}

// Retry interceptor
class RetryInterceptor implements ApiInterceptor {
  final int maxRetries;
  final Duration retryDelay;
  final List<int> retryableStatusCodes;

  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
    this.retryableStatusCodes = const [408, 429, 500, 502, 503, 504],
  });

  @override
  Future<RequestOptions> onRequest(RequestOptions options) async {
    return options;
  }

  @override
  Future<Response> onResponse(Response response) async {
    return response;
  }

  @override
  Future<void> onError(DioException error, RequestOptions options) async {
    // Retry logic would be implemented in the API client
    if (error.type == DioExceptionType.badResponse && 
        error.response != null &&
        retryableStatusCodes.contains(error.response!.statusCode)) {
      print('🔄 Retryable error detected: ${error.response!.statusCode}');
    }
  }
}

// Logging interceptor
class LoggingInterceptor implements ApiInterceptor {
  final bool logRequests;
  final bool logResponses;
  final bool logErrors;

  LoggingInterceptor({
    this.logRequests = true,
    this.logResponses = true,
    this.logErrors = true,
  });

  @override
  Future<RequestOptions> onRequest(RequestOptions options) async {
    if (logRequests) {
      print('📤 REQUEST: ${options.method} ${options.path}');
      if (options.data != null) {
        print('   Body: ${options.data}');
      }
      if (options.queryParameters.isNotEmpty) {
        print('   Query: ${options.queryParameters}');
      }
    }
    return options;
  }

  @override
  Future<Response> onResponse(Response response) async {
    if (logResponses) {
      print('📥 RESPONSE: ${response.statusCode} ${response.statusMessage}');
      print('   URL: ${response.requestOptions.path}');
    }
    return response;
  }

  @override
  Future<void> onError(DioException error, RequestOptions options) async {
    if (logErrors) {
      print('❌ ERROR: ${error.message}');
      print('   Request: ${options.method} ${options.path}');
      print('   Type: ${error.type}');
    }
  }
}

// Cache interceptor
class CacheInterceptor implements ApiInterceptor {
  final Map<String, CachedResponse> _cache = {};
  final Duration cacheExpiry;

  CacheInterceptor({this.cacheExpiry = const Duration(minutes: 5)});

  @override
  Future<RequestOptions> onRequest(RequestOptions options) async {
    // Only cache GET requests
    if (options.method == 'GET') {
      final cacheKey = _generateCacheKey(options);
      final cached = _cache[cacheKey];
      
      if (cached != null && !cached.isExpired) {
        print('📦 Serving from cache: ${options.path}');
        // Return cached response
        throw DioException(
          requestOptions: options,
          type: DioExceptionType.other,
          error: 'Cached response',
        );
      }
    }
    
    return options;
  }

  @override
  Future<Response> onResponse(Response response) async {
    // Cache successful GET responses
    if (response.requestOptions.method == 'GET' && 
        response.statusCode != null && 
        response.statusCode! >= 200 && 
        response.statusCode! < 300) {
      final cacheKey = _generateCacheKey(response.requestOptions);
      _cache[cacheKey] = CachedResponse(
        response: response,
        timestamp: DateTime.now(),
        expiry: cacheExpiry,
      );
      print('📦 Cached response: ${response.requestOptions.path}');
    }
    
    return response;
  }

  @override
  Future<void> onError(DioException error, RequestOptions options) async {
    // Handle cache hits
    if (error.error == 'Cached response') {
      final cacheKey = _generateCacheKey(options);
      final cached = _cache[cacheKey];
      if (cached != null) {
        print('📦 Cache hit: ${options.path}');
      }
    }
  }

  String _generateCacheKey(RequestOptions options) {
    return '${options.method}_${options.path}_${options.queryParameters.hashCode}';
  }

  // Clear cache
  void clearCache() {
    _cache.clear();
  }

  // Get cache size
  int get cacheSize => _cache.length;
}

// Cached response wrapper
class CachedResponse {
  final Response response;
  final DateTime timestamp;
  final Duration expiry;

  CachedResponse({
    required this.response,
    required this.timestamp,
    required this.expiry,
  });

  bool get isExpired => DateTime.now().isAfter(timestamp.add(expiry));
}

// Composite interceptor that combines multiple interceptors
class CompositeInterceptor implements ApiInterceptor {
  final List<ApiInterceptor> interceptors;

  CompositeInterceptor(this.interceptors);

  @override
  Future<RequestOptions> onRequest(RequestOptions options) async {
    RequestOptions currentOptions = options;
    for (final interceptor in interceptors) {
      currentOptions = await interceptor.onRequest(currentOptions);
    }
    return currentOptions;
  }

  @override
  Future<Response> onResponse(Response response) async {
    Response currentResponse = response;
    for (final interceptor in interceptors) {
      currentResponse = await interceptor.onResponse(currentResponse);
    }
    return currentResponse;
  }

  @override
  Future<void> onError(DioException error, RequestOptions options) async {
    for (final interceptor in interceptors) {
      await interceptor.onError(error, options);
    }
  }
}

// Dio-specific interceptors
class DioLogInterceptor extends LoggingInterceptor {
  DioLogInterceptor({
    super.logRequests = true,
    super.logResponses = true,
    super.logErrors = true,
  });
}

class DioAuthInterceptor extends AuthInterceptor {
  DioAuthInterceptor({
    required super.getToken,
    super.onTokenExpired,
  });
}

class DioRetryInterceptor extends RetryInterceptor {
  DioRetryInterceptor({
    super.maxRetries = 3,
    super.retryDelay = const Duration(seconds: 1),
    super.retryableStatusCodes = const [408, 429, 500, 502, 503, 504],
  });
}
