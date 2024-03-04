import 'package:demarco_teste_pratico/core/models/user_model.dart';
import 'package:demarco_teste_pratico/core/states/app_service_state.dart';
import 'package:demarco_teste_pratico/features/tasks/add_task/data/service/add_task_firebase_service.dart';
import 'package:demarco_teste_pratico/features/tasks/add_task/domain/repositories/add_task_repository.dart';
import 'package:demarco_teste_pratico/features/tasks/tasks_list/domain/models/task_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../login/utils/login_utils.dart';

class MockAddTaskListFirebaseServicec extends Mock
    implements AddTaskFirebaseService {}

void main() {
  late IAddTaskRepository repository;
  late IAddTaskFirebaseService mockService;

  late MockFirebaseFirestore firestore;
  late MockFirebaseStorage storage;
  var task = TaskModel(title: 'title', date: 'date', image: 'image');
  var user = UserModel(uid: '', email: '');
  setUp(() {
    firestore = MockFirebaseFirestore();
    storage = MockFirebaseStorage();
    mockService = MockAddTaskListFirebaseServicec();
    repository = AddTaskRepository(
      service: mockService,
    );
  });
  setUpAll(() {
    registerFallbackValue(MockFirebaseFirestore());
    registerFallbackValue(MockFirebaseStorage());
    registerFallbackValue(task);
    registerFallbackValue(user);
  });

  group('AddTaskRepository', () {
    test('addTask - Success', () async {
      when(
        () => mockService.addTask(any(), any(), any(), any()),
      ).thenAnswer((invocation) async => SuccessServiceState(data: ''));

      final result = await repository.addTask(
        task,
        user,
        firestore,
        storage,
      );

      expect(result, isA<SuccessServiceState>());
    });
    test('addTask - Failure', () async {
      when(
        () => mockService.addTask(any(), any(), any(), any()),
      ).thenAnswer((invocation) async => FailureServiceState(message: ''));

      final result = await repository.addTask(
        task,
        user,
        firestore,
        storage,
      );

      expect(result, isA<FailureServiceState>());
    });
  });
}
