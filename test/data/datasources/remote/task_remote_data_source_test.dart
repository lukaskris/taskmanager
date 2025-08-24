import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:taskmanager/data/datasources/remote/task_remote_data_source.dart';
import 'package:taskmanager/data/models/task_model.dart';
import 'package:taskmanager/utils/task_model_extension.dart';

import 'task_remote_data_source_test.mocks.dart';

@GenerateMocks([
  FirebaseDatabase,
  DatabaseReference,
  DataSnapshot,
  Query,
])
void main() {
  late MockFirebaseDatabase mockFirebaseDatabase;
  late MockDatabaseReference mockRootRef;
  late MockDatabaseReference mockUserRef;
  late MockDatabaseReference mockTaskRef;
  late MockQuery mockQuery;
  late MockDataSnapshot mockSnapshot;
  late TaskRemoteDataSource dataSource;

  const userId = 'user1';

  final taskModel = TaskModel(
    id: '1',
    title: 'Test Task',
    description: 'Test Desc',
    status: TaskStatus.toDo,
    userId: userId,
  );

  setUp(() {
    mockFirebaseDatabase = MockFirebaseDatabase();
    mockRootRef = MockDatabaseReference();
    mockUserRef = MockDatabaseReference();
    mockTaskRef = MockDatabaseReference();
    mockQuery = MockQuery();
    mockSnapshot = MockDataSnapshot();

    when(mockFirebaseDatabase.ref('tasks')).thenReturn(mockRootRef);
    when(mockRootRef.child(userId)).thenReturn(mockUserRef);
    when(mockUserRef.child(taskModel.id)).thenReturn(mockTaskRef);

    dataSource = TaskRemoteDataSource(mockFirebaseDatabase);
  });

  group('fetchTasks', () {
    test('should return empty list if snapshot has no data', () async {
      when(mockUserRef.get()).thenAnswer((_) async => mockSnapshot);
      when(mockSnapshot.exists).thenReturn(false);
      when(mockSnapshot.value).thenReturn(null);

      final result = await dataSource.fetchTasks(userId);

      expect(result, []);
    });

    test('should return list of TaskModel when snapshot has valid data',
        () async {
      when(mockUserRef.get()).thenAnswer((_) async => mockSnapshot);
      when(mockSnapshot.exists).thenReturn(true);
      when(mockSnapshot.value).thenReturn({
        '1': {
          'id': '1',
          'title': 'Test Task',
          'description': 'Test Desc',
          'status': 'toDo',
          'userId': userId,
        }
      });

      final result = await dataSource.fetchTasks(userId);

      expect(result.length, 1);
      expect(result.first.id, '1');
      expect(result.first.status, TaskStatus.toDo);
    });

    test('should query filtered by status if provided', () async {
      when(mockRootRef.child(userId)).thenReturn(mockUserRef);
      when(mockUserRef.orderByChild('status')).thenReturn(mockQuery);
      when(mockQuery.equalTo('toDo')).thenReturn(mockQuery);
      when(mockQuery.get()).thenAnswer((_) async => mockSnapshot);
      when(mockSnapshot.exists).thenReturn(true);
      when(mockSnapshot.value).thenReturn({
        '1': {
          'id': '1',
          'title': 'Filtered Task',
          'description': 'Test',
          'status': 'toDo',
          'userId': userId,
        }
      });

      final result =
          await dataSource.fetchTasks(userId, taskStatus: TaskStatus.toDo);

      expect(result.length, 1);
      expect(result.first.status, TaskStatus.toDo);
    });
  });

  group('addTask', () {
    test('should call set on the correct reference', () async {
      when(mockTaskRef.set(taskModel.toMap())).thenAnswer((_) async {});

      await dataSource.addTask(taskModel);

      verify(mockFirebaseDatabase.ref('tasks')).called(1);
      verify(mockTaskRef.set(taskModel.toMap())).called(1);
    });
  });

  group('updateTask', () {
    test('should call update on the correct reference', () async {
      when(mockTaskRef.update(taskModel.toMap())).thenAnswer((_) async {});

      await dataSource.updateTask(taskModel);

      verify(mockFirebaseDatabase.ref('tasks')).called(1);
      verify(mockTaskRef.update(taskModel.toMap())).called(1);
    });
  });

  group('deleteTask', () {
    test('should call remove on the correct reference', () async {
      when(mockTaskRef.remove()).thenAnswer((_) async {});

      await dataSource.deleteTask(userId, taskModel.id);

      verify(mockFirebaseDatabase.ref('tasks')).called(1);
      verify(mockTaskRef.remove()).called(1);
    });
  });
}
