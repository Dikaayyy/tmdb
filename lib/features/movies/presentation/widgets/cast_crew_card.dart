import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'movie_network_image_frame.dart';

class CastCrewCard extends StatelessWidget {
  const CastCrewCard({
    super.key,
    required this.name,
    required this.role,
    required this.imageUrl,
  });

  final String name;
  final String role;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: AppColors.border),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: 140,
            child: MovieNetworkImageFrame(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              overlayBuilder: (_) => const SizedBox.shrink(),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 8,
                left: 12,
                right: 12,
                bottom: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    role,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
