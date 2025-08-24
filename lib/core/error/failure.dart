import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure(this.message, {this.code});

  @override
  String toString() => 'Failure(code: $code, message: $message)';

  @override
  List<Object> get props => [message];
}

// Specific Failure Types
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message, {super.code});
}

class TokenExpired extends Failure {
  const TokenExpired(super.message, {super.code});
}
