import 'package:bloc_test/bloc_test.dart';
import 'package:controle_tarefas/core/models/user_model.dart';
import 'package:controle_tarefas/core/states/app_service_state.dart';
import 'package:controle_tarefas/features/login/data/service/login_firebase_service.dart';
import 'package:controle_tarefas/features/login/domain/repositories/auth_repository.dart';
import 'package:controle_tarefas/features/tasks/tasks_list/data/service/tasks_list_firebase_service.dart';
import 'package:controle_tarefas/features/tasks/tasks_list/domain/models/task_model.dart';
import 'package:controle_tarefas/features/tasks/tasks_list/domain/repositories/tasks_list_repository.dart';
import 'package:controle_tarefas/features/tasks/tasks_list/presenter/bloc/tasks_list_bloc.dart';
import 'package:controle_tarefas/features/tasks/tasks_list/presenter/event/tasks_list_event.dart';
import 'package:controle_tarefas/features/tasks/tasks_list/presenter/state/task_list_bloc_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../login/utils/login_utils.dart';

class MockAuthFirebaseService extends Mock implements AuthFirebaseService {}

class MockTasksListFirebaseService extends Mock
    implements TasksListFirebaseService {}

class MockTasksListRepository extends Mock implements TasksListRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late TasksListBloc bloc;
  late ITasksListRepository mockRepository;
  late IAuthRepository mockAuthRepository;

  late MockAppDatabase mockAppDatabase;

  late MockConnectivity mockConnectivity;
  late MockFirebaseFirestore mockFirebaseFirestore;
  late MockFirebaseStorage mockFirebaseStorage;
  UserModel user = UserModel(email: 'email', uid: 'uid');
  setUp(() {
    mockRepository = MockTasksListRepository();
    mockAuthRepository = MockAuthRepository();
    mockAppDatabase = MockAppDatabase();
    mockConnectivity = MockConnectivity();
    mockAppDatabase = MockAppDatabase();
    mockFirebaseFirestore = MockFirebaseFirestore();
    mockFirebaseStorage = MockFirebaseStorage();
    bloc = TasksListBloc(
      repository: mockRepository,
      authRepository: mockAuthRepository,
      connectivity: mockConnectivity,
      database: MockAppDatabase(),
      firestore: mockFirebaseFirestore,
      storage: mockFirebaseStorage,
      initGet: false,
    );
  });
  setUpAll(() {
    registerFallbackValue(MockAppDatabase());
    registerFallbackValue(UserModel(email: 'email', uid: 'uid'));
    registerFallbackValue(MockFirebaseFirestore());
    registerFallbackValue(MockFirebaseStorage());
    registerFallbackValue(MockConnectivity());
  });
  group('TasksListBloc', () {
    blocTest(
      'GetTasksListEvent',
      build: () => bloc,
      act: (bloc) {
        when(() => mockAuthRepository.getUser(any())).thenAnswer((_) async {
          return SuccessServiceState(
            data: user,
          );
        });
        when(
          () => mockRepository.getTasks(
            any(),
            any(),
            any(),
            any(),
          ),
        ).thenAnswer(
          (invocation) async => SuccessServiceState(data: {
            'listTasks': [
              {
                'id': 'id',
                'title': 'title',
                'date': 'date',
                'image': 'image',
                'isDone': true,
              }
            ]
          }),
        );

        when(
          () => mockRepository.getImages(user, any(), any()),
        ).thenAnswer(
          (invocation) async => SuccessServiceState(
            data: [
              {
                'task': 'teste.jgp',
                'b64': 'b64',
              }
            ],
          ),
        );
        bloc.add(
          GetTasksListEvent(
            database: mockAppDatabase,
            firestore: mockFirebaseFirestore,
            storage: mockFirebaseStorage,
            connectivity: mockConnectivity,
          ),
        );
      },
      expect: () => [
        isA<LoadingTasksListBlocState>(),
        isA<SuccessTasksListBlocState>(),
      ],
    );

    blocTest(
      'DeleteTaskListEvent',
      build: () => bloc,
      act: (bloc) {
        var task = TaskModel(
          date: '',
          image: '',
          title: '',
          id: '',
          isChecked: false,
          isDone: false,
        );
        when(() => mockAuthRepository.getUser(any())).thenAnswer((_) async {
          return SuccessServiceState(
            data: UserModel(email: 'email', uid: 'uid'),
          );
        });

        when(
          () => mockRepository.deleteTask(any(), task, mockFirebaseFirestore),
        ).thenAnswer((invocation) async => SuccessServiceState(data: ''));
        bloc.add(
          DeleteTaskListEvent(
              database: mockAppDatabase,
              task: task,
              firestore: mockFirebaseFirestore),
        );
      },
      expect: () => [
        isA<SuccessTasksListBlocState>(),
      ],
    );
    group('SelectedTasksListBloc', () {
      blocTest(
        'SelectedTaskListEvent | isDone(true)',
        build: () => bloc,
        act: (bloc) {
          var task = TaskModel(
            date: '',
            image: '',
            title: '',
            id: '',
            isChecked: false,
            isDone: false,
          );
          bloc.filterTasks.add(task);

          bloc.add(
            SelectedTaskListEvent(
              index: 0,
              value: true,
            ),
          );
        },
        expect: () => [
          isA<SelectedTaskListBlocState>(),
        ],
      );
      blocTest(
        'SelectedTaskListEvent | isDone(false)',
        build: () => bloc,
        act: (bloc) {
          var task = TaskModel(
            date: '',
            image: '',
            title: '',
            id: '',
            isChecked: true,
            isDone: false,
          );
          bloc.filterTasks.add(task);

          bloc.add(
            SelectedTaskListEvent(
              index: 0,
              value: false,
            ),
          );
        },
        expect: () => [
          isA<SelectedTaskListBlocState>(),
        ],
      );
    });
    group('DoneTasksListEvent', () {
      blocTest(
        'DoneTasksListEvent ',
        build: () => bloc,
        act: (bloc) {
          var task = TaskModel(
            date: '',
            image: '',
            title: '',
            id: '',
            isChecked: true,
            isDone: false,
          );
          bloc.filterTasks.add(task);

          when(() => mockAuthRepository.getUser(any())).thenAnswer((_) async {
            return SuccessServiceState(
              data: user,
            );
          });
          when(() => mockRepository.completeTasks(user, [], any()))
              .thenAnswer((_) async {
            return SuccessServiceState(data: '');
          });

          bloc.add(
            DoneTasksListEvent(
              database: mockAppDatabase,
              firestore: mockFirebaseFirestore,
            ),
          );
        },
        expect: () => [
          isA<SuccessTasksListBlocState>(),
        ],
      );
    });
    group('FilterTaskListEvent', () {
      blocTest(
        'FilterTaskListEvent ',
        build: () => bloc,
        act: (bloc) {
          var task = TaskModel(
            date: '',
            image: '',
            title: 'Telefonar',
            id: '',
            isChecked: true,
            isDone: false,
          );
          bloc.filterTasks.add(task);

          bloc.add(
            FilterTaskListEvent(text: 'Tele'),
          );
        },
        expect: () => [
          isA<FilteredListBlocState>(),
        ],
      );
    });

    group('AddTaskListEvent', () {
      blocTest(
        'AddTaskListEvent',
        build: () => bloc,
        act: (bloc) {
          var task = TaskModel(
            date: '',
            image: '',
            title: 'Telefonar',
            id: '',
            isChecked: true,
            isDone: false,
          );

          bloc.add(
            AddTaskListEvent(
              firestore: mockFirebaseFirestore,
              task: task,
            ),
          );
        },
        expect: () => [
          isA<SuccessTasksListBlocState>(),
        ],
      );
    });
    group('selectThreeElements', () {
      test('selectThreeElements - (>=3)', () {
        bloc.listTasks.addAll(
          [
            TaskModel(
              title: 'title',
              date: 'date',
              image: 'image',
            ),
            TaskModel(
              title: 'title',
              date: 'date',
              image: 'image',
            ),
            TaskModel(
              title: 'title',
              date: 'date',
              image: 'image',
            ),
            TaskModel(
              title: 'title',
              date: 'date',
              image: 'image',
            ),
          ],
        );
        final result = bloc.selectThreeElements();

        expect(result.length, 3);
      });
      test('selectThreeElements - (>=3)', () {
        bloc.listTasks.addAll(
          [
            TaskModel(
              title: 'title',
              date: 'date',
              image: 'image',
            ),
            TaskModel(
              title: 'title',
              date: 'date',
              image: 'image',
            ),
          ],
        );
        final result = bloc.selectThreeElements();

        expect(result.length, 2);
      });
    });
    group('isListEmpty', () {
      test('isListEmpty', () {
        final result = bloc.isListEmpty();

        expect(result, true);
      });
    });
  });
}
