import '../../../../core/network/network_error_handler.dart';
import '../datasources/tmdb_remote_datasource.dart';
import '../models/genre_list_response_model.dart';
import '../models/movie_detail_model.dart';
import '../models/movie_list_response_model.dart';
import '../models/movie_model.dart';

class MovieRepository {
  MovieRepository({TmdbRemoteDatasource? remoteDatasource})
    : _remoteDatasource = remoteDatasource ?? TmdbRemoteDatasource();

  final TmdbRemoteDatasource _remoteDatasource;

  Future<MovieListResponseModel> getTrendingAll() async {
    final response = await _remoteDatasource.getTrendingAll();
    return _parseMovieList(response, 'trending');
  }

  Future<MovieListResponseModel> getTrendingMovies() async {
    final response = await _remoteDatasource.getTrendingMovies();
    return _parseMovieList(response, 'trending movie');
  }

  Future<MovieListResponseModel> getTrendingTv() async {
    final response = await _remoteDatasource.getTrendingTv();
    return _parseMovieList(response, 'trending TV');
  }

  Future<MovieListResponseModel> getNowPlayingMovies() async {
    final response = await _remoteDatasource.getNowPlayingMovies();
    return _parseMovieList(response, 'new release movie');
  }

  Future<MovieListResponseModel> getOnTheAirTv() async {
    final response = await _remoteDatasource.getOnTheAirTv();
    return _parseMovieList(response, 'new release TV');
  }

  Future<MovieListResponseModel> getTopRatedMovies() async {
    final response = await _remoteDatasource.getTopRatedMovies();
    return _parseMovieList(response, 'top rated movie');
  }

  Future<MovieListResponseModel> getTopRatedTv() async {
    final response = await _remoteDatasource.getTopRatedTv();
    return _parseMovieList(response, 'top rated TV');
  }

  Future<GenreListResponseModel> getMovieGenres() async {
    final response = await _remoteDatasource.getMovieGenres();
    return _parseGenreList(response);
  }

  Future<GenreListResponseModel> getTvGenres() async {
    final response = await _remoteDatasource.getTvGenres();
    return _parseGenreList(response, isTv: true);
  }

  Future<MovieListResponseModel> discoverMoviesByGenre(int genreId) async {
    final response = await _remoteDatasource.discoverMoviesByGenre(genreId);
    return _parseMovieList(response, 'genre movie');
  }

  Future<MovieListResponseModel> discoverTvByGenre(int genreId) async {
    final response = await _remoteDatasource.discoverTvByGenre(genreId);
    return _parseMovieList(response, 'genre TV');
  }

  Future<MovieDetailModel> getMovieDetail(int movieId) async {
    final detailResponse = await _remoteDatasource.getMovieDetail(
      movieId,
      appendToResponse: 'credits',
    );
    final reviewResponse = await _getFallbackMap(
      () => _remoteDatasource.getMovieReviews(movieId),
      fallback: {'results': const []},
    );
    return MovieDetailModel.fromJson({
      ...detailResponse,
      'reviews': reviewResponse,
    });
  }

  Future<MovieDetailModel> getTvDetail(int tvId) async {
    final detailResponse = await _remoteDatasource.getTvDetail(
      tvId,
      appendToResponse: 'credits',
    );
    final reviewResponse = await _getFallbackMap(
      () => _remoteDatasource.getTvReviews(tvId),
      fallback: {'results': const []},
    );
    return MovieDetailModel.fromJson({
      ...detailResponse,
      'reviews': reviewResponse,
    });
  }

  Future<MovieDetailModel> getMediaDetail(MovieModel movie) async {
    if (movie.isTv) {
      return getTvDetail(movie.id);
    }
    return getMovieDetail(movie.id);
  }

  Future<Map<String, dynamic>> _getFallbackMap(
    Future<Map<String, dynamic>> Function() request, {
    required Map<String, dynamic> fallback,
  }) async {
    try {
      return await request();
    } catch (_) {
      return fallback;
    }
  }

  MovieListResponseModel _parseMovieList(
    Map<String, dynamic> response,
    String context,
  ) {
    final model = MovieListResponseModel.fromJson(response);
    if (model.movies.isEmpty) {
      throw NetworkErrorHandler.emptyData(context);
    }
    return model;
  }

  GenreListResponseModel _parseGenreList(
    Map<String, dynamic> response, {
    bool isTv = false,
  }) {
    final model = GenreListResponseModel.fromJson(response, isTv: isTv);
    if (model.genres.isEmpty) {
      throw NetworkErrorHandler.emptyData('genre');
    }
    return model;
  }
}
