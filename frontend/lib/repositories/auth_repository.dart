import 'dart:convert';

import 'package:frontend/data/datasources/auth_datasources.dart';
import 'package:frontend/data/models/response_model.dart';

class AuthRepository {
  AuthRepository({AuthDatasources? authDatasources})
    : _authDatasources = authDatasources ?? AuthDatasources();

  final AuthDatasources _authDatasources;

  Future<ResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authDatasources.login(
        email: email,
        password: password,
      );
      final body = json.decode(response.body);
      return Success(body);
    } on RequestAuthFailure catch (e) {
      return Error(e.message);
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<ResponseModel> register({
    required String email,
    required String name,
    required String address,
    required String age,
    required String password,
  }) async {
    try {
      final response = await _authDatasources.register(
        email: email,
        name: name,
        address: address,
        age: age,
        password: password,
      );
      final body = json.decode(response.body);
      return Success(body);
    } on RequestAuthFailure catch (e) {
      return Error(e.message);
    } catch (e) {
      return Error(e.toString());
    }
  }
}
