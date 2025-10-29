import 'package:callparts/core/error/app_exception.dart';

sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get data => isSuccess ? (this as Success<T>).data : null;
  AppException? get error => isFailure ? (this as Failure<T>).error : null;

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(AppException error) onFailure,
  }) {
    if (isSuccess) {
      return onSuccess((this as Success<T>).data);
    } else {
      return onFailure((this as Failure<T>).error);
    }
  }

  Result<R> map<R>(R Function(T data) transform) {
    return fold(
      onSuccess: (data) => Success(transform(data)),
      onFailure: (error) => Failure(error),
    );
  }

  Result<T> onSuccess(void Function(T data) callback) {
    if (isSuccess) {
      callback((this as Success<T>).data);
    }
    return this;
  }

  Result<T> onFailure(void Function(AppException error) callback) {
    if (isFailure) {
      callback((this as Failure<T>).error);
    }
    return this;
  }
}

class Success<T> extends Result<T> {
  final T data;
  
  const Success(this.data);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> &&
          runtimeType == other.runtimeType &&
          data == other.data;

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'Success($data)';
}

class Failure<T> extends Result<T> {
  final AppException error;
  
  const Failure(this.error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<T> &&
          runtimeType == other.runtimeType &&
          error == other.error;

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'Failure($error)';
}

// Extension methods for easier usage
extension ResultExtensions<T> on Result<T> {
  T getOrThrow() {
    if (isSuccess) {
      return data!;
    } else {
      throw error!;
    }
  }

  T getOrElse(T Function() defaultValue) {
    if (isSuccess) {
      return data!;
    } else {
      return defaultValue();
    }
  }

  T? getOrNull() {
    return data;
  }
}

