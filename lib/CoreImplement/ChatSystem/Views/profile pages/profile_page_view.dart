import 'package:chatapp/CoreImplement/ChatSystem/State%20Management%20of%20Chats/profile_bloc.dart';
import 'package:chatapp/CoreImplement/ChatSystem/State%20Management%20of%20Chats/profile_event.dart';
import 'package:chatapp/CoreImplement/ChatSystem/State%20Management%20of%20Chats/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePageView extends StatefulWidget {
  const ProfilePageView({super.key});
  @override
  State<ProfilePageView> createState() => _ProfilePageViewState();
}
class _ProfilePageViewState extends State<ProfilePageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Logic Tester')),

      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileExistState) {
            // navigation or toast here later
          }
        },
        child: Builder(
          builder: (context) {
            final state = context.read<ProfileBloc>().state;

            if (state is ProfileViewState) {
              final user = state.user;

              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Username: ${user.userName}"),
                    Text("Dialog: ${user.userDialog}"),
                    Text("Email: ${user.email}"),
                    Text("Status:${user.statusMessage}"),
                    Text("Phone Number:${user.phoneNumber}"),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProfileBloc>().add(const EnterEditEvent());
                      },
                      child: const Text("Edit Profile"),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text("User not loaded yet"));
            }
          },
        ),
      ),
    );
  }
}





