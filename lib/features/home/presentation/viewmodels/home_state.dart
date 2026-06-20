import '../../../movies/data/models/movie_model.dart';

class HomeState {
  const HomeState({
    required this.trendingMovies,
    required this.newReleaseMovies,
    required this.topRatedMovies,
  });

  final List<MovieModel> trendingMovies;
  final List<MovieModel> newReleaseMovies;
  final List<MovieModel> topRatedMovies;
}
