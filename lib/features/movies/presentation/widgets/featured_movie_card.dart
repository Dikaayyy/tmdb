import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/movie_model.dart';
import 'movie_image_scrim.dart';
import 'movie_network_image_frame.dart';

class FeaturedMovieCard extends StatelessWidget {
  const FeaturedMovieCard({
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
    final imageHeight = width * (200 / 310);

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
                      MovieNetworkImageFrame(
                        imageUrl: movie.fullBackdropUrl.isNotEmpty
                            ? movie.fullBackdropUrl
                            : movie.fullPosterUrl,
                        fit: BoxFit.cover,
                        overlayBuilder: (_) {
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              const MovieImageScrim(),
                              MovieImageScrim(
                                padding: const EdgeInsets.all(16),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: _RatingBadge(voteAverage: movie.voteAverage),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
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
                    Text(
                      movie.overview.isEmpty
                          ? 'No overview available.'
                          : movie.overview,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
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
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.voteAverage});

  final double voteAverage;

  @override
  Widget build(BuildContext context) {
    final percentage = (voteAverage * 10).round();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: ShapeDecoration(
        color: AppColors.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
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
        children: [
          const Icon(
            Icons.star_rounded,
            size: 12,
            color: Color(0xFF713F12),
          ),
          const SizedBox(width: 2),
          Text(
            '$percentage%',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF713F12),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
