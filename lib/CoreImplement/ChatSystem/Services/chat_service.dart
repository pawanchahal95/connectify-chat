import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_room.dart';
import 'chat_message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create a chat room between two users
  Future<String> createOrGetChatRoom(String currentUserId, String otherUserId) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Always keep a consistent roomId (so both users land in the same room)
    List<String> participants = [currentUserId, otherUserId]..sort();
    String chatRoomId = participants.join('_');

    DocumentReference roomRef = _firestore.collection('chatRooms').doc(chatRoomId);

    final roomSnapshot = await roomRef.get();

    if (!roomSnapshot.exists) {
      // Create new chat room
      ChatRoom room = ChatRoom(
        chatRoomId: chatRoomId,
        participants: participants,
        lastMessage: null,
        lastMessageTime: null,
      );
      await roomRef.set(room.toMap());
    }

    return chatRoomId;
  }

  /// Send a message to a chat room
  Future<void> sendMessage(
      String chatRoomId, String senderId, String text) async {
    ChatMessage message = ChatMessage(
      senderId: senderId,
      text: text,
      timestamp: Timestamp.now(),
    );

    // Save in subcollection messages
    await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(message.toMap());

    // Update last message in room
    await _firestore.collection('chatRooms').doc(chatRoomId).update({
      'lastMessage': text,
      'lastMessageTime': message.timestamp,
    });
  }

  /// Stream of messages in a chat room
  Stream<List<ChatMessage>> getMessages(String chatRoomId) {
    return _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => ChatMessage.fromMap(doc.data())).toList());
  }

  /// Stream of chat rooms for a user
  Stream<List<ChatRoom>> getUserChatRooms(String userId) {
    return _firestore
        .collection('chatRooms')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => ChatRoom.fromMap(doc.data())).toList());
  }
}
