import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:callparts/core/constants/app_colors.dart';
import 'package:callparts/presentation/providers/cart_provider.dart';
import 'package:callparts/presentation/pages/cartScreen/cart_screen.dart';
class CartIconWithBadge extends StatelessWidget {
  final GlobalKey? cartIconKey;
  final Color iconColor;
  final Color badgeColor;
  final double iconSize;

  const CartIconWithBadge({
    Key? key,
    this.cartIconKey,
    this.iconColor = Colors.white,
    this.badgeColor = Colors.orange,
    this.iconSize = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Stack(
          key: cartIconKey,
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: Icon(Icons.shopping_cart, color: iconColor, size: iconSize),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartScreen(),
                  ),
                );
              },
            ),
            if (cart.itemCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: badgeColor.withOpacity(0.4),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    '${cart.itemCount}',
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
        );
      },
    );
  }
}
