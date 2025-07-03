import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AllUsersPage extends StatefulWidget {
  const AllUsersPage({super.key});

  @override
  State<AllUsersPage> createState() => _AllUsersPageState();
}

class _AllUsersPageState extends State<AllUsersPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllUsersExceptCurrent();
  }

  Future<void> fetchAllUsersExceptCurrent() async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final querySnapshot = await _firestore.collection('users').get();

    final filteredUsers = querySnapshot.docs
        .where((doc) => doc.id != currentUser.uid)
        .map((doc) => {
      'uid': doc.id,
      'email': doc['email'],
      'name': doc['name'],
    })
        .toList();

    setState(() {
      users = filteredUsers;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Available Users")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(user['name']),
            subtitle: Text(user['email']),
            onTap: () {
              // Optional: initiate chat, etc.
            },
          );
        },
      ),
    );
  }
}
