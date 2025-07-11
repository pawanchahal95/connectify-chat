import 'package:flutter/cupertino.dart';

@immutable
abstract class ProfileEvent {
  const ProfileEvent();
}

class LoadProfile extends ProfileEvent {
  const LoadProfile();
}

class EnterEditMode extends ProfileEvent {
  const EnterEditMode();
}

class CancelEditMode extends ProfileEvent {
  const CancelEditMode();
}
class ProfileViewEvent extends ProfileEvent {
  const ProfileViewEvent();
}


class CreateOrUpdateProfile extends ProfileEvent {
  final String username;
  final String dialogName;
  final String statusMessage;
  final String phoneNumber;

  const CreateOrUpdateProfile({
    required this.username,
    required this.dialogName,
    required this.statusMessage,
    required this.phoneNumber,
  });
}

class DeleteProfile extends ProfileEvent {
  const DeleteProfile();
}
