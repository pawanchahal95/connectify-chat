import 'package:chatapp/Services/Authentication/auth_exception.dart';
import 'package:chatapp/Services/StateManagement/auth_bloc.dart';
import 'package:chatapp/Services/StateManagement/auth_event.dart';
import 'package:chatapp/Services/StateManagement/auth_state.dart';
import 'package:chatapp/Utilities/Dialogs/error_dialog.dart';
import 'package:chatapp/Utilities/Dialogs/loading_dialog.dart';
import 'package:chatapp/Views/register_page.dart';
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
      if (state is AuthStateLoggedOut) {
        final closeDialog = _closeDialogHandle;
        if (!state.isLoading && closeDialog != null) {
          closeDialog();
          _closeDialogHandle = null;
        } else if (state.isLoading && closeDialog == null) {
          _closeDialogHandle = showLoadingDialog(
              context: context,
              text: 'Loading'
          );
        }
        if (state.exception is UserNotFoundAuthException) {
          await showErrorDialog(context, 'User not found');
        } else if (state.exception is WrongPasswordAuthException) {
          await showErrorDialog(context, 'Wrong credentials');
        } else if (state.exception is GenericAuthException) {
          await showErrorDialog(context, 'Authentication error');
        }
      }
    },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child: Image.asset(
                      'assets/images/face.png',
                      height: 300,
                      width: 300, // Ensure the image covers the entire area
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          "Getting Started",
                          style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Welcome back glad to see you again",
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "E-mail",
                        style: TextStyle(fontSize: 20, color: Colors.black87),
                      ),

                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _email,
                        // Specifies the input type as email
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(
                            color: Colors.black87,
                          ),
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                          labelText: 'Email',
                          // Label for the field
                          hintText: 'Enter your email',
                          // Placeholder text
                          prefixIcon: const Icon(Icons.email),
                          // Adds an email icon to the left
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            // Rounded corners
                            borderSide: const BorderSide(
                              color: Colors.grey, // Border color
                              width: 1.5, // Border width
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: Colors.green, // Border color when focused
                              width: 2.0, // Border width when focused
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              // Border color when not focused
                              width: 1.5, // Border width when not focused
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              // Border color when there's an error
                              width: 1.5,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              // Border color when focused and error is present
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        "Password",
                        style: TextStyle(fontSize: 20, color: Colors.black87),
                      ),
                      TextField(
                        obscureText: _obscureText,
                        controller: _password,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: Colors.green,
                              // Change the color to something more visible
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: Colors.grey, // Standard border color
                              width: 1.5,
                            ),
                          ),
                          labelStyle: const TextStyle(
                            color: Colors
                                .black87, // Keep the label color visible
                          ),
                          hintStyle: const TextStyle(
                            color: Colors.grey, // Keep the hint text visible
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  rememberMe = newValue!;
                                });
                              },
                            ),
                            const Text("Remember me")
                          ],
                        ),
                      ),
                      //problem,error,mistake,here in async
                      TextButton(
                          onPressed: () {
                            {
                              final email = _email.text;
                              context.read<AuthBloc>().add(
                                AuthEventForgotPassword(email: email),
                              );
                            }
                          },
                          child: const Text(
                            "Forgot Password ?",
                            style: TextStyle(color: Colors.green),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final email = _email.text;
                            final password = _password.text;
                            print(
                                "🔁 Dispatching AuthEventLogIn with: $email"); // ADD THIS
                            context.read<AuthBloc>().add(
                              AuthEventLogIn(
                                email,
                                password,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              side: const BorderSide(
                                color: Colors.green,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              )),
                          child: const Text(
                            "Sign In",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Row(
                          children: [
                            Expanded(child: Divider()),
                            // The line itself, taking up available space
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'or continue with',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(child: Divider()),
                            // The line on the other side
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          //google input
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white70,
                              side: const BorderSide(
                                color: Colors.white70,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              )),
                          child: Row(
                            // Centers the Row's content
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/google.png',
                                height: 24,
                                width: 24,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              const Text(
                                "Sign in with Google",
                                style:
                                TextStyle(color: Colors.black87, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            //facebook login
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white70,
                                side: const BorderSide(
                                  color: Colors.white70,
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // Centers the Row's content
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/images/facebook.png',
                                  height: 24,
                                  width: 24,
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                const Text(
                                  "Sign in with Facebook",
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ,

    );
  }
}