import 'package:equatable/equatable.dart';

sealed class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object?> get props => [];
}

class AddBulkUserEvent extends MainEvent {
  final int userCount;
  const AddBulkUserEvent(this.userCount);

  @override
  List<Object> get props => [userCount];
}

class FetchPaginationUsersEvent extends MainEvent {
  final int page;
  final int limit;
  const FetchPaginationUsersEvent(this.page, this.limit);

  @override
  List<Object> get props => [page, limit];
}

class SearchUsersEvent extends MainEvent {
  final String query;

  const SearchUsersEvent({required this.query});

  @override
  List<Object> get props => [query];
}
