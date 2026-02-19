// ─────────────────────────────────────────────────────────────
// lib/providers/auth_provider.dart
//
// ChangeNotifier that wraps AuthService.
// Exposes:  isLoading, isLoggedIn, currentUser, errorMessage
//
// Usage in main.dart:
//   ChangeNotifierProvider(create: (_) => AuthProvider()..init()),
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

import '../models/auth_models.dart';
import '../services/auth_service.dart';
import '../utils/Token_storage.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthProvider({AuthService? authService})
      : _authService = authService ?? AuthService();

  // ── State ─────────────────────────────────────────────────
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _userId;
  String? _email;
  String? _fullName;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get userId => _userId;
  String? get email => _email;
  String? get fullName => _fullName;
  String? get errorMessage => _errorMessage;

  // ── Init: restore session on app start ───────────────────
  Future<void> init() async {
    _isLoggedIn = await TokenStorage.isLoggedIn();
    if (_isLoggedIn) {
      _userId = await TokenStorage.getUserId();
      _email = await TokenStorage.getEmail();
      _fullName = await TokenStorage.getFullName();
    }
    notifyListeners();
  }

  // ── Register ──────────────────────────────────────────────
  /// Returns true on success, false on failure (check [errorMessage]).
  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final response = await _authService.register(RegisterRequest(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
      ));
      _applyAuthResponse(response);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── Login ─────────────────────────────────────────────────
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final response = await _authService.login(
          LoginRequest(email: email, password: password));
      _applyAuthResponse(response);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── Logout ────────────────────────────────────────────────
  Future<void> logout() async {
    await _authService.logout();
    _isLoggedIn = false;
    _userId = null;
    _email = null;
    _fullName = null;
    _errorMessage = null;
    notifyListeners();
  }

  // ── Helpers ───────────────────────────────────────────────
  void _applyAuthResponse(AuthResponse r) {
    _isLoggedIn = true;
    _userId = r.userId;
    _email = r.email;
    _fullName = r.fullName;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}