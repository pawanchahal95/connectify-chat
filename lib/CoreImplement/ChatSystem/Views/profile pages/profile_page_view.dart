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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background, // 👈 from theme
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary, // 👈 from theme
        title: Text(
          'Profile',
          style: TextStyle(
            color: theme.colorScheme.onPrimary, // 👈 ensures contrast
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
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

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile avatar
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                      child: Text(
                        user.userName.isNotEmpty
                            ? user.userName[0].toUpperCase()
                            : "?",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Profile details card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            _buildInfoRow(theme, Icons.person, "Username", user.userName),
                            const Divider(),
                            _buildInfoRow(theme, Icons.chat_bubble, "Dialog", user.userDialog),
                            const Divider(),
                            _buildInfoRow(theme, Icons.email, "Email", user.email),
                            const Divider(),
                            _buildInfoRow(theme, Icons.info_outline, "Status",
                                user.statusMessage ?? "I am new to WeChat"),
                            const Divider(),
                            _buildInfoRow(theme, Icons.phone, "Phone", user.phoneNumber ?? "N/A"),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Edit button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.read<ProfileBloc>().add(const EnterEditEvent());
                        },
                        icon: Icon(Icons.edit, color: theme.colorScheme.onPrimary),
                        label: Text(
                          "Edit Profile",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary, // 👈 themed
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      ThemeData theme,
      IconData icon,
      String label,
      String value,
      ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: theme.colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  color: theme.colorScheme.onBackground.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
