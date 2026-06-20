import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

enum SeeAllCategory {
  all('Semua'),
  movie('Film'),
  tv('Serial TV');

  const SeeAllCategory(this.label);

  final String label;
}

class SeeAllCategoryTabs extends StatelessWidget {
  const SeeAllCategoryTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final SeeAllCategory selected;
  final ValueChanged<SeeAllCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: SeeAllCategory.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = SeeAllCategory.values[index];
          final isSelected = category == selected;

          return GestureDetector(
            onTap: () => onChanged(category),
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              decoration: ShapeDecoration(
                color: isSelected
                    ? AppColors.primary
                    : Colors.white.withValues(alpha: 0.90),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              child: Center(
                child: Text(
                  category.label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
