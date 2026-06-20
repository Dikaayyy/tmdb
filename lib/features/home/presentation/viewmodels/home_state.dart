import '../../../movies/data/models/genre_model.dart';
import '../../../movies/data/models/movie_model.dart';

class HomeState {
  const HomeState({
    required this.trendingMovies,
    required this.newReleaseMovies,
    required this.topRatedMovies,
    required this.genres,
  });

  final List<MovieModel> trendingMovies;
  final List<MovieModel> newReleaseMovies;
  final List<MovieModel> topRatedMovies;
  final List<GenreModel> genres;
}
