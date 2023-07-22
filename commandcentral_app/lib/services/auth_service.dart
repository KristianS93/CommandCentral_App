import 'dart:convert';
import 'package:commandcentral_app/components/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // singleton instance
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  String? _token;
  String? get token => _token;

  AuthService._internal();

  Future<void> loadTokenFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
  }

  // Method to check if the user is logged in
  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  // Method to handle the login process
  Future<bool> login(String username, String password) async {
    // Implement your actual login logic here
    // For simplicity, we will just set isLoggedIn to true.
    try {
      var url = Uri.parse('${baseApiUrl}Authentication/1');
      var response = await http.post(url);

      if (response.statusCode == 200) {
        var _token = response.body;
        print(_token);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('token', _token);
        return true;
      } else {
        // Handle API response for failed login
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', false);
        return false;
      }
    } catch (e) {
      // Handle any errors that occurred during the API call
      print('Error: $e');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      return false;
    }
  }

  // Method to handle the logout process
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
  }
}
