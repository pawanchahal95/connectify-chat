import 'package:chatapp/CoreImplement/ChatSystem/Services/chat_list_page.dart';
import 'package:chatapp/CoreImplement/ChatSystem/State%20Management%20of%20Chats/profile_bloc.dart';
import 'package:chatapp/CoreImplement/ChatSystem/State%20Management%20of%20Chats/profile_event.dart';
import 'package:chatapp/CoreImplement/ChatSystem/State%20Management%20of%20Chats/profile_state.dart';
import 'package:chatapp/CoreImplement/ChatSystem/Views/chat_screen.dart';
import 'package:chatapp/CoreImplement/ChatSystem/Views/homePage.dart';
import 'package:chatapp/CoreImplement/ChatSystem/Views/list_user.dart';
import 'package:chatapp/CoreImplement/ChatSystem/Views/profile%20pages/profile_page_edit.dart';
import 'package:chatapp/CoreImplement/ChatSystem/Views/profile%20pages/profile_page_error.dart';
import 'package:chatapp/CoreImplement/ChatSystem/Views/profile%20pages/profile_page_view.dart';
import 'package:chatapp/Views/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Two person room/user_management.dart';
import 'profile pages/profile_page_create.dart';
class FancyProfilePage extends StatelessWidget {
  const FancyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (context) => ProfileBloc(FirebaseCloudUser()),
      child: const FancyProfileView(),
    );
  }
}

//view and
class FancyProfileView extends StatefulWidget {
  const FancyProfileView({super.key});

  @override
  State<FancyProfileView> createState() => _FancyProfileViewState();
}

class _FancyProfileViewState extends State<FancyProfileView> {
  @override
  Widget build(BuildContext context) {
    context.read<ProfileBloc>().add(const LoadProfileEvent());

    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      if (state is ProfileLoadingState) {
        return const ElegantLoadingScreen();
      } else if (state is ProfileDeletedState) {
        return const ProfilePageCreate();
      } else if (state is ProfileEditState) {
        return const ProfilePageEdit();
      } else if (state is ProfileCreateState) {
        return const ProfilePageCreate();
      } else if (state is ProfileViewState) {
        return const ProfilePageView();
      } else if (state is ProfileExistState) {
        return const HomePage();
      } else if (state is ProfileErrorState) {
        return const ProfileErrorPage();
      } else {
        return const CircularProgressIndicator();
      }
    });
  }
}
