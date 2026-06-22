import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/error_state_view.dart';
import '../../../profile/data/datasources/recently_viewed_local_datasource.dart';
import '../../../watchlist/data/models/watchlist_movie_model.dart';
import '../../../watchlist/presentation/viewmodels/watchlist_viewmodel.dart';
import '../../data/models/movie_detail_model.dart';
import '../../data/models/movie_model.dart';
import '../../data/providers/movie_repository_provider.dart';
import '../utils/movie_detail_formatter.dart';
import '../widgets/movie_detail_content.dart';
import '../widgets/movie_detail_hero.dart';
import '../widgets/movie_detail_loading_skeleton.dart';

class MovieDetailPage extends ConsumerStatefulWidget {
  const MovieDetailPage({super.key, required this.movie});

  final MovieModel movie;

  @override
  ConsumerState<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends ConsumerState<MovieDetailPage> {
  final _recentlyViewedDatasource = RecentlyViewedLocalDatasource();
  late Future<MovieDetailModel> _movieDetailFuture;

  @override
  void initState() {
    super.initState();
    _recentlyViewedDatasource.saveMovie(widget.movie);
    _movieDetailFuture = ref
        .read(movieRepositoryProvider)
        .getMediaDetail(widget.movie);
  }

  Future<void> _toggleWatchlist(MovieDetailModel detail) async {
    await ref
        .read(watchlistViewModelProvider.notifier)
        .toggleWatchlist(
          WatchlistMovieModel.fromDetail(
            detail,
            mediaType: widget.movie.mediaType,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final watchlistMovies = ref.watch(watchlistViewModelProvider);

    return Scaffold(
      body: FutureBuilder<MovieDetailModel>(
        future: _movieDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MovieDetailLoadingSkeleton(
              onBackTap: () => Navigator.of(context).pop(),
            );
          }

          if (snapshot.hasError) {
            return ErrorStateView(
              message: '${snapshot.error}',
              onRetry: () {
                setState(() {
                  _movieDetailFuture = ref
                      .read(movieRepositoryProvider)
                      .getMediaDetail(widget.movie);
                });
              },
            );
          }

          final detail = snapshot.data;
          if (detail == null) {
            return const Center(child: Text('Movie detail not found'));
          }

          final backdropUrl = MovieDetailFormatter.backdropUrl(detail);
          final genresText = MovieDetailFormatter.genresText(detail);
          final releaseDate = MovieDetailFormatter.releaseDate(
            detail.releaseDate,
          );
          final durationText = MovieDetailFormatter.runtimeOrEpisodes(
            detail,
            isTv: widget.movie.isTv,
          );
          final rating = MovieDetailFormatter.rating(detail);
          final castCrewItems = MovieDetailFormatter.castCrewItems(detail);
          final isInWatchlist = watchlistMovies.any(
            (movie) =>
                movie.id == widget.movie.id &&
                movie.mediaType == widget.movie.mediaType,
          );

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
                  isInWatchlist: isInWatchlist,
                  onBackTap: () => Navigator.of(context).pop(),
                  onWatchlistTap: () => _toggleWatchlist(detail),
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

}
