import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:demarco_teste_pratico/core/database/app_database.dart';
import 'package:demarco_teste_pratico/core/states/app_service_state.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:demarco_teste_pratico/features/login/domain/repositories/auth_repository.dart';
import 'package:demarco_teste_pratico/features/tasks/tasks_list/domain/models/task_model.dart';
import 'package:demarco_teste_pratico/features/tasks/tasks_list/domain/repositories/tasks_list_repository.dart';
import 'package:demarco_teste_pratico/features/tasks/tasks_list/presenter/state/task_list_bloc_state.dart';

import '../event/tasks_list_event.dart';

class TasksListBloc extends Bloc<ITaskListEvent, ITaskListBlocState> {
  final List<TaskModel> listTasks = [];
  List<TaskModel> filterTasks = [];
  ITasksListRepository repository;
  IAuthRepository authRepository;

  FirebaseFirestore firestore;
  FirebaseStorage storage;
  AppDatabase database;
  Connectivity connectivity;
  bool isOkDone = false;
  bool initGet;
  TasksListBloc({
    required this.repository,
    required this.authRepository,
    required this.firestore,
    required this.storage,
    required this.database,
    required this.connectivity,
    this.initGet = true,
  }) : super(IdleTaskListBlocState()) {
    on<GetTasksListEvent>((event, emit) async {
      emit(LoadingTasksListBlocState());
      late IServiceState result;
      try {
        result = await authRepository.getUser(event.database);
      } catch (e) {
        print("Oi");
      }
      if (result is SuccessServiceState) {
        final data = await repository.getTasks(
          result.data,
          event.firestore,
          event.storage,
          event.connectivity,
        );
        if (data is SuccessServiceState) {
          if (data.data != null) {
            listTasks.clear();
            filterTasks.clear();
            for (var item in data.data['listTasks']) {
              listTasks.add(TaskModel.fromMap(item));
            }
            filterTasks.addAll(listTasks);
            final resultImages = await repository.getImages(
              result.data,
              event.firestore,
              event.storage,
            );
            if (resultImages
                is SuccessServiceState<List<Map<String, dynamic>>>) {
              for (var item in resultImages.data) {
                for (var task in listTasks) {
                  if (item['task'].toString().split('.')[0] == task.id) {
                    task.image = item['b64'];
                  }
                }
              }
            }
            emit(SuccessTasksListBlocState());
          } else {
            emit(SuccessTasksListBlocState());
          }
        } else if (data is FailureServiceState) {
          emit(FailureTasksListBlocState(failureState: data));
        }
      } else if (result is FailureServiceState) {
        emit(FailureTasksListBlocState(failureState: result));
      }
    });
    on<DeleteTaskListEvent>((event, emit) async {
      listTasks.removeWhere((element) => element.id == event.task.id);
      filterTasks.removeWhere((element) => element.id == event.task.id);
      final resultUser = await authRepository.getUser(event.database);
      if (resultUser is SuccessServiceState) {
        final result = await repository.deleteTask(
          resultUser.data,
          event.task,
          event.firestore,
        );
        if (result is SuccessServiceState) {
          emit(SuccessTasksListBlocState());
        }
      }
    });
    on<SelectedTaskListEvent>((event, emit) {
      filterTasks[event.index].isChecked = event.value;
      if (filterTasks
          .where(
            (element) => element.isChecked && element.isDone == false,
          )
          .toList()
          .isEmpty) {
        isOkDone = false;
      } else {
        isOkDone = true;
      }
      emit(SelectedTaskListBlocState());
    });
    on<DoneTasksListEvent>((event, emit) async {
      for (var element in listTasks) {
        if (element.isChecked == true) {
          element.isDone = true;
        }
      }
      filterTasks.clear();
      filterTasks.addAll(listTasks);
      final result = await authRepository.getUser(event.database);
      if (result is SuccessServiceState) {
        final result2 = await repository.completeTasks(
          result.data,
          listTasks,
          event.firestore,
        );
        if (result2 is SuccessServiceState) {
          if (filterTasks
              .where(
                (element) => element.isChecked && element.isDone == false,
              )
              .toList()
              .isEmpty) {
            isOkDone = false;
          } else {
            isOkDone = true;
          }
          emit(SuccessTasksListBlocState());
        }
      }
    });
    on<FilterTaskListEvent>((event, emit) {
      filterTasks.clear();
      filterTasks.addAll(
        listTasks.where(
          (element) =>
              element.title!.toLowerCase().contains(event.text.toLowerCase()),
        ),
      );

      emit(SuccessTasksListBlocState());
    });
    on<AddTaskListEvent>((event, emit) {
      listTasks.add(event.task);
      filterTasks.add(event.task);

      emit(SuccessTasksListBlocState());
    });
    if (initGet) {
      add(GetTasksListEvent(
        database: database,
        firestore: firestore,
        storage: storage,
        connectivity: connectivity,
      ));
    }
  }
  List<TaskModel> selectThreeElements() {
    var list = listTasks.where((element) => element.isDone == false).toList();
    if (list.length >= 3) {
      return list.sublist(0, 3);
    } else {
      return list;
    }
  }

  bool isListEmpty() => listTasks.isEmpty;
}
