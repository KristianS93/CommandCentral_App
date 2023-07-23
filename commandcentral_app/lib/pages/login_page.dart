import 'package:commandcentral_app/components/styled_button.dart';
import 'package:commandcentral_app/components/styled_textfield.dart';
import 'package:commandcentral_app/pages/dashboard_page.dart';
import 'package:commandcentral_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:commandcentral_app/components/custom_colors.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn(String username, String password) async {
    print("in sign in");
    bool success = await AuthService().login(username, password);

    if (success) {
      Navigator.pushReplacement(
        _scaffoldKey.currentContext!,
        MaterialPageRoute(builder: (context) => const DashBoardPage()),
      );
    } else {
      showSnackBarWithText('Invalid login details!', Colors.red);
    }
  }

  void showSnackBarWithText(String text, Color backgroundColor) {
    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        content: Text(
          text,
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: loginBgColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              const Icon(
                Icons.lock,
                color: loginItemColor,
                size: 100,
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                'Command Central',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 24,
                ),
              ),
              Text(
                'Login',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              // username textfield
              StyledTextfield(
                controller: usernameController,
                hintText: 'Username',
                obsureText: false,
              ),

              //space
              const SizedBox(height: 10),
              // password textfield
              StyledTextfield(
                controller: passwordController,
                hintText: 'Password',
                obsureText: true,
              ),

              const SizedBox(
                height: 20,
              ),
              // sign in button
              StyledButton(onTap: () {
                // pass the username and passwotd to signin function
                signIn(usernameController.text, passwordController.text);
              }),
              const SizedBox(
                height: 45,
              ),
              // Not a member? register..
            ],
          ),
        ),
      ),
    );
  }
}
