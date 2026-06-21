import 'package:intl/intl.dart';

import '../../data/models/movie_detail_model.dart';
import '../widgets/movie_detail_cast_crew_section.dart';

class MovieDetailFormatter {
  const MovieDetailFormatter._();

  static String backdropUrl(MovieDetailModel detail) {
    return detail.fullBackdropUrl.isNotEmpty
        ? detail.fullBackdropUrl
        : detail.fullPosterUrl;
  }

  static String genresText(MovieDetailModel detail) {
    return detail.genres.map((genre) => genre.name).join(', ');
  }

  static String releaseDate(String rawDate) {
    final parsedDate = DateTime.tryParse(rawDate);
    if (parsedDate == null) return rawDate.isEmpty ? '-' : rawDate;
    return DateFormat('dd/MM/yyyy').format(parsedDate);
  }

  static String runtimeOrEpisodes(MovieDetailModel detail, {required bool isTv}) {
    if (detail.runtime > 0) return _runtime(detail.runtime);
    if (isTv && detail.numberOfEpisodes > 0) {
      return '${detail.numberOfEpisodes} episode';
    }
    return '-';
  }

  static int rating(MovieDetailModel detail) {
    return (detail.voteAverage * 10).round();
  }

  static List<MovieDetailCastCrewItem> castCrewItems(MovieDetailModel detail) {
    final castItems = detail.cast
        .where((cast) => cast.name.isNotEmpty)
        .take(5)
        .map(
          (cast) => MovieDetailCastCrewItem(
            name: cast.name,
            role: cast.character.isEmpty ? 'Pemeran' : cast.character,
            imageUrl: cast.fullProfileUrl,
          ),
        );

    final crewItems = detail.crew
        .where((crew) => crew.name.isNotEmpty && crew.job.isNotEmpty)
        .take(5)
        .map(
          (crew) => MovieDetailCastCrewItem(
            name: crew.name,
            role: crew.job,
            imageUrl: crew.fullProfileUrl,
          ),
        );

    return [...castItems, ...crewItems].take(5).toList();
  }

  static String _runtime(int runtime) {
    if (runtime <= 0) return '-';
    final hours = runtime ~/ 60;
    final minutes = runtime % 60;
    if (hours <= 0) return '$minutes menit';
    return '$hours jam $minutes menit';
  }
}
