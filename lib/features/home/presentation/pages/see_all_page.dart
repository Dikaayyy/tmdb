import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../movies/data/models/movie_model.dart';
import '../../../movies/presentation/widgets/featured_movie_card.dart';
import '../viewmodels/home_view_model.dart';
import '../widgets/see_all_loading_skeleton.dart';
import '../widgets/see_all_category_tabs.dart';

enum SeeAllSectionType {
  trending,
  newRelease,
  topRated;
}

class SeeAllPageArgs {
  const SeeAllPageArgs({
    required this.sectionType,
    required this.title,
    this.subtitle,
    required this.movies,
  });

  final SeeAllSectionType sectionType;
  final String title;
  final String? subtitle;
  final List<MovieModel> movies;
}

class SeeAllPage extends ConsumerStatefulWidget {
  const SeeAllPage({
    super.key,
    required this.args,
  });

  final SeeAllPageArgs args;

  @override
  ConsumerState<SeeAllPage> createState() => _SeeAllPageState();
}

class _SeeAllPageState extends ConsumerState<SeeAllPage> {
  SeeAllCategory _selectedCategory = SeeAllCategory.all;
  late Future<List<MovieModel>> _moviesFuture;
  bool _isReloading = false;

  @override
  void initState() {
    super.initState();
    _moviesFuture = _fetchMovies();
  }

  Future<List<MovieModel>> _fetchMovies() async {
    final repository = ref.read(movieRepositoryProvider);

    switch (widget.args.sectionType) {
      case SeeAllSectionType.trending:
        switch (_selectedCategory) {
          case SeeAllCategory.all:
            return (await repository.getTrendingAll()).movies;
          case SeeAllCategory.movie:
            return (await repository.getTrendingMovies()).movies;
          case SeeAllCategory.tv:
            return (await repository.getTrendingTv()).movies;
        }
      case SeeAllSectionType.newRelease:
        switch (_selectedCategory) {
          case SeeAllCategory.all:
            final results = await Future.wait([
              repository.getNowPlayingMovies(),
              repository.getOnTheAirTv(),
            ]);
            return _sortByNewest([...results[0].movies, ...results[1].movies]);
          case SeeAllCategory.movie:
            return _sortByNewest((await repository.getNowPlayingMovies()).movies);
          case SeeAllCategory.tv:
            return _sortByNewest((await repository.getOnTheAirTv()).movies);
        }
      case SeeAllSectionType.topRated:
        switch (_selectedCategory) {
          case SeeAllCategory.all:
            final results = await Future.wait([
              repository.getTopRatedMovies(),
              repository.getTopRatedTv(),
            ]);
            return _sortByTopRated([...results[0].movies, ...results[1].movies]);
          case SeeAllCategory.movie:
            return _sortByTopRated((await repository.getTopRatedMovies()).movies);
          case SeeAllCategory.tv:
            return _sortByTopRated((await repository.getTopRatedTv()).movies);
        }
    }
  }

  Future<void> _changeCategory(SeeAllCategory value) async {
    setState(() {
      _selectedCategory = value;
      _isReloading = true;
      _moviesFuture = _fetchMovies();
    });

    try {
      await _moviesFuture;
    } finally {
      if (mounted) {
        setState(() {
          _isReloading = false;
        });
      }
    }
  }

  List<MovieModel> _sortByNewest(List<MovieModel> movies) {
    final sortedMovies = [...movies];
    sortedMovies.sort(
      (a, b) => _parseDate(b.releaseDate).compareTo(_parseDate(a.releaseDate)),
    );
    return sortedMovies;
  }

  List<MovieModel> _sortByTopRated(List<MovieModel> movies) {
    final sortedMovies = [...movies];
    sortedMovies.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
    return sortedMovies;
  }

  DateTime _parseDate(String rawDate) {
    return DateTime.tryParse(rawDate) ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final contentWidth = screenWidth - 48;
    final featuredWidth = contentWidth;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                        children: [
                          TextSpan(
                            text: widget.args.title,
                            style: const TextStyle(color: AppColors.textPrimary),
                          ),
                          if ((widget.args.subtitle ?? '').isNotEmpty) ...[
                            const TextSpan(text: ' '),
                            TextSpan(
                              text: widget.args.subtitle!,
                              style: const TextStyle(color: AppColors.textPrimary),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SeeAllCategoryTabs(
              selected: _selectedCategory,
              onChanged: _changeCategory,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Stack(
                children: [
                  FutureBuilder<List<MovieModel>>(
                    future: _moviesFuture,
                    initialData: widget.args.movies,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting &&
                          !(snapshot.hasData && snapshot.data!.isNotEmpty)) {
                        return const SeeAllLoadingSkeleton();
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              '${snapshot.error}',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      final movies = snapshot.data ?? const <MovieModel>[];

                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        itemCount: movies.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final movie = movies[index];

                          return FeaturedMovieCard(
                            movie: movie,
                            width: featuredWidth,
                          );
                        },
                      );
                    },
                  ),
                  if (_isReloading)
                    Positioned.fill(
                      child: Container(
                        color: Colors.white.withValues(alpha: 0.72),
                        child: const IgnorePointer(
                          child: SeeAllLoadingSkeleton(itemCount: 3),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
