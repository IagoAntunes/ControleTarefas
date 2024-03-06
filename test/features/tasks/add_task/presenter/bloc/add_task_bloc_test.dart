import 'package:bloc_test/bloc_test.dart';
import 'package:controle_tarefas/core/models/user_model.dart';
import 'package:controle_tarefas/core/states/app_service_state.dart';
import 'package:controle_tarefas/features/login/domain/repositories/auth_repository.dart';
import 'package:controle_tarefas/features/tasks/add_task/domain/repositories/add_task_repository.dart';
import 'package:controle_tarefas/features/tasks/add_task/presenter/bloc/add_task_bloc.dart';
import 'package:controle_tarefas/features/tasks/add_task/presenter/event/add_task_event.dart';
import 'package:controle_tarefas/features/tasks/tasks_list/domain/models/task_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../login/utils/login_utils.dart';

class MockAddTaskRepository extends Mock implements AddTaskRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockImagePicker extends Mock implements ImagePicker {}

void main() {
  late AddTaskBloc bloc;
  late IAddTaskRepository mockRepository;
  late IAuthRepository mockAuthRepository;
  late MockAppDatabase mockAppDatabase;
  late MockFirebaseFirestore mockFirestore;
  late MockImagePicker mockImagePicker;
  late MockFirebaseStorage mockStorage;
  //late XFile xFile;
  setUp(() {
    //xFile = XFile("teste");
    mockImagePicker = MockImagePicker();
    mockRepository = MockAddTaskRepository();
    mockAuthRepository = MockAuthRepository();
    mockAppDatabase = MockAppDatabase();
    mockFirestore = MockFirebaseFirestore();
    mockStorage = MockFirebaseStorage();
    bloc = AddTaskBloc(
      repository: mockRepository,
      authRepository: mockAuthRepository,
    );
  });
  setUpAll(() {
    registerFallbackValue(MockAppDatabase());
  });
  group('AddDateTaskEvent', () {
    blocTest(
      '',
      build: () => bloc,
      act: (bloc) {
        bloc.add(AddDateTaskEvent(date: '01/01/2024'));
      },
      expect: () => [],
    );
  });
  group('SelectImageEvent', () {
    blocTest(
      '',
      build: () => bloc,
      act: (bloc) {
        when(
          () => mockImagePicker.pickImage(source: ImageSource.camera),
        ).thenAnswer((invocation) async => null);

        bloc.add(SelectImageEvent(
          imagePicker: mockImagePicker,
          imageOption: PickImage.camera,
        ));
      },
    );
  });

  group('AddTaskEvent', () {
    blocTest(
      'AddTaskEvent',
      build: () => bloc,
      act: (bloc) {
        var user = UserModel(email: 'email', uid: 'uid');
        var task = TaskModel(title: 'title', date: 'date', image: 'image');

        bloc.taskModel = task;
        when(
          () => mockAuthRepository.getUser(any()),
        ).thenAnswer(
          (invocation) async => SuccessServiceState(data: user),
        );
        when(
          () => mockRepository.addTask(task, user, mockFirestore, mockStorage),
        ).thenAnswer((invocation) async => SuccessServiceState(data: ''));

        bloc.add(
          AddTaskEvent(
            database: mockAppDatabase,
            firestore: mockFirestore,
            nameTask: 'task',
            storage: mockStorage,
          ),
        );
      },
    );
  });
}
