import '../datasources/watchlist_local_datasource.dart';
import '../models/watchlist_movie_model.dart';

class WatchlistRepository {
  WatchlistRepository({WatchlistLocalDatasource? localDatasource})
    : _localDatasource = localDatasource ?? WatchlistLocalDatasource();

  final WatchlistLocalDatasource _localDatasource;

  List<WatchlistMovieModel> getAllMovies() {
    return _localDatasource.getAllMovies();
  }

  Future<void> addMovie(WatchlistMovieModel movie) {
    return _localDatasource.addMovie(movie);
  }

  Future<void> removeMovieById(int movieId) {
    return _localDatasource.removeMovieById(movieId);
  }

  Future<void> removeMovie(WatchlistMovieModel movie) {
    return _localDatasource.removeMovie(movie);
  }

  bool isInWatchlist(int movieId) {
    return _localDatasource.isInWatchlist(movieId);
  }

  bool containsMovie(WatchlistMovieModel movie) {
    return _localDatasource.containsMovie(movie);
  }

  Future<bool> toggleWatchlist(WatchlistMovieModel movie) async {
    if (containsMovie(movie)) {
      await removeMovie(movie);
      return false;
    }

    await addMovie(movie);
    return true;
  }
}
