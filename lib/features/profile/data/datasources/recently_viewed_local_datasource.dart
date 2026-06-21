import 'package:hive/hive.dart';

import '../../../movies/data/models/movie_model.dart';

class RecentlyViewedLocalDatasource {
  RecentlyViewedLocalDatasource({Box? box}) : _box = box ?? Hive.box('appBox');

  static const _recentlyViewedKey = 'recentlyViewedMovies';

  final Box _box;

  List<MovieModel> getMovies() {
    final rawMovies = _box.get(
      _recentlyViewedKey,
      defaultValue: const <Map<String, dynamic>>[],
    );

    return (rawMovies as List)
        .whereType<Map>()
        .map((movie) => MovieModel.fromJson(Map<String, dynamic>.from(movie)))
        .toList();
  }

  Future<void> saveMovie(MovieModel movie) async {
    final movies = getMovies()
      ..removeWhere(
        (recentMovie) =>
            recentMovie.id == movie.id && recentMovie.mediaType == movie.mediaType,
      )
      ..insert(0, movie);

    await _box.put(
      _recentlyViewedKey,
      movies.take(6).map((movie) => movie.toJson()).toList(),
    );
  }

  Future<void> clearMovies() async {
    await _box.delete(_recentlyViewedKey);
  }
}
