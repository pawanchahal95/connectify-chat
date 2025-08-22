import 'package:flutter/material.dart';
import '../Services/chat_room.dart'
    '';
import '../Services/chat_service.dart';
import 'chat_page.dart';

class ChatListPage extends StatefulWidget {
  final String currentUserId;
  const ChatListPage({super.key, required this.currentUserId});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Chats")),
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
              final time = dt != null ? TimeOfDay.fromDateTime(dt).format(context) : "";

              // the other participant (not me)
              final otherUserId = room.participants.firstWhere(
                    (id) => id != widget.currentUserId,
                orElse: () => "Unknown",
              );

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
                  child: Icon(Icons.person, color: theme.colorScheme.primary),
                ),
                title: Text(
                  otherUserId, // replace with display name lookup if you want
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                subtitle: Text(
                  lastMsg,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  time,
                  style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                ),
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
