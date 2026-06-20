import '../../../../core/constants/api_constants.dart';
import 'genre_model.dart';

class MovieDetailModel {
  const MovieDetailModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.runtime,
    required this.genres,
    required this.adult,
  });

  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate;
  final int runtime;
  final List<GenreModel> genres;
  final bool adult;

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? '',
      runtime: json['runtime'] ?? 0,
      genres: (json['genres'] as List<dynamic>? ?? const [])
          .map((genre) => GenreModel.fromJson(genre as Map<String, dynamic>))
          .toList(),
      adult: json['adult'] ?? false,
    );
  }

  String get fullPosterUrl {
    if (posterPath.isEmpty) return '';
    return '${ApiConstants.imageUrl}$posterPath';
  }

  String get fullBackdropUrl {
    if (backdropPath.isEmpty) return '';
    return '${ApiConstants.imageUrl}$backdropPath';
  }
}
