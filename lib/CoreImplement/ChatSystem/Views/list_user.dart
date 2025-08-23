import 'package:chatapp/CoreImplement/ChatSystem/Two%20person%20room/dual_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Services/chat_page.dart';
import '../Services/chat_service.dart';

class AllUsersPage extends StatefulWidget {
  const AllUsersPage({super.key});

  @override
  State<AllUsersPage> createState() => _AllUsersPageState();
}

class _AllUsersPageState extends State<AllUsersPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final currentUser = _auth.currentUser;
    final currentUserId = currentUser?.uid ?? '';
    final currentUserEmail = currentUser?.email ?? '';

    // Stream of chat rooms the user is part of
    final chatRoomsStream = _firestore
        .collection('chatRooms')
        .where('participants', arrayContains: currentUserId)
        .snapshots();

    // Stream of all users
    final usersStream = _firestore.collection('usersList').snapshots();

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: usersStream,
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!userSnapshot.hasData || userSnapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No other users found.'));
          }

          return StreamBuilder<QuerySnapshot>(
            stream: chatRoomsStream,
            builder: (context, roomSnapshot) {
              if (roomSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // Collect IDs of users we already have chat rooms with
              final existingUserIds = <String>{};
              if (roomSnapshot.hasData) {
                for (var doc in roomSnapshot.data!.docs) {
                  final participants = List<String>.from(doc['participants'] ?? []);
                  for (var uid in participants) {
                    if (uid != currentUserId) existingUserIds.add(uid);
                  }
                }
              }

              // Filter out current user and users with existing chat rooms
              final filteredUsers = userSnapshot.data!.docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final userEmail = data['email'] ?? '';
                final userId = (data['user_id'] as String?)?.trim() ?? '';
                return userEmail != currentUserEmail && !existingUserIds.contains(userId);
              }).toList();

              if (filteredUsers.isEmpty) {
                return const Center(child: Text('No new users found.'));
              }

              return ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final doc = filteredUsers[index];
                  final data = doc.data() as Map<String, dynamic>;
                  final otherUserId = (data['user_id'] as String?)?.trim() ?? '';
                  final otherUserEmail = data['email'] ?? '';

                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(data['userName'] ?? 'Unknown'),
                    subtitle: Text(otherUserEmail),
                    onTap: () async {
                      String chatRoomId = await ChatService()
                          .createOrGetChatRoom(currentUserId, otherUserId);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            chatRoomId: chatRoomId,
                            currentUserId: currentUserId,
                            otherUserId: otherUserId,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
