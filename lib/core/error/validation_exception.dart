import 'app_exception.dart';

class ValidationException extends AppException {
  final String field;
  final List<String> errors;

  const ValidationException(
    String message, {
    required this.field,
    required this.errors,
    super.code,
    super.details,
  });

  factory ValidationException.fieldRequired(String field) {
    return ValidationException(
      'Field $field is required',
      field: field,
      errors: ['Field is required'],
      code: 'FIELD_REQUIRED',
    );
  }

  factory ValidationException.invalidFormat(String field, String expectedFormat) {
    return ValidationException(
      'Invalid format for $field',
      field: field,
      errors: ['Expected format: $expectedFormat'],
      code: 'INVALID_FORMAT',
    );
  }

  factory ValidationException.invalidValue(String field, String value) {
    return ValidationException(
      'Invalid value for $field: $value',
      field: field,
      errors: ['Value $value is not allowed'],
      code: 'INVALID_VALUE',
    );
  }

  factory ValidationException.minLength(String field, int minLength) {
    return ValidationException(
      '$field must be at least $minLength characters',
      field: field,
      errors: ['Minimum length: $minLength'],
      code: 'MIN_LENGTH',
    );
  }

  factory ValidationException.maxLength(String field, int maxLength) {
    return ValidationException(
      '$field must not exceed $maxLength characters',
      field: field,
      errors: ['Maximum length: $maxLength'],
      code: 'MAX_LENGTH',
    );
  }
}
