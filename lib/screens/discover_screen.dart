import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Discover Screen - Find talent and creators (YouTube-style dark theme)
class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedSkill = 'All';
  final skills = ['All', 'Directing', 'Cinematography', 'Editing', 'Animation'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Discover Talent'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          // Search bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(AppRadii.full),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextField(
                  controller: _searchController,
                  style: AppTypography.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Search by skill...',
                    hintStyle: AppTypography.bodySmall.copyWith(
                      color: AppColors.textHint,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: AppSpacing.lg),
                      child: Icon(
                        Icons.search,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.lg,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Skill filter
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    skills.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.md),
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => selectedSkill = skills[index]),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: selectedSkill == skills[index]
                                ? AppColors.primary
                                : AppColors.surfaceAlt,
                            borderRadius: BorderRadius.circular(AppRadii.full),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(
                            skills[index],
                            style: AppTypography.labelSmall.copyWith(
                              color: selectedSkill == skills[index]
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
          // Results list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _TalentCard(index: index),
              childCount: 6,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _TalentCard extends StatelessWidget {
  final int index;

  const _TalentCard({required this.index});

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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.6),
                    AppColors.secondary.withValues(alpha: 0.6),
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + (index % 5)),
                  style: AppTypography.headline3.copyWith(
                    color: Colors.white,
                  ),
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
                    'Talent ${index + 1}',
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Professional Creator',
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  // Rating
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 14,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${4.5 + (index % 5) * 0.1}',
                        style: AppTypography.labelSmall,
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'USA',
                        style: AppTypography.labelSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Action button
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
