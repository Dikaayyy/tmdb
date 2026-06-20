import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MovieDetailLoadingSkeleton extends StatelessWidget {
  const MovieDetailLoadingSkeleton({
    super.key,
    required this.onBackTap,
  });

  final VoidCallback onBackTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Shimmer.fromColors(
          baseColor: const Color(0xFFE8ECF3),
          highlightColor: const Color(0xFFF6F8FC),
          child: CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            slivers: const [
              SliverToBoxAdapter(child: _HeroSkeleton()),
              SliverToBoxAdapter(child: _ContentSkeleton()),
            ],
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: IconButton(
              onPressed: onBackTap,
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroSkeleton extends StatelessWidget {
  const _HeroSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 430,
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _SkeletonBox(width: 240, height: 24, radius: 8),
            SizedBox(height: 8),
            _SkeletonBox(width: 180, height: 10, radius: 6),
            SizedBox(height: 12),
            Row(
              children: [
                _SkeletonBox(width: 46, height: 22, radius: 6),
                SizedBox(width: 8),
                _SkeletonBox(width: 72, height: 10, radius: 6),
                SizedBox(width: 8),
                _SkeletonBox(width: 86, height: 10, radius: 6),
              ],
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _SkeletonBox(width: 124, height: 34, radius: 999),
                _SkeletonBox(width: 108, height: 34, radius: 999),
                _SkeletonBox(width: 72, height: 34, radius: 999),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ContentSkeleton extends StatelessWidget {
  const _ContentSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _SkeletonBox(width: 150, height: 20, radius: 8),
          SizedBox(height: 14),
          _SkeletonBox(width: double.infinity, height: 12, radius: 6),
          SizedBox(height: 8),
          _SkeletonBox(width: double.infinity, height: 12, radius: 6),
          SizedBox(height: 8),
          _SkeletonBox(width: 260, height: 12, radius: 6),
          SizedBox(height: 24),
          Divider(height: 1),
          SizedBox(height: 24),
          _CreditSkeletonGrid(),
          SizedBox(height: 32),
          _HorizontalCardSkeleton(titleWidth: 180, cardHeight: 172),
          SizedBox(height: 32),
          _CreditSkeletonGrid(),
          SizedBox(height: 24),
          _HorizontalCardSkeleton(titleWidth: 90, cardHeight: 260),
        ],
      ),
    );
  }
}

class _CreditSkeletonGrid extends StatelessWidget {
  const _CreditSkeletonGrid();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: const [
        _SkeletonBox(width: 165, height: 58, radius: 12),
        _SkeletonBox(width: 165, height: 58, radius: 12),
        _SkeletonBox(width: 165, height: 58, radius: 12),
        _SkeletonBox(width: 165, height: 58, radius: 12),
      ],
    );
  }
}

class _HorizontalCardSkeleton extends StatelessWidget {
  const _HorizontalCardSkeleton({
    required this.titleWidth,
    required this.cardHeight,
  });

  final double titleWidth;
  final double cardHeight;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardWidth = (screenWidth - 48).clamp(0, 342).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SkeletonBox(width: titleWidth, height: 20, radius: 8),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              _SkeletonBox(width: cardWidth, height: cardHeight, radius: 16),
              const SizedBox(width: 12),
              _SkeletonBox(width: cardWidth, height: cardHeight, radius: 16),
            ],
          ),
        ),
      ],
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.radius,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
