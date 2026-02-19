// lib/widgets/badge_widget.dart
import 'package:flutter/material.dart';
import 'package:shopzy/models/badge.dart' as model;
import 'package:shopzy/utils/app_colors.dart';

class BadgeWidget extends StatelessWidget {
  final model.Badge badge;

  const BadgeWidget({super.key, required this.badge});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: badge.isUnlocked ? 1.0 : 0.4,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: badge.isUnlocked
                  ? AppColors.primary.withOpacity(0.1)
                  : AppColors.secondaryText.withOpacity(0.1),
              border: Border.all(
                color: badge.isUnlocked
                    ? AppColors.primary.withOpacity(0.3)
                    : AppColors.secondaryText.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: Icon(
              badge.isUnlocked ? badge.icon : Icons.lock_outline,
              color: badge.isUnlocked ? AppColors.primary : AppColors.secondaryText,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            badge.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: badge.isUnlocked
                  ? AppColors.textCharcoal
                  : AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}