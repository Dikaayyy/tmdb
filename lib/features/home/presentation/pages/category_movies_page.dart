import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/error_state_view.dart';
import '../../../movies/data/models/genre_model.dart';
import '../../../movies/data/models/movie_model.dart';
import '../../../movies/data/providers/movie_repository_provider.dart';
import '../../../movies/presentation/pages/movie_detail_page.dart';
import '../../../movies/presentation/widgets/featured_movie_card.dart';
import '../widgets/see_all_category_tabs.dart';
import '../widgets/see_all_loading_skeleton.dart';

class CategoryMoviesPage extends ConsumerStatefulWidget {
  const CategoryMoviesPage({super.key, required this.genre});

  final GenreModel genre;

  @override
  ConsumerState<CategoryMoviesPage> createState() => _CategoryMoviesPageState();
}

class _CategoryMoviesPageState extends ConsumerState<CategoryMoviesPage> {
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

    switch (_selectedCategory) {
      case SeeAllCategory.all:
        final movieResults = widget.genre.movieGenreId != null
            ? (await repository.discoverMoviesByGenre(
                widget.genre.movieGenreId!,
              )).movies
            : <MovieModel>[];
        final tvResults = widget.genre.tvGenreId != null
            ? (await repository.discoverTvByGenre(
                widget.genre.tvGenreId!,
              )).movies
            : <MovieModel>[];
        return _sortByNewest([...movieResults, ...tvResults]);
      case SeeAllCategory.movie:
        if (widget.genre.movieGenreId == null) return const <MovieModel>[];
        return _sortByNewest(
          (await repository.discoverMoviesByGenre(
            widget.genre.movieGenreId!,
          )).movies,
        );
      case SeeAllCategory.tv:
        if (widget.genre.tvGenreId == null) return const <MovieModel>[];
        return _sortByNewest(
          (await repository.discoverTvByGenre(widget.genre.tvGenreId!)).movies,
        );
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

  DateTime _parseDate(String rawDate) {
    return DateTime.tryParse(rawDate) ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final contentWidth = screenWidth - 48;

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
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                        children: [
                          TextSpan(
                            text: widget.genre.name,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                            ),
                          ),
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
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting &&
                          !(snapshot.hasData && snapshot.data!.isNotEmpty)) {
                        return const SeeAllLoadingSkeleton();
                      }

                      if (snapshot.hasError) {
                        return ErrorStateView(
                          message: '${snapshot.error}',
                          onRetry: () {
                            setState(() {
                              _moviesFuture = _fetchMovies();
                            });
                          },
                        );
                      }

                      final movies = snapshot.data ?? const <MovieModel>[];
                      if (movies.isEmpty) {
                        return const Center(child: Text('No movies found'));
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        itemCount: movies.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final movie = movies[index];

                          return FeaturedMovieCard(
                            movie: movie,
                            width: contentWidth,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => MovieDetailPage(movie: movie),
                                ),
                              );
                            },
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
