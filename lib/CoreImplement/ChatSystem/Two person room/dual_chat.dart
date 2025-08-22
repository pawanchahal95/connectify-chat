import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  final String roomId;
  final List<String> participants;

  ChatRoom({
    required this.roomId,
    required this.participants,
  });

  factory ChatRoom.fromDocument(String id, Map<String, dynamic> data) {
    return ChatRoom(
      roomId: id,
      participants: List<String>.from(data['participants']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'participants': participants,
    };
  }
}
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference chatRooms = _firestore.collection('chat_rooms');


Future<ChatRoom> findOrCreateChatRoom(String userA, String userB) async {
  // Step 1: Find existing room where both users are present
  final querySnapshot = await chatRooms
      .where('participants', arrayContains: userA)
      .get();

  for (var doc in querySnapshot.docs) {
    final participants = List<String>.from(doc['participants']);
    if (participants.contains(userB)) {
      return ChatRoom.fromDocument(doc.id, doc.data() as Map<String, dynamic>);
    }
  }
  // Step 2: If not found, create new room
  final newRoom = {
    'participants': [userA, userB],
  };
  final roomDoc = await chatRooms.add(newRoom);
  return ChatRoom(roomId: roomDoc.id, participants: [userA, userB]);
}


Future<void> sendMessageToUser({
  required String senderId,
  required String receiverId,
  required String messageText,
})
async {
  final room = await findOrCreateChatRoom(senderId, receiverId);

  final message = {
    'senderId': senderId,
    'text': messageText,
    'timestamp': FieldValue.serverTimestamp(),
  };

  await chatRooms.doc(room.roomId).collection('messages').add(message);
}

Future<void>deleteChatRoom({required String chatRoomId})async{
  try{
    await chatRooms.doc(chatRoomId).delete();
  }catch(e){
    throw Exception('Could not delete chat room:$e');
  }
}

Stream<List<Map<String, dynamic>>> getMessages(String roomId) {
  return chatRooms
      .doc(roomId)
      .collection('messages')
      .orderBy('timestamp', descending: false)
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
}

