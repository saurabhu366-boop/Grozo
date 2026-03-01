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
    const activeGreen = Color(0xFF2DB45D); // ✅ YOUR COLOR

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
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: activeGreen, // ✅ updated
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: activeGreen.withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
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
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          padding: EdgeInsets.zero,
          height: 72,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: 'Home',
                index: 0,
                selectedIndex: _selectedIndex,
                onTap: _onItemTapped,
                activeColor: activeGreen,
              ),
              _NavItem(
                icon: Icons.grid_view_outlined,
                activeIcon: Icons.grid_view_rounded,
                label: 'Categories',
                index: 1,
                selectedIndex: _selectedIndex,
                onTap: _onItemTapped,
                activeColor: activeGreen,
              ),
              const SizedBox(width: 48),
              _CartNavItem(
                index: 2,
                selectedIndex: _selectedIndex,
                onTap: _onItemTapped,
                activeColor: activeGreen,
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Account',
                index: 3,
                selectedIndex: _selectedIndex,
                onTap: _onItemTapped,
                activeColor: activeGreen,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Nav item ─────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int index;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final Color activeColor;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;
    final color = isSelected ? activeColor : const Color(0xFF9CA3AF);

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isSelected ? activeIcon : icon, size: 26, color: color),
            if (isSelected) ...[
              const SizedBox(height: 4),
              Text(label,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: color)),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Cart nav item ────────────────────────────────────────────
class _CartNavItem extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final Color activeColor;

  static final CartService _cartService = CartService();

  const _CartNavItem({
    required this.index,
    required this.selectedIndex,
    required this.onTap,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;
    final color = isSelected ? activeColor : const Color(0xFF9CA3AF);

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected
                  ? Icons.shopping_cart_rounded
                  : Icons.shopping_cart_outlined,
              size: 26,
              color: color,
            ),
            if (isSelected) ...[
              const SizedBox(height: 4),
              Text('Cart',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: color)),
            ],
          ],
        ),
      ),
    );
  }
}