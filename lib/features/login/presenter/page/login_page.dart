import 'package:demarco_teste_pratico/features/login/presenter/event/auth_bloc_event.dart';
import 'package:demarco_teste_pratico/features/login/presenter/utils/auth_options_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/components/custom_textfield_component.dart';
import '../../../tasks/tasks_list/presenter/pages/tasks_list_page.dart';
import '../bloc/auth_bloc.dart';
import '../state/auth_option_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController = TabController(length: 2, vsync: this);
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 48),
                const Text(
                  "Demarco",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                BlocProvider(
                  create: (context) => authBloc,
                  child: BlocConsumer<AuthBloc, IAuthBlocState>(
                    bloc: authBloc,
                    listenWhen: (previous, current) =>
                        current is IAuthListeners,
                    listener: (context, state) {
                      if (state is SuccessAuthListener) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Sucesso",
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
                    builder: (context, state) {
                      return Container(
                        height: MediaQuery.sizeOf(context).height * 0.5,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 12),
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
                                  LoginWidget(),
                                  RegisterWidget(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterWidget extends StatelessWidget {
  RegisterWidget({super.key});

  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text(
            "Crie uma conta",
            style: TextStyle(
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
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  authBloc.add(
                    CreateAuthBlocEvent(
                      email: emailController.text,
                      password: passwordController.text,
                    ),
                  );
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
                  ? null
                  : const Icon(
                      Icons.login_outlined,
                      color: Colors.white,
                    ),
              label: authBloc.state is LoadingLoginBlocState
                  ? const CircularProgressIndicator()
                  : const Text(
                      "Cadastrar",
                      style: TextStyle(
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

class LoginWidget extends StatelessWidget {
  LoginWidget({super.key});

  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text(
            "Acesse sua conta",
            style: TextStyle(
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
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  authBloc.add(
                    LoginLoginBlocEvent(
                      email: emailController.text,
                      password: passwordController.text,
                    ),
                  );
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
                  ? null
                  : const Icon(
                      Icons.login_outlined,
                      color: Colors.white,
                    ),
              label: authBloc.state is LoadingLoginBlocState
                  ? const CircularProgressIndicator()
                  : const Text(
                      "Entrar",
                      style: TextStyle(
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
