import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:taskmanager/core/error/failure.dart';
import 'package:taskmanager/data/datasources/remote/auth_remote_data_source.dart';
import 'package:taskmanager/data/repositories/auth_repository_impl.dart';
import 'package:taskmanager/domain/entities/user_entity.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([AuthRemoteDataSource])
void main() {
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  const email = 'user@example.com';
  const password = 'password123';
  var user = UserEntity(id: 'uid-001', email: email);

  group('login', () {
    test('should return Right(UserEntity) when login succeeds', () async {
      when(mockRemoteDataSource.login(email, password))
          .thenAnswer((_) async => user);

      final result = await repository.login(email, password);

      expect(result, Right(user));
      verify(mockRemoteDataSource.login(email, password)).called(1);
    });

    test('should return Left(ServerFailure) when login throws exception',
        () async {
      when(mockRemoteDataSource.login(email, password))
          .thenThrow(Exception('Login failed'));

      final result = await repository.login(email, password);

      expect(result, isA<Left<Failure, UserEntity>>());
      expect(
          result.fold((l) => l.message, (_) => null), contains('Login failed'));
      verify(mockRemoteDataSource.login(email, password)).called(1);
    });
  });

  group('register', () {
    test('should return Right(UserEntity) when registration succeeds',
        () async {
      when(mockRemoteDataSource.register(email, password))
          .thenAnswer((_) async => user);

      final result = await repository.register(email, password);

      expect(result, Right(user));
      verify(mockRemoteDataSource.register(email, password)).called(1);
    });

    test('should return Left(ServerFailure) when registration fails', () async {
      when(mockRemoteDataSource.register(email, password))
          .thenThrow(Exception('Register failed'));

      final result = await repository.register(email, password);

      expect(result, isA<Left<Failure, UserEntity>>());
      expect(result.fold((l) => l.message, (_) => null),
          contains('Register failed'));
      verify(mockRemoteDataSource.register(email, password)).called(1);
    });
  });

  group('logout', () {
    test('should call remoteDataSource.logout once', () async {
      when(mockRemoteDataSource.logout()).thenAnswer((_) async {
        return;
      });

      await repository.logout();

      verify(mockRemoteDataSource.logout()).called(1);
    });
  });
}
