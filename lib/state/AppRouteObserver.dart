import 'package:flutter/material.dart';
import '../screens/login.dart';
import 'AuthGuard.dart';

class AppRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  final AuthGuard authGuard;

  AppRouteObserver(this.authGuard);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is PageRoute && previousRoute is PageRoute) {
      if (authGuard.canActivate(route.settings)) {
        super.didPush(route, previousRoute);
      } else {
        // Redirect to the login screen if the user is not authenticated
        navigator!.pushReplacement(MaterialPageRoute(builder: (_) => LogInScreen()));
      }
    } else {
      super.didPush(route, previousRoute);
    }
  }
}