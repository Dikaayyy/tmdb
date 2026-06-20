import '../../../../core/network/dio_client.dart';
import '../../../../core/network/network_error_handler.dart';

class TmdbRemoteDatasource {
  Future<Map<String, dynamic>> getTrendingAll() async {
    return _request('/trending/all/day');
  }

  Future<Map<String, dynamic>> getTrendingMovies() async {
    return _request('/trending/movie/day');
  }

  Future<Map<String, dynamic>> getTrendingTv() async {
    return _request('/trending/tv/day');
  }

  Future<Map<String, dynamic>> getNowPlayingMovies() async {
    return _request('/movie/now_playing');
  }

  Future<Map<String, dynamic>> getOnTheAirTv() async {
    return _request('/tv/on_the_air');
  }

  Future<Map<String, dynamic>> getTopRatedMovies() async {
    return _request('/movie/top_rated');
  }

  Future<Map<String, dynamic>> getTopRatedTv() async {
    return _request('/tv/top_rated');
  }

  Future<Map<String, dynamic>> getMovieGenres() async {
    return _request('/genre/movie/list');
  }

  Future<Map<String, dynamic>> getTvGenres() async {
    return _request('/genre/tv/list');
  }

  Future<Map<String, dynamic>> discoverMoviesByGenre(int genreId) async {
    return _request(
      '/discover/movie',
      queryParameters: {'with_genres': genreId},
    );
  }

  Future<Map<String, dynamic>> discoverTvByGenre(int genreId) async {
    return _request('/discover/tv', queryParameters: {'with_genres': genreId});
  }

  Future<Map<String, dynamic>> getMovieDetail(
    int movieId, {
    String? appendToResponse,
  }) async {
    return _request(
      '/movie/$movieId',
      queryParameters: appendToResponse == null
          ? null
          : {'append_to_response': appendToResponse},
    );
  }

  Future<Map<String, dynamic>> getMovieReviews(int movieId) async {
    return _request('/movie/$movieId/reviews');
  }

  Future<Map<String, dynamic>> getTvDetail(
    int tvId, {
    String? appendToResponse,
  }) async {
    return _request(
      '/tv/$tvId',
      queryParameters: appendToResponse == null
          ? null
          : {'append_to_response': appendToResponse},
    );
  }

  Future<Map<String, dynamic>> getTvReviews(int tvId) async {
    return _request('/tv/$tvId/reviews');
  }

  Future<Map<String, dynamic>> _request(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await DioClient.instance.get(
        path,
        queryParameters: queryParameters,
      );
      final data = response.data;

      if (data is Map<String, dynamic>) {
        return data;
      }

      if (data is Map) {
        return Map<String, dynamic>.from(data);
      }

      throw NetworkErrorHandler.emptyData();
    } catch (error) {
      throw NetworkErrorHandler.handle(error);
    }
  }
}
