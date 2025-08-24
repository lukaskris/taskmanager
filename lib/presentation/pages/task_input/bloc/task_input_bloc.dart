import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:taskmanager/domain/entities/task_entity.dart';
import 'package:taskmanager/domain/usecases/create_task_usecase.dart';
import 'package:taskmanager/domain/usecases/update_task_usecase.dart';

part 'task_input_event.dart';
part 'task_input_state.dart';

@injectable
class TaskInputBloc extends Bloc<TaskInputEvent, TaskInputState> {
  final CreateTaskUseCase createTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;

  TaskInputBloc({
    required this.createTaskUseCase,
    required this.updateTaskUseCase,
  }) : super(TaskInputInitial()) {
    on<SubmitNewTask>((event, emit) async {
      emit(TaskInputLoading());
      final result = await createTaskUseCase(event.task);
      result.fold(
        (failure) => emit(TaskInputFailure(message: 'Failed to create task')),
        (_) => emit(TaskInputSuccess()),
      );
    });

    on<SubmitUpdatedTask>((event, emit) async {
      emit(TaskInputLoading());
      final result = await updateTaskUseCase(event.task);
      result.fold(
        (failure) => emit(TaskInputFailure(message: 'Failed to update task')),
        (_) => emit(TaskInputSuccess()),
      );
    });
  }
}
