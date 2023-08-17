import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maven_market/MyApp.dart';
import 'package:provider/provider.dart';

import '../models/User.dart';
import '../screens/login.dart';
import 'AuthHiveBox.dart';

class AuthState extends ChangeNotifier {
  String? _token;
  // User? _user;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Method to check if the user is already authenticated
  bool isUserAuthenticated() {
    return _firebaseAuth.currentUser != null;
  }

  bool get isAuthenticated => _token != null;

  // Method to log in the user and store the token in Hive
  Future<void> login(String token) async {
    _token = token;
    await AuthHiveBox.setToken(token);
    notifyListeners();
  }

  // Method to log out the user and remove the token from Hive
  Future<void> logout() async {
    _token = null;
    await AuthHiveBox.setToken('');
    notifyListeners();
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    return authState.isAuthenticated ? MyApp() : LogInScreen();
  }
}
