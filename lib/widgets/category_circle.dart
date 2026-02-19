// lib/widgets/category_circle.dart
import 'package:flutter/material.dart';
import 'package:shopzy/utils/app_colors.dart';

class CategoryCircle extends StatelessWidget {
  final String name;
  final String imagePath;
  final VoidCallback? onTap;

  const CategoryCircle({
    super.key,
    required this.name,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColors.secondarySurface,
              shape: BoxShape.circle,
            ),
            child: Image.network(
              imagePath,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.category, color: AppColors.secondaryText),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              color: AppColors.textCharcoal,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}