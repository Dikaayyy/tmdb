import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SeeAllLoadingSkeleton extends StatelessWidget {
  const SeeAllLoadingSkeleton({
    super.key,
    this.itemCount = 4,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardWidth = screenWidth - 48;
    final cardHeight = cardWidth * (200 / 310) + 110;

    return Shimmer.fromColors(
      baseColor: const Color(0xFFE8ECF3),
      highlightColor: const Color(0xFFF6F8FC),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (_, __) => Container(
          width: cardWidth,
          height: cardHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
