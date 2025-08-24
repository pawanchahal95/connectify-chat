import 'package:chatapp/CoreImplement/ChatSystem/Services/chat_list_page.dart';
import 'package:chatapp/CoreImplement/ChatSystem/Views/list_user.dart';
import 'package:chatapp/CoreImplement/ChatSystem/Views/setting_page.dart';
import 'package:chatapp/Services/StateManagement/auth_bloc.dart';
import 'package:chatapp/Services/StateManagement/auth_event.dart';
import 'package:chatapp/Services/StateManagement/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Utilities/Dialogs/delete_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../Utilities/Dialogs/logout_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedIndex = 0;

  final Set<String> _selectedRooms = {};

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  Future<void> _deleteSelectedRooms() async {
    if (_selectedRooms.isEmpty) return;

    final confirmed = await showDeleteDialog(context);
    if (!confirmed) return;

    final firestore = FirebaseFirestore.instance;
    for (final roomId in _selectedRooms) {
      final msgs = await firestore
          .collection('chatRooms')
          .doc(roomId)
          .collection('messages')
          .get();
      for (var msg in msgs.docs) await msg.reference.delete();
      await firestore.collection('chatRooms').doc(roomId).delete();
    }

    setState(() => _selectedRooms.clear());

    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Selected chats deleted',
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.colorScheme.onPrimary),
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = _auth.currentUser;
    final currentUserId = currentUser?.uid ?? '';

    final List<Widget> _pages = [
      ChatListPage(
        currentUserId: currentUserId,
        selectedRooms: _selectedRooms,
        onSelectionChanged: (updated) {
          setState(() {
            _selectedRooms.clear();
            _selectedRooms.addAll(updated);
          });
        },
      ),
      const AllUsersPage(),
      const SettingsPage(),
    ];

    // Theme-based gradient for AppBar and BottomNavigationBar
    final gradientColors = [
      theme.colorScheme.primary,
      theme.colorScheme.primaryContainer,
    ];

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateLoggedOut) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/login', (route) => false);
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.3),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedRooms.isEmpty
                          ? "ChatVault"
                          : "${_selectedRooms.length} selected",
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(color: theme.colorScheme.onPrimary),
                    ),
                    Row(
                      children: [
                        if (_selectedRooms.isNotEmpty)
                          IconButton(
                            icon: Icon(Icons.delete, color: theme.colorScheme.onPrimary),
                            tooltip: 'Delete selected chats',
                            onPressed: _deleteSelectedRooms,
                          ),
                        IconButton(
                          icon: Icon(Icons.logout, color: theme.colorScheme.onPrimary),
                          tooltip: 'Log out',
                          onPressed: () async {
                            final shouldLogout = await showLogOutDialog(context);
                            if (shouldLogout) {
                              context
                                  .read<AuthBloc>()
                                  .add(const AuthEventLogOut());
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors.reversed.toList(),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.3),
                blurRadius: 5,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: theme.colorScheme.secondary,
            unselectedItemColor: theme.colorScheme.onBackground.withOpacity(0.7),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline),
                label: "Chats",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_alt_outlined),
                label: "Contacts",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "Settings",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
