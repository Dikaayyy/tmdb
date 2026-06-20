class GenreModel {
  const GenreModel({
    required this.name,
    this.movieGenreId,
    this.tvGenreId,
  });

  final String name;
  final int? movieGenreId;
  final int? tvGenreId;

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      name: json['name'] ?? '',
      movieGenreId: json['id'],
    );
  }

  GenreModel copyWith({
    String? name,
    int? movieGenreId,
    int? tvGenreId,
  }) {
    return GenreModel(
      name: name ?? this.name,
      movieGenreId: movieGenreId ?? this.movieGenreId,
      tvGenreId: tvGenreId ?? this.tvGenreId,
    );
  }
}
