import 'package:flutter/material.dart';
import 'package:commandcentral_app/components/custom_colors.dart';

class StyledButton extends StatelessWidget {
  final Function()? onTap;
  const StyledButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
            color: loginItemColor, borderRadius: BorderRadius.circular(8)),
        child: const Center(
            child: Text(
          "Sign in",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        )),
      ),
    );
  }
}
