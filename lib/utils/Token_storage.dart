// ─────────────────────────────────────────────────────────────
// lib/utils/token_storage.dart
//
// Persists the JWT token & user info locally using shared_preferences.
// Add to pubspec.yaml:
//   dependencies:
//     shared_preferences: ^2.2.2
// ─────────────────────────────────────────────────────────────

import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _keyToken = 'auth_token';
  static const _keyUserId = 'user_id';
  static const _keyEmail = 'user_email';
  static const _keyFullName = 'user_full_name';

  // ── Save ─────────────────────────────────────────────────
  static Future<void> saveAuthData({
    required String token,
    required String userId,
    required String email,
    required String fullName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyUserId, userId);
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyFullName, fullName);
  }

  // ── Read ─────────────────────────────────────────────────
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  static Future<String?> getFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyFullName);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ── Clear (logout) ────────────────────────────────────────
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyFullName);
  }
}