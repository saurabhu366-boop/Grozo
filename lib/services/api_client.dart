import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'api_exception.dart';

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  // ================= GET =================
  Future<dynamic> get(String endpoint) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final headers = await ApiConfig.getAuthHeaders();

      final response = await _client
          .get(uri, headers: headers)
          .timeout(ApiConfig.connectionTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException.networkError();
    } on HttpException {
      throw ApiException.serverError();
    } catch (e) {
      throw ApiException(message: 'Unexpected error: $e');
    }
  }

  // ================= POST =================
  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final headers = await ApiConfig.getAuthHeaders();

      final response = await _client
          .post(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.connectionTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException.networkError();
    } on HttpException {
      throw ApiException.serverError();
    } catch (e) {
      throw ApiException(message: 'Unexpected error: $e');
    }
  }

  // ================= PUT =================
  Future<dynamic> put(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final headers = await ApiConfig.getAuthHeaders();

      final response = await _client
          .put(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.connectionTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException.networkError();
    } on HttpException {
      throw ApiException.serverError();
    } catch (e) {
      throw ApiException(message: 'Unexpected error: $e');
    }
  }

  // ================= DELETE =================
  Future<dynamic> delete(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final headers = await ApiConfig.getAuthHeaders();

      final response = await _client
          .delete(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.connectionTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException.networkError();
    } on HttpException {
      throw ApiException.serverError();
    } catch (e) {
      throw ApiException(message: 'Unexpected error: $e');
    }
  }

  // ================= RESPONSE HANDLER =================
  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else if (statusCode == 400) {
      throw ApiException.badRequest(_extractErrorMessage(response));
    } else if (statusCode == 401) {
      throw ApiException.unauthorized();
    } else if (statusCode == 404) {
      throw ApiException.notFound();
    } else if (statusCode >= 500) {
      throw ApiException.serverError();
    } else {
      throw ApiException(
        message: _extractErrorMessage(response),
        statusCode: statusCode,
      );
    }
  }

  String _extractErrorMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      if (body is Map<String, dynamic>) {
        return body['message'] ?? body['error'] ?? 'An error occurred';
      }
      return response.body;
    } catch (e) {
      return 'An error occurred';
    }
  }

  void dispose() {
    _client.close();
  }
}
