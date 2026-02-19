// lib/screens/home_section.dart
import 'package:flutter/material.dart';
import 'package:shopzy/data/mock_database.dart';
import 'package:shopzy/models/grocery_item.dart';
import 'package:shopzy/screens/ai_assistant_screen.dart';
import 'package:shopzy/utils/app_colors.dart';
import 'package:shopzy/widgets/in_store_nav_card.dart';
import 'package:shopzy/widgets/product_card.dart';
import 'package:shopzy/widgets/promo_card.dart';

class HomeSection extends StatelessWidget {
  const HomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for general "Recommended" section
    final List<String> recommendedBarcodes = [
      '9876543210987', // Whole Wheat Bread
      '4567890123456', // Standard Yogurt
      '8901234567890', // Organic Almonds
      '1234567890128', // Fresh Orange Juice
    ];
    final recommendedItems = recommendedBarcodes
        .map((barcode) => MockDatabase.findByBarcode(barcode))
        .where((item) => item != null)
        .cast<GroceryItem>()
        .toList();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(top: 20),
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildAiPanel(context),
            const SizedBox(height: 24),
            const InStoreNavCard(),
            const SizedBox(height: 30),
            _buildFeaturedDeals(context),
            const SizedBox(height: 30),
            _buildSectionHeader('Recommended', () {}, showSeeMore: true),
            const SizedBox(height: 16),
            _buildProductCarousel(recommendedItems),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  text: 'Morning, ',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textCharcoal,
                  ),
                  children: [
                    TextSpan(
                      text: 'Sahil',
                      style: const TextStyle(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              const Row(
                children: [
                  Icon(Icons.location_on, color: AppColors.secondaryText, size: 16),
                  SizedBox(width: 4),
                  Text('Mumbai, Maharashtra',
                      style: TextStyle(color: AppColors.secondaryText, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
          const CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage('https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeMore, {bool showSeeMore = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textCharcoal,
            ),
          ),
          if (showSeeMore)
            TextButton(
              onPressed: onSeeMore,
              child: const Text(
                'See More >',
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductCarousel(List<GroceryItem> items) {
    return SizedBox(
      height: 250,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ProductCard(item: items[index]);
        },
        separatorBuilder: (context, index) => const SizedBox(width: 16),
      ),
    );
  }

  Widget _buildFeaturedDeals(BuildContext context) {
    return const PromoCard();
  }

  Widget _buildAiPanel(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AiAssistantScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.accentBlack,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.psychology_alt_outlined, color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Grozo AI',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textOnBlack,
                        fontSize: 16
                    ),
                  ),
                  Text(
                    'Based on your diet, we found 4 new recipes.',
                    style: TextStyle(color: AppColors.secondaryText, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: AppColors.secondaryText, size: 16),
          ],
        ),
      ),
    );
  }
}