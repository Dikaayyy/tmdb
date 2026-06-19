import 'package:flutter/material.dart';

import '../../data/models/movie_model.dart';

class FeaturedMovieCard extends StatelessWidget {
  const FeaturedMovieCard({
    super.key,
    required this.movie,
    this.width = 330,
    this.onTap,
  });

  final MovieModel movie;
  final double width;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: width),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: width,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: const Color(0xFFFCFCFF),
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1,
                color: Color(0x193F55C6),
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
                height: 185,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _CardImage(movie: movie),
                    Container(
                      color: Colors.black.withValues(alpha: 0.20),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: const Alignment(0.5, 0),
                          end: const Alignment(0.5, 1),
                          colors: [
                            Colors.black.withValues(alpha: 0.60),
                            Colors.black.withValues(alpha: 0),
                          ],
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: _RatingBadge(voteAverage: movie.voteAverage),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF1F2937),
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.36,
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
                        color: const Color(0xFF71747D),
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

class _CardImage extends StatelessWidget {
  const _CardImage({required this.movie});

  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    final imageUrl = movie.fullBackdropUrl.isNotEmpty
        ? movie.fullBackdropUrl
        : movie.fullPosterUrl;

    if (imageUrl.isEmpty) {
      return Container(
        color: const Color(0xFFE5E7EB),
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
          color: const Color(0xFFE5E7EB),
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

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.voteAverage});

  final double voteAverage;

  @override
  Widget build(BuildContext context) {
    final percentage = (voteAverage * 10).round();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: ShapeDecoration(
        color: const Color(0xFFFACC15),
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
