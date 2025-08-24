import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:taskmanager/core/error/failure.dart';
import 'package:taskmanager/core/secure_storage_service.dart';
import 'package:taskmanager/core/service/connectivity_service.dart';
import 'package:taskmanager/data/datasources/local/task_local_data_source.dart';
import 'package:taskmanager/data/datasources/remote/task_remote_data_source.dart';
import 'package:taskmanager/data/models/task_model.dart';
import 'package:taskmanager/data/repositories/task_repository_impl.dart';
import 'package:taskmanager/domain/entities/task_entity.dart';
import 'package:taskmanager/utils/task_model_extension.dart';

import 'task_repository_impl_test.mocks.dart';

@GenerateMocks([
  TaskRemoteDataSource,
  TaskLocalDataSource,
  SecureStorageService,
  ConnectivityService,
])
void main() {
  late TaskRepositoryImpl repository;
  late MockTaskRemoteDataSource mockRemote;
  late MockTaskLocalDataSource mockLocal;
  late MockSecureStorageService mockStorage;
  late MockConnectivityService mockConnectivity;

  setUp(() {
    mockRemote = MockTaskRemoteDataSource();
    mockLocal = MockTaskLocalDataSource();
    mockStorage = MockSecureStorageService();
    mockConnectivity = MockConnectivityService();

    repository = TaskRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
      secureStorageService: mockStorage,
      connectivityService: mockConnectivity,
    );
  });

  const userId = '123';
  final model = TaskModel(
    id: '1',
    title: 'Test Task',
    description: 'desc',
    status: TaskStatus.toDo,
    userId: userId,
  );
  final entity = model.toTaskEntity();

  group('getTasks', () {
    test('should return tasks from remote when online', () async {
      when(mockConnectivity.isConnected).thenAnswer((_) async => true);
      when(mockStorage.getUser()).thenAnswer((_) async => userId);
      when(mockRemote.fetchTasks(userId, taskStatus: null))
          .thenAnswer((_) async => [model]);
      when(mockLocal.cacheTasks(any)).thenAnswer((_) async => {});

      final result = await repository.getTasks(null);

      assert(result.isRight());
      expect(((result as Right).value as List<TaskEntity>).length, 1);
      expect(((result as Right).value as List<TaskEntity>).first.id, entity.id);
      verify(mockRemote.fetchTasks(userId, taskStatus: null)).called(1);
      verify(mockLocal.cacheTasks([model])).called(1);
    });

    test('should return tasks from local when offline', () async {
      when(mockConnectivity.isConnected).thenAnswer((_) async => false);
      when(mockStorage.getUser()).thenAnswer((_) async => userId);
      when(mockLocal.getCachedTasks()).thenAnswer((_) async => [model]);

      final result = await repository.getTasks(null);

      assert(result.isRight());
      expect(((result as Right).value as List<TaskEntity>).length, 1);
      expect(((result as Right).value as List<TaskEntity>).first.id, entity.id);
      verify(mockLocal.getCachedTasks()).called(1);
    });

    test('should fallback to cache on remote error', () async {
      when(mockConnectivity.isConnected).thenAnswer((_) async => true);
      when(mockStorage.getUser()).thenAnswer((_) async => userId);
      when(mockRemote.fetchTasks(userId, taskStatus: null))
          .thenThrow(Exception('API failed'));
      when(mockLocal.getCachedTasks()).thenAnswer((_) async => [model]);

      final result = await repository.getTasks(null);

      assert(result.isRight());
      expect(((result as Right).value as List<TaskEntity>).length, 1);
      expect(((result as Right).value as List<TaskEntity>).first.id, entity.id);
    });

    test('should return CacheFailure if local also fails', () async {
      when(mockConnectivity.isConnected).thenAnswer((_) async => true);
      when(mockStorage.getUser()).thenAnswer((_) async => userId);
      when(mockRemote.fetchTasks(userId, taskStatus: null))
          .thenThrow(Exception('remote fail'));
      when(mockLocal.getCachedTasks()).thenThrow(Exception('local cache fail'));

      final result = await repository.getTasks(null);

      expect(result, isA<Left<Failure, List<TaskEntity>>>());
      expect(result.fold((l) => l, (_) => null), isA<CacheFailure>());
    });
  });

  group('addTask', () {
    test('should call remote and update cache when online', () async {
      when(mockConnectivity.isConnected).thenAnswer((_) async => true);
      when(mockStorage.getUser()).thenAnswer((_) async => userId);
      when(mockRemote.addTask(any)).thenAnswer((_) async => {});
      when(mockRemote.fetchTasks(userId)).thenAnswer((_) async => [model]);
      when(mockLocal.cacheTasks(any)).thenAnswer((_) async => {});

      final result = await repository.addTask(entity);

      expect(result, const Right(null));
      verify(mockRemote.addTask(any)).called(1);
      verify(mockLocal.cacheTasks(any)).called(1);
    });

    test('should save locally with pendingSync when offline', () async {
      when(mockConnectivity.isConnected).thenAnswer((_) async => false);
      when(mockStorage.getUser()).thenAnswer((_) async => userId);
      when(mockLocal.updateTask(any)).thenAnswer((_) async => {});

      final result = await repository.addTask(entity);

      expect(result, const Right(null));
      verify(mockLocal.updateTask(any)).called(1);
    });

    test('should return ServerFailure on error', () async {
      when(mockConnectivity.isConnected).thenThrow(Exception('fail'));

      final result = await repository.addTask(entity);

      expect(result, isA<Left<Failure, void>>());
    });
  });

  group('updateTask', () {
    test('should update remote and cache when online', () async {
      when(mockConnectivity.isConnected).thenAnswer((_) async => true);
      when(mockRemote.updateTask(any)).thenAnswer((_) async => {});
      when(mockRemote.fetchTasks(userId)).thenAnswer((_) async => [model]);
      when(mockLocal.cacheTasks(any)).thenAnswer((_) async => {});

      final updated = entity.copyWith(userId: userId);
      final result = await repository.updateTask(updated);

      expect(result, const Right(null));
    });

    test('should update locally with pendingSync when offline', () async {
      when(mockConnectivity.isConnected).thenAnswer((_) async => false);
      when(mockLocal.updateTask(any)).thenAnswer((_) async => {});

      final result = await repository.updateTask(entity);

      expect(result, const Right(null));
    });
  });

  group('deleteTask', () {
    test('should call remote and update local when online', () async {
      when(mockConnectivity.isConnected).thenAnswer((_) async => true);
      when(mockStorage.getUser()).thenAnswer((_) async => userId);
      when(mockRemote.deleteTask(userId, any)).thenAnswer((_) async => {});
      when(mockRemote.fetchTasks(userId)).thenAnswer((_) async => [model]);
      when(mockLocal.cacheTasks(any)).thenAnswer((_) async => {});

      final result = await repository.deleteTask('1');

      expect(result, const Right(null));
    });

    test('should delete locally when offline', () async {
      when(mockStorage.getUser()).thenAnswer((_) async => userId);
      when(mockConnectivity.isConnected).thenAnswer((_) async => false);
      when(mockLocal.deleteTask('1')).thenAnswer((_) async => {});

      final result = await repository.deleteTask('1');

      expect(result, const Right(null));
    });
  });

  group('syncTasks', () {
    test('should refresh local cache from remote', () async {
      when(mockStorage.getUser()).thenAnswer((_) async => userId);
      when(mockRemote.fetchTasks(userId)).thenAnswer((_) async => [model]);
      when(mockLocal.cacheTasks(any)).thenAnswer((_) async => {});

      final result = await repository.syncTasks();

      expect(result, const Right(null));
    });

    test('should return ServerFailure if remote fails', () async {
      when(mockStorage.getUser()).thenAnswer((_) async => userId);
      when(mockRemote.fetchTasks(userId)).thenThrow(Exception('fail'));

      final result = await repository.syncTasks();

      expect(result, isA<Left<Failure, void>>());
    });
  });
}
