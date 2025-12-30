import 'app_exception.dart';

class BusinessException extends AppException {
  final String operation;
  final String? entity;

  const BusinessException(
    String message, {
    required this.operation,
    this.entity,
    super.code,
    super.details,
  }) : super('');

  factory BusinessException.insufficientPermissions(String operation) {
    return BusinessException(
      'Insufficient permissions for operation: $operation',
      operation: operation,
      code: 'INSUFFICIENT_PERMISSIONS',
    );
  }

  factory BusinessException.resourceNotFound(String entity, String id) {
    return BusinessException(
      '$entity with id $id not found',
      operation: 'FIND',
      entity: entity,
      code: 'RESOURCE_NOT_FOUND',
      details: 'ID: $id',
    );
  }

  factory BusinessException.resourceAlreadyExists(String entity, String identifier) {
    return BusinessException(
      '$entity with identifier $identifier already exists',
      operation: 'CREATE',
      entity: entity,
      code: 'RESOURCE_ALREADY_EXISTS',
      details: 'Identifier: $identifier',
    );
  }

  factory BusinessException.invalidState(String entity, String currentState) {
    return BusinessException(
      '$entity is in invalid state: $currentState',
      operation: 'VALIDATE',
      entity: entity,
      code: 'INVALID_STATE',
      details: 'Current state: $currentState',
    );
  }

  factory BusinessException.businessRuleViolation(String rule, String details) {
    return BusinessException(
      'Business rule violation: $rule',
      operation: 'VALIDATE',
      code: 'BUSINESS_RULE_VIOLATION',
      details: details,
    );
  }

  factory BusinessException.quotaExceeded(String resource, int limit) {
    return BusinessException(
      'Quota exceeded for $resource',
      operation: 'LIMIT_CHECK',
      entity: resource,
      code: 'QUOTA_EXCEEDED',
      details: 'Limit: $limit',
    );
  }
}
