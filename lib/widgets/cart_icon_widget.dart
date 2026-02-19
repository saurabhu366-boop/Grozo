// lib/widgets/cart_icon_widget.dart
import 'package:flutter/material.dart';
import 'package:shopzy/screens/cart_screen.dart';
import 'package:shopzy/services/cart_service.dart';
import 'package:shopzy/utils/app_colors.dart';

class CartIconWidget extends StatelessWidget {
  final CartService _cartService = CartService();
  final bool isLight;
  final bool isActive;
  final VoidCallback? onPressed;
  final IconData activeIcon;
  final IconData inactiveIcon;

  CartIconWidget({
    super.key,
    this.isLight = false,
    this.isActive = false,
    this.onPressed,
    this.activeIcon = Icons.shopping_cart,
    this.inactiveIcon = Icons.shopping_cart_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isLight ? Colors.white : (isActive ? AppColors.primary : AppColors.inactiveIcon);

    return ValueListenableBuilder<int>(
      valueListenable: _cartService.cartItemCount,
      builder: (context, count, child) {
        return IconButton(
          onPressed: onPressed ?? () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CartScreen()));
          },
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(isActive ? activeIcon : inactiveIcon, color: iconColor, size: 30),
              if (count > 0)
                Positioned(
                  top: -5,
                  right: -5,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: isLight ? Colors.black : AppColors.bottomBarBackground, width: 2)
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      count.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          tooltip: 'Open Cart',
        );
      },
    );
  }
}