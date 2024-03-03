import 'package:demarco_teste_pratico/core/states/app_service_state.dart';
import 'package:demarco_teste_pratico/features/login/data/service/login_firebase_service.dart';
import 'package:demarco_teste_pratico/features/login/domain/models/login_request_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../presenter/bloc/auth_bloc_test.dart';
import '../../utils/login_utils.dart';

void main() {
  late IAuthService service;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirebaseFirestore;
  late LoginRequestModel loginRequestModel;

  late MockCollectionReference mockCollectionReference;
  late MockDocumentReference mockDocumentReference;
  setUp(() {
    mockCollectionReference = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();

    mockFirebaseFirestore = MockFirebaseFirestore();
    loginRequestModel = LoginRequestModel(email: 'email', password: 'password');
    mockFirebaseAuth = MockFirebaseAuth();
    service = AuthFirebaseService();
  });

  setUpAll(() {
    registerFallbackValue(
      LoginRequestModel(email: '', password: ''),
    );

    registerFallbackValue(
      MockFirebaseAuth(),
    );
  });
  group('login_firebase_service', () {
    group('login ', () {
      test('login | Sucess', () async {
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: 'email',
            password: 'password',
          ),
        ).thenAnswer((invocation) async {
          return MockUserCredential(
            user: MockUser(email: '', uid: ''),
          );
        });
        final result = await service.login(
          loginRequestModel,
          mockFirebaseAuth,
        );
        expect(result, isA<SuccessServiceState>());
      });
      test('login | Failure-invalid-credential ', () async {
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: 'email',
            password: 'password',
          ),
        ).thenThrow(
          FirebaseAuthException(code: 'invalid-credential'),
        );
        final result = await service.login(
          loginRequestModel,
          mockFirebaseAuth,
        );
        expect(result, isA<FailureServiceState>());
        expect((result as FailureServiceState).message, 'Usuário invalido');
      });
      test('login | Failure-user-not-found ', () async {
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: 'email',
            password: 'password',
          ),
        ).thenThrow(
          FirebaseAuthException(code: 'user-not-found'),
        );
        final result = await service.login(
          loginRequestModel,
          mockFirebaseAuth,
        );
        expect(result, isA<FailureServiceState>());
        expect(
            (result as FailureServiceState).message, 'Usuário não encontrado');
      });
      test('login | Failure-wrong-password ', () async {
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: 'email',
            password: 'password',
          ),
        ).thenThrow(
          FirebaseAuthException(code: 'wrong-password'),
        );
        final result = await service.login(
          loginRequestModel,
          mockFirebaseAuth,
        );
        expect(result, isA<FailureServiceState>());
        expect((result as FailureServiceState).message, 'Senha Incorreta');
      });
      test('login | Failure-invalid-email ', () async {
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: 'email',
            password: 'password',
          ),
        ).thenThrow(
          FirebaseAuthException(code: 'invalid-email'),
        );
        final result = await service.login(
          loginRequestModel,
          mockFirebaseAuth,
        );
        expect(result, isA<FailureServiceState>());
        expect((result as FailureServiceState).message, 'Email Invalido');
      });
      test('login | Failure-other ', () async {
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: 'email',
            password: 'password',
          ),
        ).thenThrow(
          FirebaseAuthException(code: 'other'),
        );
        final result = await service.login(
          loginRequestModel,
          mockFirebaseAuth,
        );
        expect(result, isA<FailureServiceState>());
        expect((result as FailureServiceState).message, 'Erro inesperado');
      });
    });
    group('createAccount ', () {
      test('login | Sucess', () async {
        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: 'email',
            password: 'password',
          ),
        ).thenAnswer((invocation) async {
          return MockUserCredential(
            user: MockUser(email: 'email', uid: 'uid'),
          );
        });
        when(() => mockFirebaseFirestore.collection(any()))
            .thenReturn(mockCollectionReference);
        when(() => mockCollectionReference.doc(any()))
            .thenReturn(mockDocumentReference);
        when(() => mockDocumentReference.set(any()))
            .thenAnswer((invocation) async => Future.value());

        final result = await service.createAccount(
          loginRequestModel,
          mockFirebaseAuth,
          mockFirebaseFirestore,
        );
        expect(result, isA<SuccessServiceState>());
        verify(() =>
                mockFirebaseFirestore.collection('users').doc(any()).set(any()))
            .called(1);
      });
      test('login | Failure -email-already-in-use', () async {
        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: 'email',
            password: 'password',
          ),
        ).thenThrow(
          FirebaseAuthException(
            code: 'email-already-in-use',
          ),
        );
        when(() => mockFirebaseFirestore.collection(any()))
            .thenReturn(mockCollectionReference);
        when(() => mockCollectionReference.doc(any()))
            .thenReturn(mockDocumentReference);
        when(() => mockDocumentReference.set(any()))
            .thenAnswer((invocation) async => Future.value());

        final result = await service.createAccount(
          loginRequestModel,
          mockFirebaseAuth,
          mockFirebaseFirestore,
        );
        expect(result, isA<FailureServiceState>());
        expect((result as FailureServiceState).message, 'Email ja em uso');
      });
      test('login | Failure -invalid-email', () async {
        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: 'email',
            password: 'password',
          ),
        ).thenThrow(
          FirebaseAuthException(
            code: 'invalid-email',
          ),
        );
        when(() => mockFirebaseFirestore.collection(any()))
            .thenReturn(mockCollectionReference);
        when(() => mockCollectionReference.doc(any()))
            .thenReturn(mockDocumentReference);
        when(() => mockDocumentReference.set(any()))
            .thenAnswer((invocation) async => Future.value());

        final result = await service.createAccount(
          loginRequestModel,
          mockFirebaseAuth,
          mockFirebaseFirestore,
        );
        expect(result, isA<FailureServiceState>());
        expect((result as FailureServiceState).message, 'Email invalido');
      });
      test('login | Failure -operation-not-allowed', () async {
        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: 'email',
            password: 'password',
          ),
        ).thenThrow(
          FirebaseAuthException(
            code: 'operation-not-allowed',
          ),
        );
        when(() => mockFirebaseFirestore.collection(any()))
            .thenReturn(mockCollectionReference);
        when(() => mockCollectionReference.doc(any()))
            .thenReturn(mockDocumentReference);
        when(() => mockDocumentReference.set(any()))
            .thenAnswer((invocation) async => Future.value());

        final result = await service.createAccount(
          loginRequestModel,
          mockFirebaseAuth,
          mockFirebaseFirestore,
        );
        expect(result, isA<FailureServiceState>());
        expect((result as FailureServiceState).message, 'Erro interno');
      });
      test('login | Failure -weak-password', () async {
        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: 'email',
            password: 'password',
          ),
        ).thenThrow(
          FirebaseAuthException(
            code: 'weak-password',
          ),
        );
        when(() => mockFirebaseFirestore.collection(any()))
            .thenReturn(mockCollectionReference);
        when(() => mockCollectionReference.doc(any()))
            .thenReturn(mockDocumentReference);
        when(() => mockDocumentReference.set(any()))
            .thenAnswer((invocation) async => Future.value());

        final result = await service.createAccount(
          loginRequestModel,
          mockFirebaseAuth,
          mockFirebaseFirestore,
        );
        expect(result, isA<FailureServiceState>());
        expect((result as FailureServiceState).message, 'Senha Fraca');
      });
      test('login | Failure -other', () async {
        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: 'email',
            password: 'password',
          ),
        ).thenThrow(
          FirebaseAuthException(
            code: 'other',
          ),
        );
        when(() => mockFirebaseFirestore.collection(any()))
            .thenReturn(mockCollectionReference);
        when(() => mockCollectionReference.doc(any()))
            .thenReturn(mockDocumentReference);
        when(() => mockDocumentReference.set(any()))
            .thenAnswer((invocation) async => Future.value());

        final result = await service.createAccount(
          loginRequestModel,
          mockFirebaseAuth,
          mockFirebaseFirestore,
        );
        expect(result, isA<FailureServiceState>());
        expect((result as FailureServiceState).message, 'Erro inesperado');
      });
    });
  });
}
