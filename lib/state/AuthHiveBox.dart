import 'package:hive/hive.dart';

class AuthHiveBox {
  static const String _boxName = 'auth_box';

  // Method to store the token in Hive
  static Future<void> setToken(String token) async {
    await Hive.openBox<String>(_boxName);
    await Hive.box<String>(_boxName).put('token', token);
  }

  // Method to retrieve the token from Hive
  static Future<String?> getToken() async {
    await Hive.openBox<String>(_boxName);
    return Hive.box<String>(_boxName).get('token');
  }
}
