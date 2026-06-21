import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ProfileMoreButton extends StatelessWidget {
  const ProfileMoreButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: IconButton(
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          shape: const CircleBorder(side: BorderSide(color: AppColors.border)),
          padding: EdgeInsets.zero,
        ),
        icon: const Icon(Icons.more_horiz_sharp, size: 22),
      ),
    );
  }
}
