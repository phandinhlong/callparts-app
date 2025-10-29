class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final String? errorCode;
  final Map<String, dynamic>? metadata;
  final int? statusCode;

  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.errorCode,
    this.metadata,
    this.statusCode,
  });

  // Factory constructor for successful response
  factory ApiResponse.success({
    required T data,
    String? message,
    Map<String, dynamic>? metadata,
    int? statusCode,
  }) {
    return ApiResponse<T>(
      success: true,
      data: data,
      message: message,
      metadata: metadata,
      statusCode: statusCode,
    );
  }

  // Factory constructor for error response
  factory ApiResponse.error({
    String? message,
    String? errorCode,
    Map<String, dynamic>? metadata,
    int? statusCode,
  }) {
    return ApiResponse<T>(
      success: false,
      message: message,
      errorCode: errorCode,
      metadata: metadata,
      statusCode: statusCode,
    );
  }

  // Factory constructor from JSON
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    final success = json['success'] ?? json['status'] == 'success';
    final message = json['message'];
    final errorCode = json['error_code'] ?? json['code'];
    final metadata = json['metadata'] ?? json['meta'];
    final statusCode = json['status_code'];
    final data = null;

    if (success && json['data'] != null) {
      T data;
      if (fromJson != null) {
        data = fromJson(json['data'] as Map<String, dynamic>);
      } else {
        data = json['data'] as T;
      }

      return ApiResponse.success(
        data: data,
        message: message,
        metadata: metadata,
        statusCode: statusCode,
      );
    } else {
      return ApiResponse.error(
        message: message,
        errorCode: errorCode,
        metadata: metadata,
        statusCode: statusCode,
      );
    }
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (data != null) 'data': data,
      if (message != null) 'message': message,
      if (errorCode != null) 'error_code': errorCode,
      if (metadata != null) 'metadata': metadata,
      if (statusCode != null) 'status_code': statusCode,
    };
  }

  // Check if response has data
  bool get hasData => data != null;

  // Check if response has error
  bool get hasError => !success || errorCode != null;

  // Get error message or default
  String get errorMessage => message ?? 'An error occurred';

  // Get data with null safety
  T? get safeData => success ? data : null;

  // Copy with modifications
  ApiResponse<T> copyWith({
    bool? success,
    T? data,
    String? message,
    String? errorCode,
    Map<String, dynamic>? metadata,
    int? statusCode,
  }) {
    return ApiResponse<T>(
      success: success ?? this.success,
      data: data ?? this.data,
      message: message ?? this.message,
      errorCode: errorCode ?? this.errorCode,
      metadata: metadata ?? this.metadata,
      statusCode: statusCode ?? this.statusCode,
    );
  }

  @override
  String toString() {
    return 'ApiResponse(success: $success, data: $data, message: $message, errorCode: $errorCode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApiResponse<T> &&
        other.success == success &&
        other.data == data &&
        other.message == message &&
        other.errorCode == errorCode &&
        other.statusCode == statusCode;
  }

  @override
  int get hashCode {
    return success.hashCode ^
        data.hashCode ^
        message.hashCode ^
        errorCode.hashCode ^
        statusCode.hashCode;
  }
}

