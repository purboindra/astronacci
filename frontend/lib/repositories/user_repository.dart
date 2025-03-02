import 'package:frontend/data/datasources/auth_datasources.dart';
import 'package:frontend/data/datasources/user_datasources.dart';
import 'package:frontend/data/models/response_model.dart';
import 'package:image_picker/image_picker.dart';

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

  Future<ResponseModel> uploadAvatar({
    required String id,
    required XFile file,
  }) async {
    try {
      final response = await _userDatasources.uploadAvatar(id: id, file: file);
      return Success(response.body);
    } on RequestAuthFailure catch (e) {
      return Error(e.message);
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<ResponseModel> updateProfile({
    String? name,
    String? address,
    String? age,
    required String id,
  }) async {
    try {
      final response = await _userDatasources.updateProfile(
        id: id,
        address: address,
        age: age,
        name: name,
      );
      return Success(response.body);
    } on RequestAuthFailure catch (e) {
      return Error(e.message);
    } catch (e) {
      return Error(e.toString());
    }
  }
}
