# Network System with Dio

Hệ thống giao tiếp API sử dụng thư viện Dio cho ứng dụng Flutter với kiến trúc Clean Architecture.

## 🚀 Tính năng chính

- **HTTP Client**: Sử dụng Dio với interceptors mạnh mẽ
- **Error Handling**: Tích hợp với hệ thống error handling
- **Response Wrapping**: ApiResponse wrapper với type safety
- **Pagination Support**: Hỗ trợ phân trang
- **Authentication**: Interceptor xử lý authentication
- **Caching**: Interceptor cache responses
- **Logging**: Logging chi tiết requests/responses
- **Retry Logic**: Tự động retry cho các lỗi có thể retry

## 📦 Cài đặt

Thêm dependency vào `pubspec.yaml`:

```yaml
dependencies:
  dio: ^5.4.0
```

Chạy:
```bash
flutter pub get
```

## 🏗️ Kiến trúc

```
ApiClient (Dio wrapper)
    ↓
ApiService (Base service)
    ↓
Concrete Services (UserApiService, ProductApiService)
    ↓
Business Logic Layer
```

## 🔧 Cách sử dụng

### 1. Tạo API Configuration

```dart
final config = ApiConfig.development();
// hoặc
final config = ApiConfig.production();
```

### 2. Tạo API Client

```dart
final client = ApiClient(
  baseUrl: config.baseUrl,
  timeout: config.timeout,
  headers: config.headers,
);
```

### 3. Thêm Interceptors

```dart
// Logging
client.addInterceptor(LoggingInterceptor());

// Authentication
client.addInterceptor(AuthInterceptor(
  getToken: () => 'your-token',
  onTokenExpired: () => print('Token expired'),
));

// Caching
client.addInterceptor(CacheInterceptor(
  cacheExpiry: Duration(minutes: 10),
));
```

### 4. Tạo API Service

```dart
class UserApiService extends ApiService {
  UserApiService(super.client);

  Future<Result<User>> getUserProfile(String userId) async {
    final result = await get<User>(
      '/users/$userId',
      fromJson: User.fromJson,
    );

    return result.fold(
      onSuccess: (response) => handleApiResponse(response),
      onFailure: (error) => Failure(error),
    );
  }
}
```

### 5. Sử dụng Service

```dart
final userService = UserApiService(client);

final result = await userService.getUserProfile('user123');
result.fold(
  onSuccess: (user) => print('User: $user'),
  onFailure: (error) => print('Error: ${error.message}'),
);
```

## 📡 HTTP Methods

### GET Request
```dart
final result = await get<User>(
  '/users/$userId',
  queryParams: {'include': 'profile'},
  fromJson: User.fromJson,
);
```

### POST Request
```dart
final result = await post<User>(
  '/users',
  body: {'name': 'John', 'email': 'john@example.com'},
  fromJson: User.fromJson,
);
```

### PUT Request
```dart
final result = await put<User>(
  '/users/$userId',
  body: {'name': 'John Updated'},
  fromJson: User.fromJson,
);
```

### DELETE Request
```dart
final result = await delete<bool>('/users/$userId');
```

## 🔄 Response Handling

### ApiResponse Wrapper
```dart
final response = ApiResponse.success(
  data: user,
  message: 'User created successfully',
  statusCode: 201,
);
```

### Paginated Response
```dart
final result = await get<Map<String, dynamic>>('/users');
return result.fold(
  onSuccess: (response) => handlePaginatedResponse(response, User.fromJson),
  onFailure: (error) => Failure(error),
);
```

## 🛡️ Error Handling

### Network Errors
```dart
if (error is NetworkException) {
  switch (error.statusCode) {
    case 401:
      print('Unauthorized');
      break;
    case 404:
      print('Not found');
      break;
    case 500:
      print('Server error');
      break;
  }
}
```

### Business Errors
```dart
if (error is BusinessException) {
  print('Business error: ${error.message}');
  print('Operation: ${error.operation}');
  print('Entity: ${error.entity}');
}
```

## 🔐 Authentication

### Set Token
```dart
client.setAuthToken('your-jwt-token');
```

### Auth Interceptor
```dart
client.addInterceptor(AuthInterceptor(
  getToken: () => getStoredToken(),
  onTokenExpired: () => refreshToken(),
));
```

## 📦 Caching

### Cache Interceptor
```dart
client.addInterceptor(CacheInterceptor(
  cacheExpiry: Duration(minutes: 15),
));
```

### Cache Control
```dart
final cacheInterceptor = CacheInterceptor();
cacheInterceptor.clearCache();
print('Cache size: ${cacheInterceptor.cacheSize}');
```

## 📊 Advanced Dio Usage

### Multipart Form Data
```dart
final dio = client.dio;
final formData = FormData.fromMap({
  'name': 'Product Name',
  'file': await MultipartFile.fromFile('path/to/file.jpg'),
});

final response = await dio.post(
  '/products/upload',
  data: formData,
);
```

### Custom Interceptors
```dart
dio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) {
      print('Custom request: ${options.method} ${options.path}');
      handler.next(options);
    },
    onResponse: (response, handler) {
      print('Custom response: ${response.statusCode}');
      handler.next(response);
    },
  ),
);
```

## 🧪 Testing

### Mock Dio Client
```dart
final mockDio = Dio();
mockDio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) {
      // Mock response
      handler.resolve(Response(
        requestOptions: options,
        data: {'id': '1', 'name': 'Test User'},
        statusCode: 200,
      ));
    },
  ),
);

final client = ApiClient(
  baseUrl: 'https://test.com',
  dio: mockDio,
);
```

## 📝 Best Practices

1. **Luôn sử dụng Result<T>** để xử lý kết quả
2. **Sử dụng interceptors** cho cross-cutting concerns
3. **Handle errors gracefully** với proper error types
4. **Use proper timeout** cho production
5. **Implement retry logic** cho network failures
6. **Cache responses** khi phù hợp
7. **Log requests/responses** trong development
8. **Validate responses** trước khi sử dụng

## 🔍 Debugging

### Enable Logging
```dart
client.addInterceptor(LoggingInterceptor(
  logRequests: true,
  logResponses: true,
  logErrors: true,
));
```

### Check Interceptors
```dart
print('Active interceptors: ${client.dio.interceptors.length}');
```

## 🚨 Troubleshooting

### Common Issues

1. **Timeout errors**: Tăng timeout duration
2. **CORS issues**: Kiểm tra server configuration
3. **SSL errors**: Kiểm tra certificate trong development
4. **Memory leaks**: Luôn dispose client khi không sử dụng

### Performance Tips

1. **Use connection pooling** với Dio
2. **Implement proper caching** strategy
3. **Batch requests** khi có thể
4. **Cancel requests** không cần thiết

## 📚 Ví dụ hoàn chỉnh

Xem file `example_api_service.dart` để có ví dụ chi tiết về cách sử dụng toàn bộ hệ thống.

