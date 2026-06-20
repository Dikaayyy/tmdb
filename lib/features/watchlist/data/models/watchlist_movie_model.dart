import '../../../movies/data/models/movie_detail_model.dart';
import '../../../movies/data/models/movie_model.dart';

class WatchlistMovieModel {
  const WatchlistMovieModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.mediaType,
  });

  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate;
  final MediaType mediaType;

  factory WatchlistMovieModel.fromMovie(MovieModel movie) {
    return WatchlistMovieModel(
      id: movie.id,
      title: movie.title,
      overview: movie.overview,
      posterPath: movie.posterPath,
      backdropPath: movie.backdropPath,
      voteAverage: movie.voteAverage,
      releaseDate: movie.releaseDate,
      mediaType: movie.mediaType,
    );
  }

  factory WatchlistMovieModel.fromDetail(
    MovieDetailModel detail, {
    required MediaType mediaType,
  }) {
    return WatchlistMovieModel(
      id: detail.id,
      title: detail.title,
      overview: detail.overview,
      posterPath: detail.posterPath,
      backdropPath: detail.backdropPath,
      voteAverage: detail.voteAverage,
      releaseDate: detail.releaseDate,
      mediaType: mediaType,
    );
  }

  factory WatchlistMovieModel.fromJson(Map<String, dynamic> json) {
    return WatchlistMovieModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['posterPath'] ?? '',
      backdropPath: json['backdropPath'] ?? '',
      voteAverage: (json['voteAverage'] ?? 0).toDouble(),
      releaseDate: json['releaseDate'] ?? '',
      mediaType: json['mediaType'] == 'tv' ? MediaType.tv : MediaType.movie,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'posterPath': posterPath,
      'backdropPath': backdropPath,
      'voteAverage': voteAverage,
      'releaseDate': releaseDate,
      'mediaType': mediaType == MediaType.tv ? 'tv' : 'movie',
    };
  }

  MovieModel toMovieModel() {
    return MovieModel(
      id: id,
      title: title,
      overview: overview,
      posterPath: posterPath,
      backdropPath: backdropPath,
      voteAverage: voteAverage,
      releaseDate: releaseDate,
      genreIds: const [],
      mediaType: mediaType,
    );
  }
}
