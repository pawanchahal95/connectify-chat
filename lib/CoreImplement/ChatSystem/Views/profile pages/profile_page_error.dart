import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../State Management of Chats/profile_bloc.dart';
import '../../State Management of Chats/profile_state.dart';

class ProfileErrorPage extends StatefulWidget {
  const ProfileErrorPage({super.key});

  @override
  State<ProfileErrorPage> createState() => _ProfileErrorPageState();
}
class _ProfileErrorPageState extends State<ProfileErrorPage> {
  @override
  Widget build(BuildContext context) {
    final state = context.read<ProfileBloc>().state;

    String errorMessage = 'Unknown error occurred.';
    if (state is ProfileErrorState) {
      errorMessage = state.message;
    }

    return  Scaffold(
      body: Center(
        child: Container(
          child: Text(errorMessage),
        ),
      ),
    );
  }
}