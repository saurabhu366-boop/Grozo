// lib/widgets/in_store_nav_card.dart
import 'package:flutter/material.dart';
import 'package:shopzy/screens/in_store_mode_screen.dart';
import 'package:shopzy/utils/app_colors.dart';

class InStoreNavCard extends StatefulWidget {
  const InStoreNavCard({super.key});

  @override
  State<InStoreNavCard> createState() => _InStoreNavCardState();
}

class _InStoreNavCardState extends State<InStoreNavCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 0.0, end: 20.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _navigateToInStoreMode(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const InStoreModeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Map Image
            Image.network(
              'https://i.pinimg.com/564x/e7/5b/c9/e75bc94262f3f1a0e820252b47118f0a.jpg',
              fit: BoxFit.cover,
              color: AppColors.background.withOpacity(0.4),
              colorBlendMode: BlendMode.dstATop,
            ),

            // User Location Pulse
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Container(
                        width: _pulseAnimation.value,
                        height: _pulseAnimation.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue
                              .withOpacity(1 - _pulseController.value),
                        ),
                      );
                    },
                  ),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.shade700,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ],
              ),
            ),

            // Store Section Markers
            const _AisleMarker(
                icon: Icons.eco_outlined, // Produce
                color: Color(0xFF4CAF50),
                top: 70,
                left: 40),
            const _AisleMarker(
                icon: Icons.local_drink_outlined, // Drinks/Dairy
                color: Color(0xFF2196F3),
                top: 70,
                left: 100),
            const _AisleMarker(
                icon: Icons.bakery_dining_outlined, // Bakery
                color: Color(0xFFFF9800),
                top: 70,
                right: 40),
            const _AisleMarker(
                icon: Icons.set_meal_outlined, // Meat
                color: Color(0xFFF44336),
                top: 130,
                left: 70),

            // Top Interactive Card
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: GestureDetector(
                onTap: () => _navigateToInStoreMode(context),
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
            ),
          ],
        ),
      ),
    );
  }
}

class _AisleMarker extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double? top, bottom, left, right;

  const _AisleMarker({
    required this.icon,
    required this.color,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}