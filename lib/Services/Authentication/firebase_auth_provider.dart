import 'package:chatapp/Services/Authentication/auth_exception.dart';
import 'package:chatapp/Services/Authentication/auth_user.dart';
import 'package:chatapp/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, FirebaseAuthException, GoogleAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:chatapp/Services/Authentication/auth_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) async {
    // TODO: implement createUser
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    }
    on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    }
    catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<AuthUser> logIn(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
      final user=currentUser;
      if(user!=null){
        return user;
      }else{
        throw UserNotLoggedInAuthException();
      }
    }
    on FirebaseAuthException catch(e){
      switch (e.code) {
        case 'invalid-email':
          throw InvalidEmailAuthException();
        case 'user-disabled':
          throw UserDisabledAuthException();
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          throw WrongPasswordAuthException(); // Handle generically
        case 'too-many-requests':
          throw TooManyRequestsAuthException();
        case 'network-request-failed':
          throw NetworkRequestFailedException();
        default:
          throw GenericAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }
//logout from the current session
  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }
//send email verification
  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null&&!user.emailVerified) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }
//sending forgot password mail
  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
          throw EmailNotFoundAuthException();
        case 'invalid-email':
          throw InvalidEmailAuthException();
        case 'too-many-requests':
          throw TooManyRequestsAuthException();
        case 'network-request-failed':
          throw NetworkRequestFailedException();
        case 'user-disabled':
          throw UserDisabledAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }

//for email verification checking and reloading at times
  @override
  // TODO: implement isEmailVerified
  bool get isEmailVerified{
   final user=FirebaseAuth.instance.currentUser;
   return user?.emailVerified??false;
  }

  @override
  Future<void> reloadUser() async{
    await FirebaseAuth.instance.currentUser?.reload();
      }


      //for google auth provider
  @override
  Future<AuthUser?> logInWithGoogle() async {
    await GoogleSignIn().signOut(); // This clears the last-used account
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    final user = userCredential.user;

    if (user == null) throw Exception('Google sign-in failed');
    return AuthUser.fromFirebase(user);
  }

}
