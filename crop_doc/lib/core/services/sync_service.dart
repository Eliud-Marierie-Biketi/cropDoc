import 'dart:convert';
import 'package:crop_doc/core/database/app_database.dart';
import 'package:http/http.dart' as http;

const baseUrl = 'http://10.2.14.144:8000/api';

/// Push unsynced users to Django backend
Future<void> syncToServer(AppDatabase db) async {
  final users = await db.getUnsyncedUsers();

  for (final user in users) {
    // Skip if serverId already set
    if (user.serverId != null && user.serverId!.isNotEmpty) continue;

    final res = await http.post(
      Uri.parse('$baseUrl/users/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': user.username,
        'country': user.country,
        'county': user.county,
        'role': user.role,
        'consent': user.consent,
      }),
    );

    if (res.statusCode == 201 || res.statusCode == 200) {
      final responseBody = jsonDecode(res.body);
      final serverId = responseBody['user_id'];

      if (serverId != null) {
        await db.markUserAsSynced(user.id, serverId);
      }
    }
  }
}

/// Pull users from server and store locally
Future<void> syncFromServer(AppDatabase db) async {
  try {
    final localUser = await db.getFirstUser();

    // Only fetch data from server if user exists locally
    if (localUser == null) return;

    final userRes = await http.get(Uri.parse('$baseUrl/users/'));

    if (userRes.statusCode == 200) {
      final List<dynamic> data = jsonDecode(userRes.body);

      for (final item in data) {
        if (item['user_id'] == localUser.serverId) {
          // Optionally update local user data here if needed
        }
      }
    }
  } catch (e) {
    rethrow;
  }
}
