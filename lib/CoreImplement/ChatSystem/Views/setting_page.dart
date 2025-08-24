import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Themes/theme_selector_page.dart';
import '../State Management of Chats/profile_bloc.dart';
import '../State Management of Chats/profile_event.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Theme aware

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
        titleTextStyle: theme.textTheme.headlineSmall,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              const SizedBox(height: 10),

              // Themes Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  leading: Icon(Icons.palette, color: theme.colorScheme.primary, size: 28),
                  title: Text('Themes', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ThemeSelectorPage(),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              // Profile Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  leading: Icon(Icons.person, color: theme.colorScheme.primary, size: 28),
                  title: Text('Profile', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                  onTap: () {
                    context.read<ProfileBloc>().add(const ProfileViewEvent());
                  },
                ),
              ),

              const SizedBox(height: 12),

              // Example: About Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  leading: Icon(Icons.info, color: theme.colorScheme.primary, size: 28),
                  title: Text('About', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                  onTap: () {
                    // Navigate to About Page or show dialog
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
