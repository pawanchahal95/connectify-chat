import 'package:chatapp/CoreImplement/ChatSystem/Two%20person%20room/exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
@immutable
class CloudUser {
  final String documentId;
  final String email;
  final String userDialog;
  final String userName;
  final String userId;
  final String? userImage;
  final String? statusMessage;
  final String? phoneNumber;
  final bool? isOnline;
  final String? typingTo;
  final DateTime? lastSeen;
  final String? pushToken;

  const CloudUser({
    required this.documentId,
    required this.email,
    required this.userDialog,
    required this.userName,
    required this.userId,
    this.userImage,
    this.statusMessage,
    this.phoneNumber,
    this.isOnline,
    this.typingTo,
    this.lastSeen,
    this.pushToken,
  });

  CloudUser.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        email = snapshot.data()['email'],
        userDialog = snapshot.data()['userDialog'],
        userId = snapshot.data()['userId'],
        userImage = snapshot.data()['userImage'],
        userName = snapshot.data()['userName'],
        statusMessage = snapshot.data()['statusMessage'],
        phoneNumber = snapshot.data()['phoneNumber'],
        isOnline = snapshot.data()['isOnline'],
        typingTo = snapshot.data()['typingTo'],
        pushToken = snapshot.data()['pushToken'],
        lastSeen = (snapshot.data()['lastSeen'] as Timestamp?)?.toDate();

  static get emailField => null;
}

class FirebaseCloudUser{
  final users = FirebaseFirestore.instance.collection('usersList');

  Future<CloudUser> createNewUser({
    required String emailId,
    required String username,
    required String userDialog,
    required String userId,
    String? userImage,
    String? statusMessage,
    String? phoneNumber,
    bool? isOnline,
    String? typingTo,
    Timestamp? lastSeen,
    String? pushToken,
  })
  async{
    try {
      final existingUsers=await users.where(emailField,isEqualTo: emailId).limit(1).get();
      if(existingUsers.docs.isNotEmpty){
        final existingUserSnapShot=existingUsers.docs.first;
        return CloudUser.fromSnapshot(existingUserSnapShot);
      }
      final Map<String, dynamic> userData = {
        userIdField: userId,
        emailField: emailId,
        userNameField: username,
        userDialogField: userDialog,
      };
      //optional can add can not
      if (userImage != null) userData[userImageField] = userImage;
      if (statusMessage != null) userData[statusMessageField] = statusMessage;
      if (phoneNumber != null) userData[phoneNumberField] = phoneNumber;
      if (isOnline != null) userData[isOnlineField] = isOnline;
      if (typingTo != null) userData[typingToField] = typingTo;
      if (lastSeen != null) userData[lastSeenField] = lastSeen;
      if (pushToken != null) userData[pushTokenField] = pushToken;


      final document = await users.add(userData);



      final fetchedUser=await document.get();
      return CloudUser.fromSnapshot(fetchedUser as QueryDocumentSnapshot<Map<String,dynamic>>);
    }
    catch(e){
       throw Exception('Could not create user: $e');
    }
  }

  Future<CloudUser>getUser({required String email})
  async{
    try{
      final querySnapshot=await users.where(emailField,isEqualTo: email).get();

      return CloudUser.fromSnapshot(querySnapshot.docs.first);
    }catch(e){
      throw CouldNotGetUsersException();
    }
  }

  Future<bool>checkIfUserExist({required String email})async{
    try{
      final querySnapshot =await users.where('email',isEqualTo: email).get();
      if( querySnapshot.docs.isNotEmpty){
        return true;
      }
      else{
        return false;
      }
    }catch(e){
      print('Error checking if user exists: $e');
      return false; // Return false if there's an error
    }
  }

  Future<Iterable<CloudUser>> getAllUsers() async {
    try {
      final querySnapshot = await users.get();
      return querySnapshot.docs.map((doc) => CloudUser.fromSnapshot(doc));
    } catch (e) {
      throw CouldNotGetUsersException();
    }
  }



}