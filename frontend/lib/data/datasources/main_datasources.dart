import 'dart:convert';
import 'dart:developer';

import 'package:frontend/data/datasources/auth_datasources.dart';
import 'package:frontend/data/failures/error_message.dart';
import 'package:frontend/utils/constants.dart';
import 'package:http/http.dart' as http;

class MainDatasources {
  MainDatasources({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  static const baseAuthUrl = "$baseUrl/api/auth";

  Future<http.Response> getUsers({String? query, int? page, int? limit}) async {
    try {
      Map<String, dynamic> queryParameters = {};

      queryParameters["page"] = (page ?? 1).toString();
      queryParameters["limit"] = (limit ?? 10).toString();

      if (query != null) {
        queryParameters["query"] = query;
      }

      log("queryParameters: $queryParameters");

      final uri = Uri.http("$ipAddress:3000", "/api/users", queryParameters);

      final response = await _httpClient.get(
        uri,
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
    } catch (e, st) {
      log("Error: $e $st");
      rethrow;
    }
  }

  Future<http.Response> addBulkUser({required int userCount}) async {
    String? errorMessage;

    final now = DateTime.now().millisecondsSinceEpoch;
    try {
      for (int i = 0; i < userCount; i++) {
        final email = "purboindra$now$i@gmail.com";
        final name = "purbo$i";
        final address = "Jalan hello world $i";
        final age = i + 1 * 10;
        final password = "qwerty";

        final response = await _httpClient.post(
          Uri.parse("$baseAuthUrl/register"),
          body: jsonEncode({
            "email": email,
            "name": name,
            "address": address,
            "age": age,
            "password": password,
          }),
          headers: {"Content-Type": "application/json"},
        );

        if (response.statusCode != 201) {
          final error = jsonDecode(response.body);
          errorMessage = error["message"] ?? AppErrorMessage.unknownError;
          break;
        }
      }

      if (errorMessage == null) {
        return http.Response("", 200);
      }

      throw RequestAuthFailure(errorMessage);
    } catch (e) {
      rethrow;
    }
  }
}
