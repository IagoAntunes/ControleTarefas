import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:demarco_teste_pratico/core/models/user_model.dart';
import 'package:demarco_teste_pratico/core/states/app_service_state.dart';
import 'package:demarco_teste_pratico/features/tasks/tasks_list/data/service/tasks_list_firebase_service.dart';
import 'package:demarco_teste_pratico/features/tasks/tasks_list/domain/models/task_model.dart';
import 'package:demarco_teste_pratico/features/tasks/tasks_list/domain/repositories/tasks_list_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../login/presenter/bloc/auth_bloc_test.dart';
import '../../../../login/utils/login_utils.dart';

class MockTasksListFirebaseService extends Mock
    implements TasksListFirebaseService {}

void main() {
  late ITasksListRepository repository;
  late ITasksListFirebaseService service;

  late MockConnectivity mockConnectivity;
  late MockFirebaseFirestore mockFirebaseFirestore;
  late MockFirebaseStorage mockFirebaseStorage;
  setUp(() {
    mockConnectivity = MockConnectivity();
    mockFirebaseFirestore = MockFirebaseFirestore();
    mockFirebaseStorage = MockFirebaseStorage();

    service = MockTasksListFirebaseService();
    repository = TasksListRepository(service: service);
  });

  setUpAll(() {
    registerFallbackValue(
      MockUserModel(),
    );
    registerFallbackValue(
      MockFirebaseFirestore(),
    );
    registerFallbackValue(
      MockFirebaseStorage(),
    );
    registerFallbackValue(
      TaskModel(title: 'title', date: 'date', image: 'image'),
    );
  });
  group('TasksListRepository', () {
    test('getTasks - Success', () async {
      when(
        () => mockConnectivity.checkConnectivity(),
      ).thenAnswer((invocation) async => ConnectivityResult.wifi);
      when(
        () => service.getTasks(any(), any(), any()),
      ).thenAnswer((invocation) async {
        return SuccessServiceState(data: '');
      });
      final result = await repository.getTasks(
        UserModel(uid: '', email: ''),
        mockFirebaseFirestore,
        mockFirebaseStorage,
        mockConnectivity,
      );
      expect(result, isA<SuccessServiceState>());
    });
    test('getTasks - Failure', () async {
      when(
        () => mockConnectivity.checkConnectivity(),
      ).thenAnswer((invocation) async => ConnectivityResult.none);
      when(
        () => service.getTasks(any(), any(), any()),
      ).thenAnswer((invocation) async {
        return NoConnectionFailureServiceState(message: '');
      });
      final result = await repository.getTasks(
        UserModel(uid: '', email: ''),
        mockFirebaseFirestore,
        mockFirebaseStorage,
        mockConnectivity,
      );
      expect(result, isA<NoConnectionFailureServiceState>());
    });

    test('getTasks - Success', () async {
      when(
        () => service.completeTasks(any(), any(), any()),
      ).thenAnswer((invocation) async {
        return SuccessServiceState(data: '');
      });
      final result = await repository.completeTasks(
        UserModel(uid: '', email: ''),
        [],
        mockFirebaseFirestore,
      );
      expect(result, isA<SuccessServiceState>());
    });
    test('getImages', () async {
      when(
        () => service.getImages(any(), any(), any()),
      ).thenAnswer((invocation) async => SuccessServiceState(data: ''));

      final result = await repository.getImages(
        UserModel(uid: '', email: ''),
        mockFirebaseFirestore,
        mockFirebaseStorage,
      );
      expect(result, isA<SuccessServiceState>());
    });
    test('deleteTask - Success', () async {
      when(
        () => service.deleteTask(any(), any(), any()),
      ).thenAnswer((invocation) async {
        return SuccessServiceState(data: '');
      });
      final result = await repository.deleteTask(
        UserModel(uid: '', email: ''),
        TaskModel(title: '', date: 'date', image: 'image'),
        mockFirebaseFirestore,
      );
      expect(result, isA<SuccessServiceState>());
    });
  });
}
