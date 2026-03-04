// lib/screens/receipt_screen.dart

import 'package:flutter/material.dart';
import '../models/checkout_response.dart';

class ReceiptScreen extends StatelessWidget {
  final CheckoutResponse response;

  const ReceiptScreen({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr =
        "${now.day}/${now.month}/${now.year}  ${now.hour}:${now.minute.toString().padLeft(2, '0')}";

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [

                  // ── Success header ──
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    decoration: BoxDecoration(
                      color: Colors.green[700],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white, size: 64),
                        SizedBox(height: 12),
                        Text(
                          "Order Placed!",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Thank you for shopping with us 🎉",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Order info ──
                  _ReceiptCard(
                    child: Column(
                      children: [
                        _InfoRow(label: "Order ID", value: "#${response.cartId}"),
                        _InfoRow(label: "Date & Time", value: dateStr),
                        _InfoRow(label: "Status", value: response.status,
                            valueColor: Colors.green),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Items ──
                  _ReceiptCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Items Purchased",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 12),
                        ...response.items.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(item.productName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500)),
                                    Text("Qty: ${item.quantity}  •  ₹${item.price} each",
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12)),
                                  ],
                                ),
                              ),
                              Text(
                                "₹${(item.price * item.quantity).toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Total Paid",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            Text(
                              "₹${response.totalAmount.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.green),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Continue Shopping button ──
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  // Pop all screens back to scanner/home
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Continue Shopping",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  final Widget child;
  const _ReceiptCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
      child: child,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: valueColor ?? Colors.black)),
        ],
      ),
    );
  }
}// TODO Implement this library.