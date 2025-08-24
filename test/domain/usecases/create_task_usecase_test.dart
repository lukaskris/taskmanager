import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:taskmanager/core/error/failure.dart';
import 'package:taskmanager/data/models/task_model.dart';
import 'package:taskmanager/domain/entities/task_entity.dart';
import 'package:taskmanager/domain/repositories/task_repository.dart';
import 'package:taskmanager/domain/usecases/create_task_usecase.dart';

import 'create_task_usecase_test.mocks.dart';

@GenerateMocks([TaskRepository])
void main() {
  late MockTaskRepository mockRepository;
  late CreateTaskUseCase useCase;

  setUp(() {
    mockRepository = MockTaskRepository();
    useCase = CreateTaskUseCase(mockRepository);
  });

  final task = TaskEntity(
    id: '1',
    title: 'New Task',
    description: 'Description',
    status: TaskStatus.toDo,
    userId: 'user123',
  );

  group('CreateTaskUseCase', () {
    test('should return Right(void) when repository succeeds', () async {
      // Arrange
      when(mockRepository.addTask(task))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(task);

      // Assert
      expect(result, const Right(null));
      verify(mockRepository.addTask(task)).called(1);
    });

    test('should return Left(Failure) when repository fails', () async {
      // Arrange
      final failure = ServerFailure('Failed to create task');
      when(mockRepository.addTask(task)).thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase(task);

      // Assert
      expect(result, Left(failure));
      verify(mockRepository.addTask(task)).called(1);
    });
  });
}
