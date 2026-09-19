import 'package:demo_shop/Models/user_model.dart';
import 'package:demo_shop/Services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LoginResult {
  success,
  missingCredentials,
  invalidCredentials,
  unexpectedError,
}

/// null = logged out
class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  AuthNotifier() : super(const AsyncValue.loading()) {
    _tryRestoreSession();
  }

  static const _tokenKey = 'auth_access_token';
  static const _refreshTokenKey = 'auth_refresh_token';

  /// Runs once on app startup. Checks for a saved token
  Future<void> _tryRestoreSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      final refreshToken = prefs.getString(_refreshTokenKey);

      if (token == null) {
        state = const AsyncValue.data(null);
        return;
      }

      ApiService.instance.setAuthToken(token);

      final response = await ApiService.instance.get('/auth/me');
      final user = User.fromJson({
        ...response as Map<String, dynamic>,
        'accessToken': token,
        'refreshToken': refreshToken ?? '',
      });

      state = AsyncValue.data(user);
    } catch (_) {
      // Token missing/expired/invalid
      await _clearStoredToken();
      ApiService.instance.clearAuthToken();
      state = const AsyncValue.data(null);
    }
  }

  Future<LoginResult> login({
    required String username,
    required String password,
  }) async {
    if (username.isEmpty || password.isEmpty) {
      return LoginResult.missingCredentials;
    }

    try {
      final response = await ApiService.instance.post(
        '/auth/login',
        body: {'username': username, 'password': password, 'expiresInMins': 60},
      );

      final user = User.fromJson(response as Map<String, dynamic>);

      ApiService.instance.setAuthToken(user.accessToken);
      await _persistToken(user.accessToken, user.refreshToken);

      // Only touch state on success, since this is the one point where it's
      // safe for the root widget to swap away from LoginScreen.
      state = AsyncValue.data(user);
      return LoginResult.success;
    } on ApiException {
      return LoginResult.invalidCredentials;
    } catch (_) {
      // No connection, timeout, unexpected response format, etc.
      return LoginResult.unexpectedError;
    }
  }

  Future<void> logout() async {
    ApiService.instance.clearAuthToken();
    await _clearStoredToken();
    state = const AsyncValue.data(null);
  }

  Future<void> _persistToken(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  Future<void> _clearStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>(
  (ref) => AuthNotifier(),
);

/// Convenience: quick sync check for whether someone is logged in,
/// without having to unwrap AsyncValue everywhere
final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).value != null;
});
