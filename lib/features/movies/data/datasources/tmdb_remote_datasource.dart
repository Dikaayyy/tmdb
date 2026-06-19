import '../../../../core/network/dio_client.dart';

class TmdbRemoteDatasource {
  Future<Map<String, dynamic>> getTrendingMovies() async {
    final response = await DioClient.instance.get('/trending/movie/day');
    return response.data;
  }

  Future<Map<String, dynamic>> getNowPlayingMovies() async {
    final response = await DioClient.instance.get('/movie/now_playing');
    return response.data;
  }

  Future<Map<String, dynamic>> getTopRatedMovies() async {
    final response = await DioClient.instance.get('/movie/top_rated');
    return response.data;
  }

  Future<Map<String, dynamic>> getGenres() async {
    final response = await DioClient.instance.get('/genre/movie/list');
    return response.data;
  }

  Future<Map<String, dynamic>> getMovieDetail(int movieId) async {
    final response = await DioClient.instance.get('/movie/$movieId');
    return response.data;
  }
}