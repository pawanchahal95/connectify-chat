import 'package:chatapp/CoreImplement/ChatSystem/State%20Management%20of%20Chats/profile_bloc.dart';
import 'package:chatapp/CoreImplement/ChatSystem/State%20Management%20of%20Chats/profile_event.dart';
import 'package:chatapp/CoreImplement/ChatSystem/State%20Management%20of%20Chats/profile_state.dart';
import 'package:chatapp/CoreImplement/ChatSystem/Two%20person%20room/user_management.dart';
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
          if (state is ProfileExist) {
            // navigation or toast here later
          }
        },
        child: Builder(
          builder: (context) {
            final state = context.read<ProfileBloc>().state;

            if (state is ProfileViewMode) {
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
                        context.read<ProfileBloc>().add(const EnterEditMode());
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

/*class ProfilePageEdit extends StatefulWidget {
  const ProfilePageEdit({super.key});

  @override
  State<ProfilePageEdit> createState() => _ProfilePageEditState();
}
class _ProfilePageEditState extends State<ProfilePageEdit> {
  late final TextEditingController _usernameController;
  late final TextEditingController _dialogController;
  late final TextEditingController _statusController;
  late final TextEditingController _phoneController;

  @override
  void initState(){
    super.initState();
    final state = context.read<ProfileBloc>().state;
    if (state is ProfileEditMode && state.user != null) {
      final user = state.user!;
      _usernameController = TextEditingController(text: user.userName);
      _dialogController = TextEditingController(text: user.userDialog);
      _statusController = TextEditingController(text: user.statusMessage ?? '');
      _phoneController = TextEditingController(text: user.phoneNumber ?? '');
    } else {
      throw Exception('ProfileEditPage must be opened in ProfileEditMode state');
    }
  }
  @override
  void dispose() {
    _usernameController.dispose();
    _dialogController.dispose();
    _statusController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Logic Tester'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                // Trigger delete event here
                context.read<ProfileBloc>().add(const DeleteProfile());
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Delete Profile'),
              ),
            ],
          ),
        ],
      ),

      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileExist) {
            // navigation or toast here later
          }
        },
        child: Builder(
          builder: (context) {
            final state = context.read<ProfileBloc>().state;

            if (state is ProfileEditMode) {
              final user = state.user;
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                    ),
                    TextField(
                      controller: _dialogController,
                      decoration: const InputDecoration(labelText: 'Dialog Name'),
                    ),
                    TextField(
                      controller: _statusController,
                      decoration: const InputDecoration(labelText: 'Status Message'),
                    ),
                    TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: 'Phone Number'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed:(){
                        context.read<ProfileBloc>().add(
                          CreateOrUpdateProfile(
                            username: _usernameController.text.trim(),
                            dialogName: _dialogController.text.trim(),
                            phoneNumber: _phoneController.text.trim(),
                            statusMessage: _statusController.text.trim(),
                          ),
                        );
                      },
                      child: const Text('Save'),
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
}*/

class ProfilePageEdit extends StatefulWidget {
  const ProfilePageEdit({super.key});

  @override
  State<ProfilePageEdit> createState() => _ProfilePageEditState();
}

class _ProfilePageEditState extends State<ProfilePageEdit> {
  late final TextEditingController _usernameController;
  late final TextEditingController _dialogController;
  late final TextEditingController _statusController;
  late final TextEditingController _phoneController;
  bool _initialized = false;

  void _initializeControllers(CloudUser? user) {
    if (_initialized) return;

    _usernameController = TextEditingController(text: user?.userName ?? '');
    _dialogController = TextEditingController(text: user?.userDialog ?? '');
    _statusController = TextEditingController(text: user?.statusMessage ?? '');
    _phoneController = TextEditingController(text: user?.phoneNumber ?? '');
    _initialized = true;
  }

  @override
  void dispose() {
    if (_initialized) {
      _usernameController.dispose();
      _dialogController.dispose();
      _statusController.dispose();
      _phoneController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                context.read<ProfileBloc>().add(const DeleteProfile());
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Delete Profile'),
              ),
            ],
          ),
        ],
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileExist) {
            Navigator.pop(context); // Navigate back
          }
        },
        child: Builder(
          builder: (context) {
            final state = context.watch<ProfileBloc>().state;

            if (state is ProfileEditMode) {
              final user = state.user;
              _initializeControllers(user); // handle null safely

              return Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (user == null)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text("New user. Please fill in your details."),
                        ),
                      TextField(
                        controller: _usernameController,
                        decoration: const InputDecoration(labelText: 'Username'),
                      ),
                      TextField(
                        controller: _dialogController,
                        decoration: const InputDecoration(labelText: 'Dialog Name'),
                      ),
                      TextField(
                        controller: _statusController,
                        decoration: const InputDecoration(labelText: 'Status Message'),
                      ),
                      TextField(
                        controller: _phoneController,
                        decoration: const InputDecoration(labelText: 'Phone Number'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ProfileBloc>().add(
                            CreateOrUpdateProfile(
                              username: _usernameController.text.trim(),
                              dialogName: _dialogController.text.trim(),
                              phoneNumber: _phoneController.text.trim(),
                              statusMessage: _statusController.text.trim(),
                            ),
                          );
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: Text("User not in edit mode"));
            }
          },
        ),
      ),
    );
  }
}


class ProfileNextPage extends StatefulWidget {
  const ProfileNextPage({super.key});

  @override
  State<ProfileNextPage> createState() => _ProfileNextPageState();
}
class _ProfileNextPageState extends State<ProfileNextPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Container(
          child: Text("Main page"),
        ),
      ),
    );
  }
}

class ProfileLoadingPage extends StatefulWidget {
  const ProfileLoadingPage({super.key});

  @override
  State<ProfileLoadingPage> createState() => _ProfileLoadingPageState();
}
class _ProfileLoadingPageState extends State<ProfileLoadingPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Container(
          child: Text("Profile Loading page"),
        ),
      ),
    );
  }
}

