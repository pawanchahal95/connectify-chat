import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatapp/Services/Authentication/auth_provider.dart';
import 'package:chatapp/Services/StateManagement/auth_event.dart';
import 'package:chatapp/Services/StateManagement/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateUninitialized()) {
    //send email verification
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });
    //send register
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        await provider.createUser(email: email, password: password);
        await provider.sendEmailVerification();
        emit(const AuthStateNeedsVerification());
      } on Exception catch (e) {
        emit(AuthStateRegistering(e));
      }
    });
    //initialized the firebase
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } else {
        if (!user.isEmailVerified) {
          emit(const AuthStateNeedsVerification());
        } else {
          emit(AuthStateLoggedIn(user));
        }
      }
    });
    //log in

    on<AuthEventLogIn>((event, emit) async {
      emit(const AuthStateLoggedOut(
        exception: null,
        isLoading: true,
      ));
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );
        if (!user.isEmailVerified) {
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
          emit(const AuthStateNeedsVerification());
        } else {
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
          emit(AuthStateLoggedIn(user));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });

    //log out
    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.logOut();
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });

    on<AuthEventShouldRegister>((event, emit) async {
      emit(const AuthStateRegistering(null));
    });
    //forgot password
    //this is new be careful

    on<AuthEventForgotPassword>((event, emit) async {
      emit(const AuthStateForgotPassword(
        exception: null,
        hasSentEmail: false,
        isLoading: true,
      ));

      final email = event.email;
      if (email == null || email.isEmpty) {
        emit(const AuthStateForgotPassword(
          exception: null,
          hasSentEmail: false,
          isLoading: false,
        ));
        return;
      }

      try {
        await provider.forgotPassword(email: email);
        emit(const AuthStateForgotPassword(
          exception: null,
          hasSentEmail: true,
          isLoading: false,
        ));
      } on Exception catch (e) {
        emit(AuthStateForgotPassword(
          exception: e,
          hasSentEmail: false,
          isLoading: false,
        ));
      }
    });

    // Reload user (called periodically or manually)
    on<AuthEventReloadUser>((event, emit) async {
      await provider.reloadUser();

      if (provider.isEmailVerified) {
        add(const AuthEventInitialize()); // re-trigger routing
      }
    });
    //for google login

    on<AuthEventLogInWithGoogle>((event, emit) async {
      try {
        emit(const AuthStateLoggedOut(exception: null, isLoading: true));
        final user = await provider.logInWithGoogle();
        if (user == null) {
          emit(const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ));
        } else if (!user.isEmailVerified) {
          emit(const AuthStateLoggedOut(
              exception: null, isLoading: false)); // 👈 close dialog
          emit(const AuthStateNeedsVerification());
        } else {
          emit(const AuthStateLoggedOut(
              exception: null, isLoading: false)); // 👈 close dialog
          emit(AuthStateLoggedIn(user));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          exception: e,
          isLoading: false,
        ));
      }
    });
  }
}
