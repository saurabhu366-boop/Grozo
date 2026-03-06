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
  bool _confirming = false;  // ✅ renamed from _placingOrder

  Future<void> _confirmCheckout() async {   // ✅ renamed from _placeOrder
    setState(() => _confirming = true);
    try {
      final response = await _cartService.checkout();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ReceiptScreen(response: response)),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _confirming = false);
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
        title: const Text("Review & Pay"),   // ✅ was "Checkout"
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      bottomNavigationBar: _ConfirmBar(     // ✅ renamed widget
        totalAmount: widget.totalAmount,
        confirming: _confirming,
        onConfirm: _confirmCheckout,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // ── Scanned Items card ──
          _SectionCard(
            title: "Scanned Items",          // ✅ was "Order Summary"
            child: Column(
              children: [
                ...widget.cartItems.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.barcode_reader,
                            color: Colors.green),  // ✅ barcode icon
                      ),
                      const SizedBox(width: 12),
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
                      Text(
                        "₹${(item.price * item.quantity).toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                )),
                const Divider(height: 24),
                // ✅ REMOVED: Delivery row entirely
                _PriceRow(label: "Subtotal", value: widget.totalAmount),
                const Divider(height: 16),
                _PriceRow(
                  label: "Amount to Pay",    // ✅ was "Total"
                  value: widget.totalAmount,
                  isBold: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Payment mode card ──
          _SectionCard(
            title: "Payment",               // ✅ was "Payment Method"
            child: Row(
              children: [
                const Icon(Icons.point_of_sale, color: Colors.green), // ✅ POS icon
                const SizedBox(width: 12),
                const Text("Pay at Counter",  // ✅ was "Cash on Delivery"
                    style: TextStyle(fontWeight: FontWeight.w500)),
                const Spacer(),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text("In-Store",  // ✅ was "Selected"
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

// ── Confirm & Pay bottom bar ──────────────────────────────────────────────────
class _ConfirmBar extends StatelessWidget {
  final double totalAmount;
  final bool confirming;
  final VoidCallback onConfirm;

  const _ConfirmBar({
    required this.totalAmount,
    required this.confirming,
    required this.onConfirm,
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
          onPressed: confirming ? null : onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[700],
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          child: confirming
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
            "Confirm & Pay  •  ₹${totalAmount.toStringAsFixed(2)}", // ✅ was "Place Order"
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

  const _PriceRow({
    required this.label,
    required this.value,
    this.isBold = false,
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
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  fontSize: isBold ? 16 : 14,
                  color: isBold ? Colors.black : Colors.grey[700])),
          Text(
            "₹${value.toStringAsFixed(2)}",
            style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: isBold ? 16 : 14),
          ),
        ],
      ),
    );
  }
}