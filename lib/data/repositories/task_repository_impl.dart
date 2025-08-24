import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:taskmanager/core/secure_storage_service.dart';
import 'package:taskmanager/core/service/connectivity_service.dart';
import 'package:taskmanager/data/datasources/local/task_local_data_source.dart';
import 'package:taskmanager/data/datasources/remote/task_remote_data_source.dart';
import 'package:taskmanager/data/models/task_model.dart';
import 'package:taskmanager/utils/task_model_extension.dart';

import '../../core/error/failure.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';

@Injectable(as: TaskRepository)
class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;
  final TaskLocalDataSource localDataSource;
  final SecureStorageService secureStorageService;
  final ConnectivityService connectivityService;

  TaskRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.secureStorageService,
    required this.connectivityService,
  });

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks(TaskStatus? status) async {
    try {
      final isOnline = await connectivityService.isConnected;
      final userId = (await secureStorageService.getUser()) ?? '';
      if (isOnline) {
        final remoteTasks =
            await remoteDataSource.fetchTasks(userId, taskStatus: status);
        await localDataSource.cacheTasks(remoteTasks);
        return Right(remoteTasks.map((e) => e.toTaskEntity()).toList());
      } else {
        final cachedTasks = await localDataSource.getCachedTasks();
        if (status != null) {
          return Right(cachedTasks
              .where((t) => t.status == status)
              .map((e) => e.toTaskEntity())
              .toList());
        }
        return Right(cachedTasks.map((e) => e.toTaskEntity()).toList());
      }
    } catch (e) {
      // On error, fallback to local cache
      try {
        final localTasks = await localDataSource.getCachedTasks();
        return Right(localTasks.map((e) => e.toTaskEntity()).toList());
      } catch (cacheError) {
        return Left(CacheFailure(cacheError.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, void>> addTask(TaskEntity task) async {
    try {
      final isOnline = await connectivityService.isConnected;
      final userId = await secureStorageService.getUser();
      if (isOnline) {
        await remoteDataSource
            .addTask(task.copyWith(userId: userId ?? '').toTaskModel());
        // Update local cache after remote success
        final tasks = await remoteDataSource.fetchTasks(userId ?? '');
        await localDataSource.cacheTasks(tasks);
      } else {
        // Mark task as pending sync and save locally
        final pendingTask = task
            .copyWith(userId: userId ?? '')
            .toTaskModel()
            .copyWith(pendingSync: true);
        await localDataSource.updateTask(pendingTask);
      }

      return const Right(null);
    } catch (e) {
      print(e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateTask(TaskEntity task) async {
    try {
      final isOnline = await connectivityService.isConnected;
      if (isOnline) {
        await remoteDataSource.updateTask(task.toTaskModel());
        final updatedTasks = await remoteDataSource.fetchTasks(task.userId);
        await localDataSource.cacheTasks(updatedTasks);
      } else {
        // Mark task as pending sync and save locally
        final pendingTask = task.toTaskModel().copyWith(pendingSync: true);
        await localDataSource.updateTask(pendingTask);
      }
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String id) async {
    try {
      final isOnline = await connectivityService.isConnected;
      final userId = await secureStorageService.getUser();
      if (isOnline) {
        await remoteDataSource.deleteTask(userId ?? '', id);
        final updatedTasks = await remoteDataSource.fetchTasks(userId ?? '');
        await localDataSource.cacheTasks(updatedTasks);
      } else {
        await localDataSource.deleteTask(id);
      }
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> syncTasks() async {
    try {
      final userId = await secureStorageService.getUser();
      // Fetch remote tasks and update local cache
      final remoteTasks = await remoteDataSource.fetchTasks(userId ?? '');
      await localDataSource.cacheTasks(remoteTasks);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Call this method when connectivity is restored to sync pending changes
  @override
  Future<void> syncPendingTasks() async {
    final userId = (await secureStorageService.getUser()) ?? '';
    final pendingTasks = await localDataSource.getPendingTasks();
    for (var task in pendingTasks) {
      try {
        // Push each pending task to remote
        await remoteDataSource.addTask(task);
        // After success, update local task to clear pendingSync flag
        final syncedTask = task.copyWith(pendingSync: false);
        await localDataSource.updateTask(syncedTask);
      } catch (e) {
        print(e);
        // Handle errors, maybe retry later
      }
    }

    // delete pending tasks
    final taskDeleteIds = await localDataSource.getDeletedTasksIds();
    for (var id in taskDeleteIds) {
      try {
        await remoteDataSource.deleteTask(userId, id);
      } catch (_) {
        // Handle errors, maybe retry later
      }
    }

    await localDataSource.clearDeletedTasksIds();

    // After syncing, refresh local cache with remote data
    final remoteTasks = await remoteDataSource.fetchTasks(userId);
    await localDataSource.cacheTasks(remoteTasks);
  }
}
