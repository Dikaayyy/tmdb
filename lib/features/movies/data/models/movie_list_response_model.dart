import 'movie_model.dart';

class MovieListResponseModel {
  const MovieListResponseModel({
    required this.page,
    required this.movies,
    required this.totalPages,
    required this.totalResults,
  });

  final int page;
  final List<MovieModel> movies;
  final int totalPages;
  final int totalResults;

  factory MovieListResponseModel.fromJson(Map<String, dynamic> json) {
    return MovieListResponseModel(
      page: json['page'] ?? 1,
      movies: (json['results'] as List<dynamic>? ?? const [])
          .map((movieJson) => MovieModel.fromJson(movieJson as Map<String, dynamic>))
          .toList(),
      totalPages: json['total_pages'] ?? 0,
      totalResults: json['total_results'] ?? 0,
    );
  }
}
