import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Services/chat_room.dart';
import '../Services/chat_service.dart';
import 'chat_page.dart';

class ChatListPage extends StatefulWidget {
  final String currentUserId;
  final Set<String> selectedRooms;
  final Function(Set<String>) onSelectionChanged;

  const ChatListPage({
    super.key,
    required this.currentUserId,
    required this.selectedRooms,
    required this.onSelectionChanged,
  });

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final ChatService _chatService = ChatService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, String> userMap = {};

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
        final uid = (data['user_id'] as String?) ?? doc.id;
        final name = (data['userName'] as String?) ?? uid;
        map[uid] = name;
      }
      if (mounted) setState(() => userMap = map);
    });
  }

  String getDisplayName(String uid) => userMap[uid] ?? uid;

  String initialsOf(String name) {
    if (name.trim().isEmpty) return "?";
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  Future<void> _deleteEmptyChatRoom(String roomId) async {
    final snap = await _firestore
        .collection('chatRooms')
        .doc(roomId)
        .collection('messages')
        .limit(1)
        .get();
    if (snap.docs.isEmpty) {
      await _firestore.collection('chatRooms').doc(roomId).delete();
    }
  }

  LinearGradient _generateGradient(String uid, ColorScheme colors) {
    // Simple deterministic gradient per user
    final colorsList = [
      colors.primary,
      colors.secondary,
      colors.tertiary ?? colors.primaryContainer,
      colors.primaryContainer,
    ];
    final index = uid.hashCode % colorsList.length;
    return LinearGradient(
      colors: [
        colorsList[index].withOpacity(0.8),
        colorsList[(index + 1) % colorsList.length].withOpacity(0.6)
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<List<ChatRoom>>(
      stream: _chatService.getUserChatRooms(widget.currentUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: theme.colorScheme.primary,
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error}",
              style: theme.textTheme.bodyMedium,
            ),
          );
        }

        final rooms = snapshot.data ?? [];
        if (rooms.isEmpty) {
          return Center(
            child: Text(
              "No chats yet",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onBackground.withOpacity(0.7),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          itemCount: rooms.length,
          itemBuilder: (context, index) {
            final room = rooms[index];

            if ((room.lastMessage ?? '').trim().isEmpty) {
              _deleteEmptyChatRoom(room.chatRoomId);
              return const SizedBox.shrink();
            }

            final isSelected = widget.selectedRooms.contains(room.chatRoomId);
            final otherUserId = room.participants.firstWhere(
                  (id) => id != widget.currentUserId,
              orElse: () => "Unknown",
            );
            final displayName = getDisplayName(otherUserId);
            final initials = initialsOf(displayName);
            final time = room.lastMessageTime != null
                ? DateFormat('hh:mm a').format(room.lastMessageTime!.toDate())
                : "";

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.25),
                    theme.colorScheme.primaryContainer.withOpacity(0.15)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                    : null,
                color: isSelected ? null : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withOpacity(0.15),
                    blurRadius: isSelected ? 12 : 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                splashColor: theme.colorScheme.primary.withOpacity(0.1),
                highlightColor: Colors.transparent,
                onLongPress: () {
                  final updated = Set<String>.from(widget.selectedRooms);
                  if (isSelected) {
                    updated.remove(room.chatRoomId);
                  } else {
                    updated.add(room.chatRoomId);
                  }
                  widget.onSelectionChanged(updated);
                },
                onTap: () {
                  if (widget.selectedRooms.isNotEmpty) {
                    final updated = Set<String>.from(widget.selectedRooms);
                    if (isSelected) {
                      updated.remove(room.chatRoomId);
                    } else {
                      updated.add(room.chatRoomId);
                    }
                    widget.onSelectionChanged(updated);
                  } else {
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
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: _generateGradient(otherUserId, theme.colorScheme),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.shadow.withOpacity(0.25),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.transparent,
                          child: Text(
                            initials,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              room.lastMessage ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.65)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        time,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color:
                          theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
