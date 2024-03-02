import 'package:demarco_teste_pratico/core/models/user_model.dart';
import 'package:demarco_teste_pratico/core/states/app_service_state.dart';
import 'package:demarco_teste_pratico/core/utils/pick_image.dart';
import 'package:demarco_teste_pratico/features/login/domain/repositories/auth_repository.dart';
import 'package:demarco_teste_pratico/features/tasks/add_task/domain/repositories/add_task_repository.dart';
import 'package:demarco_teste_pratico/features/tasks/add_task/presenter/event/add_task_event.dart';
import 'package:demarco_teste_pratico/features/tasks/add_task/presenter/states/add_task_state.dart';
import 'package:demarco_teste_pratico/features/tasks/tasks_list/domain/models/task_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddTaskBloc extends Bloc<IAddTaskEvent, IAddTaskState> {
  IAddTaskRepository repository;
  IAuthRepository authRepository;
  AddTaskBloc({
    required this.repository,
    required this.authRepository,
  }) : super(IdleTaskState()) {
    taskModel = TaskModel.empty();
    on<AddDateTaskEvent>((event, emit) {
      taskModel.date = event.date;
    });
    on<SelectImageEvent>(
      (event, emit) async {
        String? image = await AppUtils.pickImage(ImageSource.camera);
        if (image != null) {
          taskModel.image = image;
          emit(AddedImageTaskState());
        }
      },
    );
    on<AddTaskEvent>(
      (event, emit) async {
        emit(LoadingAddTaskListener());
        taskModel.title = event.nameTask;
        final result = await authRepository.getUser();
        if (result is SuccessServiceState<UserModel>) {
          UserModel user = result.data;
          taskModel.id = const Uuid().v1();
          final result2 = await repository.addTask(taskModel, user);
          if (result2 is SuccessServiceState) {
            emit(SuccessAddTaskListener(task: taskModel));
          } else {
            //
          }
        }
      },
    );
  }
  late TaskModel taskModel;

  bool isImageSelected() => taskModel.image != null;
}
