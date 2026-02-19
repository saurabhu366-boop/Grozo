// lib/widgets/promo_card.dart
import 'package:flutter/material.dart';
import 'package:shopzy/utils/app_colors.dart';

class PromoCard extends StatelessWidget {
  const PromoCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Colors inspired by the reference image, with a black background
    const cardBackgroundColor = AppColors.accentBlack;
    const premiumTagColor = Color(0xFF2DB45D);
    const claimButtonColor = Color(0xFFD7F5E2);
    const starColor = Color(0xFFFFD700);

    return Container(
      height: 195, // Increased from 170 to fix overflow
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: AppColors.softShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            _buildBackground(cardBackgroundColor),
            _buildGlowingStar(starColor),
            _buildContent(context, premiumTagColor, claimButtonColor, starColor),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground(Color backgroundColor) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        image: DecorationImage(
          image: const NetworkImage(
              'https://images.unsplash.com/photo-1601004890684-d8cbf643f5f2?q=80&w=1974&auto=format&fit=crop'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            backgroundColor.withOpacity(0.6), // Blend image with the background color
            BlendMode.darken,
          ),
        ),
      ),
    );
  }

  Widget _buildGlowingStar(Color starColor) {
    return Positioned(
      top: 15,
      right: 20,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: starColor.withOpacity(0.3), // Reduced opacity
              blurRadius: 15, // Reduced blur
              spreadRadius: 1, // Reduced spread
            ),
          ],
        ),
        child: Icon(
          Icons.star,
          color: starColor,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Color premiumTagColor, Color claimButtonColor, Color starColor) {
    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 20), // Adjusted bottom padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPremiumTag(premiumTagColor, starColor),
            const SizedBox(height: 10), // Reduced from 12
            const Text(
              'Exclusive Weekend Deals',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Up to 40% off on all seasonal berries',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.8), fontSize: 14, height: 1.3),
            ),
            const Spacer(),
            _buildGlowingButton(context, claimButtonColor),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumTag(Color tagColor, Color starColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: tagColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'PREMIUM',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 11,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.star, color: starColor, size: 14),
        ],
      ),
    );
  }

  Widget _buildGlowingButton(BuildContext context, Color buttonColor) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: buttonColor.withOpacity(0.30), // Reduced opacity
            blurRadius: 10, // Reduced blur
            spreadRadius: 4, // Reduced spread
            offset: const Offset(0, 0),
          )
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Offer claimed! Discount applied at checkout.'),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: AppColors.textCharcoal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12), // Adjusted from 14
          elevation: 0,
        ),
        child: const Text(
          'Claim Offer',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}