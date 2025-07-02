import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Services/Authentication/auth_exception.dart';
import '../Services/StateManagement/auth_bloc.dart';
import '../Services/StateManagement/auth_event.dart';
import '../Services/StateManagement/auth_state.dart';
import '../Utilities/Dialogs/error_dialog.dart';
import '../Utilities/Dialogs/show_success_dialog.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _emailController;
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  bool emailSent = false;

  @override
  void initState() {
    _emailController = TextEditingController();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail && state.exception == null) {
            _emailController.clear();
            setState(() => emailSent = true);
            await showSuccessDialog(
              context,
              "Password reset email sent.\nYou'll be redirected to login shortly.",
            );
            Future.delayed(const Duration(seconds: 30), () {
              context.read<AuthBloc>().add(const AuthEventLogOut());
            });
          }

          final exception = state.exception;
          if (exception != null) {
            if (exception is InvalidEmailAuthException) {
              await showErrorDialog(context, 'Invalid email address.');
            } else if (exception is EmailNotFoundAuthException) {
              await showErrorDialog(context, 'User not found.');
            } else if (exception is TooManyRequestsAuthException) {
              await showErrorDialog(context, 'Too many attempts. Try again later.');
            } else if (exception is NetworkRequestFailedException) {
              await showErrorDialog(context, 'Please check your internet connection.');
            } else {
              await showErrorDialog(context, 'We could not process your request.');
            }
          }
        }
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        resizeToAvoidBottomInset: true,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primaryContainer,
                theme.colorScheme.tertiaryContainer,
                theme.colorScheme.surfaceVariant,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 60, bottom: 24),
              child: Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
                          constraints: const BoxConstraints(maxWidth: 400),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: theme.dividerColor.withOpacity(0.3),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: theme.shadowColor.withOpacity(0.15),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.lock_reset,
                                  size: 64, color: theme.colorScheme.primary),
                              const SizedBox(height: 18),
                              Text(
                                "Forgot Password",
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Enter your email and we’ll send you a reset link.",
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 28),
                              TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(color: theme.colorScheme.onSurface),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: theme.colorScheme.surface,
                                  hintText: 'Email Address',
                                  hintStyle: TextStyle(color: theme.hintColor),
                                  prefixIcon: Icon(Icons.email_outlined, color: theme.hintColor),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 22),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    final email = _emailController.text.trim();
                                    context.read<AuthBloc>().add(
                                      AuthEventForgotPassword(email: email),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.colorScheme.primary,
                                    foregroundColor: theme.colorScheme.onPrimary,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    elevation: 4,
                                  ),
                                  child: const Text(
                                    "Send Reset Link",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 26),
                              Column(
                                children: [
                                  if (emailSent) ...[
                                    Icon(Icons.mark_email_read_outlined,
                                        size: 34, color: theme.colorScheme.secondary),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Reset link sent! Check your inbox.",
                                      style: TextStyle(color: theme.colorScheme.onSurface),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                  TextButton(
                                    onPressed: () {
                                      context.read<AuthBloc>().add(const AuthEventLogOut());
                                    },
                                    child: Text(
                                      "Return to Login",
                                      style: TextStyle(
                                        color: theme.colorScheme.error,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
