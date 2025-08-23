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
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('usersList').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No other users found.'));
          }

          // Filter out the current user by email
          final filteredUsers = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>; // fixed here
            final userEmail = data['email'] ?? '';
            return userEmail != currentUserEmail;
          }).toList();

          if (filteredUsers.isEmpty) {
            return const Center(child: Text('No other users found.'));
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
                subtitle: Text(data['email'] ?? ''),
                onTap: ()async {
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
      ),
    );
  }

}
