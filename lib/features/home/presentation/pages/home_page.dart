import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../movies/presentation/widgets/featured_movie_card.dart';
import '../viewmodels/home_view_model.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsync = ref.watch(homeViewModelProvider);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardWidth = ((screenWidth - 32) * 0.82).clamp(260.0, 330.0);
    final cardImageHeight = cardWidth * (200 / 310);
    final featuredSectionHeight = cardImageHeight + 110;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trending Movies'),
      ),
      body: moviesAsync.when(
        data: (movies) {
          if (movies.isEmpty) {
            return const Center(
              child: Text('No movies found'),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(homeViewModelProvider.notifier).refresh(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Text(
                    'Trending Movies',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: featuredSectionHeight,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: movies.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final movie = movies[index];

                      return FeaturedMovieCard(
                        movie: movie,
                        width: cardWidth,
                      );
                    },
                  ),
                ),
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
