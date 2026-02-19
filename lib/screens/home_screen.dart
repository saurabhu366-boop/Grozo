// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:shopzy/screens/account_section.dart';
import 'package:shopzy/screens/barcode_scanner_screen.dart';
import 'package:shopzy/screens/cart_screen.dart';
import 'package:shopzy/screens/category_section.dart';
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

  final List<Widget> _pages = <Widget>[
    const HomeSection(key: ValueKey('home_section')),
    const CategorySection(key: ValueKey('category_section')),
    const CartScreen(key: ValueKey('cart_screen')),
    const AccountSection(key: ValueKey('account_section')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const BarcodeScannerScreen(),
          ));
        },
        child: const Icon(Icons.qr_code_scanner_rounded, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 10.0,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNavItem(Icons.home_rounded, 'Home', 0),
            _buildNavItem(Icons.grid_view_sharp, 'Categories', 1),
            const SizedBox(width: 48),
            _buildCartNavItem(2),
            _buildNavItem(Icons.person_outline_rounded, 'Profile', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return IconButton(
      tooltip: label,
      icon: Icon(
        icon,
        color: isSelected ? AppColors.primary : AppColors.inactiveIcon,
        size: 30,
      ),
      onPressed: () => _onItemTapped(index),
    );
  }

  Widget _buildCartNavItem(int index) {
    final isSelected = _selectedIndex == index;
    return CartIconWidget(
      isActive: isSelected,
      onPressed: () => _onItemTapped(index),
      activeIcon: Icons.shopping_bag,
      inactiveIcon: Icons.shopping_bag_outlined,
    );
  }
}