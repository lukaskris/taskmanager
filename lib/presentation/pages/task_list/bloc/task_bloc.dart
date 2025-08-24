import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:taskmanager/data/models/task_model.dart';
import 'package:taskmanager/domain/entities/task_entity.dart';
import 'package:taskmanager/domain/usecases/delete_task_usecase.dart';
import 'package:taskmanager/domain/usecases/get_tasks_usecase.dart';
import 'package:taskmanager/domain/usecases/logout_usecase.dart';

part 'task_event.dart';
part 'task_state.dart';

@Injectable()
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasksUsecase getTasksUsecase;
  final DeleteTaskUsecase deleteTaskUsecase;
  final LogoutUsecase logoutUsecase;
  TaskStatus? selectedStatus;

  TaskBloc({
    required this.getTasksUsecase,
    required this.deleteTaskUsecase,
    required this.logoutUsecase,
  }) : super(TaskInitial()) {
    on<LoadTasks>((event, emit) async {
      await _loadTasks(emit);
    });

    on<TaskFiltered>((event, emit) async {
      selectedStatus = event.state;
      await _loadTasks(emit);
    });

    on<TaskDeleted>((event, emit) async {
      if (state is TaskLoaded) {
        await deleteTaskUsecase(event.task);
        await _loadTasks(emit);
      }
    });

    on<Logout>((event, emit) async {
      await logoutUsecase();
    });
  }

  Future<void> _loadTasks(Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final result = await getTasksUsecase(selectedStatus);
      result.fold(
        (failure) => emit(TaskError(failure.message)),
        (tasks) => emit(TaskLoaded(tasks, _filterIndex(selectedStatus))),
      );
    } catch (_) {
      emit(TaskError('Failed to load tasks'));
    }
  }

  int _filterIndex(TaskStatus? status) {
    switch (status) {
      case TaskStatus.toDo:
        return 1;
      case TaskStatus.inProgress:
        return 2;
      case TaskStatus.done:
        return 3;
      default:
        return 0; // All
    }
  }
}
