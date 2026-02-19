// lib/widgets/nutrition_info_widget.dart
import 'package:flutter/material.dart';
import 'package:shopzy/models/grocery_item.dart';
import 'package:shopzy/utils/app_colors.dart';

class NutritionInfoWidget extends StatelessWidget {
  final GroceryItem item;
  final List<String> aiTips;

  const NutritionInfoWidget({
    super.key,
    required this.item,
    this.aiTips = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16.0,
            runSpacing: 16.0,
            alignment: WrapAlignment.spaceAround,
            children: _buildNutrientWidgets(),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Chip(
              label: Text(item.healthHint),
              backgroundColor: AppColors.primary.withOpacity(0.1),
              labelStyle: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
              avatar: const Icon(Icons.check_circle_outline, color: AppColors.primary),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              side: BorderSide.none,
            ),
          ),
          if (aiTips.isNotEmpty) ...[
            const Divider(height: 24, thickness: 1, color: AppColors.secondarySurface),
            ...aiTips.map((tip) => _buildAiTip(tip)).toList(),
          ]
        ],
      ),
    );
  }

  List<Widget> _buildNutrientWidgets() {
    final nutrients = <Widget>[
      _buildNutrient('Calories', item.calories.toString(), Icons.local_fire_department_outlined),
      _buildNutrient('Protein', '${item.protein.toStringAsFixed(1)}g', Icons.fitness_center_outlined),
      _buildNutrient('Carbs', '${item.carbs.toStringAsFixed(1)}g', Icons.rice_bowl_outlined),
    ];
    if (item.fat != null) {
      nutrients.add(_buildNutrient('Fat', '${item.fat!.toStringAsFixed(1)}g', Icons.opacity));
    }
    if (item.sugar != null) {
      nutrients.add(_buildNutrient('Sugar', '${item.sugar!.toStringAsFixed(1)}g', Icons.cake_outlined));
    }
    return nutrients;
  }

  Widget _buildAiTip(String tip) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.psychology_outlined, color: AppColors.primary, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(
                color: AppColors.textCharcoal,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrient(String name, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textCharcoal,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          name,
          style: const TextStyle(
            color: AppColors.secondaryText,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}