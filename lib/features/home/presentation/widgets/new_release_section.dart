import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../pages/see_all_page.dart';
import '../../../movies/data/models/movie_model.dart';
import '../../../movies/presentation/pages/movie_detail_page.dart';
import '../../../movies/presentation/widgets/new_release_movie_card.dart';
import 'home_section_header.dart';

class NewReleaseSection extends StatelessWidget {
  const NewReleaseSection({
    super.key,
    required this.movies,
  });

  final List<MovieModel> movies;

  @override
  Widget build(BuildContext context) {
    final visibleMovies = movies.take(5).toList();
    final currentMonth = DateFormat('MMMM', 'id_ID').format(DateTime.now());
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardWidth = ((screenWidth - 48) * 0.42).clamp(140.0, 160.0);
    final imageHeight = cardWidth * (241.14 / 160);

    return Column(
      children: [
        const SizedBox(height: 24),
        HomeSectionHeader(
          title: 'Baru Rilis',
          subtitle: currentMonth,
          onSeeAll: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => SeeAllPage(
                  args: SeeAllPageArgs(
                    sectionType: SeeAllSectionType.newRelease,
                    title: 'Baru Rilis',
                    subtitle: currentMonth,
                    movies: movies,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: imageHeight,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: visibleMovies.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final movie = visibleMovies[index];

              return NewReleaseMovieCard(
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
        const SizedBox(height: 24),
      ],
    );
  }
}
