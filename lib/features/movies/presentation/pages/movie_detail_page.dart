import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/storage/hive_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/movie_detail_model.dart';
import '../../data/models/movie_model.dart';
import '../../data/repositories/movie_repository.dart';
import '../widgets/movie_network_image_frame.dart';

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({
    super.key,
    required this.movie,
  });

  final MovieModel movie;

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late Future<MovieDetailModel> _movieDetailFuture;
  bool _isInWatchlist = false;

  @override
  void initState() {
    super.initState();
    _movieDetailFuture = MovieRepository().getMovieDetail(widget.movie.id);
    _isInWatchlist = HiveService.isInWatchlist(widget.movie.id);
  }

  Future<void> _toggleWatchlist() async {
    await HiveService.toggleWatchlistMovie(widget.movie.id);
    setState(() {
      _isInWatchlist = HiveService.isInWatchlist(widget.movie.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<MovieDetailModel>(
        future: _movieDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: SizedBox.shrink());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  '${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final detail = snapshot.data;
          if (detail == null) {
            return const Center(child: Text('Movie detail not found'));
          }

          final backdropUrl = detail.fullBackdropUrl.isNotEmpty
              ? detail.fullBackdropUrl
              : detail.fullPosterUrl;
          final genresText = detail.genres.map((genre) => genre.name).join(', ');
          final releaseDate = _formatDate(detail.releaseDate);
          final runtime = _formatRuntime(detail.runtime);
          final rating = (detail.voteAverage * 10).round();

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Stack(
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
                              onPressed: () => Navigator.of(context).pop(),
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
                        padding: const EdgeInsets.only(
                          left: 24,
                          right: 24,
                          bottom: 24,
                        ),
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
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                        width: 0.50,
                                        color: Color(0xFFEEEEEE),
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  child: Text(
                                    detail.adult ? 'R' : 'PG-13',
                                    style: const TextStyle(
                                      color: Color(0xFFEEEEEE),
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                                Text(
                                  releaseDate,
                                  style: const TextStyle(
                                    color: Color(0xFFEEEEEE),
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  '•',
                                  style: const TextStyle(
                                    color: Color(0xFFEEEEEE),
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  runtime,
                                  style: const TextStyle(
                                    color: Color(0xFFEEEEEE),
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _ActionChip(
                                  backgroundColor: AppColors.primary,
                                  icon: Icons.play_arrow_rounded,
                                  label: 'Lihat Trailer',
                                  textColor: Colors.white,
                                  onTap: () {},
                                ),
                                _ActionChip(
                                  backgroundColor: Colors.white.withValues(alpha: 0.25),
                                  icon: _isInWatchlist
                                      ? Icons.check_rounded
                                      : Icons.add_outlined,
                                  label: 'Watchlist',
                                  textColor: Colors.white,
                                  onTap: _toggleWatchlist,
                                ),
                                _RatingChip(rating: rating),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gambaran Umum',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        detail.overview.isEmpty
                            ? 'Tidak ada gambaran umum yang tersedia.'
                            : detail.overview,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.6,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatDate(String rawDate) {
    final parsedDate = DateTime.tryParse(rawDate);
    if (parsedDate == null) return rawDate.isEmpty ? '-' : rawDate;
    return DateFormat('dd/MM/yyyy').format(parsedDate);
  }

  String _formatRuntime(int runtime) {
    if (runtime <= 0) return '-';
    final hours = runtime ~/ 60;
    final minutes = runtime % 60;
    if (hours <= 0) return '$minutes menit';
    return '$hours jam $minutes menit';
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.backgroundColor,
    required this.icon,
    required this.label,
    required this.textColor,
    required this.onTap,
  });

  final Color backgroundColor;
  final IconData icon;
  final String label;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 40,
        padding: const EdgeInsets.only(top: 6, left: 16, right: 20, bottom: 6),
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: textColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingChip extends StatelessWidget {
  const _RatingChip({required this.rating});

  final int rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.only(top: 6, left: 16, right: 20, bottom: 6),
      decoration: ShapeDecoration(
        color: AppColors.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 12, color: Color(0xFF713F12)),
          const SizedBox(width: 4),
          Text(
            '$rating%',
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
