import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart' as iconly;

import '../../../../core/theme/app_colors.dart';

class MovieDetailActionChip extends StatelessWidget {
  const MovieDetailActionChip({
    super.key,
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

class MovieDetailRatingChip extends StatelessWidget {
  const MovieDetailRatingChip({super.key, required this.rating});

  final int rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.only(top: 6, left: 16, right: 20, bottom: 6),
      decoration: ShapeDecoration(
        color: AppColors.secondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(iconly.IconlyBold.star, size: 12, color: Color(0xFF713F12)),
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
