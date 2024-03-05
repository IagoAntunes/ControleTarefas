import 'package:controle_tarefas/core/database/app_database.dart';
import 'package:controle_tarefas/core/states/app_service_state.dart';
import 'package:controle_tarefas/features/login/data/dao/auth_dao.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../presenter/bloc/auth_bloc_test.dart';
import '../../utils/login_utils.dart';

void main() {
  late IAuthDao dao;
  late AppDatabase mockDatabase;
  setUp(() {
    mockDatabase = MockAppDatabase();
    dao = AuthDao();
  });
  setUpAll(() {
    registerFallbackValue(MockUserModel());
  });
  group('auth_dao', () {
    test('deleteUser', () async {
      when(() => mockDatabase.deleteUser())
          .thenAnswer((invocation) => Future.value());

      final result = await dao.deleteUser(mockDatabase);
      expect(result, isA<SuccessServiceState>());
    });
    test('getUser', () async {
      when(() => mockDatabase.getUser())
          .thenAnswer((invocation) async => MockUserModel());

      final result = await dao.geteUser(mockDatabase);
      expect(result, isA<SuccessServiceState>());
    });
    test('storeUser | Success', () async {
      when(() => mockDatabase.insertUser(any()))
          .thenAnswer((invocation) async => Future.value(true));

      final result = await dao.storeUser(
        MockUserModel(),
        mockDatabase,
      );
      expect(result, isA<SuccessServiceState>());
    });
    test('storeUser | Failure', () async {
      when(() => mockDatabase.insertUser(any()))
          .thenAnswer((invocation) async => Future.value(false));

      final result = await dao.storeUser(
        MockUserModel(),
        mockDatabase,
      );
      expect(result, isA<FailureServiceState>());
      expect((result as FailureServiceState).message, 'Erro ao Inserir');
    });
  });
}
