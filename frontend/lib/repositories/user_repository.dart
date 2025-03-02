import 'package:frontend/data/datasources/auth_datasources.dart';
import 'package:frontend/data/datasources/user_datasources.dart';
import 'package:frontend/data/models/response_model.dart';

class UserRepository {
  UserRepository({UserDatasources? userDatasources})
    : _userDatasources = userDatasources ?? UserDatasources();

  final UserDatasources _userDatasources;

  Future<ResponseModel> fetchUserById({required String id}) async {
    try {
      final response = await _userDatasources.fetchUserById(id: id);
      return Success(response.body);
    } on RequestAuthFailure catch (e) {
      return Error(e.message);
    } catch (e) {
      return Error(e.toString());
    }
  }
}
