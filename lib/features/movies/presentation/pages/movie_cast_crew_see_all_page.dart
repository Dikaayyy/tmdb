import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/movie_detail_model.dart';
import '../widgets/cast_crew_see_all_card.dart';

enum MovieCastCrewCategory {
  all('Semua'),
  cast('Pemeran'),
  crew('Kru');

  const MovieCastCrewCategory(this.label);

  final String label;
}

class MovieCastCrewSeeAllPage extends StatefulWidget {
  const MovieCastCrewSeeAllPage({
    super.key,
    required this.title,
    required this.cast,
    required this.crew,
  });

  final String title;
  final List<CastModel> cast;
  final List<CrewModel> crew;

  @override
  State<MovieCastCrewSeeAllPage> createState() =>
      _MovieCastCrewSeeAllPageState();
}

class _MovieCastCrewSeeAllPageState extends State<MovieCastCrewSeeAllPage> {
  MovieCastCrewCategory _selectedCategory = MovieCastCrewCategory.all;

  @override
  Widget build(BuildContext context) {
    final cast = widget.cast.where((item) => item.name.isNotEmpty).toList();
    final crew = widget.crew.where((item) => item.name.isNotEmpty).toList();
    final castItems = cast
        .map(
          (item) => CastCrewListItem(
            name: item.name,
            role: item.character.isEmpty ? 'Pemeran' : item.character,
            imageUrl: item.fullProfileUrl,
          ),
        )
        .toList();
    final crewItems = crew
        .map(
          (item) => CastCrewListItem(
            name: item.name,
            role: item.job.isEmpty ? 'Kru' : item.job,
            imageUrl: item.fullProfileUrl,
          ),
        )
        .toList();
    final items = switch (_selectedCategory) {
      MovieCastCrewCategory.all => const <CastCrewListItem>[],
      MovieCastCrewCategory.cast => castItems,
      MovieCastCrewCategory.crew => crewItems,
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pemeran & Kru',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: AppColors.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _MovieCastCrewCategoryTabs(
              selected: _selectedCategory,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            Expanded(
              child: _selectedCategory == MovieCastCrewCategory.all
                  ? _CastCrewAllList(castItems: castItems, crewItems: crewItems)
                  : _CastCrewSingleList(
                      title: _selectedCategory.label,
                      countText: _countText(cast.length, crew.length),
                      emptyText: _emptyText,
                      items: items,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _countText(int castCount, int crewCount) {
    return switch (_selectedCategory) {
      MovieCastCrewCategory.all => '$castCount, $crewCount',
      MovieCastCrewCategory.cast => '$castCount',
      MovieCastCrewCategory.crew => '$crewCount',
    };
  }

  String get _emptyText {
    return switch (_selectedCategory) {
      MovieCastCrewCategory.all => 'Belum ada pemeran dan kru yang tersedia.',
      MovieCastCrewCategory.cast => 'Belum ada pemeran yang tersedia.',
      MovieCastCrewCategory.crew => 'Belum ada kru yang tersedia.',
    };
  }
}

class _CastCrewAllList extends StatelessWidget {
  const _CastCrewAllList({required this.castItems, required this.crewItems});

  final List<CastCrewListItem> castItems;
  final List<CastCrewListItem> crewItems;

  @override
  Widget build(BuildContext context) {
    if (castItems.isEmpty && crewItems.isEmpty) {
      return Center(
        child: Text(
          'Belum ada pemeran dan kru yang tersedia.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      children: [
        _CastCrewSectionList(
          title: 'Pemeran',
          countText: '${castItems.length}',
          emptyText: 'Belum ada pemeran yang tersedia.',
          items: castItems,
        ),
        const SizedBox(height: 24),
        _CastCrewSectionList(
          title: 'Kru',
          countText: '${crewItems.length}',
          emptyText: 'Belum ada kru yang tersedia.',
          items: crewItems,
        ),
      ],
    );
  }
}

class _CastCrewSingleList extends StatelessWidget {
  const _CastCrewSingleList({
    required this.title,
    required this.countText,
    required this.emptyText,
    required this.items,
  });

  final String title;
  final String countText;
  final String emptyText;
  final List<CastCrewListItem> items;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      children: [
        _CastCrewSectionList(
          title: title,
          countText: countText,
          emptyText: emptyText,
          items: items,
        ),
      ],
    );
  }
}

class _CastCrewSectionList extends StatelessWidget {
  const _CastCrewSectionList({
    required this.title,
    required this.countText,
    required this.emptyText,
    required this.items,
  });

  final String title;
  final String countText;
  final String emptyText;
  final List<CastCrewListItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              countText,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (items.isEmpty)
          Text(
            emptyText,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return CastCrewSeeAllCard(item: items[index]);
            },
          ),
      ],
    );
  }
}

class _MovieCastCrewCategoryTabs extends StatelessWidget {
  const _MovieCastCrewCategoryTabs({
    required this.selected,
    required this.onChanged,
  });

  final MovieCastCrewCategory selected;
  final ValueChanged<MovieCastCrewCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: MovieCastCrewCategory.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = MovieCastCrewCategory.values[index];
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
