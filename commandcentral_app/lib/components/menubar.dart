import 'package:flutter/material.dart';

class BottomMenuBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomMenuBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Grocery List',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu),
          label: 'Meal Planner',
        ),
      ],
    );
  }
}