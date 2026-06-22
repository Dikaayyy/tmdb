import 'package:hive/hive.dart';

import '../models/watchlist_movie_model.dart';

class WatchlistLocalDatasource {
  WatchlistLocalDatasource({Box? box}) : _box = box ?? Hive.box('appBox');

  static const _watchlistKey = 'watchlistMovies';

  final Box _box;

  List<WatchlistMovieModel> getAllMovies() {
    final rawMovies = _box.get(_watchlistKey, defaultValue: const <dynamic>[]);

    return (rawMovies as List)
        .whereType<Map>()
        .map(
          (movie) =>
              WatchlistMovieModel.fromJson(Map<String, dynamic>.from(movie)),
        )
        .toList();
  }

  Future<void> addMovie(WatchlistMovieModel movie) async {
    final movies = getAllMovies();
    final existingIndex = movies.indexWhere((item) => _isSameMovie(item, movie));

    if (existingIndex >= 0) {
      movies[existingIndex] = movie;
    } else {
      movies.add(movie);
    }

    await _saveMovies(movies);
  }

  Future<void> removeMovieById(int movieId) async {
    final movies = getAllMovies()..removeWhere((movie) => movie.id == movieId);
    await _saveMovies(movies);
  }

  Future<void> removeMovie(WatchlistMovieModel movie) async {
    final movies = getAllMovies()..removeWhere((item) => _isSameMovie(item, movie));
    await _saveMovies(movies);
  }

  bool isInWatchlist(int movieId) {
    return getAllMovies().any((movie) => movie.id == movieId);
  }

  bool containsMovie(WatchlistMovieModel movie) {
    return getAllMovies().any((item) => _isSameMovie(item, movie));
  }

  bool _isSameMovie(WatchlistMovieModel a, WatchlistMovieModel b) {
    return a.id == b.id && a.mediaType == b.mediaType;
  }

  Future<void> _saveMovies(List<WatchlistMovieModel> movies) async {
    await _box.put(
      _watchlistKey,
      movies.map((movie) => movie.toJson()).toList(),
    );
  }
}
