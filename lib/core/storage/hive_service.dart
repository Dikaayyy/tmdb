import 'package:hive/hive.dart';

class HiveService {
  static final Box _box = Hive.box('appBox');
  static const _watchlistKey = 'watchlistMovieIds';

  static Future<void> saveLogin(bool value) async {
    await _box.put('isLoggedIn', value);
  }

  static bool getLoginStatus() {
    return _box.get('isLoggedIn', defaultValue: false);
  }

  static Future<void> logout() async {
    await _box.put('isLoggedIn', false);
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
