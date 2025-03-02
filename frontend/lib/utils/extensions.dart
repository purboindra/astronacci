import 'dart:convert';

extension StringExtension on String {
  String decodeToken() {
    List<String> parts = split('.');
    if (parts.length != 3) {
      throw Exception("Invalid JWT token");
    }

    String payload = parts[1];
    String normalized = base64Url.normalize(payload);
    String decoded = utf8.decode(base64Url.decode(normalized));

    return decoded;
  }
}
