import '../../../../core/utils/tmdb_image_url_builder.dart';
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
    required this.numberOfEpisodes,
    required this.genres,
    required this.adult,
    required this.status,
    required this.originalLanguage,
    required this.budget,
    required this.revenue,
    required this.crew,
    required this.cast,
    required this.reviews,
  });

  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate;
  final int runtime;
  final int numberOfEpisodes;
  final List<GenreModel> genres;
  final bool adult;
  final String status;
  final String originalLanguage;
  final int budget;
  final int revenue;
  final List<CrewModel> crew;
  final List<CastModel> cast;
  final List<ReviewModel> reviews;

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    final credits = json['credits'] as Map<String, dynamic>? ?? {};
    final reviews = json['reviews'] as Map<String, dynamic>? ?? {};
    final runtime = _parseRuntime(json);

    return MovieDetailModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? json['name'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? json['first_air_date'] ?? '',
      runtime: runtime,
      numberOfEpisodes: _parseNumber(json['number_of_episodes']),
      genres: (json['genres'] as List<dynamic>? ?? const [])
          .map((genre) => GenreModel.fromJson(genre as Map<String, dynamic>))
          .toList(),
      adult: json['adult'] ?? false,
      status: json['status'] ?? '',
      originalLanguage: json['original_language'] ?? '',
      budget: _parseNumber(json['budget']),
      revenue: _parseNumber(json['revenue']),
      crew: (credits['crew'] as List<dynamic>? ?? const [])
          .map((item) => CrewModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      cast: (credits['cast'] as List<dynamic>? ?? const [])
          .map((item) => CastModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      reviews: (reviews['results'] as List<dynamic>? ?? const [])
          .map((item) => ReviewModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  static int _parseRuntime(Map<String, dynamic> json) {
    final movieRuntime = json['runtime'];
    if (movieRuntime is num && movieRuntime > 0) return movieRuntime.toInt();

    final episodeRunTime = json['episode_run_time'];
    if (episodeRunTime is List && episodeRunTime.isNotEmpty) {
      final tvRuntime = episodeRunTime.first;
      if (tvRuntime is num) return tvRuntime.toInt();
    }

    return 0;
  }

  static int _parseNumber(dynamic value) {
    if (value is num) return value.toInt();
    return 0;
  }

  String get fullPosterUrl => TmdbImageUrlBuilder.build(posterPath);

  String get fullBackdropUrl => TmdbImageUrlBuilder.build(backdropPath);
}

class ReviewModel {
  const ReviewModel({
    required this.author,
    required this.content,
    required this.createdAt,
    required this.rating,
  });

  final String author;
  final String content;
  final String createdAt;
  final double rating;

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    final authorDetails = json['author_details'] as Map<String, dynamic>? ?? {};
    return ReviewModel(
      author: json['author'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['created_at'] ?? '',
      rating: _parseRating(authorDetails['rating']),
    );
  }

  static double _parseRating(dynamic value) {
    if (value is num) return value.toDouble();
    return 0;
  }
}

class CrewModel {
  const CrewModel({
    required this.name,
    required this.job,
    required this.profilePath,
  });

  final String name;
  final String job;
  final String profilePath;

  factory CrewModel.fromJson(Map<String, dynamic> json) {
    return CrewModel(
      name: json['name'] ?? '',
      job: json['job'] ?? '',
      profilePath: json['profile_path'] ?? '',
    );
  }

  String get fullProfileUrl => TmdbImageUrlBuilder.build(profilePath);
}

class CastModel {
  const CastModel({
    required this.name,
    required this.character,
    required this.profilePath,
  });

  final String name;
  final String character;
  final String profilePath;

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      name: json['name'] ?? '',
      character: json['character'] ?? '',
      profilePath: json['profile_path'] ?? '',
    );
  }

  String get fullProfileUrl => TmdbImageUrlBuilder.build(profilePath);
}
