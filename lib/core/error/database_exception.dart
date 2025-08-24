import 'app_exception.dart';

class DatabaseException extends AppException {
  final String operation;
  final String? table;

  const DatabaseException(
    String message, {
    required this.operation,
    this.table,
    super.code,
    super.details,
  });

  factory DatabaseException.connectionFailed() {
    return const DatabaseException(
      'Database connection failed',
      operation: 'CONNECT',
      code: 'CONNECTION_FAILED',
    );
  }

  factory DatabaseException.insertFailed(String table, {String? details}) {
    return DatabaseException(
      'Failed to insert data into $table',
      operation: 'INSERT',
      table: table,
      code: 'INSERT_FAILED',
      details: details,
    );
  }

  factory DatabaseException.updateFailed(String table, {String? details}) {
    return DatabaseException(
      'Failed to update data in $table',
      operation: 'UPDATE',
      table: table,
      code: 'UPDATE_FAILED',
      details: details,
    );
  }

  factory DatabaseException.deleteFailed(String table, {String? details}) {
    return DatabaseException(
      'Failed to delete data from $table',
      operation: 'DELETE',
      table: table,
      code: 'DELETE_FAILED',
      details: details,
    );
  }

  factory DatabaseException.queryFailed(String table, {String? details}) {
    return DatabaseException(
      'Failed to query data from $table',
      operation: 'QUERY',
      table: table,
      code: 'QUERY_FAILED',
      details: details,
    );
  }

  factory DatabaseException.recordNotFound(String table, String id) {
    return DatabaseException(
      'Record not found in $table with id: $id',
      operation: 'QUERY',
      table: table,
      code: 'RECORD_NOT_FOUND',
      details: 'ID: $id',
    );
  }

  factory DatabaseException.constraintViolation(String table, String constraint) {
    return DatabaseException(
      'Constraint violation in $table: $constraint',
      operation: 'CONSTRAINT',
      table: table,
      code: 'CONSTRAINT_VIOLATION',
      details: constraint,
    );
  }
}
