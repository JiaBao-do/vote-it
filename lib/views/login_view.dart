import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voteit/services/auth/auth_exceptions.dart';
import 'package:voteit/services/auth/bloc/auth_bloc.dart';
import 'package:voteit/services/auth/bloc/auth_event.dart';
import 'package:voteit/services/auth/bloc/auth_state.dart';
import 'package:voteit/utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  //use text editing controller to manage the changes input field
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
                context, 'Cannot find a user with the entered credentials!');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Wrong Credentials!');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication Error!');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Column(children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter your Email',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            decoration: const InputDecoration(
              hintText: 'Enter your Password',
            ),
          ),
          TextButton(
            onPressed: () {
              final email = _email.text;
              final password = _password.text;

              context.read<AuthBloc>().add(
                    AuthEventLogIn(
                      email,
                      password,
                    ),
                  );
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(const AuthEventShouldRegister());
            },
            child: const Text('Not registered yet? Register here!'),
          )
        ]),
      ),
    );
  }
}
