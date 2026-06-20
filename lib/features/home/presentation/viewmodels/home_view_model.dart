import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../movies/data/repositories/movie_repository.dart';
import 'home_state.dart';

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  return MovieRepository();
});

final homeViewModelProvider =
    AsyncNotifierProvider<HomeViewModel, HomeState>(HomeViewModel.new);

class HomeViewModel extends AsyncNotifier<HomeState> {
  @override
  Future<HomeState> build() async {
    return _fetchHomeData();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchHomeData);
  }

  Future<HomeState> _fetchHomeData() async {
    final repository = ref.read(movieRepositoryProvider);
    final results = await Future.wait([
      repository.getTrendingMovies(),
      repository.getNowPlayingMovies(),
    ]);

    return HomeState(
      trendingMovies: results[0].movies,
      newReleaseMovies: results[1].movies,
    );
  }
}
