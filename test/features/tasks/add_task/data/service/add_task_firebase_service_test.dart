import 'dart:typed_data';

import 'package:demarco_teste_pratico/core/models/user_model.dart';
import 'package:demarco_teste_pratico/core/states/app_service_state.dart';
import 'package:demarco_teste_pratico/features/tasks/add_task/data/service/add_task_firebase_service.dart';
import 'package:demarco_teste_pratico/features/tasks/tasks_list/domain/models/task_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../login/utils/login_utils.dart';

void main() {
  late IAddTaskFirebaseService service;

  late MockFirebaseFirestore mockFirebaseFirestore;
  late MockFirebaseStorage mockFirebaseStorage;
  late MockCollectionReference mockCollectionReference;
  late MockDocumentReference mockDocumentReference;
  late MockDocumentSnapShotReference mockDocumentSnapShotReference;

  late MockReference mockReference;
  late MockReference mockReferenceChild;
  late MockUploadTask mockUploadTask;

  var task = TaskModel(title: 'title', date: 'date', image: 'bbbb');
  var user = UserModel(uid: 'uid', email: 'email');
  setUp(() {
    service = AddTaskFirebaseService();

    mockCollectionReference = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();
    mockFirebaseStorage = MockFirebaseStorage();
    mockDocumentSnapShotReference =
        MockDocumentSnapShotReference(itExist: true);
    mockFirebaseFirestore = MockFirebaseFirestore();
    mockReference = MockReference();
    mockReferenceChild = MockReference();
    mockUploadTask = MockUploadTask();
  });
  setUpAll(() {
    registerFallbackValue(Uint8List(4));
  });
  group("AddTaskFirebaseService", () {
    group('addTask', () {
      test('addTask', () async {
        when(() => mockFirebaseFirestore.collection(any()))
            .thenReturn(mockCollectionReference);
        when(() => mockCollectionReference.doc(any()))
            .thenReturn(mockDocumentReference);
        when(() => mockDocumentReference.get(any()))
            .thenAnswer((invocation) async => mockDocumentSnapShotReference);

        when(
          () => mockFirebaseStorage.ref(),
        ).thenAnswer((invocation) => mockReference);
        when(
          () => mockReference.child(any()),
        ).thenAnswer((invocation) => mockReferenceChild);
        when(
          () => mockReferenceChild.putData(any()),
        ).thenAnswer((invocation) => mockUploadTask);

        //
        when(
          () => mockDocumentReference.update(any()),
        ).thenAnswer((invocation) async => Future.value());
        final result = await service.addTask(
            task, user, mockFirebaseFirestore, mockFirebaseStorage);
        expect(result, isA<SuccessServiceState>());
      });
    });
  });
}
