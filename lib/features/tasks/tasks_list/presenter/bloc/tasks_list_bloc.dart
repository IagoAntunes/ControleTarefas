import 'package:demarco_teste_pratico/core/states/app_service_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:demarco_teste_pratico/features/login/domain/repositories/auth_repository.dart';
import 'package:demarco_teste_pratico/features/tasks/tasks_list/domain/models/task_model.dart';
import 'package:demarco_teste_pratico/features/tasks/tasks_list/domain/repositories/tasks_list_repository.dart';
import 'package:demarco_teste_pratico/features/tasks/tasks_list/presenter/state/task_list_bloc_state.dart';

import '../event/tasks_list_event.dart';

class TasksListBloc extends Bloc<ITaskListEvent, ITaskListBlocState> {
  final List<TaskModel> _listTasks = [];
  List<TaskModel> filterTasks = [];
  ITasksListRepository repository;
  IAuthRepository authRepository;

  bool isOkDone = false;

  TasksListBloc({
    required this.repository,
    required this.authRepository,
  }) : super(IdleTaskListBlocState()) {
    on<GetTasksListEvent>((event, emit) async {
      emit(LoadingTasksListBlocState());
      final result = await authRepository.getUser();
      if (result is SuccessServiceState) {
        final data = await repository.getTasks(result.data);
        if (data is SuccessServiceState) {
          if (data.data != null) {
            _listTasks.clear();
            filterTasks.clear();
            for (var item in data.data['listTasks']) {
              _listTasks.add(TaskModel.fromMap(item));
            }
            filterTasks.addAll(_listTasks);
            final resultImages = await repository.getImages(result.data);
            if (resultImages
                is SuccessServiceState<List<Map<String, dynamic>>>) {
              for (var item in resultImages.data) {
                for (var task in _listTasks) {
                  if (item['task'].toString().split('.')[0] == task.id) {
                    task.image = item['b64'];
                  }
                }
              }
            }
            print("OLa");
            if (_listTasks.isEmpty) {
              emit(EmptyTasksListBlcoState());
            } else {
              emit(SuccessTasksListBlocState());
            }
          } else {
            emit(EmptyTasksListBlcoState());
          }
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
      emit(SuccessTasksListBlocState());
    });
    on<DoneTasksListEvent>((event, emit) async {
      for (var element in _listTasks) {
        if (element.isChecked == true) {
          element.isDone = true;
        }
      }
      filterTasks.clear();
      filterTasks.addAll(_listTasks);
      final result = await authRepository.getUser();
      if (result is SuccessServiceState) {
        final result2 = await repository.completeTasks(result.data, _listTasks);
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
          if (_listTasks.isEmpty) {
            emit(EmptyTasksListBlcoState());
          } else {
            emit(SuccessTasksListBlocState());
          }
        }
      }
    });
    on<FilterTaskListEvent>((event, emit) {
      filterTasks.clear();
      filterTasks.addAll(
        _listTasks.where(
          (element) =>
              element.title!.toLowerCase().contains(event.text.toLowerCase()),
        ),
      );

      if (filterTasks.isEmpty) {
        emit(EmptyTasksListBlcoState());
      } else {
        emit(SuccessTasksListBlocState());
      }
    });
    add(GetTasksListEvent());
  }
  List<TaskModel> selectThreeElements() {
    var list = _listTasks.where((element) => element.isDone == false).toList();
    if (list.length >= 3) {
      return list.sublist(0, 3);
    } else {
      return list;
    }
  }

  bool isListEmpty() => _listTasks.isEmpty;
}
