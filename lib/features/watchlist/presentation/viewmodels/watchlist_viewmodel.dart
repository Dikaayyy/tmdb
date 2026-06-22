import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/watchlist_movie_model.dart';
import '../../data/providers/watchlist_repository_provider.dart';
import '../../data/repositories/watchlist_repository.dart';

final watchlistViewModelProvider =
    NotifierProvider<WatchlistViewModel, List<WatchlistMovieModel>>(
      WatchlistViewModel.new,
    );

class WatchlistViewModel extends Notifier<List<WatchlistMovieModel>> {
  late final WatchlistRepository _repository;

  @override
  List<WatchlistMovieModel> build() {
    _repository = ref.read(watchlistRepositoryProvider);
    return _repository.getAllMovies();
  }

  List<WatchlistMovieModel> getAllMovies() {
    state = _repository.getAllMovies();
    return state;
  }

  Future<void> addMovie(WatchlistMovieModel movie) async {
    await _repository.addMovie(movie);
    state = _repository.getAllMovies();
  }

  Future<void> removeMovieById(int movieId) async {
    await _repository.removeMovieById(movieId);
    state = _repository.getAllMovies();
  }

  bool isInWatchlist(int movieId) {
    return state.any((movie) => movie.id == movieId);
  }

  bool containsMovie(WatchlistMovieModel selectedMovie) {
    return state.any(
      (movie) =>
          movie.id == selectedMovie.id &&
          movie.mediaType == selectedMovie.mediaType,
    );
  }

  Future<bool> toggleWatchlist(WatchlistMovieModel movie) async {
    final isAdded = await _repository.toggleWatchlist(movie);
    state = _repository.getAllMovies();
    return isAdded;
  }
}
