import 'package:chatapp/CoreImplement/ChatSystem/Services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chat_page.dart';

class AllUsersPage extends StatefulWidget {
  const AllUsersPage({super.key});

  @override
  State<AllUsersPage> createState() => _AllUsersPageState();
}

class _AllUsersPageState extends State<AllUsersPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<List<Color>> generateGradients(ThemeData theme) {
    final colors = [
      theme.colorScheme.primary,
      theme.colorScheme.primaryContainer,
      theme.colorScheme.secondary,
      theme.colorScheme.secondaryContainer,
      theme.colorScheme.tertiary ?? theme.colorScheme.secondary,
      theme.colorScheme.tertiaryContainer ?? theme.colorScheme.secondaryContainer,
    ];

    return List.generate(colors.length - 1, (i) => [colors[i], colors[i + 1]]);
  }

  Widget _buildUserTile(Map<String, dynamic> data, List<Color> gradientColors, ThemeData theme) {
    final otherUserId = (data['user_id'] as String?)?.trim() ?? '';
    final otherUserEmail = data['email'] ?? '';

    return GestureDetector(
      onTap: () async {
        final currentUserId = _auth.currentUser?.uid ?? '';
        String chatRoomId = await ChatService().createOrGetChatRoom(currentUserId, otherUserId);
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatPage(
              chatRoomId: chatRoomId,
              currentUserId: currentUserId,
              otherUserId: otherUserId,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          leading: CircleAvatar(
            radius: 28,
            backgroundColor: gradientColors.first,
            child: Icon(Icons.person, color: theme.colorScheme.onPrimary),
          ),
          title: Text(
            data['userName'] ?? 'Unknown',
            style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.onPrimary),
          ),
          subtitle: Text(
            otherUserEmail,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.onPrimary.withOpacity(0.7)),
          ),
          trailing: Icon(Icons.arrow_forward_ios,
              color: theme.colorScheme.onPrimary.withOpacity(0.7)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = _auth.currentUser;
    final currentUserId = currentUser?.uid ?? '';
    final currentUserEmail = currentUser?.email ?? '';
    final gradients = generateGradients(theme);

    final usersStream = _firestore.collection('usersList').snapshots();
    final chatRoomsStream = _firestore
        .collection('chatRooms')
        .where('participants', arrayContains: currentUserId)
        .snapshots();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: StreamBuilder<QuerySnapshot>(
        stream: usersStream,
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!userSnapshot.hasData || userSnapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No other users found.', style: theme.textTheme.bodyMedium),
            );
          }

          return StreamBuilder<QuerySnapshot>(
            stream: chatRoomsStream,
            builder: (context, roomSnapshot) {
              if (roomSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final existingUserIds = <String>{};
              if (roomSnapshot.hasData) {
                for (var doc in roomSnapshot.data!.docs) {
                  final participants = List<String>.from(doc['participants'] ?? []);
                  for (var uid in participants) {
                    if (uid != currentUserId) existingUserIds.add(uid);
                  }
                }
              }

              final filteredUsers = userSnapshot.data!.docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final userEmail = data['email'] ?? '';
                final userId = (data['user_id'] as String?)?.trim() ?? '';
                return userEmail != currentUserEmail && !existingUserIds.contains(userId);
              }).toList();

              if (filteredUsers.isEmpty) {
                return Center(
                  child: Text('No new users found.', style: theme.textTheme.bodyMedium),
                );
              }

              // Use Column with top alignment even for a single user
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List.generate(filteredUsers.length, (index) {
                    final data = filteredUsers[index].data() as Map<String, dynamic>;
                    final gradientColors = gradients[index % gradients.length];
                    return _buildUserTile(data, gradientColors, theme);
                  }),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
