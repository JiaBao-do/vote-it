import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart' show immutable;

@immutable
class AuthUser {
  final String id;
  final String email;
  final bool isEmailVerified;
  final String userName;

  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
    required this.userName,
  });

  //use factory to get auth user instance object
  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        email: user.email!,
        isEmailVerified: user.emailVerified,
        userName: 'Anonymous',
      );
}
