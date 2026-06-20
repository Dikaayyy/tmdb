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

  bool isInWatchlist(int movieId) {
    return _localDatasource.isInWatchlist(movieId);
  }

  Future<bool> toggleWatchlist(WatchlistMovieModel movie) async {
    if (isInWatchlist(movie.id)) {
      await removeMovieById(movie.id);
      return false;
    }

    await addMovie(movie);
    return true;
  }
}
