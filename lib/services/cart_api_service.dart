// ─────────────────────────────────────────────────────────────
// lib/services/cart_api_service.dart   (UPDATED – with auth)
//
// Drop-in replacement for the reference cart_api_service.dart.
// Now attaches the JWT token to every request automatically.
// ─────────────────────────────────────────────────────────────

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/token_storage.dart';

const String kCartBaseUrl = 'http://10.0.2.2:8087';

// ── Models ────────────────────────────────────────────────────
class CartItemResponse {
  final String productName;
  final double price;
  final int quantity;

  CartItemResponse({
    required this.productName,
    required this.price,
    required this.quantity,
  });

  factory CartItemResponse.fromJson(Map<String, dynamic> json) {
    return CartItemResponse(
      productName: (json['productName'] as String?) ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as int?) ?? 0,
    );
  }
}

class CartResponse {
  final List<CartItemResponse> items;
  final double totalAmount;

  CartResponse({required this.items, required this.totalAmount});

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'];
    final List<CartItemResponse> items = itemsList is List
        ? itemsList
        .map((e) => CartItemResponse.fromJson(
        e is Map<String, dynamic> ? e : <String, dynamic>{}))
        .toList()
        : [];
    return CartResponse(
      items: items,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

// ── Service ───────────────────────────────────────────────────
class CartApiService {
  final String baseUrl;

  CartApiService({String? baseUrl}) : baseUrl = baseUrl ?? kCartBaseUrl;

  // ── Internal: build headers with Bearer token ─────────────
  Future<Map<String, String>> _authHeaders({bool json = false}) async {
    final token = await TokenStorage.getToken();
    final headers = <String, String>{};
    if (json) headers['Content-Type'] = 'application/json';
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // ── Throws if status is not 2xx, surfaces backend message ──
  void _checkStatus(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;

    String msg = 'Request failed (${response.statusCode})';
    try {
      final body = jsonDecode(response.body);
      if (body is Map && body['message'] != null) msg = body['message'];
    } catch (_) {
      if (response.body.isNotEmpty) msg = response.body;
    }
    throw Exception(msg);
  }

  // ── Scan product ──────────────────────────────────────────
  /// Scans a barcode, adds to cart, returns updated cart.
  Future<CartResponse> scanProduct(
      String barcode,
      String userId, {
        int quantity = 1,
      }) async {
    final uri = Uri.parse('$baseUrl/api/cart/scan');
    final headers = await _authHeaders(json: true);

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode({
        'barcode': barcode,
        'userId': userId,
        'quantity': quantity,
      }),
    );

    _checkStatus(response);
    return CartResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  }

  // ── Get active cart ───────────────────────────────────────
  Future<CartResponse> getCart(String userId) async {
    final uri = Uri.parse('$baseUrl/api/cart/$userId');
    final headers = await _authHeaders();

    final response = await http.get(uri, headers: headers);

    _checkStatus(response);
    return CartResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  }

  // ── Checkout ──────────────────────────────────────────────
  Future<Map<String, dynamic>> checkout(String userId) async {
    final uri = Uri.parse('$baseUrl/api/cart/$userId/checkout');
    final headers = await _authHeaders(json: true);

    final response = await http.post(uri, headers: headers);

    _checkStatus(response);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  // ── Remove product ────────────────────────────────────────
  Future<void> removeProduct(
      String barcode,
      String userId, {
        int quantity = 1,
      }) async {
    final uri = Uri.parse('$baseUrl/api/cart/remove');
    final headers = await _authHeaders(json: true);

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode({
        'barcode': barcode,
        'userId': userId,
        'quantity': quantity,
      }),
    );

    _checkStatus(response);
  }
}