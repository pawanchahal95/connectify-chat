import 'package:flutter/cupertino.dart';

@immutable
abstract class ProfileEvent {
  const ProfileEvent();
}

class LoadProfileEvent extends ProfileEvent {
  const LoadProfileEvent();
}

class EnterEditEvent extends ProfileEvent {
  const EnterEditEvent();
}

class CancelEditEvent extends ProfileEvent {
  const CancelEditEvent();
}
class CreateEvent extends ProfileEvent{
  const CreateEvent();
}
class ProfileViewEvent extends ProfileEvent {
  const ProfileViewEvent();
}


class CreateOrUpdateProfileEvent extends ProfileEvent {
  final String username;
  final String dialogName;
  final String statusMessage;
  final String phoneNumber;

  const CreateOrUpdateProfileEvent({
    required this.username,
    required this.dialogName,
    required this.statusMessage,
    required this.phoneNumber,
  });
}

class DeleteProfileEvent extends ProfileEvent {
  const DeleteProfileEvent();
}
class ProfileExistEvent extends ProfileEvent{
  const ProfileExistEvent();
}
