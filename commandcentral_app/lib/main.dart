import 'package:commandcentral_app/pages/dashboard_page.dart';
import 'package:commandcentral_app/pages/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            final isLoggedIn = snapshot.data ?? false;
            return isLoggedIn ? const DashBoardPage() : LoginPage();
          }
        },
      ),
    );
  }
}
