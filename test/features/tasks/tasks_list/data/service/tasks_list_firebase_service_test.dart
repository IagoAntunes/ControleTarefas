import 'package:controle_tarefas/core/models/user_model.dart';
import 'package:controle_tarefas/core/states/app_service_state.dart';
import 'package:controle_tarefas/features/tasks/tasks_list/data/service/tasks_list_firebase_service.dart';
import 'package:controle_tarefas/features/tasks/tasks_list/domain/models/task_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../login/utils/login_utils.dart';

void main() {
  late ITasksListFirebaseService tasksListFirebaseService;
  late MockFirebaseFirestore mockFirebaseFirestore;
  late MockFirebaseStorage mockFirebaseStorage;
  late MockCollectionReference mockCollectionReference;
  late MockDocumentReference mockDocumentReference;
  late MockDocumentSnapShotReference mockDocumentSnapShotReference;
  late MocListResult mockListResult;
  late MockReference mockReference;
  setUp(() {
    mockDocumentSnapShotReference =
        MockDocumentSnapShotReference(itExist: true);
    mockCollectionReference = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();
    mockFirebaseStorage = MockFirebaseStorage();
    mockReference = MockReference();
    mockListResult = MocListResult();
    mockFirebaseFirestore = MockFirebaseFirestore();
    tasksListFirebaseService = TasksListFirebaseService();
  });
  group('TaskListFirebaseService', () {
    group('getTasks', () {
      test('getTasks - Sucess', () async {
        when(() => mockFirebaseFirestore.collection(any()))
            .thenReturn(mockCollectionReference);
        when(() => mockCollectionReference.doc(any()))
            .thenReturn(mockDocumentReference);
        when(() => mockDocumentReference.get(any()))
            .thenAnswer((invocation) async => mockDocumentSnapShotReference);

        final result = await tasksListFirebaseService.getTasks(
          UserModel(email: 'email', uid: 'uid'),
          mockFirebaseFirestore,
          MockFirebaseStorage(),
        );

        expect(result, isA<SuccessServiceState>());
      });
      test('getTasks - Failure', () async {
        when(() => mockFirebaseFirestore.collection(any()))
            .thenReturn(mockCollectionReference);
        when(() => mockCollectionReference.doc(any()))
            .thenReturn(mockDocumentReference);
        when(() => mockDocumentReference.get(any())).thenThrow(Exception());

        final result = await tasksListFirebaseService.getTasks(
          UserModel(email: 'email', uid: 'uid'),
          mockFirebaseFirestore,
          MockFirebaseStorage(),
        );

        expect(result, isA<FailureServiceState>());
      });
    });
    group('completeTasks', () {
      test('completeTasks - Sucess', () async {
        when(() => mockFirebaseFirestore.collection(any()))
            .thenReturn(mockCollectionReference);
        when(() => mockCollectionReference.doc(any()))
            .thenReturn(mockDocumentReference);
        when(() => mockDocumentReference.update(any()))
            .thenAnswer((invocation) => Future.value());

        final result = await tasksListFirebaseService.completeTasks(
          UserModel(email: 'email', uid: 'uid'),
          [TaskModel(title: 'title', date: 'date', image: 'image')],
          mockFirebaseFirestore,
        );

        expect(result, isA<SuccessServiceState>());
      });
      test('completeTasks - Failure', () async {
        when(() => mockFirebaseFirestore.collection(any()))
            .thenReturn(mockCollectionReference);
        when(() => mockCollectionReference.doc(any()))
            .thenReturn(mockDocumentReference);
        when(() => mockDocumentReference.get(any())).thenThrow(Exception());

        final result = await tasksListFirebaseService.completeTasks(
          UserModel(email: 'email', uid: 'uid'),
          [TaskModel(title: 'title', date: 'date', image: 'image')],
          mockFirebaseFirestore,
        );

        expect(result, isA<FailureServiceState>());
      });
    });
    group('getImages', () {
      test('getImages - Sucess', () async {
        when(() => mockFirebaseStorage.ref(any())).thenReturn(mockReference);
        when(() => mockReference.listAll())
            .thenAnswer((invocation) async => mockListResult);

        final result = await tasksListFirebaseService.getImages(
          UserModel(email: 'email', uid: 'uid'),
          mockFirebaseFirestore,
          mockFirebaseStorage,
        );

        expect(result, isA<SuccessServiceState>());
      });
      test('getImages - Failure', () async {
        when(() => mockFirebaseStorage.ref(any())).thenReturn(mockReference);
        when(() => mockReference.listAll()).thenThrow(Exception());

        final result = await tasksListFirebaseService.getImages(
          UserModel(email: 'email', uid: 'uid'),
          mockFirebaseFirestore,
          mockFirebaseStorage,
        );

        expect(result, isA<FailureServiceState>());
      });
    });
    group('deleteTask', () {
      test('deleteTask - Sucess', () async {
        when(() => mockFirebaseFirestore.collection(any()))
            .thenReturn(mockCollectionReference);
        when(() => mockCollectionReference.doc(any()))
            .thenReturn(mockDocumentReference);
        when(() => mockDocumentReference.update(any()))
            .thenAnswer((invocation) async => Future.value());

        final result = await tasksListFirebaseService.deleteTask(
          UserModel(email: 'email', uid: 'uid'),
          TaskModel(title: 'title', date: 'date', image: 'image'),
          mockFirebaseFirestore,
        );

        expect(result, isA<SuccessServiceState>());
      });
      test('deleteTask - Failure', () async {
        when(() => mockFirebaseFirestore.collection(any()))
            .thenReturn(mockCollectionReference);
        when(() => mockCollectionReference.doc(any()))
            .thenReturn(mockDocumentReference);
        when(() => mockDocumentReference.update(any())).thenThrow(Exception());

        final result = await tasksListFirebaseService.deleteTask(
          UserModel(email: 'email', uid: 'uid'),
          TaskModel(title: 'title', date: 'date', image: 'image'),
          mockFirebaseFirestore,
        );

        expect(result, isA<FailureServiceState>());
      });
    });
  });
}
