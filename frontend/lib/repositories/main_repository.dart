import 'package:frontend/data/datasources/auth_datasources.dart';
import 'package:frontend/data/datasources/main_datasources.dart';
import 'package:frontend/data/models/response_model.dart';

class MainRepository {
  MainRepository({MainDatasources? mainDatasources})
    : _mainDatasources = mainDatasources ?? MainDatasources();

  final MainDatasources _mainDatasources;

  Future<ResponseModel> getUsers({String? query, int? page, int? limit}) async {
    try {
      final response = await _mainDatasources.getUsers(
        limit: limit,
        page: page,
        query: query,
      );
      return Success(response.body);
    } on RequestAuthFailure catch (e) {
      return Error(e.message);
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<ResponseModel> addBulkUser({required int userCount}) async {
    try {
      final response = await _mainDatasources.addBulkUser(userCount: userCount);
      return Success(response.body);
    } on RequestAuthFailure catch (e) {
      return Error(e.message);
    } catch (e) {
      return Error(e.toString());
    }
  }
}
