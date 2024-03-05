import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demarco_teste_pratico/core/database/app_database.dart';
import 'package:demarco_teste_pratico/features/login/presenter/bloc/auth_bloc.dart';
import 'package:demarco_teste_pratico/features/login/presenter/event/auth_bloc_event.dart';
import 'package:demarco_teste_pratico/features/login/presenter/state/auth_option_state.dart';
import 'package:demarco_teste_pratico/features/login/presenter/utils/auth_options_enum.dart';
import 'package:demarco_teste_pratico/features/tasks/tasks_list/presenter/pages/tasks_list_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/components/custom_textfield_component.dart';

class FormLogin extends StatefulWidget {
  const FormLogin({
    super.key,
  });

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin>
    with SingleTickerProviderStateMixin {
  late TabController tabController = TabController(length: 2, vsync: this);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    return BlocProvider(
      create: (context) => authBloc,
      child: BlocConsumer<AuthBloc, IAuthBlocState>(
        bloc: authBloc,
        listenWhen: (previous, current) => current is IAuthListeners,
        listener: (context, state) {
          if (state is SuccessAuthListener) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Login realizado",
                ),
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TasksListPage(),
              ),
            );
          } else if (state is FailureAuthListener) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                ),
              ),
            );
          }
        },
        buildWhen: (previous, current) => current is! IAuthListeners,
        builder: (context, state) {
          return Container(
            height: MediaQuery.sizeOf(context).height * 0.5,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: Colors.grey,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            authBloc.add(
                              ChangeOptionAuthBlocEvent(
                                authOption: AuthOption.login,
                              ),
                            );
                            tabController.animateTo(0);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color: authBloc.isAuthLogin()
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Login",
                                style: authBloc.isAuthLogin()
                                    ? const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      )
                                    : const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            authBloc.add(
                              ChangeOptionAuthBlocEvent(
                                authOption: AuthOption.register,
                              ),
                            );
                            tabController.animateTo(1);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color: !authBloc.isAuthLogin()
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Registrar",
                                style: !authBloc.isAuthLogin()
                                    ? const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      )
                                    : const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      LoginWidget(
                        emailController: emailController,
                        passwordController: passwordController,
                      ),
                      LoginWidget(
                        emailController: emailController,
                        passwordController: passwordController,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class LoginWidget extends StatelessWidget {
  LoginWidget({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController;
  final TextEditingController passwordController;
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
            authBloc.state.authOption == AuthOption.login
                ? "Acesse sua conta"
                : "Crie sua conta",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          CustomTextField(
            controller: emailController,
            hintText: 'Email',
            prefixIcon: const Icon(
              Icons.email_outlined,
            ),
            textInputType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Campo obrigatorio";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: passwordController,
            hintText: 'Senha',
            prefixIcon: const Icon(
              Icons.password_outlined,
            ),
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Campo obrigatorio";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (authBloc.state.authOption == AuthOption.login) {
                    authBloc.add(
                      LoginLoginBlocEvent(
                        email: emailController.text,
                        password: passwordController.text,
                        shared: await SharedPreferences.getInstance(),
                        firebaseAuth: FirebaseAuth.instance,
                        database: AppDatabase(),
                      ),
                    );
                  } else {
                    authBloc.add(
                      CreateAuthBlocEvent(
                        email: emailController.text,
                        password: passwordController.text,
                        shared: await SharedPreferences.getInstance(),
                        firebaseAuth: FirebaseAuth.instance,
                        firestore: FirebaseFirestore.instance,
                        database: AppDatabase(),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: authBloc.state is LoadingLoginBlocState
                  ? Container()
                  : const Icon(
                      Icons.login_outlined,
                      color: Colors.white,
                    ),
              label: authBloc.state is LoadingLoginBlocState
                  ? const CircularProgressIndicator()
                  : Text(
                      authBloc.state.authOption == AuthOption.login
                          ? "Entrar"
                          : "Cadastrar",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
