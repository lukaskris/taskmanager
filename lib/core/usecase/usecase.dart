// core/usecases/usecase.dart
import 'package:dartz/dartz.dart';
import 'package:taskmanager/core/error/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

abstract class NoParamUseCase<Type> {
  Future<Either<Failure, Type>> call();
}

// For use cases with no parameters
class NoParams {}
