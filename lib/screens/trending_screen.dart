import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Trending Screen - Popular films and content
class TrendingScreen extends StatefulWidget {
  const TrendingScreen({super.key});

  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
  final List<String> categories = [
    'Now Trending',
    'Upcoming',
    'Most Viewed',
    'Top Rated'
  ];
  int selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Trending'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          // Category filter
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    categories.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.md),
                      child: GestureDetector(
                        onTap: () => setState(() => selectedCategory = index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.md,
                          ),
                          decoration: BoxDecoration(
                            color: selectedCategory == index
                                ? AppColors.primary
                                : AppColors.surfaceAlt,
                            borderRadius: BorderRadius.circular(AppRadii.full),
                          ),
                          child: Text(
                            categories[index],
                            style: AppTypography.labelMedium.copyWith(
                              color: selectedCategory == index
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Trending content
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _TrendingCard(index: index),
              childCount: 8,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
        ],
      ),
    );
  }
}

/// Trending content card
class _TrendingCard extends StatelessWidget {
  final int index;

  const _TrendingCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          Container(
            width: 120,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(AppRadii.md),
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.3),
                  AppColors.secondary.withValues(alpha: 0.2),
                ],
              ),
            ),
            child: Center(
              child: Icon(
                Icons.play_arrow,
                color: AppColors.primary.withValues(alpha: 0.6),
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rank
                Text(
                  '#${index + 1}',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                // Title
                Text(
                  'Trending Title ${index + 1}',
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.sm),
                // Creator
                Text(
                  'Creator Name',
                  style: AppTypography.bodySmall,
                ),
                // Stats
                Row(
                  children: [
                    Icon(
                      Icons.visibility_outlined,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${125 + index * 250}K views',
                      style: AppTypography.labelSmall,
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Icon(
                      Icons.favorite_outline,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${45 + index * 100}K',
                      style: AppTypography.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Menu
          Icon(
            Icons.more_vert,
            color: AppColors.textSecondary,
            size: 20,
          ),
        ],
      ),
    );
  }
}
