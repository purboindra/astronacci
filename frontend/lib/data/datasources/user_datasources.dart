import 'dart:convert';
import 'dart:developer';

import 'package:frontend/data/datasources/auth_datasources.dart';
import 'package:frontend/data/failures/error_message.dart';
import 'package:frontend/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class UserDatasources {
  UserDatasources({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  static const url = "$baseUrl/api/users";

  Future<http.Response> fetchUserById({required String id}) async {
    try {
      final response = await _httpClient.get(
        Uri.parse("$url/$id"),
        headers: {"Content-Type": "application/json"},
      );

      final data = jsonDecode(response.body);

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

  Future<http.Response> deleteUser({required String id}) async {
    try {
      final response = await _httpClient.delete(
        Uri.parse("$url/$id"),
        headers: {"Content-Type": "application/json"},
      );

      final data = jsonDecode(response.body);

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

  Future<http.Response> uploadAvatar({
    required String id,
    required XFile file,
  }) async {
    try {
      final uri = Uri.parse("$url/upload-avatar/$id");

      var request =
          http.MultipartRequest("POST", uri)
            ..headers["Content-Type"] = "multipart/form-data"
            ..files.add(
              await http.MultipartFile.fromPath(
                'avatar',
                file.path,
                contentType: MediaType('image', 'jpeg'),
              ),
            );

      final streamedResponse = await request.send();

      final response = await http.Response.fromStream(streamedResponse);

      log("Response status: ${response.statusCode}");
      log("Response body: ${response.body}");

      if (response.statusCode != 200) {
        throw RequestAuthFailure(AppErrorMessage.unknownError);
      }

      return response;
    } catch (e, st) {
      log("error: $e $st");
      rethrow;
    }
  }

  Future<http.Response> updateProfile({
    String? name,
    String? address,
    String? age,
    required String id,
  }) async {
    try {
      Map<String, dynamic> body = {};

      body.addAll({
        if (name != null) "name": name,
        if (address != null) "address": address,
        if (age != null) "age": age,
      });

      final response = await _httpClient.put(
        Uri.parse("$url/$id"),
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json"},
      );

      log("response: ${response.body} == ${response.statusCode}");

      final data = jsonDecode(response.body);

      log("data: $data");

      if (response.statusCode != 200) {
        throw RequestAuthFailure(
          data["message"] ?? AppErrorMessage.unknownError,
        );
      }

      return response;
    } catch (e, st) {
      log("error update profile: $e $st");
      rethrow;
    }
  }
}
