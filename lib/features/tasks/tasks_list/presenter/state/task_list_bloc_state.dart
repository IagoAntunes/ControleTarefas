abstract class ITaskListBlocState {}

class IdleTaskListBlocState extends ITaskListBlocState {
  //
}

class LoadingTasksListBlocState extends ITaskListBlocState {}

class SuccessTasksListBlocState extends ITaskListBlocState {}

class EmptyTasksListBlcoState extends SuccessTasksListBlocState {}

class EmptyFilterTasksListBlocState extends SuccessTasksListBlocState {}

class FailureTasksListBlocState extends ITaskListBlocState {}
