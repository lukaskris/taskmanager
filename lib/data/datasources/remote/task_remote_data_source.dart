import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';
import 'package:taskmanager/data/models/task_model.dart';
import 'package:taskmanager/utils/task_model_extension.dart';

@Injectable()
class TaskRemoteDataSource {
  final FirebaseDatabase firebaseDatabase;
  TaskRemoteDataSource(this.firebaseDatabase);

  Future<List<TaskModel>> fetchTasks(String userId,
      {TaskStatus? taskStatus}) async {
    final taskRef = firebaseDatabase.ref('tasks').child(userId);
    Query query = taskRef;

    if (taskStatus != null) {
      final statusString = taskStatus.toString().split('.').last;
      query = taskRef.orderByChild('status').equalTo(statusString);
    }

    final snapshot = await query.get();

    if (!snapshot.exists || snapshot.value == null) return [];

    final rawMap = snapshot.value;
    if (rawMap is! Map) return [];

    final tasksMap = Map<String, dynamic>.from(rawMap);

    return tasksMap.entries.map((e) {
      final data = Map<String, dynamic>.from(e.value);
      return TaskModel(
        id: data['id'] as String,
        title: data['title'] as String,
        description: data['description'] as String,
        userId: data['userId'] as String,
        status: data['status'] == 'toDo'
            ? TaskStatus.toDo
            : data['status'] == 'inProgress'
                ? TaskStatus.inProgress
                : TaskStatus.done,
      );
    }).toList();
  }

  Future<void> addTask(TaskModel task) async {
    await firebaseDatabase
        .ref('tasks')
        .child(task.userId)
        .child(task.id)
        .set(task.toMap());
  }

  Future<void> updateTask(TaskModel task) async {
    await firebaseDatabase
        .ref('tasks')
        .child(task.userId)
        .child(task.id)
        .update(task.toMap());
  }

  Future<void> deleteTask(String userId, String id) async {
    await firebaseDatabase.ref('tasks').child(userId).child(id).remove();
  }
}
