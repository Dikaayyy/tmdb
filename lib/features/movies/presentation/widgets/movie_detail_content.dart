import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/movie_detail_model.dart';
import 'movie_detail_cast_crew_section.dart';

class MovieDetailContent extends StatelessWidget {
  const MovieDetailContent({
    super.key,
    required this.detail,
    required this.castCrewItems,
  });

  final MovieDetailModel detail;
  final List<MovieDetailCastCrewItem> castCrewItems;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
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
              const SizedBox(height: 24),
              Divider(color: Theme.of(context).dividerColor, thickness: 1),
              const SizedBox(height: 24),
              _MovieCreditCards(detail: detail),
            ],
          ),
        ),
        if (castCrewItems.isNotEmpty) ...[
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            color: const Color(0xFFFAFAFA),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: MovieDetailCastCrewSection(items: castCrewItems),
          ),
        ] else
          const SizedBox(height: 32),
        Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            castCrewItems.isNotEmpty ? 0 : 24,
            24,
            24,
          ),
          child: _MovieFactCards(detail: detail),
        ),
        _MovieReviewSection(reviews: detail.reviews),
      ],
    );
  }
}

class _MovieReviewSection extends StatelessWidget {
  const _MovieReviewSection({required this.reviews});

  final List<ReviewModel> reviews;

  @override
  Widget build(BuildContext context) {
    final visibleReviews = reviews
        .where((review) => review.content.trim().isNotEmpty)
        .take(4)
        .toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ulasan',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          if (visibleReviews.isEmpty)
            Text(
              'Belum ada ulasan yang tersedia.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = constraints.maxWidth.clamp(0, 342).toDouble();

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final review in visibleReviews) ...[
                        SizedBox(
                          width: cardWidth,
                          child: _ReviewCard(review: review),
                        ),
                        if (review != visibleReviews.last) const SizedBox(width: 12),
                      ],
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final ReviewModel review;

  @override
  Widget build(BuildContext context) {
    final author = review.author.trim().isEmpty ? 'Anonim' : review.author;
    final initial = author.characters.first.toUpperCase();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEFC),
        border: Border.all(color: const Color(0x19FACC15)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black.withValues(alpha: 0.2)),
                ),
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: Color(0xFFFAFAFA),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatReviewDate(review.createdAt),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              _ReviewRatingBadge(rating: review.rating),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.content.trim(),
            maxLines: 12,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  String _formatReviewDate(String rawDate) {
    final parsedDate = DateTime.tryParse(rawDate);
    if (parsedDate == null) return rawDate.isEmpty ? '-' : rawDate;
    return DateFormat('dd MMMM yyyy', 'id_ID').format(parsedDate);
  }
}

class _ReviewRatingBadge extends StatelessWidget {
  const _ReviewRatingBadge({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 23,
      padding: const EdgeInsets.only(top: 4, left: 6, right: 8, bottom: 4),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 12, color: Color(0xFF020617)),
          const SizedBox(width: 4),
          Text(
            rating > 0 ? rating.toStringAsFixed(1) : '-',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF020617),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieFactCards extends StatelessWidget {
  const _MovieFactCards({required this.detail});

  final MovieDetailModel detail;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      runAlignment: WrapAlignment.start,
      spacing: 12,
      runSpacing: 12,
      children: [
        _CreditCard(label: 'Status', value: _formatText(detail.status)),
        _CreditCard(
          label: 'Bahasa Ucapan',
          value: _formatLanguage(detail.originalLanguage),
        ),
        _CreditCard(label: 'Anggaran', value: _formatCurrency(detail.budget)),
        _CreditCard(label: 'Pemasukan', value: _formatCurrency(detail.revenue)),
      ],
    );
  }

  String _formatText(String value) {
    return value.trim().isEmpty ? '-' : value;
  }

  String _formatLanguage(String languageCode) {
    final language = languageCode.trim();
    if (language.isEmpty) return '-';
    return language.toUpperCase();
  }

  String _formatCurrency(int amount) {
    if (amount <= 0) return '-';
    return NumberFormat.currency(
      locale: 'en_US',
      symbol: r'$',
      decimalDigits: 0,
    ).format(amount);
  }
}

class _MovieCreditCards extends StatelessWidget {
  const _MovieCreditCards({required this.detail});

  final MovieDetailModel detail;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      runAlignment: WrapAlignment.start,
      spacing: 12,
      runSpacing: 12,
      children: [
        ..._creditNamesByJob(detail, [
          'Director',
        ]).map((name) => _CreditCard(label: 'Director', value: name)),
        ..._creditNamesByJob(detail, [
          'Writer',
          'Screenplay',
          'Story',
          'Author',
          'Novel',
        ]).map((name) => _CreditCard(label: 'Writer', value: name)),
        ..._topCharacterNames(
          detail,
          4,
        ).map((name) => _CreditCard(label: 'Characters', value: name)),
      ],
    );
  }

  List<String> _creditNamesByJob(MovieDetailModel detail, List<String> jobs) {
    return detail.crew
        .where((crew) => jobs.contains(crew.job))
        .map((crew) => crew.name)
        .toSet()
        .toList();
  }

  List<String> _topCharacterNames(MovieDetailModel detail, int limit) {
    return detail.cast
        .where((cast) => cast.character.isNotEmpty)
        .map((cast) => cast.character)
        .toSet()
        .take(limit)
        .toList();
  }
}

class _CreditCard extends StatelessWidget {
  const _CreditCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF71747D),
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
