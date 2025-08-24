import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskmanager/core/utils/page_router.dart';
import 'package:taskmanager/core/utils/toast_util.dart';
import 'package:taskmanager/core/widgets/bouncer_tap_widget.dart';
import 'package:taskmanager/core/widgets/typography.dart';
import 'package:taskmanager/data/models/task_model.dart';
import 'package:taskmanager/domain/entities/task_entity.dart';
import 'package:taskmanager/injectable.dart';
import 'package:taskmanager/presentation/pages/task_list/bloc/task_bloc.dart';
import 'package:taskmanager/utils/context_extension.dart';
import 'package:taskmanager/utils/task_model_extension.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final _bloc = getIt<TaskBloc>();

  @override
  void initState() {
    super.initState();
    _bloc.add(LoadTasks());
  }

  Widget _buildTaskTile(TaskEntity task) {
    return BouncerTapWidget(
      onPressed: () async {
        final response = await context.push(AppRoutes.taskInput, extra: task);
        if (response != null) {
          _bloc.add(LoadTasks());
        }
      },
      child: Dismissible(
        key: Key(task.id),
        direction: DismissDirection.endToStart, // swipe from right to left
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        onDismissed: (_) {
          _bloc.add(TaskDeleted(task));
          showSuccessToast('Deleted Task ${task.title}');
        },
        child: ListTile(
          title: Text(task.title),
          subtitle: Text(task.description),
          trailing: Text(task.status.toShort),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => context.pop(),
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          _bloc.add(Logout());
                          context
                            ..pop()
                            ..replace(AppRoutes.login);
                        },
                        child: const Text('Yes'),
                      )
                    ]),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final response = await context.push(AppRoutes.taskInput);
          if (response != null) {
            _bloc.add(LoadTasks());
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: BlocBuilder<TaskBloc, TaskState>(
          bloc: _bloc,
          builder: (context, state) {
            if (state is TaskLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TaskLoaded) {
              return Column(
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      BouncerTapWidget(
                        onPressed: () => _bloc.add(TaskFiltered()),
                        child: Container(
                          width: 80,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: state.status == 0
                                    ? context.colorScheme.secondary
                                    : context.colorScheme.onSurface
                                        .withValues(alpha: .5)),
                            borderRadius: BorderRadius.circular(10),
                            color: state.status == 0
                                ? context.colorScheme.secondary
                                : context.colorScheme.surface,
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8),
                          child: AppTypography(
                              text: 'All',
                              color: state.status == 0
                                  ? context.colorScheme.onSecondary
                                  : context.colorScheme.onSurface
                                      .withValues(alpha: .5)),
                        ),
                      ),
                      BouncerTapWidget(
                        onPressed: () =>
                            _bloc.add(TaskFiltered(state: TaskStatus.toDo)),
                        child: Container(
                          width: 80,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: state.status == 1
                                    ? context.colorScheme.secondary
                                    : context.colorScheme.onSurface
                                        .withValues(alpha: .5)),
                            borderRadius: BorderRadius.circular(10),
                            color: state.status == 1
                                ? context.colorScheme.secondary
                                : context.colorScheme.surface,
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8),
                          child: AppTypography(
                              text: 'To Do',
                              color: state.status == 1
                                  ? context.colorScheme.onSecondary
                                  : context.colorScheme.onSurface
                                      .withValues(alpha: .5)),
                        ),
                      ),
                      BouncerTapWidget(
                        onPressed: () => _bloc
                            .add(TaskFiltered(state: TaskStatus.inProgress)),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: state.status == 2
                                    ? context.colorScheme.secondary
                                    : context.colorScheme.onSurface
                                        .withValues(alpha: .5)),
                            borderRadius: BorderRadius.circular(10),
                            color: state.status == 2
                                ? context.colorScheme.secondary
                                : context.colorScheme.surface,
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8),
                          child: AppTypography(
                              text: 'In Progress',
                              color: state.status == 2
                                  ? context.colorScheme.onSecondary
                                  : context.colorScheme.onSurface
                                      .withValues(alpha: .5)),
                        ),
                      ),
                      BouncerTapWidget(
                        onPressed: () =>
                            _bloc.add(TaskFiltered(state: TaskStatus.done)),
                        child: Container(
                          width: 80,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: state.status == 3
                                    ? context.colorScheme.secondary
                                    : context.colorScheme.onSurface
                                        .withValues(alpha: .5)),
                            borderRadius: BorderRadius.circular(10),
                            color: state.status == 3
                                ? context.colorScheme.secondary
                                : context.colorScheme.surface,
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8),
                          child: AppTypography(
                              text: 'Done',
                              color: state.status == 3
                                  ? context.colorScheme.onSecondary
                                  : context.colorScheme.onSurface
                                      .withValues(alpha: .5)),
                        ),
                      ),
                    ],
                  ),
                  if (state.tasks.isEmpty)
                    Expanded(child: const Center(child: Text('No tasks found')))
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.tasks.length,
                        itemBuilder: (context, index) =>
                            _buildTaskTile(state.tasks[index]),
                      ),
                    ),
                ],
              );
            } else if (state is TaskError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
