import 'package:demarco_teste_pratico/core/models/user_model.dart';
import 'package:demarco_teste_pratico/core/states/app_service_state.dart';
import 'package:demarco_teste_pratico/features/login/data/dao/auth_dao.dart';
import 'package:demarco_teste_pratico/features/login/data/service/login_firebase_service.dart';
import 'package:demarco_teste_pratico/features/login/domain/models/login_request_model.dart';
import 'package:demarco_teste_pratico/features/login/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../utils/login_utils.dart';

class MockAuthService extends Mock implements IAuthService {}

class MockAuthDao extends Mock implements IAuthDao {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  late IAuthRepository repository;
  late IAuthService service;
  late IAuthDao dao;
  late LoginRequestModel requestModel;
  late UserModel user;
  setUp(() {
    requestModel = LoginRequestModel(
      email: 'email',
      password: 'password',
    );
    user = UserModel(
      uid: 'uid',
      email: 'email',
    );
    service = MockAuthService();
    dao = MockAuthDao();
    repository = AuthRepository(
      service: service,
      dao: dao,
    );
  });

  setUpAll(() {
    registerFallbackValue(
      LoginRequestModel(email: '', password: ''),
    );
    registerFallbackValue(
      UserModel(uid: 'uid', email: 'email'),
    );
    registerFallbackValue(
      MockFirebaseAuth(),
    );
    registerFallbackValue(
      MockFirebaseFirestore(),
    );
  });

  group('AuthRepositoryTests', () {
    group('login', () {
      test('login | Sucess', () async {
        when(
          () => service.login(
            any(),
            any(),
          ),
        ).thenAnswer((invocation) async {
          return SuccessServiceState(data: '');
        });

        final result = await repository.login(requestModel, MockFirebaseAuth());
        expect(result, isA<SuccessServiceState>());
      });
      test('login | Failure', () async {
        when(
          () => service.login(any(), any()),
        ).thenAnswer((invocation) async {
          return FailureServiceState(message: '');
        });

        final result = await repository.login(requestModel, MockFirebaseAuth());
        expect(result, isA<FailureServiceState>());
      });
    });

    group('createAccount', () {
      test('createAccount | Sucess', () async {
        when(
          () => service.createAccount(any(), any(), any()),
        ).thenAnswer((invocation) async {
          return SuccessServiceState(data: '');
        });

        final result = await repository.createAccount(
            requestModel, MockFirebaseAuth(), MockFirebaseFirestore());
        expect(result, isA<SuccessServiceState>());
      });
      test('createAccount | Failure', () async {
        when(
          () => service.createAccount(any(), any(), any()),
        ).thenAnswer((invocation) async {
          return FailureServiceState(message: '');
        });

        final result = await repository.createAccount(
            requestModel, MockFirebaseAuth(), MockFirebaseFirestore());
        expect(result, isA<FailureServiceState>());
      });
    });
    group('storeUser', () {
      test('storeUser | Sucess', () async {
        when(
          () => dao.storeUser(any()),
        ).thenAnswer((invocation) async {
          return SuccessServiceState(data: '');
        });

        final result = await repository.storeUser(user);
        expect(result, isA<SuccessServiceState>());
      });
      test('storeUser | Failure', () async {
        when(
          () => dao.storeUser(any()),
        ).thenAnswer((invocation) async {
          return FailureServiceState(message: '');
        });

        final result = await repository.storeUser(user);
        expect(result, isA<FailureServiceState>());
      });
    });
    group('getUser', () {
      test('getUser | Sucess', () async {
        when(
          () => dao.geteUser(),
        ).thenAnswer((invocation) async {
          return SuccessServiceState(data: '');
        });

        final result = await repository.getUser();
        expect(result, isA<SuccessServiceState>());
      });
      test('getUser | Failure', () async {
        when(
          () => dao.geteUser(),
        ).thenAnswer((invocation) async {
          return FailureServiceState(message: '');
        });

        final result = await repository.getUser();
        expect(result, isA<FailureServiceState>());
      });
    });

    group('logout', () {
      test('logout | Sucess', () async {
        when(
          () => dao.deleteUser(),
        ).thenAnswer((invocation) async {
          return SuccessServiceState(data: '');
        });

        final result = await repository.logout();
        expect(result, isA<SuccessServiceState>());
      });
      test('logout | Failure', () async {
        when(
          () => dao.deleteUser(),
        ).thenAnswer((invocation) async {
          return FailureServiceState(message: '');
        });

        final result = await repository.logout();
        expect(result, isA<FailureServiceState>());
      });
    });
  });
}
