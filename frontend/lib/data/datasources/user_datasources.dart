import 'dart:convert';
import 'dart:developer';

import 'package:frontend/data/datasources/auth_datasources.dart';
import 'package:frontend/data/failures/error_message.dart';
import 'package:http/http.dart' as http;

class UserDatasources {
  UserDatasources({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  static const baseUrl = "http://192.168.1.7:3000/api/users";

  Future<http.Response> fetchUserById({required String id}) async {
    try {
      final response = await _httpClient.get(
        Uri.parse("$baseUrl/$id"),
        headers: {"Content-Type": "application/json"},
      );

      final data = jsonDecode(response.body);

      log("data: $data");

      if (response.statusCode != 200) {
        throw RequestAuthFailure(
          data["message"] ?? AppErrorMessage.unknownError,
        );
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
