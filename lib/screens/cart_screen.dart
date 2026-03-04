// lib/screens/cart_screen.dart

import 'package:flutter/material.dart';
import 'package:shopzy/services/cart_api_service.dart';
import '../models/cart_response.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _apiService = CartService();

  List<CartItemResponse> cartItems = [];
  double totalAmount = 0;
  bool loading = true;

  int get totalQuantity =>
      cartItems.fold<int>(0, (sum, item) => sum + item.quantity);

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  Future<void> fetchCart() async {
    try {
      final data = await _apiService.getActiveCart();
      setState(() {
        cartItems = data.items;
        totalAmount = data.totalAmount;
        loading = false;
      });
    } catch (e) {
      debugPrint("Cart fetch error: $e");
      setState(() => loading = false);
    }
  }

  Future<void> removeItem(CartItemResponse item) async {
    try {
      await _apiService.removeProduct(item.barcode, quantity: 1);
      await fetchCart();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Item removed successfully")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Remove failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          cartItems.isEmpty ? 'My Cart' : 'My Cart ($totalQuantity items)',
        ),
        centerTitle: true,
      ),

      // ✅ Zepto-style sticky bottom bar
      bottomNavigationBar: cartItems.isEmpty
          ? null
          : _CheckoutBottomBar(
        totalAmount: totalAmount,
        totalQuantity: totalQuantity,
        onCheckout: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CheckoutScreen(
                cartItems: cartItems,
                totalAmount: totalAmount,
              ),
            ),
          ).then((_) => fetchCart()); // refresh cart on return
        },
      ),

      body: RefreshIndicator(
        onRefresh: fetchCart,
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : cartItems.isEmpty
            ? ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 100),
            Center(
              child: Text(
                "Your cart is empty",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        )
            : ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          itemCount: cartItems.length,
          itemBuilder: (context, index) {
            final item = cartItems[index];
            return Card(
              margin: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 6),
              child: ListTile(
                title: Text(
                  item.productName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Qty: ${item.quantity}  •  ₹${item.price} each"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "₹${(item.price * item.quantity).toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => removeItem(item),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ── Zepto-style bottom checkout bar ──────────────────────────────────────────
class _CheckoutBottomBar extends StatelessWidget {
  final double totalAmount;
  final int totalQuantity;
  final VoidCallback onCheckout;

  const _CheckoutBottomBar({
    required this.totalAmount,
    required this.totalQuantity,
    required this.onCheckout,
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
        child: Row(
          children: [
            // Left: total info
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "₹${totalAmount.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "$totalQuantity item${totalQuantity > 1 ? 's' : ''}",
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
            const Spacer(),
            // Right: proceed button
            ElevatedButton(
              onPressed: onCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                padding: const EdgeInsets.symmetric(
                    horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Row(
                children: [
                  Text(
                    "Proceed to Checkout",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward_ios,
                      size: 14, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}