import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/categories_section.dart';
import '../widgets/new_release_section.dart';
import '../widgets/top_rated_section.dart';
import '../widgets/trending_section.dart';
import '../viewmodels/home_view_model.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsync = ref.watch(homeViewModelProvider);

    return Scaffold(
      body: moviesAsync.when(
        data: (movies) {
          if (movies.trendingMovies.isEmpty &&
              movies.newReleaseMovies.isEmpty &&
              movies.topRatedMovies.isEmpty &&
              movies.genres.isEmpty) {
            return const Center(
              child: Text('No movies found'),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(homeViewModelProvider.notifier).refresh(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const _HomeHeader(),
                TrendingSection(movies: movies.trendingMovies),
                NewReleaseSection(movies: movies.newReleaseMovies),
                TopRatedSection(movies: movies.topRatedMovies),
                CategoriesSection(genres: movies.genres),
              ],
            ),
          );
        },
        error: (error, _) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Failed to load movies',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$error',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () =>
                        ref.read(homeViewModelProvider.notifier).refresh(),
                    child: const Text('Try again'),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const _HomeLoadingSkeleton(),
      ),
    );
  }
}

class _HomeLoadingSkeleton extends StatelessWidget {
  const _HomeLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE8ECF3),
      highlightColor: const Color(0xFFF6F8FC),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          _HomeHeaderSkeleton(),
          _TrendingSectionSkeleton(),
          _NewReleaseSectionSkeleton(),
          _TopRatedSectionSkeleton(),
          _CategoriesSectionSkeleton(),
        ],
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Transform.rotate(
                angle: -0.17,
                child: SizedBox(
                  width: 27.62,
                  height: 27.62,
                  child: const Image(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                'TMDB',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const Row(
            children: [
              _HeaderIconButton(assetPath: 'assets/icons/notification.png'),
              SizedBox(width: 4),
              _HeaderIconButton(assetPath: 'assets/icons/search.png'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
      ),
      alignment: Alignment.center,
      child: Image.asset(
        assetPath,
        width: 20,
        height: 20,
      ),
    );
  }
}

class _HomeHeaderSkeleton extends StatelessWidget {
  const _HomeHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              _SkeletonBox(width: 28, height: 28, radius: 8),
              SizedBox(width: 8),
              _SkeletonBox(width: 72, height: 20, radius: 8),
            ],
          ),
          Row(
            children: const [
              _SkeletonBox(width: 40, height: 40, radius: 999),
              SizedBox(width: 4),
              _SkeletonBox(width: 40, height: 40, radius: 999),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrendingSectionSkeleton extends StatelessWidget {
  const _TrendingSectionSkeleton();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardWidth = ((screenWidth - 32) * 0.82).clamp(260.0, 330.0);
    final cardHeight = cardWidth * (200 / 310) + 110;

    return Column(
      children: [
        const SizedBox(height: 12),
        const _SectionHeaderSkeleton(),
        const SizedBox(height: 16),
        SizedBox(
          height: cardHeight,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (_, __) => _SkeletonBox(
              width: cardWidth,
              height: cardHeight,
              radius: 16,
            ),
          ),
        ),
      ],
    );
  }
}

class _NewReleaseSectionSkeleton extends StatelessWidget {
  const _NewReleaseSectionSkeleton();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardWidth = ((screenWidth - 48) * 0.42).clamp(140.0, 160.0);
    final imageHeight = cardWidth * (241.14 / 160);

    return Column(
      children: [
        const SizedBox(height: 24),
        const _SectionHeaderSkeleton(),
        const SizedBox(height: 12),
        SizedBox(
          height: imageHeight,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, __) => _SkeletonBox(
              width: cardWidth,
              height: imageHeight,
              radius: 16,
            ),
          ),
        ),
      ],
    );
  }
}

class _TopRatedSectionSkeleton extends StatelessWidget {
  const _TopRatedSectionSkeleton();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardWidth = ((screenWidth - 32) * 0.82).clamp(260.0, 330.0);
    final cardHeight = cardWidth * (185 / 350) + 76;

    return Column(
      children: [
        const SizedBox(height: 24),
        const _SectionHeaderSkeleton(),
        const SizedBox(height: 12),
        SizedBox(
          height: cardHeight,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (_, __) => _SkeletonBox(
              width: cardWidth,
              height: cardHeight,
              radius: 16,
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoriesSectionSkeleton extends StatelessWidget {
  const _CategoriesSectionSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SkeletonBox(width: 210, height: 18, radius: 8),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _SkeletonBox(width: 74, height: 36, radius: 24),
              _SkeletonBox(width: 68, height: 36, radius: 24),
              _SkeletonBox(width: 82, height: 36, radius: 24),
              _SkeletonBox(width: 78, height: 36, radius: 24),
              _SkeletonBox(width: 70, height: 36, radius: 24),
              _SkeletonBox(width: 88, height: 36, radius: 24),
              _SkeletonBox(width: 92, height: 36, radius: 24),
              _SkeletonBox(width: 96, height: 36, radius: 24),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeaderSkeleton extends StatelessWidget {
  const _SectionHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _SkeletonBox(width: 110, height: 18, radius: 8),
              SizedBox(width: 8),
              _SkeletonBox(width: 64, height: 14, radius: 8),
            ],
          ),
          _SkeletonBox(width: 84, height: 14, radius: 8),
        ],
      ),
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
