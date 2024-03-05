import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:controle_tarefas/core/states/app_service_state.dart';
import 'package:controle_tarefas/features/tasks/tasks_list/data/service/tasks_list_firebase_service.dart';
import 'package:controle_tarefas/features/tasks/tasks_list/domain/models/task_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../../core/models/user_model.dart';

abstract class ITasksListRepository {
  Future<IServiceState> getTasks(
    UserModel user,
    FirebaseFirestore firestore,
    FirebaseStorage storage,
    Connectivity connectivity,
  );
  Future<IServiceState> deleteTask(
    UserModel user,
    TaskModel task,
    FirebaseFirestore firestore,
  );

  Future<IServiceState> getImages(
    UserModel user,
    FirebaseFirestore firestore,
    FirebaseStorage storage,
  );
  Future<IServiceState> completeTasks(
    UserModel user,
    List<TaskModel> listTasks,
    FirebaseFirestore firestore,
  );
}

class TasksListRepository extends ITasksListRepository {
  ITasksListFirebaseService service;
  TasksListRepository({
    required this.service,
  });
  @override
  Future<IServiceState> getTasks(
    UserModel user,
    FirebaseFirestore firestore,
    FirebaseStorage storage,
    Connectivity connectivity,
  ) async {
    var connectivityResult = await (connectivity.checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return NoConnectionFailureServiceState(message: 'Sem conexão');
    } else {
      return service.getTasks(user, firestore, storage);
    }
  }

  @override
  Future<IServiceState> completeTasks(
    UserModel user,
    List<TaskModel> listTasks,
    FirebaseFirestore firestore,
  ) {
    return service.completeTasks(user, listTasks, firestore);
  }

  @override
  Future<IServiceState> getImages(
    UserModel user,
    FirebaseFirestore firestore,
    FirebaseStorage storage,
  ) {
    return service.getImages(user, firestore, storage);
  }

  @override
  Future<IServiceState> deleteTask(
    UserModel user,
    TaskModel task,
    FirebaseFirestore firestore,
  ) {
    return service.deleteTask(user, task, firestore);
  }
}
