import 'package:controle_tarefas/core/states/app_service_state.dart';

abstract class ITaskListBlocState {}

class IdleTaskListBlocState extends ITaskListBlocState {
  //
}

///
abstract class IGetTasksListBlocState extends ITaskListBlocState {}

class LoadingTasksListBlocState extends IGetTasksListBlocState {}

class FailureTasksListBlocState extends IGetTasksListBlocState {
  FailureTasksListBlocState({required this.failureState});
  FailureServiceState failureState;
}

class SuccessTasksListBlocState extends IGetTasksListBlocState {}

class EmptyFilterTasksListBlocState extends SuccessTasksListBlocState {}

//TaskItem
abstract class ITaskItemListBlocState extends ITaskListBlocState {}

class SelectedTaskListBlocState extends ITaskItemListBlocState {}

class EmptyTaskListBlocState extends ITaskItemListBlocState {}

//ADD
abstract class IChangeItemTaskListBlocState extends ITaskListBlocState {}

class AddedTaskListBlocState extends IChangeItemTaskListBlocState {}

class DoneTaskListBlocState extends IChangeItemTaskListBlocState {}

abstract class ITaskCarouselListBlocState extends ITaskListBlocState {
  //
}
