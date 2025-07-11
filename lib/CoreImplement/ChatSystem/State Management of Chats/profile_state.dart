import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ProfileState {
  const ProfileState();
}
class ProfileStateInitial extends ProfileState{
  const ProfileStateInitial();
}

class ProfileStateLoading  extends ProfileState{}

class ProfileStateLoaded  extends ProfileState{}

class ProfileNotFound extends ProfileState {}

class ProfileStateCreated extends ProfileState {}


