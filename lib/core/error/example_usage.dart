import 'errors.dart';

// Example usage of the error handling system
class ExampleService {
  // Example of using Result with network operations
  Future<Result<String>> fetchData() async {
    try {
      // Simulate network call
      await Future.delayed(const Duration(seconds: 1));
      
      // Simulate success
      return const Success('Data fetched successfully');
      
      // Simulate network error
      // throw NetworkException.connectionError();
      
      // Simulate server error
      // throw NetworkException.fromStatusCode(500);
      
    } catch (e) {
      if (e is AppException) {
        return Failure(e);
      } else {
        return Failure(AppException('Unknown error occurred'));
      }
    }
  }

  // Example of using Result with validation
  Result<User> createUser(String email, String password) {
    try {
      // Validate email
      if (email.isEmpty) {
        throw ValidationException.fieldRequired('email');
      }
      
      if (!email.contains('@')) {
        throw ValidationException.invalidFormat('email', 'valid email format');
      }

      // Validate password
      if (password.isEmpty) {
        throw ValidationException.fieldRequired('password');
      }
      
      if (password.length < 6) {
        throw ValidationException.minLength('password', 6);
      }

      // Create user if validation passes
      final user = User(email: email, password: password);
      return Success(user);
      
    } catch (e) {
      if (e is AppException) {
        return Failure(e);
      } else {
        return Failure(AppException('Validation failed'));
      }
    }
  }

  // Example of using Result with database operations
  Future<Result<User>> saveUser(User user) async {
    try {
      // Simulate database operation
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Simulate success
      return Success(user);
      
      // Simulate database error
      // throw DatabaseException.insertFailed('users', details: 'Connection timeout');
      
    } catch (e) {
      if (e is AppException) {
        return Failure(e);
      } else {
        return Failure(DatabaseException.insertFailed('users', details: e.toString()));
      }
    }
  }

  // Example of using ErrorHandler
  void handleOperationError(dynamic error) {
    ErrorHandler.handleError(error, context: 'ExampleService');
    
    // Get user-friendly message
    final message = ErrorHandler.getUserFriendlyMessage(error);
    print('User message: $message');
    
    // Check error type
    if (ErrorHandler.isNetworkError(error)) {
      print('This is a network error');
    } else if (ErrorHandler.isValidationError(error)) {
      print('This is a validation error');
    }
  }
}

// Example User class
class User {
  final String email;
  final String password;

  const User({required this.email, required this.password});

  @override
  String toString() => 'User(email: $email)';
}

// Example of how to use in your app
void main() async {
  final service = ExampleService();
  
  // Example 1: Fetch data with Result
  final fetchResult = await service.fetchData();
  fetchResult.fold(
    onSuccess: (data) => print('Success: $data'),
    onFailure: (error) => print('Error: ${error?.message}'),
  );

  // Example 2: Create user with validation
  final createResult = service.createUser('test@example.com', '123456');
  createResult.fold(
    onSuccess: (user) => print('User created: $user'),
    onFailure: (error) => print('Validation failed: ${error.message}'),
  );

  // Example 3: Save user to database
  if (createResult.isSuccess) {
    final saveResult = await service.saveUser(createResult.data!);
    saveResult.fold(
      onSuccess: (user) => print('User saved: $user'),
      onFailure: (error) => print('Save failed: ${error.message}'),
    );
  }

  // Example 4: Using extension methods
  final user = createResult.getOrNull();
  if (user != null) {
    print('User available: $user');
  }

  // Example 5: Error handling
  try {
    service.createUser('', '');
  } catch (e) {
    service.handleOperationError(e);
  }
}

extension on Object? {
  get message => null;
}
