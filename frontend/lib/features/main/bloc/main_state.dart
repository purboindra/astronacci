import 'package:frontend/data/models/user_model.dart';

sealed class MainState {}

class MainInitial extends MainState {}

class MainLoading extends MainState {}

class MainSuccess extends MainState {
  final List<UserModel> users;
  final bool hasMore;
  final String message;
  final int currentPage;
  final int totalPages;

  MainSuccess({
    required this.users,
    required this.hasMore,
    required this.message,
    required this.currentPage,
    required this.totalPages,
  });
}

class MainError extends MainState {
  final String message;
  MainError(this.message);
}

class AddBulkUsersSuccess extends MainState {
  final String message;
  AddBulkUsersSuccess(this.message);
}

class AddBulkUsersError extends MainState {
  final String message;
  AddBulkUsersError(this.message);
}
