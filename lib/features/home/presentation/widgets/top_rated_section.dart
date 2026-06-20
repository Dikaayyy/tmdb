import 'package:flutter/material.dart';

import '../../../movies/data/models/movie_model.dart';
import '../../../movies/presentation/widgets/top_rated_movie_card.dart';
import 'home_section_header.dart';

class TopRatedSection extends StatelessWidget {
  const TopRatedSection({
    super.key,
    required this.movies,
  });

  final List<MovieModel> movies;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardWidth = ((screenWidth - 32) * 0.82).clamp(260.0, 330.0);
    final cardImageHeight = cardWidth * (185 / 350);
    final sectionHeight = cardImageHeight + 76;

    return Column(
      children: [
        const HomeSectionHeader(
          title: 'Rating Tertinggi',
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: sectionHeight,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final movie = movies[index];

              return TopRatedMovieCard(
                movie: movie,
                width: cardWidth,
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
