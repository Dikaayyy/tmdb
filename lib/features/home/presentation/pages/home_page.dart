import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      appBar: AppBar(
        title: const Text('Trending Movies'),
      ),
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
