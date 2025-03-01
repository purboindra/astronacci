import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/models/response_model.dart';
import 'package:frontend/features/register/bloc/register_event.dart';
import 'package:frontend/features/register/bloc/register_state.dart';
import 'package:frontend/repositories/auth_repository.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc(this._authRepository) : super(RegisterInitial()) {
    on<SubmitRegisterEvent>(_register);
  }

  void _register(SubmitRegisterEvent event, Emitter emit) async {
    emit(RegisterLoading());
    final result = await _authRepository.register(
      email: event.email,
      name: event.name,
      address: event.address,
      age: event.age,
      password: event.password,
    );
    if (result is Success) {
      emit(RegisterSuccess(result.data));
    } else if (result is Error) {
      emit(RegisterError(result.message));
    }
  }

  final AuthRepository _authRepository;
}
