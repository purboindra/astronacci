import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/models/response_model.dart';
import 'package:frontend/features/profile/bloc/profile_event.dart';
import 'package:frontend/features/profile/bloc/profile_state.dart';
import 'package:frontend/repositories/user_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this._userRepository) : super(ProfileInitialState()) {
    on<UploadAvatarEvent>(_uploadAvatar);
    on<UpdateProfileEvent>(_updateProfile);
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

    log("result: $result");

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

  final UserRepository _userRepository;
}
