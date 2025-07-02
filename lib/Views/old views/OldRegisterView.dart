import 'package:chatapp/Services/Authentication/auth_exception.dart';
import 'package:chatapp/Services/StateManagement/auth_bloc.dart';
import 'package:chatapp/Services/StateManagement/auth_event.dart';
import 'package:chatapp/Services/StateManagement/auth_state.dart';
import 'package:chatapp/Utilities/Dialogs/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;
  String? _errorText;
  bool _isError = false;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();

    //not me
    _confirmPassword.addListener(_validatePasswords);
    _password.addListener(_validatePasswords);

    super.initState();
  }

  void _validatePasswords() {
    final password = _password.text;
    final confirm = _confirmPassword.text;

    if (confirm.length >= password.length) {
      setState(() {
        if (confirm != password) {
          _errorText = 'Passwords do not match';
          _isError = true;
        } else {
          _errorText = null;
          _isError = false;
        }
      });
    } else {
      setState(() {
        _errorText = null;
        _isError = false;
      });
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();

    super.dispose();
  }

  bool agreeToTerms = false;
  bool _obscurePassword = true; // For password visibility toggle
  bool _obscureConfirmPassword = true; // For confirm password visibility toggle

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthStateRegistering) {
            if (state.exception is WeakPasswordAuthException) {
              await showErrorDialog(context, 'Weak Password');
            } else if (state.exception is EmailAlreadyInUseAuthException) {
              await showErrorDialog(context, 'Email Already in use');
            } else if (state.exception is GenericAuthException) {
              await showErrorDialog(context, 'Failed to Register');
            } else if (state.exception is InvalidEmailAuthException) {
              await showErrorDialog(context, 'Invalid email');
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
                      width: 300,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          "Create an Account",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Please fill in the details to sign up",
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
                        controller: _email,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email),
                          labelText: 'Enter Your Email',
                          hintText: 'Enter your email address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.green,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.5,
                            ),
                          ),
                          labelStyle: const TextStyle(
                            color: Colors.black87,
                          ),
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Password",
                        style: TextStyle(fontSize: 20, color: Colors.black87),
                      ),
                      TextField(
                        controller: _password,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Enter Your Password',
                          prefixIcon: const Icon(Icons.lock),
                          hintText: 'Password must be at least 8 characters',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.green,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.5,
                            ),
                          ),
                          labelStyle: const TextStyle(
                            color: Colors.black87,
                          ),
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Confirm Password",
                        style: TextStyle(fontSize: 20, color: Colors.black87),
                      ),
                      TextField(
                        controller: _confirmPassword,
                        obscureText: _obscureConfirmPassword,
                        style: TextStyle(
                            color: _isError ? Colors.red : Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Confirm Your Password',
                          hintText: 'Re-enter your password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.green,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.5,
                            ),
                          ),
                          labelStyle: const TextStyle(
                            color: Colors.black87,
                          ),
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: agreeToTerms,
                        onChanged: (bool? newValue) {
                          setState(() {
                            agreeToTerms = newValue ?? false;
                          });
                        },
                      ),
                      const Text('Agree to Terms and Conditions'),
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

                            // Only proceed if there's no error and user agreed to terms
                            if (!_isError && agreeToTerms) {
                              context.read<AuthBloc>().add(AuthEventRegister(email, password));
                            } else {
                              // Optional: give feedback (e.g., toast/snackbar)
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    !_isError
                                        ? 'Please agree to the terms and conditions.'
                                        : 'Please fix the errors before signing up.',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Row(
                          children: [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'or continue with',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
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
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset('assets/images/google.png',
                                  height: 24, width: 24),
                              const SizedBox(width: 15),
                              const Text(
                                "Sign up with Google",
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 16),
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
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset('assets/images/facebook.png',
                                    height: 24, width: 24),
                                const SizedBox(width: 15),
                                const Text(
                                  "Sign up with Facebook",
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
                          const Text("Already have an account?"),
                          TextButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(const AuthEventLogOut());
                            },
                            child: const Text("Log in here"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
