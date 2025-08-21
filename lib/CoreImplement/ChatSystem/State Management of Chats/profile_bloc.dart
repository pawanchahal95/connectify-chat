import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Two person room/user_management.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {

  ProfileBloc(FirebaseCloudUser cloudService) : super(ProfileLoadingState()) {

    on<LoadProfileEvent>((event, emit) async {
      emit(ProfileLoadingState());
      final email = FirebaseAuth.instance.currentUser?.email;
      if (email == null) {
        emit(ProfileErrorState(message: 'User not logged in.'));
        return;
      }
      try {
        final exists = await cloudService.checkIfUserExist(email: email);
        if (exists) {
          emit(ProfileExistState());
        } else {
          emit(ProfileCreateState(user: null));
        }
      } catch (e) {
        emit(ProfileErrorState(message: 'Failed to load profile: $e'));
      }
    });

    on<EnterEditEvent>((event, emit) {
      if (state is ProfileViewState) {
        final user = (state as ProfileViewState).user;
        emit(ProfileEditState(user: user));
      }
    });

    on<CancelEditEvent>((event, emit) {
      if (state is ProfileEditState) {
        final user = (state as ProfileEditState).user;
        if (user != null) {
          emit(ProfileViewState(user: user));
        } else {
          emit(ProfileEditState(user: null)); // Still in create  mode
        }
      }
    });



    on<ProfileViewEvent>((event,emit)async {
      emit(ProfileLoadingState());
      final email = FirebaseAuth.instance.currentUser?.email;
      if (email == null) {
        emit(ProfileErrorState(message: 'User not logged in.'));
        return;
      }
      try {
        final exists = await cloudService.checkIfUserExist(email: email);
        if (exists) {
          final user = await cloudService.getUser(email: email);
          emit(ProfileViewState(user: user));

        } else {
          emit(ProfileCreateState(user: null));
        }
      } catch (e) {
        emit(ProfileErrorState(message: 'Failed to load profile: $e'));
      }
    });

    on<CreateOrUpdateProfileEvent>((event, emit) async {
      emit(ProfileLoadingState());
      final email = FirebaseAuth.instance.currentUser?.email;
      final uid = FirebaseAuth.instance.currentUser?.uid;

      if (email == null || uid == null) {
        emit(ProfileErrorState(message: 'User not authenticated.'));
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
        emit(ProfileExistState());
      } catch (e) {
        emit(ProfileErrorState(message: 'Failed to save profile: $e'));
      }
    });

    on<DeleteProfileEvent>((event, emit) async {
      emit(ProfileLoadingState());
      final email = FirebaseAuth.instance.currentUser?.email;
      if (email == null) {
        emit(ProfileErrorState(message: 'User not authenticated.'));
        return;
      }
      try {
        await cloudService.deleteUserByEmail(email: email);
        emit(ProfileCreateState(user: null)); // Go back to empty profile
      } catch (e) {
        emit(ProfileErrorState(message: 'Error deleting profile: $e'));
      }
    });
  }
}
