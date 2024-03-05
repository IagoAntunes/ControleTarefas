import 'package:controle_tarefas/features/tasks/tasks_list/domain/models/task_model.dart';

abstract class IAddTaskState {}

class IdleTaskState extends IAddTaskState {}

class AddedImageTaskState extends IAddTaskState {}

abstract class IAddTaskListeners extends IAddTaskState {}

class SuccessAddTaskListener extends IAddTaskListeners {
  TaskModel task;
  SuccessAddTaskListener({
    required this.task,
  });
}

class LoadingAddTaskListener extends IAddTaskListeners {}
