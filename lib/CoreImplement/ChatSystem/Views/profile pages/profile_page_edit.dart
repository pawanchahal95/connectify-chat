/*
import 'package:chatapp/Utilities/Dialogs/delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../State Management of Chats/profile_bloc.dart';
import '../../State Management of Chats/profile_event.dart';
import '../../State Management of Chats/profile_state.dart';
import '../../Two person room/user_management.dart';

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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.redAccent,
        title: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'delete') {
                final shouldDelete = await showDeleteDialog(context);
                if (shouldDelete) {
                  // Only delete if user confirmed
                  context.read<ProfileBloc>().add(const DeleteProfileEvent());
                }
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
          if (state is ProfileExistState) {
            Navigator.pop(context); // Navigate back
          }
        },
        child: Builder(
          builder: (context) {
            final state = context.watch<ProfileBloc>().state;

            if (state is ProfileEditState) {
              final user = state.user;
              _initializeControllers(user);

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Profile Avatar
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.redAccent.withOpacity(0.2),
                      child: const Icon(Icons.person, size: 60, color: Colors.redAccent),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Update your profile",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Fields in Card
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildTextField(
                              controller: _usernameController,
                              label: "Username",
                              icon: Icons.person,
                            ),
                            _buildTextField(
                              controller: _dialogController,
                              label: "Dialog Name",
                              icon: Icons.chat,
                            ),
                            _buildTextField(
                              controller: _statusController,
                              label: "Status Message",
                              icon: Icons.info,
                            ),
                            _buildTextField(
                              controller: _phoneController,
                              label: "Phone Number",
                              icon: Icons.phone,
                              keyboardType: TextInputType.phone,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),
                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        onPressed: () {
                          final username = _usernameController.text.trim();
                          final dialogName = _dialogController.text.trim();
                          final phoneNumber = _phoneController.text.trim();
                          final statusMessage = _statusController.text.trim().isEmpty
                              ? "I am new to WeChat"
                              : _statusController.text.trim();

                          if (username.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Username cannot be empty")),
                            );
                            return;
                          }

                          context.read<ProfileBloc>().add(
                            CreateOrUpdateProfileEvent(
                              username: username,
                              dialogName: dialogName,
                              phoneNumber: phoneNumber,
                              statusMessage: statusMessage,
                            ),
                          );
                        },
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.redAccent),
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }
}

*/
import 'package:chatapp/Utilities/Dialogs/delete_dialog.dart';
import 'package:chatapp/Utilities/Dialogs/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../State Management of Chats/profile_bloc.dart';
import '../../State Management of Chats/profile_event.dart';
import '../../State Management of Chats/profile_state.dart';
import '../../Two person room/user_management.dart';

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

  void _onSaveProfilePressed() {
    final username = _usernameController.text.trim();
    final dialogName = _dialogController.text.trim();
    final phoneNumber = _phoneController.text.trim();
    final statusMessage = _statusController.text.trim().isEmpty
        ? "I am new to WeChat"
        : _statusController.text.trim();

    if (username.isEmpty ||
        dialogName.isEmpty ||
        phoneNumber.isEmpty ||
        statusMessage.isEmpty) {
      showErrorDialog(context, "All fields are required. Please fill them in.");
      return;
    }

    context.read<ProfileBloc>().add(
      CreateOrUpdateProfileEvent(
        username: username,
        dialogName: dialogName,
        phoneNumber: phoneNumber,
        statusMessage: statusMessage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceVariant,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          PopupMenuButton<String>(
            iconColor: theme.colorScheme.onPrimary,
            onSelected: (value) async {
              if (value == 'delete') {
                final shouldDelete = await showDeleteDialog(context);
                if (shouldDelete) {
                  context.read<ProfileBloc>().add(const DeleteProfileEvent());
                }
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'delete',
                child: Text(
                  'Delete Profile',
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileExistState) {
            Navigator.pop(context); // Navigate back
          }
        },
        child: Builder(
          builder: (context) {
            final state = context.watch<ProfileBloc>().state;

            if (state is ProfileEditState) {
              final user = state.user;
              _initializeControllers(user);

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor:
                      theme.colorScheme.primary.withOpacity(0.2),
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Update your profile",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildTextField(
                              controller: _usernameController,
                              label: "Username",
                              icon: Icons.person,
                              theme: theme,
                            ),
                            _buildTextField(
                              controller: _dialogController,
                              label: "Dialog Name",
                              icon: Icons.chat,
                              theme: theme,
                            ),
                            _buildTextField(
                              controller: _statusController,
                              label: "Status Message",
                              icon: Icons.info,
                              theme: theme,
                            ),
                            _buildTextField(
                              controller: _phoneController,
                              label: "Phone Number",
                              icon: Icons.phone,
                              keyboardType: TextInputType.phone,
                              theme: theme,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        onPressed: _onSaveProfilePressed,
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required ThemeData theme,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: theme.colorScheme.primary),
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: theme.colorScheme.surface,
        ),
      ),
    );
  }
}

