// repositories/auth_repository.dart
import 'package:dartz/dartz.dart';
import 'package:taskmanager/core/error/failure.dart';
import 'package:taskmanager/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String email, String password);
  Future<Either<Failure, UserEntity>> register(String email, String password);
  Future<void> logout();
}
