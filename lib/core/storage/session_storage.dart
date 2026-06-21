import 'package:hive/hive.dart';

class SessionStorage {
  SessionStorage({Box? box}) : _box = box ?? Hive.box('appBox');

  static const _isLoggedInKey = 'isLoggedIn';
  static const _isGuestKey = 'isGuest';

  final Box _box;

  Future<void> saveLogin(bool value) async {
    await _box.put(_isLoggedInKey, value);
    await _box.put(_isGuestKey, false);
  }

  Future<void> saveGuestLogin() async {
    await _box.put(_isLoggedInKey, true);
    await _box.put(_isGuestKey, true);
  }

  bool getLoginStatus() {
    return _box.get(_isLoggedInKey, defaultValue: false);
  }

  bool getGuestStatus() {
    return _box.get(_isGuestKey, defaultValue: false);
  }

  Future<void> logout() async {
    await _box.put(_isLoggedInKey, false);
    await _box.put(_isGuestKey, false);
  }
}
