import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'cast_crew_card.dart';

class MovieDetailCastCrewSection extends StatelessWidget {
  const MovieDetailCastCrewSection({super.key, required this.items});

  final List<MovieDetailCastCrewItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _CastCrewSectionHeader(),
        const SizedBox(height: 12),
        SizedBox(
          height: 202,
          child: ListView.separated(
            clipBehavior: Clip.none,
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final item = items[index];

              return CastCrewCard(
                name: item.name,
                role: item.role,
                imageUrl: item.imageUrl,
              );
            },
          ),
        ),
      ],
    );
  }
}

class MovieDetailCastCrewItem {
  const MovieDetailCastCrewItem({
    required this.name,
    required this.role,
    required this.imageUrl,
  });

  final String name;
  final String role;
  final String imageUrl;
}

class _CastCrewSectionHeader extends StatelessWidget {
  const _CastCrewSectionHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Pemeran & Kru',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        TextButton.icon(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 32),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            alignment: Alignment.centerRight,
          ),
          iconAlignment: IconAlignment.end,
          label: const Text(
            'Lihat Semua',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          icon: const Icon(
            Icons.chevron_right,
            size: 14,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
