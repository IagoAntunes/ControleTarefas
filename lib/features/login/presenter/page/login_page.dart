import 'package:flutter/material.dart';
import '../components/form_login_component.dart';
import '../components/head_login_component.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  HeadLogin(),
                  SizedBox(height: 32),
                  FormLogin(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
