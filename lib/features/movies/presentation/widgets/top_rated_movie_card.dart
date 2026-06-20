import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/movie_model.dart';
import 'movie_image_scrim.dart';

class TopRatedMovieCard extends StatelessWidget {
  const TopRatedMovieCard({
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
    final theme = Theme.of(context);
    final imageHeight = width * (185 / 350);
    final formattedDate = _formatReleaseDate(movie.releaseDate);
    final score = (movie.voteAverage * 10).round();

    return SizedBox(
      width: width,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: AppColors.surface,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1,
                color: AppColors.border,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: imageHeight,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _TopRatedImage(movie: movie),
                      const MovieImageScrim(),
                      const MovieImageScrim(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formattedDate,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 12,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '$score%',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatReleaseDate(String rawDate) {
    if (rawDate.isEmpty) return 'Tanggal tidak tersedia';

    final parsedDate = DateTime.tryParse(rawDate);
    if (parsedDate == null) return rawDate;

    return DateFormat('MMM dd, yyyy', 'en_US').format(parsedDate);
  }
}

class _TopRatedImage extends StatelessWidget {
  const _TopRatedImage({required this.movie});

  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    final imageUrl = movie.fullBackdropUrl.isNotEmpty
        ? movie.fullBackdropUrl
        : movie.fullPosterUrl;

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
