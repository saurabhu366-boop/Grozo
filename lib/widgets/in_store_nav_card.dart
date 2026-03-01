// lib/widgets/in_store_nav_card.dart
import 'package:flutter/material.dart';
import 'package:shopzy/screens/in_store_mode_screen.dart';
import 'package:shopzy/utils/app_colors.dart';

class InStoreNavCard extends StatefulWidget {
  const InStoreNavCard({super.key});

  @override
  State<InStoreNavCard> createState() => _InStoreNavCardState();
}

class _InStoreNavCardState extends State<InStoreNavCard> {
  void _navigateToInStoreMode(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const InStoreModeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToInStoreMode(context),
      child: Container(
        height: 200,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Map Image
              Image.network(
                'https://www.dreamstime.com/supermarket-interior-flat-vector-illustration-grocery-store-shelves-food-products-cartoon-food-shop-aisle-bakery-meat-image166466892',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.network(
                  'https://static.vecteezy.com/system/resources/previews/057/219/123/large_2x/grocery-store-front-view-supermarket-food-inside-interior-design-vector.jpg',
                  fit: BoxFit.cover,
                ),
              ),

              // Map UI Overlay Elements
              Container(color: Colors.white.withOpacity(0.15)),

              // User Location Pulse
              Positioned(
                bottom: 40,
                left: 60,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),

              // Map Pins
              // const Positioned(
              //   top: 80,
              //   right: 50,
              //   child: Icon(Icons.location_on, color: Colors.redAccent, size: 32),
              // ),
              // const Positioned(
              //   bottom: 60,
              //   right: 100,
              //   child: Icon(Icons.location_on, color: Colors.orangeAccent, size: 28),
              // ),

              // Top Label Pill
              Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.secondarySurface,
                    borderRadius: BorderRadius.circular(100), // Pill shape
                    boxShadow: AppColors.softShadow,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.explore_outlined,
                          color: AppColors.secondaryText, size: 28),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'In-Store Navigation',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textCharcoal,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Tap to find any item in the store →',
                              style: TextStyle(
                                color: AppColors.secondaryText,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.chevron_right,
                          color: AppColors.secondaryText.withOpacity(0.7)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
