import 'package:flutter/material.dart';

import '../../../movies/data/models/movie_model.dart';
import '../../../movies/presentation/pages/movie_detail_page.dart';
import '../../../movies/presentation/widgets/featured_movie_card.dart';
import '../pages/see_all_page.dart';
import 'home_section_header.dart';

class TrendingSection extends StatelessWidget {
  const TrendingSection({
    super.key,
    required this.movies,
  });

  final List<MovieModel> movies;

  @override
  Widget build(BuildContext context) {
    final visibleMovies = movies.take(5).toList();
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardWidth = ((screenWidth - 32) * 0.82).clamp(260.0, 330.0);
    final cardImageHeight = cardWidth * (200 / 310);
    final sectionHeight = cardImageHeight + 110;

    return Column(
      children: [
        const SizedBox(height: 12),
        HomeSectionHeader(
          title: 'Trending',
          subtitle: 'Hari Ini',
          onSeeAll: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => SeeAllPage(
                  args: SeeAllPageArgs(
                    sectionType: SeeAllSectionType.trending,
                    title: 'Trending',
                    subtitle: 'Hari Ini',
                    movies: movies,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: sectionHeight,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: visibleMovies.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final movie = visibleMovies[index];

              return FeaturedMovieCard(
                movie: movie,
                width: cardWidth,
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
    );
  }
}
