import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/models/response_model.dart';
import 'package:frontend/data/models/user_model.dart';
import 'package:frontend/features/user/bloc/user_event.dart';
import 'package:frontend/features/user/bloc/user_state.dart';
import 'package:frontend/repositories/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc(this._userRepository) : super(FetchDetailInitialState()) {
    on<FetchDetailUserEvent>(_fetchDetailUser);
  }

  void _fetchDetailUser(FetchDetailUserEvent event, Emitter emit) async {
    emit(FetchDetailLoadingState());
    try {
      final result = await _userRepository.fetchUserById(id: event.id);

      if (result is Success) {
        final data = jsonDecode(result.data);
        final user = UserModel.fromJson(data);
        emit(FetchDetailSuccessState(userModel: user));
      } else if (result is Error) {
        emit(FetchDetailErrorState(message: result.message));
      }
    } catch (e) {
      log("Error: $e");
      emit(FetchDetailErrorState(message: e.toString()));
    }
  }

  final UserRepository _userRepository;
}
