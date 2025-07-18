import 'package:flutter/material.dart' show immutable;

@immutable
abstract class AuthEvent{
  const AuthEvent();
}
class AuthEventInitialize extends AuthEvent{
  const AuthEventInitialize();
}
class AuthEventLogIn extends AuthEvent{
  final String email;
  final String password;
  const AuthEventLogIn(this.email,this.password);
}

class AuthEventRegister extends AuthEvent{
  final String email;
  final String password;
  const AuthEventRegister(this.email, this.password);
}
class AuthEventShouldRegister extends AuthEvent{
  const AuthEventShouldRegister();
}
class AuthEventSendEmailVerification extends AuthEvent{
  const AuthEventSendEmailVerification();
}


class AuthEventLogOut extends AuthEvent{
  const AuthEventLogOut();
}
//new class can have problems
class AuthEventForgotPassword extends AuthEvent {
  final String email;
//this is new be careful
  const AuthEventForgotPassword({required this.email});
}
//new one not sure
class AuthEventReloadUser extends AuthEvent {
  const AuthEventReloadUser();
}

//google login
class AuthEventLogInWithGoogle extends AuthEvent {
  const AuthEventLogInWithGoogle();
}

