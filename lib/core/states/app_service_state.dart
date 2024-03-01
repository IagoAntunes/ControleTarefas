abstract class IServiceState {}

class SuccessServiceState<T> extends IServiceState {
  T data;
  SuccessServiceState({
    required this.data,
  });
}

class FailureServiceState extends IServiceState {
  String message;
  FailureServiceState({
    required this.message,
  });
}
