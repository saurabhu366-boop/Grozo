// ─────────────────────────────────────────────────────────────
// lib/services/auth_service.dart
//
// Calls POST /api/auth/register  and  POST /api/auth/login
// Persists the returned JWT via TokenStorage.
// ─────────────────────────────────────────────────────────────

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/auth_models.dart';
import '../utils/Token_storage.dart';

/// Change this to match your running backend:
/// - Android emulator  →  http://10.0.2.2:8087
/// - iOS simulator     →  http://127.0.0.1:8087
/// - Real device       →  http://<YOUR_PC_LAN_IP>:8087
const String kBaseUrl = 'http://192.168.0.104:8087';

class AuthService {
  final String baseUrl;

  AuthService({String? baseUrl}) : baseUrl = baseUrl ?? kBaseUrl;

  // ────────────────────────────────────────────────────────────
  // REGISTER
  // ────────────────────────────────────────────────────────────
  /// Registers a new user. Returns [AuthResponse] with JWT on success.
  /// Throws a descriptive [Exception] on failure.
  Future<AuthResponse> register(RegisterRequest request) async {
    final uri = Uri.parse('$baseUrl/api/auth/register');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final auth = AuthResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      // Persist credentials locally
      await TokenStorage.saveAuthData(
        token: auth.token,
        userId: auth.userId,
        email: auth.email,
        fullName: auth.fullName,
      );
      return auth;
    }

    // Surface the backend error message (e.g. "Email already registered")
    _throwFromResponse(response);
    throw Exception('Registration failed'); // unreachable
  }

  // ────────────────────────────────────────────────────────────
  // LOGIN
  // ────────────────────────────────────────────────────────────
  /// Logs in an existing user. Returns [AuthResponse] with JWT on success.
  Future<AuthResponse> login(LoginRequest request) async {
    final uri = Uri.parse('$baseUrl/api/auth/login');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final auth = AuthResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      await TokenStorage.saveAuthData(
        token: auth.token,
        userId: auth.userId,
        email: auth.email,
        fullName: auth.fullName,
      );
      return auth;
    }

    _throwFromResponse(response);
    throw Exception('Login failed'); // unreachable
  }

  // ────────────────────────────────────────────────────────────
  // LOGOUT
  // ────────────────────────────────────────────────────────────
  Future<void> logout() async {
    await TokenStorage.clearAll();
  }

  // ────────────────────────────────────────────────────────────
  // HELPERS
  // ────────────────────────────────────────────────────────────
  void _throwFromResponse(http.Response response) {
    String message = 'Something went wrong (${response.statusCode})';
    try {
      final body = jsonDecode(response.body);
      if (body is Map && body.containsKey('message')) {
        message = body['message'] as String;
      } else if (body is Map && body.containsKey('error')) {
        message = body['error'] as String;
      } else if (response.body.isNotEmpty) {
        message = response.body;
      }
    } catch (_) {
      if (response.body.isNotEmpty) message = response.body;
    }
    throw Exception(message);
  }
}