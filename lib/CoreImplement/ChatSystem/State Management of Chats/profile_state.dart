import '../Two person room/user_management.dart';

abstract class ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileViewState extends ProfileState {
  final CloudUser user;
  ProfileViewState({required this.user});
}

class ProfileEditState extends ProfileState {
  final CloudUser? user;
  ProfileEditState({this.user});
}
//just to create the profile
class ProfileCreateState extends ProfileState {
  final CloudUser? user;
  ProfileCreateState({this.user});
}
class ProfileDeletedState extends ProfileState {}

class ProfileExistState extends ProfileState{}

class ProfileErrorState extends ProfileState {
  final String message;
  ProfileErrorState({required this.message});
}
