class ApiConfig {
  final String baseUrl;
  final Duration timeout;
  final Duration connectTimeout;
  final int maxRetries;
  final Duration retryDelay;
  final Map<String, String> defaultHeaders;
  final bool enableLogging;
  final bool enableRetry;
  final bool enableAuth;
  final String? authToken;

  const ApiConfig({
    required this.baseUrl,
    this.timeout = const Duration(seconds: 30),
    this.connectTimeout = const Duration(seconds: 10),
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
    this.defaultHeaders = const {},
    this.enableLogging = true,
    this.enableRetry = true,
    this.enableAuth = false,
    this.authToken,
  });

  // Development configuration
  factory ApiConfig.development() {
    return const ApiConfig(
      baseUrl: 'http://localhost:8000/api',
      enableLogging: true,
      enableRetry: true,
      enableAuth: false,
    );
  }

  // Staging configuration
  factory ApiConfig.staging() {
    return const ApiConfig(
      baseUrl: 'https://staging-api.example.com/api',
      enableLogging: true,
      enableRetry: true,
      enableAuth: true,
    );
  }

  // Production configuration
  factory ApiConfig.production() {
    return const ApiConfig(
      baseUrl: 'https://api.example.com/api',
      enableLogging: false,
      enableRetry: true,
      enableAuth: true,
    );
  }

  // Copy with modifications
  ApiConfig copyWith({
    String? baseUrl,
    Duration? timeout,
    Duration? connectTimeout,
    int? maxRetries,
    Duration? retryDelay,
    Map<String, String>? defaultHeaders,
    bool? enableLogging,
    bool? enableRetry,
    bool? enableAuth,
    String? authToken,
  }) {
    return ApiConfig(
      baseUrl: baseUrl ?? this.baseUrl,
      timeout: timeout ?? this.timeout,
      connectTimeout: connectTimeout ?? this.connectTimeout,
      maxRetries: maxRetries ?? this.maxRetries,
      retryDelay: retryDelay ?? this.retryDelay,
      defaultHeaders: defaultHeaders ?? this.defaultHeaders,
      enableLogging: enableLogging ?? this.enableLogging,
      enableRetry: enableRetry ?? this.enableRetry,
      enableAuth: enableAuth ?? this.enableAuth,
      authToken: authToken ?? this.authToken,
    );
  }

  // Get headers with auth token if enabled
  Map<String, String> get headers {
    final headers = Map<String, String>.from(defaultHeaders);
    
    if (enableAuth && authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }
    
    return headers;
  }

  // Validate configuration
  bool get isValid {
    if (baseUrl.isEmpty) return false;
    if (timeout.inSeconds <= 0) return false;
    if (maxRetries < 0) return false;
    return true;
  }

  // Get validation errors
  List<String> get validationErrors {
    final errors = <String>[];
    
    if (baseUrl.isEmpty) {
      errors.add('Base URL cannot be empty');
    }
    
    if (timeout.inSeconds <= 0) {
      errors.add('Timeout must be positive');
    }
    
    if (maxRetries < 0) {
      errors.add('Max retries cannot be negative');
    }
    
    if (enableAuth && authToken == null) {
      errors.add('Auth token required when auth is enabled');
    }
    
    return errors;
  }

  @override
  String toString() {
    return 'ApiConfig('
        'baseUrl: $baseUrl, '
        'timeout: $timeout, '
        'maxRetries: $maxRetries, '
        'enableLogging: $enableLogging, '
        'enableRetry: $enableRetry, '
        'enableAuth: $enableAuth'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApiConfig &&
        other.baseUrl == baseUrl &&
        other.timeout == timeout &&
        other.connectTimeout == connectTimeout &&
        other.maxRetries == maxRetries &&
        other.retryDelay == retryDelay &&
        other.enableLogging == enableLogging &&
        other.enableRetry == enableRetry &&
        other.enableAuth == enableAuth &&
        other.authToken == authToken;
  }

  @override
  int get hashCode {
    return baseUrl.hashCode ^
        timeout.hashCode ^
        connectTimeout.hashCode ^
        maxRetries.hashCode ^
        retryDelay.hashCode ^
        enableLogging.hashCode ^
        enableRetry.hashCode ^
        enableAuth.hashCode ^
        authToken.hashCode;
  }
}

// Environment-specific configurations
class EnvironmentConfig {
  static const String _devBaseUrl = 'http://localhost:8000/api';
  static const String _stagingBaseUrl = 'https://staging-api.example.com/api';
  static const String _prodBaseUrl = 'https://api.example.com/api';

  // Get configuration based on environment
  static ApiConfig getConfig(String environment) {
    switch (environment.toLowerCase()) {
      case 'development':
      case 'dev':
        return ApiConfig.development();
      case 'staging':
      case 'stg':
        return ApiConfig.staging();
      case 'production':
      case 'prod':
        return ApiConfig.production();
      default:
        return ApiConfig.development();
    }
  }

  // Get base URL for environment
  static String getBaseUrl(String environment) {
    switch (environment.toLowerCase()) {
      case 'development':
      case 'dev':
        return _devBaseUrl;
      case 'staging':
      case 'stg':
        return _stagingBaseUrl;
      case 'production':
      case 'prod':
        return _prodBaseUrl;
      default:
        return _devBaseUrl;
    }
  }

  // Check if environment is production
  static bool isProduction(String environment) {
    return environment.toLowerCase() == 'production' ||
           environment.toLowerCase() == 'prod';
  }

  // Check if environment is development
  static bool isDevelopment(String environment) {
    return environment.toLowerCase() == 'development' ||
           environment.toLowerCase() == 'dev';
  }

  // Check if environment is staging
  static bool isStaging(String environment) {
    return environment.toLowerCase() == 'staging' ||
           environment.toLowerCase() == 'stg';
  }
}

