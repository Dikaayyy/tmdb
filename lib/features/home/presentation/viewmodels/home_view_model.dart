import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../movies/data/models/genre_model.dart';
import '../../../movies/data/models/genre_list_response_model.dart';
import '../../../movies/data/models/movie_model.dart';
import '../../../movies/data/models/movie_list_response_model.dart';
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
      repository.getTopRatedMovies(),
      repository.getTopRatedTv(),
      repository.getMovieGenres(),
      repository.getTvGenres(),
    ]);

    final trendingResponse = results[0] as MovieListResponseModel;
    final newReleaseResponse = results[1] as MovieListResponseModel;
    final topRatedResponse = results[2] as MovieListResponseModel;
    final topRatedTvResponse = results[3] as MovieListResponseModel;
    final movieGenresResponse = results[4] as GenreListResponseModel;
    final tvGenresResponse = results[5] as GenreListResponseModel;

    final uniqueGenresByName = <String, GenreModel>{};

    for (final genre in movieGenresResponse.genres) {
      uniqueGenresByName[genre.name] = GenreModel(
        name: genre.name,
        movieGenreId: genre.movieGenreId,
      );
    }

    for (final genre in tvGenresResponse.genres) {
      final existing = uniqueGenresByName[genre.name];
      uniqueGenresByName[genre.name] = (existing ?? GenreModel(name: genre.name))
          .copyWith(tvGenreId: genre.movieGenreId);
    }

    return HomeState(
      trendingMovies: trendingResponse.movies,
      newReleaseMovies: _sortByNewest(newReleaseResponse.movies),
      topRatedMovies: _sortByTopRated([
        ...topRatedResponse.movies,
        ...topRatedTvResponse.movies,
      ]),
      genres: uniqueGenresByName.values
          .where((genre) => genre.movieGenreId != null && genre.tvGenreId != null)
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name)),
    );
  }

  List<MovieModel> _sortByNewest(List<MovieModel> movies) {
    final sortedMovies = [...movies];
    sortedMovies.sort(
      (a, b) => _parseDate(b.releaseDate).compareTo(_parseDate(a.releaseDate)),
    );
    return sortedMovies;
  }

  List<MovieModel> _sortByTopRated(List<MovieModel> movies) {
    final sortedMovies = [...movies];
    sortedMovies.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
    return sortedMovies;
  }

  DateTime _parseDate(String rawDate) {
    return DateTime.tryParse(rawDate) ?? DateTime.fromMillisecondsSinceEpoch(0);
  }
}
