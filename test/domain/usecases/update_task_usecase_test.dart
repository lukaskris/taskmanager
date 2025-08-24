import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:taskmanager/core/error/failure.dart';
import 'package:taskmanager/data/models/task_model.dart';
import 'package:taskmanager/domain/entities/task_entity.dart';
import 'package:taskmanager/domain/repositories/task_repository.dart';
import 'package:taskmanager/domain/usecases/update_task_usecase.dart';

import 'update_task_usecase_test.mocks.dart';

@GenerateMocks([TaskRepository])
void main() {
  late MockTaskRepository mockRepository;
  late UpdateTaskUseCase usecase;

  setUp(() {
    mockRepository = MockTaskRepository();
    usecase = UpdateTaskUseCase(mockRepository);
  });

  final task = TaskEntity(
    id: '1',
    title: 'Updated Task',
    description: 'Updated description',
    status: TaskStatus.done,
    userId: 'user123',
  );

  group('UpdateTaskUseCase', () {
    test('should return Right(null) when update is successful', () async {
      // Arrange
      when(mockRepository.updateTask(task))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await usecase(task);

      // Assert
      expect(result, const Right(null));
      verify(mockRepository.updateTask(task)).called(1);
    });

    test('should return Left(ServerFailure) on failure', () async {
      final failure = ServerFailure('Update failed');

      when(mockRepository.updateTask(task))
          .thenAnswer((_) async => Left(failure));

      final result = await usecase(task);

      expect(result, Left(failure));
      verify(mockRepository.updateTask(task)).called(1);
    });
  });
}
