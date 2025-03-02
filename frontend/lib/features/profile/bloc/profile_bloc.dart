import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/models/response_model.dart';
import 'package:frontend/features/profile/bloc/profile_event.dart';
import 'package:frontend/features/profile/bloc/profile_state.dart';
import 'package:frontend/repositories/auth_repository.dart';
import 'package:frontend/repositories/user_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this._userRepository, this._authRepository)
    : super(ProfileInitialState()) {
    on<UploadAvatarEvent>(_uploadAvatar);
    on<UpdateProfileEvent>(_updateProfile);
    on<LogoutEvent>(_logout);
  }

  void _uploadAvatar(
    UploadAvatarEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(UploadAvatarLoadingState());

    final result = await _userRepository.uploadAvatar(
      id: event.userId,
      file: event.file,
    );

    if (result is Success) {
      final data = jsonDecode(result.data);
      emit(
        UploadAvatarSuccessState(
          avatarUrl: data["avatar"] ?? "Avatar uploaded successfully",
        ),
      );
    } else if (result is Error) {
      emit(UploadAvatarErrorState(message: result.message));
    }
  }

  void _updateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(UpdateProfileLoadingState());

    final result = await _userRepository.updateProfile(
      id: event.id,
      address: event.address,
      age: event.age,
      name: event.name,
    );

    if (result is Success) {
      emit(UpdateProfileSuccessState(message: "Profile updated successfully"));
    } else if (result is Error) {
      emit(UpdateProfileErrorState(message: result.message));
    }
  }

  void _logout(LogoutEvent event, Emitter emit) async {
    emit(LogoutLoadingState());
    final result = await _authRepository.logout();
    if (result is Success) {
      emit(LogoutSuccessState(message: "Logout successfully"));
    }
  }

  final UserRepository _userRepository;
  final AuthRepository _authRepository;
}
