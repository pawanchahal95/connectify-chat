import 'package:flutter/material.dart';
import '../Services/chat_message.dart';
import '../Services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String chatRoomId;
  final String currentUserId;
  final String otherUserId;

  const ChatPage({
    super.key,
    required this.chatRoomId,
    required this.currentUserId,
    required this.otherUserId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatService _chatService = ChatService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, String> userMap = {}; // UID -> userName

  @override
  void initState() {
    super.initState();
    _listenToUsers();
  }

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

  String getDisplayName(String uid) => userMap[uid] ?? uid;

  String getInitials(String name) {
    if (name.isEmpty) return "?";
    final words = name.trim().split(" ");
    if (words.length == 1) return words[0][0].toUpperCase();
    return (words[0][0] + words[1][0]).toUpperCase();
  }

  String formatTime(DateTime time) => DateFormat('hh:mm a').format(time);

  String formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return "Today";
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return "Yesterday";
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    try {
      await _chatService.sendMessage(widget.chatRoomId, widget.currentUserId, text);
      _controller.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to send: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final otherUserName = getDisplayName(widget.otherUserId);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
              child: Text(
                getInitials(otherUserName),
                style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 8),
            Text(otherUserName),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: _chatService.getMessages(widget.chatRoomId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                final messages = snapshot.data ?? [];
                if (messages.isEmpty) {
                  return const Center(child: Text("No messages yet"));
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == widget.currentUserId;
                    final senderName = getDisplayName(msg.senderId);

                    final msgTime = msg.timestamp?.toDate() ?? DateTime.now();

                    // Determine if we need a date header
                    bool showDateHeader = true;
                    if (index < messages.length - 1) {
                      final prevTime = messages[index + 1].timestamp?.toDate();
                      if (prevTime != null &&
                          prevTime.year == msgTime.year &&
                          prevTime.month == msgTime.month &&
                          prevTime.day == msgTime.day) {
                        showDateHeader = false;
                      }
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (showDateHeader)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surfaceVariant.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    formatDateHeader(msgTime),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: theme.colorScheme.onSurface.withOpacity(0.7)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        Align(
                          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isMe)
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                                  child: Text(
                                    getInitials(senderName),
                                    style: TextStyle(
                                        color: theme.colorScheme.primary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              if (!isMe) const SizedBox(width: 6),
                              Container(
                                constraints:
                                BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                decoration: BoxDecoration(
                                  color: isMe
                                      ? theme.colorScheme.primary.withOpacity(0.15)
                                      : theme.colorScheme.surfaceVariant.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      senderName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.onSurface.withOpacity(0.7)),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      msg.text,
                                      style: TextStyle(color: theme.colorScheme.onSurface),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      formatTime(msgTime),
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: theme.colorScheme.onSurface.withOpacity(0.5)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send),
                    color: theme.colorScheme.primary,
                    tooltip: "Send",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
