// lib/screens/checkout_screen.dart

import 'package:flutter/material.dart';
import 'package:shopzy/services/cart_api_service.dart';
import '../models/cart_response.dart';
import 'receipt_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItemResponse> cartItems;
  final double totalAmount;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.totalAmount,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CartService _cartService = CartService();
  bool _placingOrder = false;

  Future<void> _placeOrder() async {
    setState(() => _placingOrder = true);
    try {
      final response = await _cartService.checkout();
      if (!mounted) return;

      // Navigate to receipt, replacing checkout screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ReceiptScreen(response: response)),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _placingOrder = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Checkout"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      bottomNavigationBar: _PlaceOrderBar(
        totalAmount: widget.totalAmount,
        placing: _placingOrder,
        onPlace: _placeOrder,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // ── Order Summary card ──
          _SectionCard(
            title: "Order Summary",
            child: Column(
              children: [
                ...widget.cartItems.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      // Item icon
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.shopping_bag_outlined,
                            color: Colors.green),
                      ),
                      const SizedBox(width: 12),
                      // Name + qty
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.productName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14)),
                            Text("Qty: ${item.quantity}",
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 12)),
                          ],
                        ),
                      ),
                      // Price
                      Text(
                        "₹${(item.price * item.quantity).toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                )),
                const Divider(height: 24),
                // Price breakdown
                _PriceRow(label: "Subtotal", value: widget.totalAmount),
                const _PriceRow(label: "Delivery", value: 0, isFree: true),
                const Divider(height: 16),
                _PriceRow(
                  label: "Total",
                  value: widget.totalAmount,
                  isBold: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Payment mode card ──
          _SectionCard(
            title: "Payment Method",
            child: Row(
              children: [
                const Icon(Icons.payments_outlined, color: Colors.green),
                const SizedBox(width: 12),
                const Text("Cash on Delivery",
                    style: TextStyle(fontWeight: FontWeight.w500)),
                const Spacer(),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text("Selected",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Place Order bottom bar ────────────────────────────────────────────────────
class _PlaceOrderBar extends StatelessWidget {
  final double totalAmount;
  final bool placing;
  final VoidCallback onPlace;

  const _PlaceOrderBar({
    required this.totalAmount,
    required this.placing,
    required this.onPlace,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: placing ? null : onPlace,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[700],
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          child: placing
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
            "Place Order  •  ₹${totalAmount.toStringAsFixed(2)}",
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// ── Reusable section card ─────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

// ── Price row helper ──────────────────────────────────────────────────────────
class _PriceRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isBold;
  final bool isFree;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.isFree = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight:
                  isBold ? FontWeight.bold : FontWeight.normal,
                  fontSize: isBold ? 16 : 14,
                  color: isBold ? Colors.black : Colors.grey[700])),
          isFree
              ? const Text("FREE",
              style: TextStyle(
                  color: Colors.green, fontWeight: FontWeight.bold))
              : Text(
            "₹${value.toStringAsFixed(2)}",
            style: TextStyle(
                fontWeight:
                isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: isBold ? 16 : 14),
          ),
        ],
      ),
    );
  }
}