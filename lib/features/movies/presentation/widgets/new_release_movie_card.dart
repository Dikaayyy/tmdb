import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/movie_model.dart';

class NewReleaseMovieCard extends StatelessWidget {
  const NewReleaseMovieCard({
    super.key,
    required this.movie,
    required this.width,
    this.onTap,
  });

  final MovieModel movie;
  final double width;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final imageHeight = width * (241.14 / 160);
    final score = (movie.voteAverage * 10).round();
    final isHighScore = score >= 70;
    final badgeColor = isHighScore ? const Color(0xFF07973C) : AppColors.secondary;
    final badgeTextColor = isHighScore ? const Color(0xFFFAFAFA) : AppColors.textPrimary;

    return SizedBox(
      width: width,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: width,
                height: imageHeight,
                child: _PosterImage(movie: movie),
              ),
            ),
            Positioned(
              left: 10,
              bottom: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: ShapeDecoration(
                  color: badgeColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '$score',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: badgeTextColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '%',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: badgeTextColor,
                        fontSize: 8,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PosterImage extends StatelessWidget {
  const _PosterImage({required this.movie});

  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    final imageUrl = movie.fullPosterUrl.isNotEmpty
        ? movie.fullPosterUrl
        : movie.fullBackdropUrl;

    if (imageUrl.isEmpty) {
      return Container(
        color: AppColors.background,
        alignment: Alignment.center,
        child: const Icon(
          Icons.movie_outlined,
          size: 40,
          color: Color(0xFF6B7280),
        ),
      );
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Container(
          color: AppColors.background,
          alignment: Alignment.center,
          child: const Icon(
            Icons.broken_image_outlined,
            size: 40,
            color: Color(0xFF6B7280),
          ),
        );
      },
    );
  }
}
