abstract class IAddTaskState {}

class IdleTaskState extends IAddTaskState {}

class AddedImageTaskState extends IAddTaskState {}

abstract class IAddTaskListeners extends IAddTaskState {}

class SuccessAddTaskListener extends IAddTaskListeners {}
