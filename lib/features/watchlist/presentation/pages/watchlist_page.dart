import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/widgets/see_all_category_tabs.dart';
import '../../../movies/data/models/movie_model.dart';
import '../../../movies/presentation/pages/movie_detail_page.dart';
import '../../../movies/presentation/widgets/featured_movie_card.dart';
import '../../data/models/watchlist_movie_model.dart';
import '../viewmodels/watchlist_viewmodel.dart';

class WatchlistPage extends ConsumerStatefulWidget {
  const WatchlistPage({super.key});

  @override
  ConsumerState<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends ConsumerState<WatchlistPage> {
  SeeAllCategory _selectedCategory = SeeAllCategory.all;

  @override
  Widget build(BuildContext context) {
    final watchlistMovies = ref.watch(watchlistViewModelProvider);
    final filteredMovies = _filterMovies(watchlistMovies);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final featuredWidth = screenWidth - 48;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '👀 Watchlist',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SeeAllCategoryTabs(
              selected: _selectedCategory,
              onChanged: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredMovies.isEmpty
                  ? _WatchlistEmptyState(category: _selectedCategory)
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                      itemCount: filteredMovies.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final watchlistMovie = filteredMovies[index];
                        final movie = watchlistMovie.toMovieModel();

                        return FeaturedMovieCard(
                          movie: movie,
                          width: featuredWidth,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => MovieDetailPage(movie: movie),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<WatchlistMovieModel> _filterMovies(List<WatchlistMovieModel> movies) {
    switch (_selectedCategory) {
      case SeeAllCategory.all:
        return movies;
      case SeeAllCategory.movie:
        return movies
            .where((movie) => movie.mediaType == MediaType.movie)
            .toList();
      case SeeAllCategory.tv:
        return movies
            .where((movie) => movie.mediaType == MediaType.tv)
            .toList();
    }
  }
}

class _WatchlistEmptyState extends StatelessWidget {
  const _WatchlistEmptyState({required this.category});

  final SeeAllCategory category;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Image(
              image: AssetImage('assets/images/watchlist.png'),
              width: 276,
              height: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            Text(
              'Watchlistmu masih kosong. \n Yuk, tambahkan yang ingin kamu tonton!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
