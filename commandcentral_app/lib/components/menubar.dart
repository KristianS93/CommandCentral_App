import 'package:commandcentral_app/components/custom_colors.dart';
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
    final iconSize = 30.0; // Set the desired icon size

    return BottomNavigationBar(
      currentIndex: currentIndex,
      backgroundColor: appItemColor,
      onTap: onTap,
      selectedIconTheme: IconThemeData(size: iconSize, color: Colors.white), // Set the active icon size and color
      unselectedIconTheme: IconThemeData(size: iconSize, color: Colors.grey), // Set the inactive icon size and color
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '', // Remove the label text
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu),
          label: '',
        ),
      ],
      selectedItemColor: Colors.white, // Set the active label text color (if label was present)
      unselectedItemColor: Colors.grey, // Set the inactive label text color (if label was present)
      type: BottomNavigationBarType.fixed, // To ensure labels are always shown
    );
  }
}
