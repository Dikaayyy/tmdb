import '../../../../core/network/dio_client.dart';

class TmdbRemoteDatasource {
  Future<Map<String, dynamic>> getTrendingAll() async {
    final response = await DioClient.instance.get('/trending/all/day');
    return response.data;
  }

  Future<Map<String, dynamic>> getTrendingMovies() async {
    final response = await DioClient.instance.get('/trending/movie/day');
    return response.data;
  }

  Future<Map<String, dynamic>> getTrendingTv() async {
    final response = await DioClient.instance.get('/trending/tv/day');
    return response.data;
  }

  Future<Map<String, dynamic>> getNowPlayingMovies() async {
    final response = await DioClient.instance.get('/movie/now_playing');
    return response.data;
  }

  Future<Map<String, dynamic>> getOnTheAirTv() async {
    final response = await DioClient.instance.get('/tv/on_the_air');
    return response.data;
  }

  Future<Map<String, dynamic>> getTopRatedMovies() async {
    final response = await DioClient.instance.get('/movie/top_rated');
    return response.data;
  }

  Future<Map<String, dynamic>> getTopRatedTv() async {
    final response = await DioClient.instance.get('/tv/top_rated');
    return response.data;
  }

  Future<Map<String, dynamic>> getMovieGenres() async {
    final response = await DioClient.instance.get('/genre/movie/list');
    return response.data;
  }

  Future<Map<String, dynamic>> getTvGenres() async {
    final response = await DioClient.instance.get('/genre/tv/list');
    return response.data;
  }

  Future<Map<String, dynamic>> discoverMoviesByGenre(int genreId) async {
    final response = await DioClient.instance.get(
      '/discover/movie',
      queryParameters: {'with_genres': genreId},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> discoverTvByGenre(int genreId) async {
    final response = await DioClient.instance.get(
      '/discover/tv',
      queryParameters: {'with_genres': genreId},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getMovieDetail(
    int movieId, {
    String? appendToResponse,
  }) async {
    final response = await DioClient.instance.get(
      '/movie/$movieId',
      queryParameters: appendToResponse == null
          ? null
          : {'append_to_response': appendToResponse},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getTvDetail(
    int tvId, {
    String? appendToResponse,
  }) async {
    final response = await DioClient.instance.get(
      '/tv/$tvId',
      queryParameters: appendToResponse == null
          ? null
          : {'append_to_response': appendToResponse},
    );
    return response.data;
  }
}
