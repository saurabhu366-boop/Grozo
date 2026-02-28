// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:shopzy/screens/account_section.dart' show AccountSection;
import 'package:shopzy/screens/barcode_scanner_screen.dart';
import 'package:shopzy/screens/cart_screen.dart';
import 'package:shopzy/screens/category_section.dart' show CategorySection;
import 'package:shopzy/screens/home_section.dart';
import 'package:shopzy/services/cart_service.dart';
import 'package:shopzy/utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  late AnimationController _fabAnimCtrl;
  late Animation<double> _fabScaleAnim;

  // ✅ FIX: No _BottomPaddedPage wrapper.
  // CategorySection, AccountSection, CartScreen are all full Scaffold widgets.
  // Wrapping a Scaffold in Padding does nothing — the Scaffold ignores it.
  // Each screen handles its own bottom clearance via SizedBox at the end
  // of its scroll view (height >= 100 clears the 64px nav bar + FAB).
  final List<Widget> _pages = [
    const HomeSection(key: ValueKey('home_section')),
    CategorySection(key: ValueKey('category_section')),
    const CartScreen(key: ValueKey('cart_screen')),
    const AccountSection(key: ValueKey('account_section')),
  ];

  @override
  void initState() {
    super.initState();
    _fabAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _fabScaleAnim = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _fabAnimCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _fabAnimCtrl.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  Future<void> _onScanPressed() async {
    await _fabAnimCtrl.forward();
    await _fabAnimCtrl.reverse();
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const BarcodeScannerScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF5F7F2),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),

      // ── Scanner FAB ─────────────────────────────────────────
      floatingActionButton: ScaleTransition(
        scale: _fabScaleAnim,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                Color.fromARGB(
                  AppColors.primary.alpha,
                  AppColors.primary.red,
                  (AppColors.primary.green + 30).clamp(0, 255),
                  AppColors.primary.blue,
                ),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.45),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _onScanPressed,
              customBorder: const CircleBorder(),
              child: const Center(
                child: Icon(Icons.qr_code_scanner_rounded,
                    color: Colors.white, size: 28),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // ── Bottom nav ──────────────────────────────────────────
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomAppBar(
          color: Colors.white,
          elevation: 0,
          notchMargin: 10.0,
          // ✅ FIX: explicit height — without this the Column inside overflows
          height: 72,
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                index: 0,
                selectedIndex: _selectedIndex,
                onTap: _onItemTapped,
              ),
              _NavItem(
                icon: Icons.grid_view_rounded,
                label: 'Categories',
                index: 1,
                selectedIndex: _selectedIndex,
                onTap: _onItemTapped,
              ),
              const SizedBox(width: 48),
              _CartNavItem(
                index: 2,
                selectedIndex: _selectedIndex,
                onTap: _onItemTapped,
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                label: 'Profile',
                index: 3,
                selectedIndex: _selectedIndex,
                onTap: _onItemTapped,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Nav item ─────────────────────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                size: 22,
                color: isSelected ? AppColors.primary : AppColors.inactiveIcon,
              ),
            ),
            const SizedBox(height: 1),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.inactiveIcon,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Cart nav item — custom badge icon, NO IconButton (avoids 48px min height) ─
class _CartNavItem extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  // Same CartService instance as CartIconWidget uses
  static final CartService _cartService = CartService();

  const _CartNavItem({
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ Stack with plain Icon — no IconButton, no forced 48px minimum
            ValueListenableBuilder<int>(
              valueListenable: _cartService.cartItemCount,
              builder: (context, count, _) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      isSelected
                          ? Icons.shopping_bag
                          : Icons.shopping_bag_outlined,
                      size: 24,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.inactiveIcon,
                    ),
                    if (count > 0)
                      Positioned(
                        top: -5,
                        right: -6,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          constraints: const BoxConstraints(
                              minWidth: 16, minHeight: 16),
                          child: Text(
                            '$count',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.inactiveIcon,
              ),
              child: const Text('Cart'),
            ),
          ],
        ),
      ),
    );
  }
}