class GenreModel {
  const GenreModel({required this.name, this.movieGenreId, this.tvGenreId});

  final String name;
  final int? movieGenreId;
  final int? tvGenreId;

  factory GenreModel.fromJson(Map<String, dynamic> json, {bool isTv = false}) {
    final id = json['id'] as int?;
    return GenreModel(
      name: json['name'] ?? '',
      movieGenreId: isTv ? null : id,
      tvGenreId: isTv ? id : null,
    );
  }

  GenreModel copyWith({String? name, int? movieGenreId, int? tvGenreId}) {
    return GenreModel(
      name: name ?? this.name,
      movieGenreId: movieGenreId ?? this.movieGenreId,
      tvGenreId: tvGenreId ?? this.tvGenreId,
    );
  }
}
