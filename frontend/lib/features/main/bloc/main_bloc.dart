import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/models/response_model.dart';
import 'package:frontend/data/models/user_model.dart';
import 'package:frontend/features/main/bloc/main_event.dart';
import 'package:frontend/features/main/bloc/main_state.dart';
import 'package:frontend/repositories/main_repository.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc(this._mainRepository) : super(MainInitial()) {
    on<AddBulkUserEvent>(_addUsersBulk);
    on<FetchPaginationUsersEvent>(_fetchPaginationUsers);
    on<SearchUsersEvent>(_searchUsers);
  }

  void _addUsersBulk(AddBulkUserEvent event, Emitter emit) async {
    emit(MainLoading());
    final result = await _mainRepository.addBulkUser(
      userCount: event.userCount,
    );

    if (result is Success) {
      emit(AddBulkUsersSuccess("Successfully added ${event.userCount} users"));
    } else if (result is Error) {
      emit(AddBulkUsersError(result.message));
    }
  }

  void _fetchPaginationUsers(
    FetchPaginationUsersEvent event,
    Emitter emit,
  ) async {
    emit(MainLoading());
    final result = await _mainRepository.getUsers(
      limit: event.limit,
      page: event.page,
    );

    log("result: $result");

    if (result is Success) {
      final data = jsonDecode(result.data);
      final userList = List.from(data["users"]);
      final parsedUsers = userList.map((e) => UserModel.fromJson(e)).toList();

      final totalPages = data["totalPages"] ?? 1;
      final currentPage = event.page;
      emit(
        MainSuccess(
          hasMore: true,
          message: "",
          users: parsedUsers,
          currentPage: currentPage,
          totalPages: totalPages,
        ),
      );
    } else if (result is Error) {
      emit(MainError(result.message));
    }
  }

  void _searchUsers(SearchUsersEvent event, Emitter emit) async {
    emit(MainLoading());
    final result = await _mainRepository.getUsers(query: event.query);

    if (result is Success) {
      final data = jsonDecode(result.data);
      final userList = List.from(data["users"]);
      final parsedUsers = userList.map((e) => UserModel.fromJson(e)).toList();
      final totalPages = data["totalPages"] ?? 1;
      final currentPage = data["page"] ?? 1;
      emit(
        MainSuccess(
          hasMore: true,
          message: "",
          users: parsedUsers,
          currentPage: currentPage,
          totalPages: totalPages,
        ),
      );
    } else if (result is Error) {
      emit(MainError(result.message));
    }
  }

  final MainRepository _mainRepository;
}
