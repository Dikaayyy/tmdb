import 'package:flutter/material.dart';

class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onSeeAll,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 4),
              Text(
                subtitle ?? '',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF71747D),
                      height: 1.5,
                    ),
              ),
            ],
          ),
          TextButton.icon(
            onPressed: onSeeAll,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            iconAlignment: IconAlignment.end,
            label: const Text(
              'Lihat Semua',
              style: TextStyle(
                color: Color(0xFF3F55C6),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            icon: const Icon(
              Icons.chevron_right,
              size: 14,
              color: Color(0xFF3F55C6),
            ),
          ),
        ],
      ),
    );
  }
}
