import 'failure.dart';

/// Contenedor funcional `Result<T>` para transporte seguro entre Repositorio y ViewModel.
sealed class Result<T> {
  const Result();

  factory Result.success(T data) = Success<T>;
  factory Result.failure(Failure failure) = Error<T>;

  T? get data => switch (this) {
    Success<T>(data: final d) => d,
    Error<T>() => null,
  };

  Failure? get failure => switch (this) {
    Success<T>() => null,
    Error<T>(failure: final f) => f,
  };

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Error<T>;

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    return switch (this) {
      Success<T>(data: final d) => onSuccess(d),
      Error<T>(failure: final f) => onFailure(f),
    };
  }
}

/// Resultado exitoso con datos de dominio.
final class Success<T> extends Result<T> {
  const Success(this.data);

  @override
  final T data;
}

/// Resultado fallido con objeto [Failure] tipado.
final class Error<T> extends Result<T> {
  const Error(this.failure);

  @override
  final Failure failure;
}
