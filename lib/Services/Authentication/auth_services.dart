
import 'package:chatapp/Services/Authentication/auth_provider.dart';
import 'package:chatapp/Services/Authentication/auth_user.dart';
import 'package:chatapp/Services/Authentication/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser(
          {required String email, required String password}) =>
      provider.createUser(email: email, password: password);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> initialize() =>provider.initialize();

  @override
  Future<AuthUser> logIn({required String email, required String password}) =>
      provider.logIn(email: email, password: password);

  @override
  Future<void> logOut() =>provider.logOut();

  @override
  Future<void> sendEmailVerification() =>provider.sendEmailVerification();

  @override
  Future<void> forgotPassword({required String email}) =>provider.forgotPassword(email: email);

  @override
  // TODO: implement isEmailVerified
  bool get isEmailVerified => provider.isEmailVerified;

  @override
  Future<void> reloadUser() =>provider.reloadUser();

  @override
  Future<AuthUser?> logInWithGoogle() =>provider.logInWithGoogle();


}
