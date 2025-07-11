import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../Authentication/auth_user.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized();
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;

  const AuthStateRegistering(this.exception);
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}

//new state can have problems
class AuthStateForgotPassword extends AuthState {
  final Exception? exception;
  final bool hasSentEmail;
  final bool isLoading;

  const AuthStateForgotPassword({
    required this.exception,
    required this.hasSentEmail,
    required this.isLoading,
  });
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  final bool isLoading;

  const AuthStateLoggedOut({
    required this.exception,
    required this.isLoading,
  });

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}


