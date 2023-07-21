import 'package:flutter/material.dart';

import 'custom_colors.dart';

ElevatedButtonThemeData customElevatedButtonTheme(BuildContext context) {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: appItemColor,
    ),
  );
}
