import 'dart:convert';
import 'dart:developer';

import 'package:frontend/data/failures/error_message.dart';
import 'package:http/http.dart' as http;

class RequestAuthFailure implements Exception {
  final String message;

  RequestAuthFailure([this.message = AppErrorMessage.unknownError]);
}

class AuthDatasources {
  AuthDatasources({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  static const baseUrl = "http://192.168.1.7:3000/api/auth";

  Future<http.Response> register({
    required String email,
    required String name,
    required String address,
    required String age,
    required String password,
  }) async {
    try {
      final response = await _httpClient.post(
        Uri.parse("$baseUrl/register"),
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
    log("authdatasource email: $email, password: $password");

    final body = jsonEncode({"email": email, "password": password});

    log("body: $body");

    try {
      final response = await _httpClient.post(
        Uri.parse("$baseUrl/login"),
        body: body,
        headers: {"Content-Type": "application/json"},
      );

      log("response: ${response.body}");

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
