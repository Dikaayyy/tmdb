import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../movies/data/models/movie_model.dart';
import '../../../movies/data/repositories/movie_repository.dart';

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  return MovieRepository();
});

final homeViewModelProvider =
    AsyncNotifierProvider<HomeViewModel, List<MovieModel>>(HomeViewModel.new);

class HomeViewModel extends AsyncNotifier<List<MovieModel>> {
  @override
  Future<List<MovieModel>> build() async {
    return _fetchTrendingMovies();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchTrendingMovies);
  }

  Future<List<MovieModel>> _fetchTrendingMovies() async {
    final repository = ref.read(movieRepositoryProvider);
    final response = await repository.getTrendingMovies();
    return response.movies;
  }
}
