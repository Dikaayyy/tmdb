import 'package:hive/hive.dart';

class HiveService {
  static final Box _box = Hive.box('appBox');
  static const _isLoggedInKey = 'isLoggedIn';
  static const _isGuestKey = 'isGuest';
  static const _watchlistKey = 'watchlistMovieIds';

  static Future<void> saveLogin(bool value) async {
    await _box.put(_isLoggedInKey, value);
    await _box.put(_isGuestKey, false);
  }

  static Future<void> saveGuestLogin() async {
    await _box.put(_isLoggedInKey, true);
    await _box.put(_isGuestKey, true);
  }

  static bool getLoginStatus() {
    return _box.get(_isLoggedInKey, defaultValue: false);
  }

  static bool getGuestStatus() {
    return _box.get(_isGuestKey, defaultValue: false);
  }

  static Future<void> logout() async {
    await _box.put(_isLoggedInKey, false);
    await _box.put(_isGuestKey, false);
  }

  static List<int> getWatchlistMovieIds() {
    return (_box.get(_watchlistKey, defaultValue: const <int>[]) as List)
        .cast<int>();
  }

  static bool isInWatchlist(int movieId) {
    return getWatchlistMovieIds().contains(movieId);
  }

  static Future<void> toggleWatchlistMovie(int movieId) async {
    final watchlist = getWatchlistMovieIds();

    if (watchlist.contains(movieId)) {
      watchlist.remove(movieId);
    } else {
      watchlist.add(movieId);
    }

    await _box.put(_watchlistKey, watchlist);
  }
}
