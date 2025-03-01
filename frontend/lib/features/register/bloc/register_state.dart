sealed class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final Map<String, dynamic> data;

  RegisterSuccess(this.data);
}

class RegisterError extends RegisterState {
  final String message;
  RegisterError(this.message);
}
