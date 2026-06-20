import 'genre_model.dart';

class GenreListResponseModel {
  const GenreListResponseModel({required this.genres});

  final List<GenreModel> genres;

  factory GenreListResponseModel.fromJson(
    Map<String, dynamic> json, {
    bool isTv = false,
  }) {
    return GenreListResponseModel(
      genres: (json['genres'] as List<dynamic>? ?? const [])
          .map(
            (genreJson) => GenreModel.fromJson(
              genreJson as Map<String, dynamic>,
              isTv: isTv,
            ),
          )
          .toList(),
    );
  }
}
