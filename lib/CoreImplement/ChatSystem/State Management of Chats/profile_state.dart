import '../Two person room/user_management.dart';

abstract class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileViewMode extends ProfileState {
  final CloudUser user;
  ProfileViewMode({required this.user});
}

class ProfileEditMode extends ProfileState {
  final CloudUser? user;
  ProfileEditMode({this.user});
}

class ProfileDeleted extends ProfileState {}

class ProfileExist extends ProfileState{}

class ProfileError extends ProfileState {
  final String message;
  ProfileError({required this.message});
}
