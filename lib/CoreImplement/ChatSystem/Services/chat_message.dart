import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id; // Firestore doc ID
  final String senderId;
  final String text;
  final Timestamp timestamp;
  final bool edited; // optional flag

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.edited = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp,
      'edited': edited,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] ?? '',
      senderId: map['senderId'],
      text: map['text'],
      timestamp: map['timestamp'],
      edited: map['edited'] ?? false,
    );
  }
}
