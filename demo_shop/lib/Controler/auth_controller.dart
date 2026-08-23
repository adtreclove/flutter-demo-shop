import 'package:demo_shop/Models/AuthUser.dart';
import 'package:demo_shop/Services/ApiService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// null = logged out
class AuthNotifier extends StateNotifier<AsyncValue<AuthUser?>> {
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
      final user = AuthUser.fromJson({
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

  /// Returns true on success, false on failure. Deliberately does NOT
  /// set `state = AsyncValue.loading()` while the request is in flight —
  /// since MyApp watches this provider to decide whether to show
  /// LoginScreen or AppShell, flipping to loading mid-request would
  /// unmount LoginScreen (and this exact login() call along with it)
  /// before the request even finishes.
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await ApiService.instance.post(
        '/auth/login',
        body: {'username': username, 'password': password, 'expiresInMins': 60},
      );

      final user = AuthUser.fromJson(response as Map<String, dynamic>);

      ApiService.instance.setAuthToken(user.accessToken);
      await _persistToken(user.accessToken, user.refreshToken);

      // Only touch state on success — this is the one point where it's
      // safe for the root widget to swap away from LoginScreen, since
      // the request is fully done by now.
      state = AsyncValue.data(user);
      return true;
    } catch (_) {
      return false;
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

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<AuthUser?>>(
  (ref) => AuthNotifier(),
);

/// Convenience: quick sync check for whether someone is logged in,
/// without having to unwrap AsyncValue everywhere (e.g. in a drawer to
/// conditionally show "Login" vs "Logout").
final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).value != null;
});
