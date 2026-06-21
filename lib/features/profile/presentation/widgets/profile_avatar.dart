import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart' as iconly;

import '../../../../core/theme/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Icon(
        iconly.IconlyLight.profile,
        color: AppColors.primary,
        size: 28,
      ),
    );
  }
}
