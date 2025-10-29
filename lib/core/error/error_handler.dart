import 'dart:developer';
import 'app_exception.dart';
import 'network_exception.dart';
import 'validation_exception.dart';
import 'database_exception.dart';
import 'business_exception.dart';

class ErrorHandler {
  static void handleError(dynamic error, {String? context}) {
    if (error is AppException) {
      _handleAppException(error, context);
    } else if (error is Exception) {
      _handleGenericException(error, context);
    } else {
      _handleUnknownError(error, context);
    }
  }

  static void _handleAppException(AppException exception, String? context) {
    final contextInfo = context != null ? ' in $context' : '';
    
    log('AppException$contextInfo: ${exception.message}', 
        error: exception, 
        stackTrace: StackTrace.current);
    
    switch (exception.runtimeType) {
      case NetworkException:
        _handleNetworkException(exception as NetworkException, contextInfo);
        break;
      case ValidationException:
        _handleValidationException(exception as ValidationException, contextInfo);
        break;
      case DatabaseException:
        _handleDatabaseException(exception as DatabaseException, contextInfo);
        break;
      case BusinessException:
        _handleBusinessException(exception as BusinessException, contextInfo);
        break;
      default:
        log('Unknown AppException type: ${exception.runtimeType}');
    }
  }

  static void _handleNetworkException(NetworkException exception, String contextInfo) {
    log('Network Error$contextInfo: ${exception.message} (${exception.statusCode})');
    
    if (exception.statusCode == 401) {
      // Handle unauthorized - maybe redirect to login
      log('User unauthorized, redirecting to login');
    } else if (exception.statusCode == 500) {
      // Handle server error
      log('Server error occurred');
    }
  }

  static void _handleValidationException(ValidationException exception, String contextInfo) {
    log('Validation Error$contextInfo: ${exception.message} for field: ${exception.field}');
    log('Validation errors: ${exception.errors}');
  }

  static void _handleDatabaseException(DatabaseException exception, String contextInfo) {
    log('Database Error$contextInfo: ${exception.message}');
    log('Operation: ${exception.operation}, Table: ${exception.table}');
  }

  static void _handleBusinessException(BusinessException exception, String contextInfo) {
    log('Business Error$contextInfo: ${exception.message}');
    log('Operation: ${exception.operation}, Entity: ${exception.entity}');
  }

  static void _handleGenericException(Exception exception, String? context) {
    final contextInfo = context != null ? ' in $context' : '';
    log('Generic Exception$contextInfo: ${exception.toString()}', 
        error: exception, 
        stackTrace: StackTrace.current);
  }

  static void _handleUnknownError(dynamic error, String? context) {
    final contextInfo = context != null ? ' in $context' : '';
    log('Unknown Error$contextInfo: ${error.toString()}', 
        error: error, 
        stackTrace: StackTrace.current);
  }

  static String getUserFriendlyMessage(dynamic error) {
    if (error is AppException) {
      return error.message;
    } else if (error is Exception) {
      return 'An unexpected error occurred';
    } else {
      return 'Something went wrong';
    }
  }

  static bool isNetworkError(dynamic error) {
    return error is NetworkException;
  }

  static bool isValidationError(dynamic error) {
    return error is ValidationException;
  }

  static bool isDatabaseError(dynamic error) {
    return error is DatabaseException;
  }

  static bool isBusinessError(dynamic error) {
    return error is BusinessException;
  }
}

