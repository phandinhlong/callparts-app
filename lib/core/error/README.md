# Error Handling System

Hệ thống xử lý lỗi toàn diện cho ứng dụng Flutter với kiến trúc Clean Architecture.

## Các thành phần chính

### 1. AppException (Base Class)
- Lớp cơ sở cho tất cả các exception trong ứng dụng
- Chứa message, code và details

### 2. NetworkException
- Xử lý lỗi mạng và HTTP
- Có các factory methods cho các status code phổ biến
- Hỗ trợ connection error và timeout

### 3. ValidationException
- Xử lý lỗi validation dữ liệu
- Các factory methods cho các loại validation phổ biến
- Hỗ trợ field validation với error details

### 4. DatabaseException
- Xử lý lỗi database
- Hỗ trợ các operation: INSERT, UPDATE, DELETE, QUERY
- Có thông tin về table và operation

### 5. BusinessException
- Xử lý lỗi business logic
- Hỗ trợ permission, resource management
- Business rule validation

### 6. ErrorHandler
- Utility class để xử lý và log lỗi
- Phân loại lỗi theo type
- Tạo user-friendly messages

### 7. Result<T>
- Generic wrapper cho kết quả thành công/thất bại
- Hỗ trợ functional programming patterns
- Extension methods để dễ sử dụng

## Cách sử dụng

### Import
```dart
import 'package:your_app/core/error/errors.dart';
```

### Sử dụng Result với network operations
```dart
Future<Result<String>> fetchData() async {
  try {
    final response = await http.get(Uri.parse('https://api.example.com/data'));
    if (response.statusCode == 200) {
      return Success(response.body);
    } else {
      return Failure(NetworkException.fromStatusCode(response.statusCode));
    }
  } catch (e) {
    return Failure(NetworkException.connectionError());
  }
}
```

### Sử dụng Result với validation
```dart
Result<User> createUser(String email, String password) {
  if (email.isEmpty) {
    return Failure(ValidationException.fieldRequired('email'));
  }
  
  if (password.length < 6) {
    return Failure(ValidationException.minLength('password', 6));
  }
  
  return Success(User(email: email, password: password));
}
```

### Xử lý kết quả
```dart
final result = await fetchData();
result.fold(
  onSuccess: (data) => print('Data: $data'),
  onFailure: (error) => print('Error: ${error.message}'),
);
```

### Sử dụng extension methods
```dart
final data = result.getOrNull();
final dataOrDefault = result.getOrElse(() => 'Default value');
```

### Error handling với ErrorHandler
```dart
try {
  // Some operation
} catch (e) {
  ErrorHandler.handleError(e, context: 'UserService');
  
  final message = ErrorHandler.getUserFriendlyMessage(e);
  // Show message to user
  
  if (ErrorHandler.isNetworkError(e)) {
    // Handle network error specifically
  }
}
```

## Best Practices

1. **Luôn sử dụng Result<T>** cho các operation có thể thất bại
2. **Sử dụng factory methods** của các Exception classes
3. **Log lỗi** với context để dễ debug
4. **Tạo user-friendly messages** cho người dùng cuối
5. **Sử dụng sealed class Result** để đảm bảo type safety
6. **Xử lý lỗi ở layer phù hợp** (UI, Business Logic, Data)

## Ví dụ hoàn chỉnh

Xem file `example_usage.dart` để có ví dụ chi tiết về cách sử dụng toàn bộ hệ thống.

