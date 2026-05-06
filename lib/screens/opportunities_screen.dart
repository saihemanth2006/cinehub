import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Opportunities Screen - Film projects and gigs (YouTube-style dark theme)
class OpportunitiesScreen extends StatefulWidget {
  const OpportunitiesScreen({super.key});
  @override
  State<OpportunitiesScreen> createState() => _OpportunitiesScreenState();
}

class _OpportunitiesScreenState extends State<OpportunitiesScreen> {
  final Set<int> bookmarkedOpp = {};
  String selectedFilter = 'All';
  final filters = ['All', 'Directing', 'Cinematography', 'Post-Production'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Opportunities'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Icon(
              Icons.tune_outlined,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Filter chips
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    filters.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.md),
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => selectedFilter = filters[index]),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.md,
                          ),
                          decoration: BoxDecoration(
                            color: selectedFilter == filters[index]
                                ? AppColors.primary
                                : AppColors.surfaceAlt,
                            borderRadius: BorderRadius.circular(AppRadii.full),
                          ),
                          child: Text(
                            filters[index],
                            style: AppTypography.labelMedium.copyWith(
                              color: selectedFilter == filters[index]
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
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
          // Opportunities list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _OpportunityCard(
                index: index,
                isBookmarked: bookmarkedOpp.contains(index),
                onBookmarkTap: () {
                  setState(() {
                    if (bookmarkedOpp.contains(index)) {
                      bookmarkedOpp.remove(index);
                    } else {
                      bookmarkedOpp.add(index);
                    }
                  });
                },
              ),
              childCount: 8,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
        ],
      ),
    );
  }
}

class _OpportunityCard extends StatelessWidget {
  final int index;
  final bool isBookmarked;
  final VoidCallback onBookmarkTap;

  const _OpportunityCard({
    required this.index,
    required this.isBookmarked,
    required this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail
                Container(
                  width: 80,
                  height: 80,
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
                ),
                const SizedBox(width: AppSpacing.lg),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Project ${index + 1}',
                        style: AppTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Production Company',
                        style: AppTypography.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(AppRadii.full),
                        ),
                        child: Text(
                          'Open',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Bookmark button
                GestureDetector(
                  onTap: onBookmarkTap,
                  child: Icon(
                    isBookmarked
                        ? Icons.bookmark
                        : Icons.bookmark_outline,
                    color: isBookmarked ? AppColors.secondary : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            // Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _DetailItem(
                  icon: Icons.location_on_outlined,
                  label: 'Los Angeles, CA',
                ),
                _DetailItem(
                  icon: Icons.monetization_on_outlined,
                  label: '\$${5000 + index * 1000}',
                ),
                _DetailItem(
                  icon: Icons.calendar_today_outlined,
                  label: '${10 + index} days',
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            // Description
            Text(
              'Looking for a talented filmmaker to direct and edit a commercial project. Must have experience with visual storytelling.',
              style: AppTypography.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.lg),
            // Action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: Text(
                  'View Details',
                  style: AppTypography.labelMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DetailItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTypography.labelSmall,
        ),
      ],
    );
  }
}
