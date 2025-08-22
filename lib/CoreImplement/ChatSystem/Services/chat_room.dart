import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  final String chatRoomId; // unique id for the room
  final List<String> participants; // list of user ids
  final String? lastMessage;
  final Timestamp? lastMessageTime;

  ChatRoom({
    required this.chatRoomId,
    required this.participants,
    this.lastMessage,
    this.lastMessageTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'chatRoomId': chatRoomId,
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
    };
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      chatRoomId: map['chatRoomId'],
      participants: List<String>.from(map['participants']),
      lastMessage: map['lastMessage'],
      lastMessageTime: map['lastMessageTime'],
    );
  }
}
