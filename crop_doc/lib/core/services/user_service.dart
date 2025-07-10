import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl = 'http://10.2.14.163:8000/api';

  Future<http.Response> registerUser({
    required String username,
    required String country,
    String? county,
    required String role,
    required bool consent,
  }) {
    return http.post(
      Uri.parse('$baseUrl/users/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'country': country,
        'county': county,
        'role': role,
        'consent': consent,
      }),
    );
  }
}
