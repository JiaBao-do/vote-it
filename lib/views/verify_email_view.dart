import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voteit/services/auth/bloc/auth_bloc.dart';
import 'package:voteit/services/auth/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Column(
        children: [
          const Text(
              'An verification email has been sent. Please click the link to verify account. '),
          const Text('Did not received a verification email yet?'),
          const Text('Press the button below and try again'),
          TextButton(
            onPressed: () {
              context
                  .read<AuthBloc>()
                  .add(const AuthEventSendEmailVerification());
            },
            child: const Text('Send email verification'),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(const AuthEventLogOut());
            },
            child: const Text('Go to Login.'),
          )
        ],
      ),
    );
  }
}
