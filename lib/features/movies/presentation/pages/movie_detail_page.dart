import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/storage/hive_service.dart';
import '../../data/models/movie_detail_model.dart';
import '../../data/models/movie_model.dart';
import '../../data/repositories/movie_repository.dart';
import '../widgets/movie_detail_cast_crew_section.dart';
import '../widgets/movie_detail_content.dart';
import '../widgets/movie_detail_hero.dart';

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({super.key, required this.movie});

  final MovieModel movie;

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late Future<MovieDetailModel> _movieDetailFuture;
  bool _isInWatchlist = false;

  @override
  void initState() {
    super.initState();
    _movieDetailFuture = MovieRepository().getMediaDetail(widget.movie);
    _isInWatchlist = HiveService.isInWatchlist(widget.movie.id);
  }

  Future<void> _toggleWatchlist() async {
    await HiveService.toggleWatchlistMovie(widget.movie.id);
    setState(() {
      _isInWatchlist = HiveService.isInWatchlist(widget.movie.id);
    });
  }

  List<MovieDetailCastCrewItem> _castCrewItems(MovieDetailModel detail) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<MovieDetailModel>(
        future: _movieDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: SizedBox.shrink());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('${snapshot.error}', textAlign: TextAlign.center),
              ),
            );
          }

          final detail = snapshot.data;
          if (detail == null) {
            return const Center(child: Text('Movie detail not found'));
          }

          final backdropUrl = detail.fullBackdropUrl.isNotEmpty
              ? detail.fullBackdropUrl
              : detail.fullPosterUrl;
          final genresText = detail.genres
              .map((genre) => genre.name)
              .join(', ');
          final releaseDate = _formatDate(detail.releaseDate);
          final durationText = _formatRuntimeOrEpisodes(detail);
          final rating = (detail.voteAverage * 10).round();
          final castCrewItems = _castCrewItems(detail);

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: MovieDetailHero(
                  detail: detail,
                  backdropUrl: backdropUrl,
                  genresText: genresText,
                  releaseDate: releaseDate,
                  durationText: durationText,
                  rating: rating,
                  isInWatchlist: _isInWatchlist,
                  onBackTap: () => Navigator.of(context).pop(),
                  onWatchlistTap: _toggleWatchlist,
                ),
              ),
              SliverToBoxAdapter(
                child: MovieDetailContent(
                  detail: detail,
                  castCrewItems: castCrewItems,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatDate(String rawDate) {
    final parsedDate = DateTime.tryParse(rawDate);
    if (parsedDate == null) return rawDate.isEmpty ? '-' : rawDate;
    return DateFormat('dd/MM/yyyy').format(parsedDate);
  }

  String _formatRuntime(int runtime) {
    if (runtime <= 0) return '-';
    final hours = runtime ~/ 60;
    final minutes = runtime % 60;
    if (hours <= 0) return '$minutes menit';
    return '$hours jam $minutes menit';
  }

  String _formatRuntimeOrEpisodes(MovieDetailModel detail) {
    if (detail.runtime > 0) return _formatRuntime(detail.runtime);
    if (widget.movie.isTv && detail.numberOfEpisodes > 0) {
      return '${detail.numberOfEpisodes} episode';
    }
    return '-';
  }
}
