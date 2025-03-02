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

class AddBulkUserInitial extends RegisterState {}

class AddBulkUserLoading extends RegisterState {}

class AddBulkUserSuccess extends RegisterState {
  final Map<String, dynamic> data;
  AddBulkUserSuccess(this.data);
}

class AddBulkError extends RegisterState {
  final String message;
  AddBulkError(this.message);
}
