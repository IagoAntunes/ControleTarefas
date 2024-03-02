import 'package:demarco_teste_pratico/features/login/data/dao/auth_dao.dart';
import 'package:demarco_teste_pratico/features/login/data/service/login_firebase_service.dart';
import 'package:demarco_teste_pratico/features/login/domain/repositories/auth_repository.dart';
import 'package:demarco_teste_pratico/features/login/presenter/bloc/auth_bloc.dart';
import 'package:demarco_teste_pratico/features/login/presenter/page/login_page.dart';
import 'package:demarco_teste_pratico/features/tasks/tasks_list/presenter/pages/tasks_list_page.dart';
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
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppBloc(),
        ),
        BlocProvider(
          create: (context) => AuthBloc(
            repository: AuthRepository(
              dao: AuthDao(),
              service: AuthFirebaseService(),
            ),
          ),
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
          title: 'Demardo Test',
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xfffd383a),
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xfffd383a),
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
