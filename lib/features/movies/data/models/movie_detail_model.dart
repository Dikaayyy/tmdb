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
    required this.numberOfEpisodes,
    required this.genres,
    required this.adult,
    required this.crew,
    required this.cast,
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
  final List<CrewModel> crew;
  final List<CastModel> cast;

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    final credits = json['credits'] as Map<String, dynamic>? ?? {};
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
      crew: (credits['crew'] as List<dynamic>? ?? const [])
          .map((item) => CrewModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      cast: (credits['cast'] as List<dynamic>? ?? const [])
          .map((item) => CastModel.fromJson(item as Map<String, dynamic>))
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

  String get fullPosterUrl {
    if (posterPath.isEmpty) return '';
    return '${ApiConstants.imageUrl}$posterPath';
  }

  String get fullBackdropUrl {
    if (backdropPath.isEmpty) return '';
    return '${ApiConstants.imageUrl}$backdropPath';
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

  String get fullProfileUrl {
    if (profilePath.isEmpty) return '';
    return '${ApiConstants.imageUrl}$profilePath';
  }
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

  String get fullProfileUrl {
    if (profilePath.isEmpty) return '';
    return '${ApiConstants.imageUrl}$profilePath';
  }
}
