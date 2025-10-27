import 'dart:convert';
import 'package:crop_doc/core/constants/app_strings.dart';
import 'package:crop_doc/core/providers/model_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:crop_doc/core/database/models/user_model.dart';

/// ---------------------------
/// 🔹 AUTH STATE
/// ---------------------------
class AuthState {
  final bool isAuthenticated;
  final UserModel? user;
  final bool isLoading;
  final String? error;

  AuthState({
    required this.isAuthenticated,
    this.user,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    UserModel? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// ---------------------------
/// 🔹 AUTH NOTIFIER
/// ---------------------------
class AuthNotifier extends StateNotifier<AuthState> {
  final Box<UserModel> userBox;

  AuthNotifier(this.userBox) : super(AuthState(isAuthenticated: false));

  /// 🔹 Load user from Hive (offline)
  Future<void> loadFromHive() async {
    final cached = userBox.get('current_user');
    if (cached != null) {
      state = state.copyWith(user: cached, isAuthenticated: true);
    } else {
      state = AuthState(isAuthenticated: false);
    }
  }

  /// 🔹 Register user via /api/users/
  Future<void> register({
    required String name,
    required String email,
    required String country,
    required String county,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final url = Uri.parse('$baseUrl/api/users/');
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'country': country,
          'county': county,
        }),
      );

      if (res.statusCode == 201 || res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final user = UserModel(
          id: data['id'],
          name: data['name'],
          email: data['email'],
          country: data['country'],
          county: data['county'],
          isSynced: true,
        );

        await userBox.put('current_user', user);
        state = state.copyWith(user: user, isAuthenticated: true);
      } else {
        state = state.copyWith(
          error: 'Failed to register user (${res.statusCode})',
        );
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// 🔹 Login by matching email in /api/users/
  Future<void> login(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final url = Uri.parse('$baseUrl/api/users/');
      final res = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as List;

        final found = data.firstWhere(
          (u) => u['email'] == email,
          orElse: () => {},
        );

        if (found.isNotEmpty) {
          final user = UserModel(
            id: found['id'],
            name: found['name'],
            email: found['email'],
            country: found['country'],
            county: found['county'],
            isSynced: true,
          );

          await userBox.put('current_user', user);
          state = state.copyWith(user: user, isAuthenticated: true);
        } else {
          state = state.copyWith(error: 'User not found');
        }
      } else {
        state = state.copyWith(error: 'Login failed (${res.statusCode})');
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// 🔹 Logout clears Hive user and resets state
  Future<void> logout() async {
    try {
      // Remove the cached user from Hive
      await userBox.delete('current_user');

      // Reset auth state
      state = AuthState(isAuthenticated: false);

      // Optional: log for debugging
      print('User logged out successfully');
    } catch (e) {
      // Optional: handle Hive errors
      state = state.copyWith(error: 'Logout failed: $e');
    }
  }
}

/// ---------------------------
/// 🔹 AUTH PROVIDER
/// ---------------------------
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final userBox = ref.watch(userBoxProvider);
  return AuthNotifier(userBox);
});
