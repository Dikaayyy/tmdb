import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../movies/data/models/movie_model.dart';
import '../../../movies/presentation/pages/movie_detail_page.dart';
import '../../../movies/presentation/widgets/new_release_movie_card.dart';

class RecentlyViewedSection extends StatelessWidget {
  const RecentlyViewedSection({super.key, required this.movies});

  final List<MovieModel> movies;

  @override
  Widget build(BuildContext context) {
    final visibleMovies = movies.take(6).toList();
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardWidth = (screenWidth - 56) / 2;
    final imageHeight = cardWidth * (241.14 / 160);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Terakhir dilihat',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: visibleMovies.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              mainAxisExtent: imageHeight,
            ),
            itemBuilder: (context, index) {
              final movie = visibleMovies[index];

              return NewReleaseMovieCard(
                movie: movie,
                width: cardWidth,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
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
