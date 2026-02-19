// ─────────────────────────────────────────────────────────────
// lib/models/auth_models.dart
// Mirrors the backend DTOs: RegisterRequest, LoginRequest, AuthResponse
// ─────────────────────────────────────────────────────────────

class RegisterRequest {
  final String email;
  final String password;
  final String fullName;
  final String phoneNumber;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.fullName,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'fullName': fullName,
    'phoneNumber': phoneNumber,
  };
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };
}

class AuthResponse {
  final String token;
  final String email;
  final String fullName;
  final String userId;
  final String message;

  AuthResponse({
    required this.token,
    required this.email,
    required this.fullName,
    required this.userId,
    required this.message,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] as String? ?? '',
      email: json['email'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      message: json['message'] as String? ?? '',
    );
  }
}