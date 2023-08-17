import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// Hive Local Database
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:maven_market/state/AppNavigatorKey.dart';
import 'package:maven_market/state/AuthState.dart';
// helper
import 'RouteGenerator.dart';
// State
import 'package:provider/provider.dart';
import 'state/DataHouse.dart';
import 'state/PostState.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    if (kDebugMode) {
      print('Error initializing Firebase: $e');
    }
  }
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  await Hive.openBox('app_state');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<DataHouse>(create: (_) => DataHouse()),
        ChangeNotifierProvider<PostState>(create: (_) => PostState()),
        ChangeNotifierProvider<AuthState>(create: (_) => AuthState()),
      ],
      child: ValueListenableBuilder(
        valueListenable: Hive.box('app_state').listenable(keys: [
          'darkMode'
        ]),
        builder: (BuildContext context, Box<dynamic> box, Widget? child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            // themeMode: box.get('darkMode', defaultValue: true) ? ThemeMode.dark : ThemeMode.light,
            themeMode: ThemeMode.light,
            theme: ThemeData(
              primaryColor: Colors.grey[50],
              brightness: Brightness.light,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.grey[50],
                foregroundColor: Colors.black,
                elevation: 0,
              ),
              dividerTheme: const DividerThemeData(color: Colors.grey, indent: 14.0, endIndent: 14.0, thickness: 0.1, space: 0),
              indicatorColor: Colors.grey,
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all<double>(0),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(240, 154, 105, 1)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: BorderSide(color: Colors.grey[400]!)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: BorderSide(color: Colors.grey.withOpacity(0.3))),
                focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: const BorderSide(color: Colors.red)),
              ),
            ),
            darkTheme: ThemeData(
              primaryColor: Colors.grey[850],
              brightness: Brightness.dark,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.grey[850],
                elevation: 0,
              ),
              dividerTheme: const DividerThemeData(color: Colors.grey, indent: 14.0, endIndent: 14.0, thickness: 0.1, space: 0),
              indicatorColor: Colors.grey,
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all<double>(0),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                  backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(240, 154, 105, 1)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: BorderSide(color: Colors.grey[700]!)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: BorderSide(color: Colors.grey.withOpacity(0.3))),
                focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: const BorderSide(color: Colors.red)),
              ),
            ),
            initialRoute: '/',
            navigatorKey: AppNavigatorKey.navigatorKey,
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        },
      ),
    ),
  );
}
