import 'dart:convert';

import 'package:frontend/data/datasources/auth_datasources.dart';
import 'package:frontend/data/models/response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  AuthRepository({AuthDatasources? authDatasources})
    : _authDatasources = authDatasources ?? AuthDatasources();

  final AuthDatasources _authDatasources;

  Future<ResponseModel> login({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final response = await _authDatasources.login(
        email: email,
        password: password,
      );
      final body = json.decode(response.body);

      await prefs.setString("access_token", body["user"]["access_token"]);

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
    final prefs = await SharedPreferences.getInstance();

    try {
      final response = await _authDatasources.register(
        email: email,
        name: name,
        address: address,
        age: age,
        password: password,
      );
      final body = json.decode(response.body);

      await prefs.setString("access_token", body["user"]["access_token"]);

      return Success(body);
    } on RequestAuthFailure catch (e) {
      return Error(e.message);
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<ResponseModel> logout() async {
    try {
      final response = await _authDatasources.logout();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("access_token");
      return Success(json.decode(response.body));
    } on RequestAuthFailure catch (e) {
      return Error(e.message);
    } catch (e) {
      return Error(e.toString());
    }
  }
}
