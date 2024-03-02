import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:demarco_teste_pratico/core/states/app_service_state.dart';
import 'package:demarco_teste_pratico/features/tasks/tasks_list/data/service/tasks_list_firebase_service.dart';
import 'package:demarco_teste_pratico/features/tasks/tasks_list/domain/models/task_model.dart';

import '../../../../../core/models/user_model.dart';

abstract class ITasksListRepository {
  Future<IServiceState> getTasks(UserModel user);
  Future<IServiceState> deleteTask(UserModel user, TaskModel task);

  Future<IServiceState> getImages(UserModel user);
  Future<IServiceState> completeTasks(
    UserModel user,
    List<TaskModel> listTasks,
  );
}

class TasksListRepository extends ITasksListRepository {
  ITasksListFirebaseService service;
  TasksListRepository({
    required this.service,
  });
  @override
  Future<IServiceState> getTasks(UserModel user) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return NoConnectionFailureServiceState(message: 'Sem conexão');
    } else {
      return service.getTasks(user);
    }
  }

  @override
  Future<IServiceState> completeTasks(
      UserModel user, List<TaskModel> listTasks) {
    return service.completeTasks(user, listTasks);
  }

  @override
  Future<IServiceState> getImages(UserModel user) {
    return service.getImages(user);
  }

  @override
  Future<IServiceState> deleteTask(UserModel user, TaskModel task) {
    return service.deleteTask(user, task);
  }
}
