import 'package:chatapp/Services/Authentication/auth_exception.dart';
import 'package:chatapp/Services/StateManagement/auth_bloc.dart';
import 'package:chatapp/Services/StateManagement/auth_event.dart';
import 'package:chatapp/Services/StateManagement/auth_state.dart';
import 'package:chatapp/Utilities/Dialogs/error_dialog.dart';
import 'package:chatapp/Utilities/Dialogs/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  CloseDialog? _closeDialogHandle;
  bool rememberMe = false;
  bool _obscureText = true;

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
    return BlocListener<AuthBloc, AuthState>(listener: (context, state) async {
      final closeDialog = _closeDialogHandle;
      if (state is AuthStateLoggedIn && _closeDialogHandle != null) {
        _closeDialogHandle!();
        _closeDialogHandle = null;
      }
      if (state is AuthStateLoggedOut) {
        if (!state.isLoading && closeDialog != null) {
          closeDialog();
          _closeDialogHandle = null;
        } else if (state.isLoading && closeDialog == null) {
          _closeDialogHandle = showLoadingDialog(
              context: context,
              text: 'Loading'
          );
        }
        if (state.exception is InvalidEmailAuthException) {
          await showErrorDialog(context, 'Invalid email');
        } else if (state.exception is WrongPasswordAuthException) {
          await showErrorDialog(context, 'Wrong credentials');
        }
        else if (state.exception is TooManyRequestsAuthException) {
          await showErrorDialog(context, 'Too many attempts. Try again later.');
        }
        else if (state.exception is NetworkRequestFailedException) {
          await showErrorDialog(context, 'Please check your internet connection');
        }
        else if (state.exception is UserDisabledAuthException) {
          await showErrorDialog(context, 'This account has been disabled.');
        }else if (state.exception is GenericAuthException) {
          await showErrorDialog(context, 'Authentication error');
        }
      }
    },
    child: Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE3F2FD), // Light Blue
              Color(0xFFFCE4EC), // Soft Pink
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/face.png',
                  height: 220,
                  width: 220,
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Getting Started",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const Center(
                child: Text(
                  "Welcome back, glad to see you again",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Email Field
              const Text(
                "E-mail",
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 6),
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: _email,
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  prefixIcon: const Icon(Icons.email),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Password Field
              const Text(
                "Password",
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _password,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  hintText: "Enter your password",
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    onChanged: (bool? newValue) {
                      setState(() {
                        rememberMe = newValue!;
                      });
                    },
                  ),
                  const Text("Remember me"),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      final email = _email.text;
                      context.read<AuthBloc>().add(
                        AuthEventForgotPassword(email: email),
                      );
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Sign In Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    final email = _email.text;
                    final password = _password.text;
                    context.read<AuthBloc>().add(
                      AuthEventLogIn(email, password),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    "Sign In",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text("or continue with"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 20),

              // Google Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child:
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthEventLogInWithGoogle());
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/google.png',
                        height: 24,
                        width: 24,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Sign in with Google",
                        style: TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Facebook Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child:
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/facebook.png',
                        height: 24,
                        width: 24,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Sign in with Facebook",
                        style: TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        const AuthEventShouldRegister(),
                      );
                    },
                    child: const Text("Sign up here"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}