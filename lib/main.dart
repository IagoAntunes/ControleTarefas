import 'package:controle_tarefas/core/theme/app_colors.dart';
import 'package:controle_tarefas/features/login/data/dao/auth_dao.dart';
import 'package:controle_tarefas/features/login/data/service/login_firebase_service.dart';
import 'package:controle_tarefas/features/login/domain/repositories/auth_repository.dart';
import 'package:controle_tarefas/features/login/presenter/bloc/auth_bloc.dart';
import 'package:controle_tarefas/features/login/presenter/page/login_page.dart';
import 'package:controle_tarefas/features/tasks/tasks_list/presenter/pages/tasks_list_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/bloc/app_bloc.dart';
import 'core/bloc/states/app_bloc_state.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isLogged = prefs.getBool('isLogged') ?? false;
  final appBloc = AppBloc();
  final authBloc = AuthBloc(
    repository: AuthRepository(
      dao: AuthDao(),
      service: AuthFirebaseService(),
    ),
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => appBloc,
        ),
        BlocProvider(
          create: (context) => authBloc,
        ),
      ],
      child: MyApp(
        child: isLogged ? TasksListPage() : const LoginPage(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({
    super.key,
    required this.child,
  });
  final Widget child;
  final bloc = AppBloc();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, IAppBlocState>(
      bloc: bloc,
      builder: (context, state) {
        return MaterialApp(
          title: 'Tarefas',
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.redPrimary,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.redPrimary,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.light,
          home: child,
        );
      },
    );
  }
}
