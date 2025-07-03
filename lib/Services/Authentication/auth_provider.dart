import 'package:chatapp/Services/Authentication/auth_user.dart';

abstract class AuthProvider{
  Future<void>initialize();
  AuthUser? get currentUser;
  Future<AuthUser>logIn({
    required String email,
    required String password,
});
  Future<AuthUser>createUser({
    required String email,
    required String password,
  });
  Future<void>forgotPassword({
    required String email,
});
  Future<void> logOut();

  Future<void> sendEmailVerification();
  Future<void> reloadUser();
  bool get isEmailVerified;

  //for google auth provider
  Future<AuthUser?> logInWithGoogle();


}