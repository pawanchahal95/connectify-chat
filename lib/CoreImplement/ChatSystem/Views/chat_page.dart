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

  Map<String, String> userMap = {};
  Set<String> selectedMessageIds = {};
  bool selectionMode = false;
  ChatMessage? _editingMessage;

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
      setState(() => userMap = map);
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
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) return "Today";
    if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) return "Yesterday";
    return DateFormat('dd/MM/yyyy').format(date);
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    try {
      if (_editingMessage != null) {
        await _chatService.editMessage(widget.chatRoomId, _editingMessage!.id!, text);
        _editingMessage = null;
      } else {
        await _chatService.sendMessage(widget.chatRoomId, widget.currentUserId, text);
      }
      _controller.clear();
      _scrollToBottom();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed: $e")),
      );
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  void _deleteSelectedMessages() async {
    for (var msgId in selectedMessageIds) {
      await _chatService.deleteMessage(widget.chatRoomId, msgId);
    }
    setState(() {
      selectionMode = false;
      selectedMessageIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final otherUserName = getDisplayName(widget.otherUserId);

    // Gradient for AppBar and Send button
    final gradientColors = [
      theme.colorScheme.primary,
      theme.colorScheme.primaryContainer,
    ];

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        elevation: 2,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: selectionMode
            ? Text("${selectedMessageIds.length} selected")
            : Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                getInitials(otherUserName),
                style: TextStyle(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                otherUserName,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: selectionMode
            ? [
          if (selectedMessageIds.length == 1)
            IconButton(
              icon: Icon(Icons.edit, color: theme.colorScheme.onPrimary),
              onPressed: () async {
                final msgId = selectedMessageIds.first;
                final doc = await _firestore
                    .collection('chatRooms')
                    .doc(widget.chatRoomId)
                    .collection('messages')
                    .doc(msgId)
                    .get();
                final msg = ChatMessage.fromMap(doc.data()!);
                _controller.text = msg.text;
                _editingMessage = msg;
                setState(() {
                  selectionMode = false;
                  selectedMessageIds.clear();
                });
              },
            ),
          IconButton(
            icon: Icon(Icons.delete, color: theme.colorScheme.onPrimary),
            onPressed: _deleteSelectedMessages,
          ),
          IconButton(
            icon: Icon(Icons.close, color: theme.colorScheme.onPrimary),
            onPressed: () {
              setState(() {
                selectionMode = false;
                selectedMessageIds.clear();
              });
            },
          ),
        ]
            : null,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: _chatService.getMessages(widget.chatRoomId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(color: theme.colorScheme.primary));
                }
                if (snapshot.hasError) {
                  return Center(
                      child: Text("Error: ${snapshot.error}", style: theme.textTheme.bodyMedium));
                }

                final messages = snapshot.data ?? [];
                if (messages.isEmpty) {
                  return Center(
                    child: Text("No messages yet", style: theme.textTheme.bodyMedium),
                  );
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

                    final bubbleColor = selectedMessageIds.contains(msg.id)
                        ? theme.colorScheme.secondaryContainer.withOpacity(0.3)
                        : isMe
                        ? theme.colorScheme.primaryContainer.withOpacity(0.3)
                        : theme.colorScheme.surfaceVariant.withOpacity(0.8);

                    return GestureDetector(
                      onLongPress: () {
                        setState(() {
                          selectionMode = true;
                          selectedMessageIds.add(msg.id!);
                        });
                      },
                      onTap: () {
                        if (selectionMode) {
                          setState(() {
                            if (selectedMessageIds.contains(msg.id)) {
                              selectedMessageIds.remove(msg.id);
                              if (selectedMessageIds.isEmpty) selectionMode = false;
                            } else {
                              selectedMessageIds.add(msg.id!);
                            }
                          });
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (showDateHeader)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  constraints: BoxConstraints(
                                      maxWidth:
                                      MediaQuery.of(context).size.width * 0.8),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surfaceVariant.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      formatDateHeader(msgTime),
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Align(
                            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              constraints: BoxConstraints(
                                  maxWidth:
                                  MediaQuery.of(context).size.width * 0.7),
                              decoration: BoxDecoration(
                                gradient: isMe
                                    ? LinearGradient(
                                  colors: [
                                    theme.colorScheme.primaryContainer,
                                    theme.colorScheme.primary
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                                    : LinearGradient(
                                  colors: [
                                    theme.colorScheme.surfaceVariant,
                                    theme.colorScheme.surface
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: isMe
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  if (!isMe)
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 16,
                                          backgroundColor:
                                          theme.colorScheme.primaryContainer,
                                          child: Text(
                                            getInitials(senderName),
                                            style: TextStyle(
                                                color:
                                                theme.colorScheme.onPrimaryContainer,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Flexible(
                                          child: Text(
                                            senderName,
                                            style: theme.textTheme.bodySmall?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: theme.colorScheme.onSurface
                                                    .withOpacity(0.7)),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  const SizedBox(height: 2),
                                  Text(
                                    msg.text,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onSurface),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    formatTime(msgTime),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.onSurface
                                            .withOpacity(0.5)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onBackground,
                      ),
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        hintStyle: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onBackground.withOpacity(0.5),
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: _sendMessage,
                      icon: Icon(Icons.send, color: theme.colorScheme.onPrimary),
                      tooltip: "Send",
                    ),
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
