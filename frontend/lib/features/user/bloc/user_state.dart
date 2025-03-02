import 'package:equatable/equatable.dart';
import 'package:frontend/data/models/user_model.dart';

class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class FetchDetailInitialState extends UserState {}

class FetchDetailLoadingState extends UserState {}

class FetchDetailSuccessState extends UserState {
  final UserModel userModel;

  const FetchDetailSuccessState({required this.userModel});
}

class FetchDetailErrorState extends UserState {
  final String message;

  const FetchDetailErrorState({required this.message});
}
