import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Services/chat_room.dart';
import '../Services/chat_service.dart';
import 'chat_page.dart';
import 'package:intl/intl.dart';

class ChatListPage extends StatefulWidget {
  final String currentUserId;
  const ChatListPage({super.key, required this.currentUserId});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final ChatService _chatService = ChatService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, String> userMap = {}; // UID -> userName

  @override
  void initState() {
    super.initState();
    _listenToUsers();
  }

  // Listen to all users and build the map
  void _listenToUsers() {
    _firestore.collection('usersList').snapshots().listen((snapshot) {
      final map = <String, String>{};
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final uid = data['user_id'] ?? doc.id;
        final name = data['userName'] ?? uid;
        map[uid] = name;
      }
      setState(() {
        userMap = map;
      });
    });
  }

  // Helper to get username from map
  String getDisplayName(String uid) {
    return userMap[uid] ?? uid;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: StreamBuilder<List<ChatRoom>>(
        stream: _chatService.getUserChatRooms(widget.currentUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final chatRooms = snapshot.data ?? [];
          if (chatRooms.isEmpty) {
            return const Center(child: Text("No chats yet"));
          }

          return ListView.builder(
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              final room = chatRooms[index];
              final lastMsg = room.lastMessage ?? "";
              final dt = room.lastMessageTime?.toDate();
              final time = dt != null ? DateFormat('hh:mm a').format(dt) : "";

              // Get the other participant UID
              final otherUserId = room.participants.firstWhere(
                    (id) => id != widget.currentUserId,
                orElse: () => "Unknown",
              );

              // Get display name from the map
              final displayName = getDisplayName(otherUserId);
              final initials = displayName.isNotEmpty
                  ? displayName.trim().split(" ").map((e) => e[0]).take(2).join()
                  : "?";

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
                  child: Text(initials, style: TextStyle(color: theme.colorScheme.primary)),
                ),
                title: Text(displayName, style: TextStyle(color: theme.colorScheme.onSurface)),
                subtitle: Text(lastMsg, maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: Text(time, style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6))),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatPage(
                        chatRoomId: room.chatRoomId,
                        currentUserId: widget.currentUserId,
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
