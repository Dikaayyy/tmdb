import '../datasources/tmdb_remote_datasource.dart';
import '../models/movie_list_response_model.dart';

class MovieRepository {
  MovieRepository({TmdbRemoteDatasource? remoteDatasource})
      : _remoteDatasource = remoteDatasource ?? TmdbRemoteDatasource();

  final TmdbRemoteDatasource _remoteDatasource;

  Future<MovieListResponseModel> getTrendingMovies() async {
    final response = await _remoteDatasource.getTrendingMovies();
    return MovieListResponseModel.fromJson(response);
  }

  Future<MovieListResponseModel> getNowPlayingMovies() async {
    final response = await _remoteDatasource.getNowPlayingMovies();
    return MovieListResponseModel.fromJson(response);
  }

  Future<MovieListResponseModel> getTopRatedMovies() async {
    final response = await _remoteDatasource.getTopRatedMovies();
    return MovieListResponseModel.fromJson(response);
  }
}
