import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/categories_section.dart';
import '../widgets/new_release_section.dart';
import '../widgets/top_rated_section.dart';
import '../widgets/trending_section.dart';
import '../viewmodels/home_view_model.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsync = ref.watch(homeViewModelProvider);

    return Scaffold(
      body: moviesAsync.when(
        data: (movies) {
          if (movies.trendingMovies.isEmpty &&
              movies.newReleaseMovies.isEmpty &&
              movies.topRatedMovies.isEmpty &&
              movies.genres.isEmpty) {
            return const Center(
              child: Text('No movies found'),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(homeViewModelProvider.notifier).refresh(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const _HomeHeader(),
                TrendingSection(movies: movies.trendingMovies),
                NewReleaseSection(movies: movies.newReleaseMovies),
                TopRatedSection(movies: movies.topRatedMovies),
                CategoriesSection(genres: movies.genres),
              ],
            ),
          );
        },
        error: (error, _) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Failed to load movies',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$error',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () =>
                        ref.read(homeViewModelProvider.notifier).refresh(),
                    child: const Text('Try again'),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Transform.rotate(
                angle: -0.17,
                child: SizedBox(
                  width: 27.62,
                  height: 27.62,
                  child: const Image(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                'TMDB',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const Row(
            children: [
              _HeaderIconButton(assetPath: 'assets/icons/notification.png'),
              SizedBox(width: 4),
              _HeaderIconButton(assetPath: 'assets/icons/search.png'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
      ),
      alignment: Alignment.center,
      child: Image.asset(
        assetPath,
        width: 20,
        height: 20,
      ),
    );
  }
}
