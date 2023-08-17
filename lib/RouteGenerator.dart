import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:maven_market/MyApp.dart';
// pages
import 'package:maven_market/pages/SearchSymbol.dart';
import 'package:maven_market/pages/EditWatchlist.dart';
import 'package:maven_market/pages/SymbolDetail.dart';
// post
import 'package:maven_market/post/CreatePost.dart';
// Auth
import 'package:maven_market/authentication/UserId.dart';
import 'package:maven_market/screens/login.dart';
import 'package:maven_market/screens/signup.dart';
import 'package:maven_market/state/AppNavigatorKey.dart';
import 'package:maven_market/state/AuthState.dart';
import 'package:provider/provider.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {

    final authState = Provider.of<AuthState>(AppNavigatorKey.navigatorKey.currentContext!, listen: false);

    switch (settings.name) {
      case '/':
        // return MaterialPageRoute(builder: (_) => MyApp(key: UniqueKey()));
        return authState.isUserAuthenticated() ? MaterialPageRoute(builder: (_) => MyApp(key: UniqueKey())) : MaterialPageRoute(builder: (_) => LogInScreen(key: UniqueKey()));
      case 'login/':
        return MaterialPageRoute(builder: (_)=> LogInScreen(key: UniqueKey()));
      case 'signup/':
        return MaterialPageRoute(builder: (_)=> SignUpScreen(key: UniqueKey()));
      case '/SearchSymbol':
        return MaterialPageRoute(builder: (_) => SearchSymbol(selListConsti: settings.arguments as List<dynamic>?));
      case '/EditWatchlist':
        return MaterialPageRoute(builder: (_) => EditWatchlist(settings.arguments as List<dynamic>));
      case '/SymbolDetail':
        return MaterialPageRoute(builder: (_) => SymbolDetail(settings.arguments as String));
      case '/CreatePost':
        return MaterialPageRoute(builder: (_) => CreatePost(symbol: settings.arguments as String?));
      case '/UserId':
        return MaterialPageRoute(builder: (_) => UserId());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
              body: Center(
                child: Text('404', style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold)),
              )
          ),
        );
    }
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Akshay Pawar Patil'),
      ),
      body: const Center(
        child: Text(
          'Text',
        ),
      ),
    );
  }
}
