import 'package:flutter/material.dart';
import 'package:shopzy/models/grocery_item.dart';
import 'package:shopzy/utils/app_colors.dart';
import 'package:shopzy/widgets/product_card.dart';

class RecommendedProductsScreen extends StatelessWidget {
  final List<GroceryItem> items;

  const RecommendedProductsScreen({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F2),
      appBar: AppBar(
        title: const Text(
          'Recommended',
          style: TextStyle(
            color: AppColors.textCharcoal,
            fontWeight: FontWeight.w900,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textCharcoal),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ProductCard(item: items[index]);
        },
      ),
    );
  }
}
