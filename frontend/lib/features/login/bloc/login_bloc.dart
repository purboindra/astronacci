import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/models/response_model.dart';
import 'package:frontend/features/login/bloc/login_event.dart';
import 'package:frontend/features/login/bloc/login_state.dart';
import 'package:frontend/repositories/auth_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._authRepository) : super(LoginInitial()) {
    on<SubmitLoginEvent>(login);
  }

  void login(SubmitLoginEvent event, Emitter emit) async {
    emit(LoginLoading());
    final result = await _authRepository.login(
      email: event.email,
      password: event.password,
    );

    if (result is Success) {
      emit(LoginSuccess(result.data));
    } else if (result is Error) {
      emit(LoginError(result.message));
    }
  }

  final AuthRepository _authRepository;
}
