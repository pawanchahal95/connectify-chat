import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Two person room/user_management.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {

  ProfileBloc(FirebaseCloudUser cloudService) : super(ProfileLoading()) {

    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      final email = FirebaseAuth.instance.currentUser?.email;
      if (email == null) {
        emit(ProfileError(message: 'User not logged in.'));
        return;
      }
      try {
        final exists = await cloudService.checkIfUserExist(email: email);
        if (exists) {
          emit(ProfileExist());
        } else {
          emit(ProfileEditMode(user: null));
        }
      } catch (e) {
        emit(ProfileError(message: 'Failed to load profile: $e'));
      }
    });

    on<EnterEditMode>((event, emit) {
      if (state is ProfileViewMode) {
        final user = (state as ProfileViewMode).user;
        emit(ProfileEditMode(user: user));
      }
    });

    on<CancelEditMode>((event, emit) {
      if (state is ProfileEditMode) {
        final user = (state as ProfileEditMode).user;
        if (user != null) {
          emit(ProfileViewMode(user: user));
        } else {
          emit(ProfileEditMode(user: null)); // Still in edit mode
        }
      }
    });

    on<ProfileViewEvent>((event,emit)async {
      emit(ProfileLoading());
      final email = FirebaseAuth.instance.currentUser?.email;
      if (email == null) {
        emit(ProfileError(message: 'User not logged in.'));
        return;
      }
      try {
        final exists = await cloudService.checkIfUserExist(email: email);
        if (exists) {
          final user = await cloudService.getUser(email: email);
          emit(ProfileViewMode(user: user));

        } else {
          emit(ProfileEditMode(user: null));
        }
      } catch (e) {
        emit(ProfileError(message: 'Failed to load profile: $e'));
      }
    });

    on<CreateOrUpdateProfile>((event, emit) async {
      emit(ProfileLoading());
      final email = FirebaseAuth.instance.currentUser?.email;
      final uid = FirebaseAuth.instance.currentUser?.uid;

      if (email == null || uid == null) {
        emit(ProfileError(message: 'User not authenticated.'));
        return;
      }

      try {
        final exists = await cloudService.checkIfUserExist(email: email);
        if (exists) {
          await cloudService.updateUserDetailByEmail(
            email: email,
            username: event.username,
            userDialog: event.dialogName,
            statusMessage: event.statusMessage,
            phoneNumber: event.phoneNumber,
          );
        } else {
          await cloudService.createNewUser(
            emailId: email,
            userId: uid,
            username: event.username,
            userDialog: event.dialogName,
            statusMessage: event.statusMessage,
            phoneNumber: event.phoneNumber,
          );
        }

        final updatedUser = await cloudService.getUser(email: email);
        emit(ProfileExist());
      } catch (e) {
        emit(ProfileError(message: 'Failed to save profile: $e'));
      }
    });

    on<DeleteProfile>((event, emit) async {
      emit(ProfileLoading());
      final email = FirebaseAuth.instance.currentUser?.email;
      if (email == null) {
        emit(ProfileError(message: 'User not authenticated.'));
        return;
      }

      try {
        await cloudService.deleteUserByEmail(email: email);
        emit(ProfileEditMode(user: null)); // Go back to empty profile
      } catch (e) {
        emit(ProfileError(message: 'Error deleting profile: $e'));
      }
    });
  }
}
