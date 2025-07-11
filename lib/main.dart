import 'package:chatapp/CoreImplement/ChatSystem/Views/profile_page.dart';
import 'package:chatapp/Services/Authentication/firebase_auth_provider.dart';
import 'package:chatapp/Services/StateManagement/auth_bloc.dart';
import 'package:chatapp/Services/StateManagement/auth_event.dart';
import 'package:chatapp/Services/StateManagement/auth_state.dart';
import 'package:chatapp/Themes/forget_password_view_themes.dart';
import 'package:chatapp/Views/emai_verification_page.dart';
import 'package:chatapp/Views/forgot_password.dart';
import 'package:chatapp/Views/home_page.dart';
import 'package:chatapp/Views/loading_view.dart';
import 'package:chatapp/Views/login_page.dart';
import 'package:chatapp/Views/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';


void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    theme: oceanAuroraTheme,
    home: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: const Manage(),
    ),
  ));
}

class Manage extends StatefulWidget {
  const Manage({super.key});

  @override
  State<Manage> createState() => _HomePageState();
}

class _HomePageState extends State<Manage> {
  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());

    return BlocBuilder<AuthBloc,AuthState>(builder: (context, state) {
      if (state is AuthStateLoggedIn) {
        //temporary changes
        return const FancyProfilePage ( );
        //return const UserManagementPage();
      } else if (state is AuthStateNeedsVerification) {
        return const EmailVerificationPage();
      } else if (state is AuthStateLoggedOut) {
        return const LoginPage();
      }
      else if(state is AuthStateRegistering){
        return const SignUpPage();
      }
      else if(state is AuthStateForgotPassword){
        return const ForgotPassword();
      }
      else if(state is AuthStateUninitialized) {
        return const ElegantLoadingScreen();
      }
      else{
        return const ElegantLoadingScreen();
      }
    });
  }
}
