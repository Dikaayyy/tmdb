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
    return MovieListResponseModel.fromJson(response);
  }

  Future<MovieListResponseModel> getTrendingMovies() async {
    final response = await _remoteDatasource.getTrendingMovies();
    return MovieListResponseModel.fromJson(response);
  }

  Future<MovieListResponseModel> getTrendingTv() async {
    final response = await _remoteDatasource.getTrendingTv();
    return MovieListResponseModel.fromJson(response);
  }

  Future<MovieListResponseModel> getNowPlayingMovies() async {
    final response = await _remoteDatasource.getNowPlayingMovies();
    return MovieListResponseModel.fromJson(response);
  }

  Future<MovieListResponseModel> getOnTheAirTv() async {
    final response = await _remoteDatasource.getOnTheAirTv();
    return MovieListResponseModel.fromJson(response);
  }

  Future<MovieListResponseModel> getTopRatedMovies() async {
    final response = await _remoteDatasource.getTopRatedMovies();
    return MovieListResponseModel.fromJson(response);
  }

  Future<MovieListResponseModel> getTopRatedTv() async {
    final response = await _remoteDatasource.getTopRatedTv();
    return MovieListResponseModel.fromJson(response);
  }

  Future<GenreListResponseModel> getMovieGenres() async {
    final response = await _remoteDatasource.getMovieGenres();
    return GenreListResponseModel.fromJson(response);
  }

  Future<GenreListResponseModel> getTvGenres() async {
    final response = await _remoteDatasource.getTvGenres();
    return GenreListResponseModel.fromJson(response);
  }

  Future<MovieListResponseModel> discoverMoviesByGenre(int genreId) async {
    final response = await _remoteDatasource.discoverMoviesByGenre(genreId);
    return MovieListResponseModel.fromJson(response);
  }

  Future<MovieListResponseModel> discoverTvByGenre(int genreId) async {
    final response = await _remoteDatasource.discoverTvByGenre(genreId);
    return MovieListResponseModel.fromJson(response);
  }

  Future<MovieDetailModel> getMovieDetail(int movieId) async {
    final response = await _remoteDatasource.getMovieDetail(
      movieId,
      appendToResponse: 'credits',
    );
    return MovieDetailModel.fromJson(response);
  }

  Future<MovieDetailModel> getTvDetail(int tvId) async {
    final response = await _remoteDatasource.getTvDetail(
      tvId,
      appendToResponse: 'credits',
    );
    return MovieDetailModel.fromJson(response);
  }

  Future<MovieDetailModel> getMediaDetail(MovieModel movie) async {
    if (movie.isTv) {
      return getTvDetail(movie.id);
    }
    return getMovieDetail(movie.id);
  }
}
