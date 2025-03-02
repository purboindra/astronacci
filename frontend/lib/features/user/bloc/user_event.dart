import 'package:equatable/equatable.dart';

class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class FetchDetailUserEvent extends UserEvent {
  final String id;

  const FetchDetailUserEvent({required this.id});
}
