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
      String chatRoomId,
      String senderId,
      String text,
      ) async {
    final Timestamp now = Timestamp.now();

    // Create a ChatMessage without an ID yet (Firestore will generate one)
    ChatMessage message = ChatMessage(
      id: '', // placeholder, Firestore generates actual ID
      senderId: senderId,
      text: text,
      timestamp: now,
      edited: false,
    );

    // Save in subcollection messages
    final docRef = await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(message.toMap());

    // Optionally update the message with its Firestore ID
    await docRef.update({'id': docRef.id});

    // Update last message in chat room
    await _firestore.collection('chatRooms').doc(chatRoomId).update({
      'lastMessage': text,
      'lastMessageTime': now,
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
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // include Firestore ID
      return ChatMessage.fromMap(data);
    }).toList());
  }
  /// Stream of chat rooms for a user
  Stream<List<ChatRoom>> getUserChatRooms(String currentUserId) {
    return _firestore
        .collection('chatRooms')
        .where('participants', arrayContains: currentUserId) // only my rooms
        .snapshots()
        .map((snapshot) {
      final rooms = snapshot.docs
          .map((doc) => ChatRoom.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      // Sort by lastMessageTime (latest first), nulls go last
      rooms.sort((a, b) {
        final aTime = a.lastMessageTime?.toDate();
        final bTime = b.lastMessageTime?.toDate();
        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1;
        if (bTime == null) return -1;
        return bTime.compareTo(aTime);
      });

      return rooms;
    });
  }

  Future<void> editMessage(String chatRoomId, String messageId, String newText) async {
    final messageRef = _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId);

    await messageRef.update({
      'text': newText,
      'edited': true,
    });

    // Optionally, update last message if this is the latest
    final messagesSnapshot = await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (messagesSnapshot.docs.isNotEmpty &&
        messagesSnapshot.docs.first.id == messageId) {
      await _firestore.collection('chatRooms').doc(chatRoomId).update({
        'lastMessage': newText,
        'lastMessageTime': messagesSnapshot.docs.first['timestamp'],
      });
    }
  }

  Future<void> deleteMessage(String chatRoomId, String messageId) async {
    await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId)
        .delete();

    // Optionally, update last message
    final messagesSnapshot = await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (messagesSnapshot.docs.isNotEmpty) {
      await _firestore.collection('chatRooms').doc(chatRoomId).update({
        'lastMessage': messagesSnapshot.docs.first['text'],
        'lastMessageTime': messagesSnapshot.docs.first['timestamp'],
      });
    } else {
      await _firestore.collection('chatRooms').doc(chatRoomId).update({
        'lastMessage': null,
        'lastMessageTime': null,
      });
    }
  }
}
