import 'package:chatapp/Services/StateManagement/auth_bloc.dart';
import 'package:chatapp/Services/StateManagement/auth_event.dart';
import 'package:chatapp/Utilities/Dialogs/logout_dialog.dart';
import 'package:chatapp/Utilities/Dialogs/error_dialog.dart'; // <-- import your error dialog
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../State Management of Chats/profile_bloc.dart';
import '../../State Management of Chats/profile_event.dart';
import '../../State Management of Chats/profile_state.dart';
import '../../Two person room/user_management.dart';

class ProfilePageCreate extends StatefulWidget {
  const ProfilePageCreate({super.key});
  @override
  State<ProfilePageCreate> createState() => _ProfilePageCreateState();
}

class _ProfilePageCreateState extends State<ProfilePageCreate> {
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

  void _onCreateProfilePressed() {
    final username = _usernameController.text.trim();
    final dialog = _dialogController.text.trim();
    final status = _statusController.text.trim();
    final phone = _phoneController.text.trim();

    if (username.isEmpty || dialog.isEmpty || status.isEmpty || phone.isEmpty) {
      showErrorDialog(context, "All fields are required. Please fill them in.");
      return;
    }

    context.read<ProfileBloc>().add(
      CreateOrUpdateProfileEvent(
        username: username,
        dialogName: dialog,
        phoneNumber: phone,
        statusMessage: status,
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
          'Create Profile',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          PopupMenuButton<String>(
            iconColor: theme.colorScheme.onPrimary,
            onSelected: (value) async {
              if (value == 'Logout') {
                final shouldLogout = await showLogOutDialog(context);
                if (shouldLogout) {
                  context.read<AuthBloc>().add(AuthEventLogOut());
                }
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'Logout',
                child: Text(
                  'Logout User',
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
            Navigator.pop(context);
          }
        },
        child: Builder(
          builder: (context) {
            final state = context.watch<ProfileBloc>().state;

            if (state is ProfileCreateState) {
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
                      "Create your profile",
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
                        onPressed: _onCreateProfilePressed,
                        child: const Text(
                          'Create Profile',
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
              return const Center(child: Text("User not in create mode"));
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
