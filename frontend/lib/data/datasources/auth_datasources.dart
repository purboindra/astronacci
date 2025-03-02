import 'dart:convert';
import 'dart:developer';

import 'package:frontend/data/failures/error_message.dart';
import 'package:frontend/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RequestAuthFailure implements Exception {
  final String message;

  RequestAuthFailure([this.message = AppErrorMessage.unknownError]);
}

class AuthDatasources {
  AuthDatasources({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  static const url = "$baseUrl/api/auth";

  Future<http.Response> register({
    required String email,
    required String name,
    required String address,
    required String age,
    required String password,
  }) async {
    try {
      final response = await _httpClient.post(
        Uri.parse("$url/register"),
        body: jsonEncode({
          "email": email,
          "name": name,
          "address": address,
          "age": age,
          "password": password,
        }),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        final responseBody = json.decode(response.body);
        throw RequestAuthFailure(
          responseBody["message"] ?? AppErrorMessage.unknownError,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> login({
    required String email,
    required String password,
  }) async {
    final body = jsonEncode({"email": email, "password": password});

    try {
      final response = await _httpClient.post(
        Uri.parse("$url/login"),
        body: body,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        final responseBody = json.decode(response.body);
        throw RequestAuthFailure(
          responseBody["message"] ?? AppErrorMessage.unknownError,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> logout() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final token = prefs.getString("access_token");

      log("Token: $token");

      final response = await _httpClient.post(
        Uri.parse("$url/logout"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        final responseBody = json.decode(response.body);
        throw RequestAuthFailure(
          responseBody["message"] ?? AppErrorMessage.unknownError,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
