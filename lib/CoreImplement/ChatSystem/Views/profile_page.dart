
import 'package:chatapp/CoreImplement/ChatSystem/State%20Management%20of%20Chats/profile_bloc.dart';
import 'package:chatapp/CoreImplement/ChatSystem/State%20Management%20of%20Chats/profile_event.dart';
import 'package:chatapp/CoreImplement/ChatSystem/State%20Management%20of%20Chats/profile_state.dart';
import 'package:chatapp/CoreImplement/ChatSystem/Views/homePage.dart';
import 'package:chatapp/CoreImplement/ChatSystem/Views/profile_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Two person room/user_management.dart';

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
    context.read<ProfileBloc>().add(const LoadProfile());

    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      if (state is ProfileLoading) {
      return  const  ProfileLoadingPage();
      } else if (state is ProfileDeleted) {
        return  const  ProfilePageEdit();
      } else if (state is ProfileEditMode) {
        return  const  ProfilePageEdit();
      } else if(state is ProfileViewMode){
        return const ProfilePageView();
      } else if (state is ProfileExist) {
        return const HomePage();
      } else {
        return const CircularProgressIndicator();
      }
    });
  }
}
