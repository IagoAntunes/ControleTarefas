import 'dart:convert';

import 'package:controle_tarefas/core/models/user_model.dart';
import 'package:controle_tarefas/core/states/app_service_state.dart';
import 'package:controle_tarefas/features/login/domain/repositories/auth_repository.dart';
import 'package:controle_tarefas/features/tasks/add_task/domain/repositories/add_task_repository.dart';
import 'package:controle_tarefas/features/tasks/add_task/presenter/event/add_task_event.dart';
import 'package:controle_tarefas/features/tasks/add_task/presenter/states/add_task_state.dart';
import 'package:controle_tarefas/features/tasks/tasks_list/domain/models/task_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

enum PickImage { camera, gallery }

class AddTaskBloc extends Bloc<IAddTaskEvent, IAddTaskState> {
  IAddTaskRepository repository;
  IAuthRepository authRepository;
  AddTaskBloc({
    required this.repository,
    required this.authRepository,
  }) : super(IdleTaskState()) {
    taskModel = TaskModel.empty();
    //AddDateTaskEvent | Setar data da tarefa
    on<AddDateTaskEvent>((event, emit) {
      taskModel.date = event.date;
    });
    //SelectImageEvent | Selecionar imagem(camera|galeria)
    on<SelectImageEvent>(
      (event, emit) async {
        String? resultImage;
        XFile? image = await event.imagePicker.pickImage(
            source: event.imageOption == PickImage.camera
                ? ImageSource.camera
                : ImageSource.gallery);
        if (image != null) {
          final imageTemporary = XFile(image.path);

          final bytes = await imageTemporary.readAsBytes();

          resultImage = base64Encode(bytes);
        }

        if (image != null) {
          taskModel.image = resultImage;
          emit(AddedImageTaskState());
        }
      },
    );
    //AddTaskEvent | Adicionar Tarefa
    on<AddTaskEvent>(
      (event, emit) async {
        emit(LoadingAddTaskListener());
        taskModel.title = event.nameTask;
        //Pegar uid do usuario logado
        final result = await authRepository.getUser(event.database);
        if (result is SuccessServiceState<UserModel>) {
          UserModel user = result.data;
          taskModel.id = const Uuid().v1();
          //Requisição para adicionar tarefa
          final result2 = await repository.addTask(
            taskModel,
            user,
            event.firestore,
            event.storage,
          );
          if (result2 is SuccessServiceState) {
            emit(SuccessAddTaskListener(task: taskModel));
          }
        }
      },
    );
  }
  late TaskModel taskModel;

  bool isImageSelected() => taskModel.image != null;
}
