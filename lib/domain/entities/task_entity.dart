import 'package:taskmanager/data/models/task_model.dart';

class TaskEntity {
  final String id;
  final String title;
  final String description;
  final String userId;
  final TaskStatus status;

  TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.userId,
    required this.status,
  });

  TaskEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? userId,
    TaskStatus? status,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      status: status ?? this.status,
    );
  }

  TaskModel toTaskModel() {
    return TaskModel(
      id: id,
      title: title,
      description: description,
      userId: userId,
      status: status,
    );
  }
}
