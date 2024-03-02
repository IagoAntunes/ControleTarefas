import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demarco_teste_pratico/core/models/user_model.dart';
import 'package:demarco_teste_pratico/core/states/app_service_state.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../domain/models/task_model.dart';

abstract class ITasksListFirebaseService {
  Future<IServiceState> getTasks(UserModel user);
  Future<IServiceState> completeTasks(
      UserModel user, List<TaskModel> listTasks);

  Future<IServiceState> getImages(UserModel user);

  Future<IServiceState> deleteTask(UserModel user, TaskModel task);
}

class TasksListFirebaseService extends ITasksListFirebaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  @override
  Future<IServiceState> getTasks(UserModel user) async {
    try {
      final result = await firestore.collection('tasks').doc(user.uid).get();
      storage.ref();
      return SuccessServiceState(data: result.data());
    } catch (e) {
      return FailureServiceState(message: 'Erro');
    }
  }

  @override
  Future<IServiceState> completeTasks(
      UserModel user, List<TaskModel> listTasks) async {
    try {
      final doc = firestore.collection('tasks').doc(user.uid);

      // Converta a lista de TaskModel para uma lista de mapas
      List<Map<String, dynamic>> tasksMapList = listTasks.map((task) {
        return task.toMap();
      }).toList();

      // Atualize o documento com a lista de tarefas no formato de mapa
      await doc.update({'listTasks': tasksMapList});

      return SuccessServiceState(data: '');
    } catch (e) {
      return FailureServiceState(message: 'Erro');
    }
  }

  @override
  Future<IServiceState> getImages(UserModel user) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    try {
      var imagePath = '${user.uid}/';
      ListResult result = await storage.ref(imagePath).listAll();
      List<Map<String, dynamic>> listImages = [];
      for (var item in result.items) {
        var image = await item.getData();
        List<int> list = image!.toList();
        listImages.add({'task': item.name, 'b64': base64Encode(list)});
      }
      return SuccessServiceState<List<Map<String, dynamic>>>(data: listImages);
    } catch (e) {
      return FailureServiceState(message: 'Erro');
    }
  }

  @override
  Future<IServiceState> deleteTask(UserModel user, TaskModel task) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('tasks').doc(user.uid).update({
        'listTasks': FieldValue.arrayRemove([task.toMap()]),
      });
      return SuccessServiceState(data: '');
    } catch (e) {
      return FailureServiceState(message: 'Erro');
    }
  }
}
