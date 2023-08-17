import 'package:flutter/material.dart';
import 'AuthState.dart';

class AuthGuard {
  final AuthState authState;

  AuthGuard(this.authState);

  // Check if the user is authenticated before allowing access to the route
  bool canActivate(RouteSettings settings) {
    if (settings.name == '/home' || settings.name == '/profile') {
      return authState.isAuthenticated;
    }

    return true; // Allow access to other routes
  }
}