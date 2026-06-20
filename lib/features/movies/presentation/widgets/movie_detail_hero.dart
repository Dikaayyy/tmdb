import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/movie_detail_model.dart';
import 'movie_detail_chip.dart';
import 'movie_network_image_frame.dart';

class MovieDetailHero extends StatelessWidget {
  const MovieDetailHero({
    super.key,
    required this.detail,
    required this.backdropUrl,
    required this.genresText,
    required this.releaseDate,
    required this.durationText,
    required this.rating,
    required this.isInWatchlist,
    required this.onBackTap,
    required this.onWatchlistTap,
  });

  final MovieDetailModel detail;
  final String backdropUrl;
  final String genresText;
  final String releaseDate;
  final String durationText;
  final int rating;
  final bool isInWatchlist;
  final VoidCallback onBackTap;
  final VoidCallback onWatchlistTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 430,
          width: double.infinity,
          child: MovieNetworkImageFrame(
            imageUrl: backdropUrl,
            fit: BoxFit.cover,
            overlayBuilder: (_) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.25),
                      Colors.black.withValues(alpha: 0.75),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                IconButton(
                  onPressed: onBackTap,
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.title,
                  style: const TextStyle(
                    color: Color(0xFFFAFAFA),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  genresText,
                  style: const TextStyle(
                    color: Color(0xFFEEEEEE),
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                _MovieDetailMeta(
                  certification: detail.adult ? 'R' : 'PG-13',
                  releaseDate: releaseDate,
                  durationText: durationText,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    MovieDetailActionChip(
                      backgroundColor: AppColors.primary,
                      icon: Icons.play_arrow_rounded,
                      label: 'Lihat Trailer',
                      textColor: Colors.white,
                      onTap: () {},
                    ),
                    MovieDetailActionChip(
                      backgroundColor: Colors.white.withValues(alpha: 0.25),
                      borderColor: isInWatchlist
                          ? const Color(0xFF22C55E)
                          : null,
                      icon: isInWatchlist
                          ? Icons.check_circle_rounded
                          : Icons.add_rounded,
                      iconColor: isInWatchlist ? const Color(0xFF22C55E) : null,
                      label: 'Watchlist',
                      textColor: Colors.white,
                      onTap: onWatchlistTap,
                    ),
                    MovieDetailRatingChip(rating: rating),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MovieDetailMeta extends StatelessWidget {
  const _MovieDetailMeta({
    required this.certification,
    required this.releaseDate,
    required this.durationText,
  });

  final String certification;
  final String releaseDate;
  final String durationText;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 0.50, color: Color(0xFFEEEEEE)),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: Text(
            certification,
            style: const TextStyle(color: Color(0xFFEEEEEE), fontSize: 10),
          ),
        ),
        Text(
          releaseDate,
          style: const TextStyle(color: Color(0xFFEEEEEE), fontSize: 10),
        ),
        const Text(
          '•',
          style: TextStyle(color: Color(0xFFEEEEEE), fontSize: 10),
        ),
        Text(
          durationText,
          style: const TextStyle(color: Color(0xFFEEEEEE), fontSize: 10),
        ),
      ],
    );
  }
}
