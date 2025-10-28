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
    this.isAuthenticated = false,
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

  AuthNotifier(this.userBox) : super(AuthState()) {
    _loadUserOnStartup();
  }

  /// Run once when the notifier is created
  Future<void> _loadUserOnStartup() async {
    print("🚀 AuthNotifier starting up...");
    await loadFromHive();
  }

  /// 🔹 Load user from Hive (offline)
  Future<void> loadFromHive() async {
    print("🔍 Checking Hive user...");
    if (userBox.isNotEmpty) {
      final user = userBox.getAt(0);
      print("📦 Found user in Hive: $user");
      if (user != null) {
        state = state.copyWith(user: user, isAuthenticated: true);
        print("✅ User authenticated from Hive");
      }
    } else {
      print("❌ Hive empty, user not found");
    }
  }

  Future<void> setUser(UserModel data) async {
    print("setUser() called");

    try {
      await userBox.clear();
      print("userBox cleared");

      await userBox.add(data);
      print("user added to Hive");

      state = state.copyWith(user: data, isAuthenticated: true);
      print("state updated inside setUser: ${state.isAuthenticated}");
    } catch (e, st) {
      print("SETUSER ERROR: $e");
      print(st);
    }
  }

  /// 🔹 Register user via /api/users/
  Future<void> register({
    required String name,
    required String email,
    required String country,
    required String county,
    required String role,
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
          'role': role,
          'consent': true,
        }),
      );

      if (res.statusCode == 201 || res.statusCode == 200) {
        final data = jsonDecode(res.body);

        print("WE HERE");
        print("Before ${state.isAuthenticated}");

        final userdata = UserModel(
          id: data['user_id'],
          name: data['name'],
          email: data['name'], // placeholder for backend gap
          country: data['country'],
          county: data['county'],
        );

        print("About to call setUser() with $userdata");
        await setUser(userdata);

        print("After ${state.isAuthenticated}");
        print("User data: ${state.user}");
      } else {
        state = state.copyWith(
          error: 'Failed to register user (${res.statusCode})',
        );
      }
    } catch (e, st) {
      print("REGISTER ERROR: $e");
      print(st);
      state = state.copyWith(error: e.toString());
    }
  }

  /// 🔹 Logout clears Hive user and resets state
  Future<void> logout() async {
    try {
      await userBox.clear();
      state = AuthState(isAuthenticated: false);
      print('🚪 User logged out successfully');
    } catch (e) {
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
