// lib/screens/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:shopzy/models/grocery_item.dart';
import 'package:shopzy/utils/app_colors.dart';
import 'package:shopzy/widgets/nutrition_info_widget.dart';

class ProductDetailScreen extends StatelessWidget {
  final GroceryItem item;

  const ProductDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textCharcoal),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection(),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    'Nutrition Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textCharcoal,
                    ),
                  ),
                  const SizedBox(height: 12),
                  NutritionInfoWidget(item: item),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      height: 350,
      width: double.infinity,
      color: AppColors.secondarySurface,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: AppColors.softShadow,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.network(
                item.imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.image_not_supported,
                    size: 60,
                    color: AppColors.secondaryText),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                item.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textCharcoal,
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Icon(Icons.favorite_border_rounded,
                color: AppColors.secondaryText, size: 28),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '1000 gm', // Example text
          style: const TextStyle(fontSize: 16, color: AppColors.secondaryText),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Text(
              '₹${item.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.textCharcoal,
              ),
            ),
            const Spacer(),
            const Icon(Icons.star, color: AppColors.primary, size: 20),
            const SizedBox(width: 4),
            const Text(
              '4.5 Rating',
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: AppColors.textCharcoal),
            )
          ],
        ),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),
        Text(
          '100% satisfaction guarantee. If you experience any issues, we offer a full refund. All our products are sourced from trusted local suppliers. ${item.healthHint}.',
          style: const TextStyle(
              fontSize: 15, color: AppColors.secondaryText, height: 1.6),
        ),
      ],
    );
  }
}