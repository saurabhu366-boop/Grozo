// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:shopzy/screens/account_section.dart' show AccountSection;
import 'package:shopzy/screens/barcode_scanner_screen.dart';
import 'package:shopzy/screens/cart_screen.dart';
import 'package:shopzy/screens/category_section.dart' show CategorySection;
import 'package:shopzy/screens/home_section.dart';
import 'package:shopzy/utils/app_colors.dart';
import 'package:shopzy/widgets/cart_icon_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // ✅ FIX: Wrap each page in _BottomPaddedPage so content never hides
  // behind the BottomAppBar when extendBody: true is set.
  // 90 = ~70 (BottomAppBar height) + 20 extra breathing room
  // ✅ FIX: removed `const` — CategorySection and AccountSection are now
  // StatefulWidgets. Const requires the entire widget tree to be compile-time
  // constant, which isn't possible for StatefulWidgets that manage state.
  final List<Widget> _pages = [
    const _BottomPaddedPage(child: HomeSection(key: ValueKey('home_section'))),
    _BottomPaddedPage(child: CategorySection(key: ValueKey('category_section'))),
    _BottomPaddedPage(child: CartScreen(key: ValueKey('cart_screen'))),
    _BottomPaddedPage(child: AccountSection(key: ValueKey('account_section'))),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),

      // ── Scanner FAB ───────────────────────────────────────────
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const BarcodeScannerScreen()),
        ),
        elevation: 4,
        child: const Icon(Icons.qr_code_scanner_rounded, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // ── Bottom nav ────────────────────────────────────────────
      bottomNavigationBar: BottomAppBar(
        notchMargin: 10.0,
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
              icon: Icons.grid_view_sharp,
              label: 'Categories',
              index: 1,
              selectedIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),

            // Gap for FAB notch
            const SizedBox(width: 48),

            // ✅ Cart with live badge — CartIconWidget already handles this
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
    );
  }
}

// ── Bottom padding wrapper ────────────────────────────────────────────────────
// Adds enough padding so page content clears the BottomAppBar + FAB.
// extendBody: true draws the body behind the bar, so without this
// the last items in any ScrollView are unreachable.
class _BottomPaddedPage extends StatelessWidget {
  final Widget child;
  const _BottomPaddedPage({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 90),
      child: child,
    );
  }
}

// ── Nav item with icon + label ────────────────────────────────────────────────
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 26,
                color: isSelected ? AppColors.primary : AppColors.inactiveIcon,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight:
                  isSelected ? FontWeight.w700 : FontWeight.w500,
                  color:
                  isSelected ? AppColors.primary : AppColors.inactiveIcon,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Cart nav item (uses CartIconWidget for live badge) ────────────────────────
class _CartNavItem extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _CartNavItem({
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // CartIconWidget handles badge + icon color + tap
          CartIconWidget(
            isActive: isSelected,
            onPressed: () => onTap(index),
            activeIcon: Icons.shopping_bag,
            inactiveIcon: Icons.shopping_bag_outlined,
          ),
          Text(
            'Cart',
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.primary : AppColors.inactiveIcon,
            ),
          ),
          const SizedBox(height: 2),
        ],
      ),
    );
  }
}