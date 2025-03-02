import 'package:equatable/equatable.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitialState extends ProfileState {}

class UploadAvatarLoadingState extends ProfileState {}

class UpdateProfileLoadingState extends ProfileState {}

class UploadAvatarSuccessState extends ProfileState {
  final String avatarUrl;
  const UploadAvatarSuccessState({required this.avatarUrl});

  @override
  List<Object?> get props => [avatarUrl];
}

class UpdateProfileSuccessState extends ProfileState {
  final String message;
  const UpdateProfileSuccessState({required this.message});

  @override
  List<Object?> get props => [message];
}

class UploadAvatarErrorState extends ProfileState {
  final String message;
  const UploadAvatarErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class UpdateProfileErrorState extends ProfileState {
  final String message;
  const UpdateProfileErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
