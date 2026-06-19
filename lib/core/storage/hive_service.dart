import 'package:hive/hive.dart';

class HiveService {
  static final Box _box = Hive.box('appBox');

  static Future<void> saveLogin(bool value) async {
    await _box.put('isLoggedIn', value);
  }

  static bool getLoginStatus() {
    return _box.get('isLoggedIn', defaultValue: false);
  }

  static Future<void> logout() async {
    await _box.put('isLoggedIn', false);
  }
}