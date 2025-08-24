import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

@HiveType(typeId: 2)
enum TaskStatus {
  @HiveField(0)
  toDo,
  @HiveField(1)
  inProgress,
  @HiveField(2)
  done
}

@freezed
@HiveType(typeId: 0)
class TaskModel with _$TaskModel {
  const factory TaskModel({
    @HiveField(0) required String id,
    @HiveField(1) required String title,
    @HiveField(2) required String description,
    @HiveField(3) required String userId,
    @HiveField(4) required TaskStatus status,
    @HiveField(5) @Default(false) bool pendingSync, // new field
  }) = _TaskModel;
  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);
}
