import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatapp/CoreImplement/ChatSystem/Two person room/dual_char.dart';
class ChatScreen extends StatefulWidget {
  final String senderId;
  final String receiverId;

  const ChatScreen({
    super.key,
    required this.senderId,
    required this.receiverId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late Future<ChatRoom> _roomFuture;

  @override
  void initState() {
    super.initState();
    _roomFuture = findOrCreateChatRoom(widget.senderId, widget.receiverId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ChatRoom>(
      future: _roomFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final room = snapshot.data!;
        final messagesRef = chatRooms.doc(room.roomId).collection('messages').orderBy('timestamp');

        return Scaffold(
          appBar: AppBar(
            title: Text('Chat with ${widget.receiverId}'),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: messagesRef.snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                    final docs = snapshot.data!.docs;

                    return ListView.builder(
                      reverse: true,
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final msg = docs[docs.length - index - 1];
                        final isSender = msg['senderId'] == widget.senderId;

                        return Align(
                          alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSender ? Colors.blue[200] : Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(msg['text'] ?? ''),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async {
                        final text = _controller.text.trim();
                        if (text.isNotEmpty) {
                          await sendMessageToUser(
                            senderId: widget.senderId,
                            receiverId: widget.receiverId,
                            messageText: text,
                          );
                          _controller.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}
