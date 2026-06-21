import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({
    super.key,
    required this.name,
    required this.email,
    this.joinedSince,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  final String name;
  final String email;
  final String? joinedSince;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          name,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          email,
          textAlign: crossAxisAlignment == CrossAxisAlignment.center
              ? TextAlign.center
              : TextAlign.start,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
        if (joinedSince != null) ...[
          const SizedBox(height: 4),
          Text(
            joinedSince!,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }
}
