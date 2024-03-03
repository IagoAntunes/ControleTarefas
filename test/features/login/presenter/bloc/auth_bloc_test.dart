// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:demarco_teste_pratico/core/models/user_model.dart';
import 'package:demarco_teste_pratico/core/states/app_service_state.dart';
import 'package:demarco_teste_pratico/features/login/domain/models/login_request_model.dart';
import 'package:demarco_teste_pratico/features/login/domain/repositories/auth_repository.dart';
import 'package:demarco_teste_pratico/features/login/presenter/bloc/auth_bloc.dart';
import 'package:demarco_teste_pratico/features/login/presenter/event/auth_bloc_event.dart';
import 'package:demarco_teste_pratico/features/login/presenter/state/auth_option_state.dart';
import 'package:demarco_teste_pratico/features/login/presenter/utils/auth_options_enum.dart';

import '../../utils/login_utils.dart';

// Mock your repository
class MockAuthRepository extends Mock implements IAuthRepository {}

class MockUserCredential extends Mock implements UserCredential {
  @override
  User user;
  MockUserCredential({
    required this.user,
  });
}

class MockUser extends Mock implements User {
  @override
  String uid;
  @override
  String email;
  MockUser({
    required this.uid,
    required this.email,
  });
}

class MockUser2 extends Mock implements User {}

class MockUserModel extends Mock implements UserModel {}

class MockRequestModel extends Mock implements LoginRequestModel {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late AuthBloc authBloc;
  late MockAuthRepository mockAuthRepository;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    mockAuthRepository = MockAuthRepository();
    authBloc = AuthBloc(repository: mockAuthRepository);
  });
  setUpAll(() {
    registerFallbackValue(
      LoginRequestModel(email: '', password: ''),
    );
    registerFallbackValue(
      UserModel(email: '', uid: ''),
    );
    registerFallbackValue(
      MockFirebaseAuth(),
    );
    registerFallbackValue(
      MockFirebaseFirestore(),
    );
    registerFallbackValue(MockSharedPreferences());
    registerFallbackValue(MockAppDatabase());
  });
  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    test('initial state is LoginAuthOptionState', () {
      expect(authBloc.state, isA<LoginAuthOptionState>());
    });

    blocTest<AuthBloc, IAuthBlocState>(
      'emits [LoginAuthOptionState] when ChangeOptionAuthBlocEvent is added with AuthOption.login',
      build: () => authBloc,
      act: (bloc) {
        bloc.add(
          ChangeOptionAuthBlocEvent(authOption: AuthOption.login),
        );
        bloc.add(
          ChangeOptionAuthBlocEvent(authOption: AuthOption.register),
        );
      },
      expect: () =>
          [isA<LoginAuthOptionState>(), isA<RegisterAuthOptionState>()],
    );
    blocTest<AuthBloc, IAuthBlocState>(
      'LoginLoginBlocEvent- Sucess',
      build: () => authBloc,
      act: (bloc) {
        when(() => mockAuthRepository.login(
              any(),
              any(),
            )).thenAnswer(
          (invocation) async {
            return SuccessServiceState(
              data: MockUserCredential(
                user: MockUser(email: 'email', uid: 'uid'),
              ),
            );
          },
        );
        when(() => mockSharedPreferences.setBool('isLogged', true))
            .thenAnswer((_) => Future.value(true));
        when(() => mockAuthRepository.getUser(any())).thenAnswer((_) async {
          return SuccessServiceState<UserCredential>(
            data: MockUserCredential(
              user: MockUser(email: 'email', uid: 'uid'),
            ),
          );
        });

        when(() => mockAuthRepository.storeUser(any(), any())).thenAnswer(
          (_) async => SuccessServiceState(data: ''),
        );
        bloc.add(
          LoginLoginBlocEvent(
            email: 'test@gmail.com',
            password: '1234',
            shared: mockSharedPreferences,
            firebaseAuth: MockFirebaseAuth(),
            database: MockAppDatabase(),
          ),
        );
      },
      expect: () => [
        isA<LoadingLoginBlocState>(),
        isA<SuccessAuthListener>(),
      ],
    );
    blocTest<AuthBloc, IAuthBlocState>(
      'LoginLoginBlocEvent - Failure',
      build: () => authBloc,
      act: (bloc) {
        when(() => mockAuthRepository.login(any(), any())).thenAnswer(
          (invocation) async {
            return FailureServiceState(message: 'teste');
          },
        );
        bloc.add(
          LoginLoginBlocEvent(
            email: 'test@gmail.com',
            password: '1234',
            shared: mockSharedPreferences,
            firebaseAuth: MockFirebaseAuth(),
            database: MockAppDatabase(),
          ),
        );
      },
      expect: () => [
        isA<LoadingLoginBlocState>(),
        isA<FailureAuthListener>(),
        isA<FailureLoginState>(),
      ],
    );
    blocTest<AuthBloc, IAuthBlocState>(
      'CreateAuthBlocEvent - Success',
      build: () => authBloc,
      act: (bloc) {
        final userCredential = MockUserCredential(
          user: MockUser(email: 'email', uid: 'uid'),
        );
        when(() => mockAuthRepository.createAccount(any(), any(), any()))
            .thenAnswer((_) async {
          return SuccessServiceState(data: userCredential);
        });
        when(() => mockSharedPreferences.setBool('isLogged', true))
            .thenAnswer((_) => Future.value(true));
        when(() => mockAuthRepository.storeUser(any(), any())).thenAnswer(
          (_) async => SuccessServiceState(data: ''),
        );

        bloc.add(
          CreateAuthBlocEvent(
            email: 'test@gmail.com',
            password: '1234',
            shared: mockSharedPreferences,
            firebaseAuth: MockFirebaseAuth(),
            firestore: MockFirebaseFirestore(),
            database: MockAppDatabase(),
          ),
        );
      },
      expect: () => [
        isA<LoadingLoginBlocState>(),
        isA<SuccessAuthListener>(),
        isA<LoggedLoginState>(),
      ],
    );

    blocTest<AuthBloc, IAuthBlocState>(
      'CreateAuthBlocEvent - Failure',
      build: () => authBloc,
      act: (bloc) {
        when(() => mockAuthRepository.createAccount(any(), any(), any()))
            .thenAnswer(
          (invocation) async {
            return FailureServiceState(message: 'teste');
          },
        );
        bloc.add(
          CreateAuthBlocEvent(
            email: 'test@gmail.com',
            password: '1234',
            shared: MockSharedPreferences(),
            firebaseAuth: MockFirebaseAuth(),
            firestore: MockFirebaseFirestore(),
            database: MockAppDatabase(),
          ),
        );
      },
      expect: () => [
        isA<LoadingLoginBlocState>(),
        isA<FailureAuthListener>(),
        isA<FailureLoginState>(),
      ],
    );
    blocTest<AuthBloc, IAuthBlocState>(
      'LogoutAuthBlocEvent - Success',
      build: () => authBloc,
      act: (bloc) {
        when(() => mockAuthRepository.logout(any())).thenAnswer(
          (invocation) async {
            return SuccessServiceState(data: '');
          },
        );
        bloc.add(
          LogoutAuthBlocEvent(
            authOption: AuthOption.login,
            database: MockAppDatabase(),
          ),
        );
      },
      expect: () => [
        isA<LogoutAuthListener>(),
      ],
    );
    blocTest<AuthBloc, IAuthBlocState>(
      'LogoutAuthBlocEvent - Failure',
      build: () => authBloc,
      act: (bloc) {
        when(() => mockAuthRepository.logout(any())).thenAnswer(
          (invocation) async {
            return FailureServiceState(message: 'teste');
          },
        );
        bloc.add(
          LogoutAuthBlocEvent(
            authOption: AuthOption.login,
            database: MockAppDatabase(),
          ),
        );
      },
      expect: () => [
        isA<FailureAuthListener>(),
      ],
    );

    test('userLogged', () async {
      final mockPrefs = MockSharedPreferences();
      when(() => mockPrefs.setBool('isLogged', true))
          .thenAnswer((_) => Future.value(true));
      await authBloc.userLogged(true, mockPrefs);

      verify(() => mockPrefs.setBool('isLogged', true)).called(1);
    });
    test('storeUser', () async {
      final user = UserModel(uid: '', email: '');
      when(() => mockAuthRepository.storeUser(user, any()))
          .thenAnswer((_) async => SuccessServiceState(data: ''));

      await authBloc.storeUserFunc(user);

      verify(() => mockAuthRepository.storeUser(user, any())).called(1);
    });

    test('isAuthLogin', () {
      authBloc.state.authOption = AuthOption.login;

      expect(authBloc.isAuthLogin(), true);
    });
  });
}
