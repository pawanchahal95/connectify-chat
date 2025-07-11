import 'dart:ui';

import 'package:chatapp/Services/StateManagement/auth_bloc.dart';
import 'package:chatapp/Services/StateManagement/auth_event.dart';
import 'package:chatapp/Views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Two person room/user_management.dart'; // Your CloudUser & FirebaseCloudUser class
import 'package:google_fonts/google_fonts.dart'; // Make sure this is imported

class FancyProfilePage extends StatefulWidget {
  const FancyProfilePage({super.key});

  @override
  State<FancyProfilePage> createState() => _FancyProfilePageState();
}

class _FancyProfilePageState extends State<FancyProfilePage> {

  //manage the firebaseclouduser state
  final FirebaseCloudUser _cloudService = FirebaseCloudUser();
  CloudUser? _cloudUser;
  bool _isLoading = true;
  bool _isEdit = false;
//textEditing controller
 late  final TextEditingController _usernameController;
 late final TextEditingController _dialogController ;
 late final TextEditingController _statusController;
 late final TextEditingController _phoneController ;

  @override
  void initState() {
    _usernameController=TextEditingController();
    _dialogController=TextEditingController();
    _statusController=TextEditingController();
    _phoneController=TextEditingController();
    super.initState();
    _loadUser();
  }
  @override
  void dispose(){
    _usernameController.dispose();
    _dialogController.dispose();
    _statusController.dispose();
    _phoneController.dispose();
    super.dispose();
}

  Future<void> _loadUser() async {
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email == null) return;

    final exists = await _cloudService.checkIfUserExist(email: email);
    if (exists) {
      final user = await _cloudService.getUser(email: email);
      setState(() {
        _cloudUser = user;
        _usernameController.text = user.userName;
        _dialogController.text = user.userDialog;
        _statusController.text = user.statusMessage ?? '';
        _phoneController.text = user.phoneNumber ?? '';
        _isLoading = false;
        _isEdit = false;
      });
    } else {
      setState(() {
        _isEdit = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    final email = FirebaseAuth.instance.currentUser?.email;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (email == null || uid == null) return;

    try {
      if (_cloudUser == null) {
        await _cloudService.createNewUser(
          emailId: email,
          username: _usernameController.text.trim(),
          userDialog: _dialogController.text.trim(),
          userId: uid,
          statusMessage: _statusController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
        );
      } else {
        await _cloudService.updateUserDetailByEmail(
          email: email,
          username: _usernameController.text.trim(),
          userDialog: _dialogController.text.trim(),
          statusMessage: _statusController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
        );
      }
      await _loadUser();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $e')),
      );
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>LoginPage()), (route)=>false);
    }
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
      ),
    );
  }
  Widget _buildReadOnlyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Text("$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        margin: const EdgeInsets.all(20),
        elevation: 12,
        color: Colors.white.withOpacity(0.9),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(_usernameController, 'Username', Icons.person),
              _buildTextField(_dialogController, 'Dialog Name', Icons.chat),
              _buildTextField(_statusController, 'Status Message', Icons.info),
              _buildTextField(_phoneController, 'Phone Number', Icons.phone),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save Profile'),
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              if (_cloudUser != null) ...[
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => setState(() => _isEdit = false),
                  child: const Text('Cancel'),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewCard() {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        margin: const EdgeInsets.all(20),
        elevation: 10,
        color: Colors.white.withOpacity(0.9),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildReadOnlyRow('Email', _cloudUser?.email ?? ''),
              _buildReadOnlyRow('Username', _cloudUser?.userName ?? ''),
              _buildReadOnlyRow('Dialog', _cloudUser?.userDialog ?? ''),
              _buildReadOnlyRow('Phone', _cloudUser?.phoneNumber ?? 'Not set'),
              _buildReadOnlyRow('Status', _cloudUser?.statusMessage ?? 'None'),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profile'),
                onPressed: () => setState(() => _isEdit = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Your Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              context.read<AuthBloc>().add(const AuthEventLogOut());
            },
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe0c3fc), Color(0xFF8ec5fc)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _isEdit ? _buildFormCard() : _buildViewCard(),
          ),
        ),
      ),
    );
  }












}
