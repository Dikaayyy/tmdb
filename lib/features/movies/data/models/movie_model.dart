import '../../../../core/utils/tmdb_image_url_builder.dart';

enum MediaType { movie, tv }

class MovieModel {
  const MovieModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.genreIds,
    required this.mediaType,
  });

  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate;
  final List<int> genreIds;
  final MediaType mediaType;

  bool get isTv => mediaType == MediaType.tv;
  bool get isMovie => mediaType == MediaType.movie;

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    final jsonMediaType = json['media_type'] as String?;
    final parsedMediaType = jsonMediaType == 'tv'
        ? MediaType.tv
        : jsonMediaType == 'movie'
        ? MediaType.movie
        : json.containsKey('first_air_date') || json.containsKey('name')
        ? MediaType.tv
        : MediaType.movie;

    return MovieModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? json['name'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? json['first_air_date'] ?? '',
      genreIds: (json['genre_ids'] as List<dynamic>? ?? const [])
          .map((genreId) => genreId as int)
          .toList(),
      mediaType: parsedMediaType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'release_date': releaseDate,
      'genre_ids': genreIds,
      'media_type': mediaType.name,
    };
  }

  String get fullPosterUrl => TmdbImageUrlBuilder.build(posterPath);

  String get fullBackdropUrl => TmdbImageUrlBuilder.build(backdropPath);
}
