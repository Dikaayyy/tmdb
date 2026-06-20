import 'package:flutter/material.dart';

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
            color: const Color(0xFFFCFDFF),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: MovieDetailCastCrewSection(items: castCrewItems),
          ),
        ] else
          const SizedBox(height: 32),
      ],
    );
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
