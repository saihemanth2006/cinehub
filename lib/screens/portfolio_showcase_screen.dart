import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_components.dart';

/// Portfolio Showcase Screen - A beautiful gallery of user's work
class PortfolioShowcaseScreen extends StatefulWidget {
  const PortfolioShowcaseScreen({super.key});

  @override
  State<PortfolioShowcaseScreen> createState() =>
      _PortfolioShowcaseScreenState();
}

class _PortfolioShowcaseScreenState extends State<PortfolioShowcaseScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio'),
        elevation: 0,
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceHover,
                borderRadius: BorderRadius.circular(AppRadii.lg),
              ),
              child: const Icon(Icons.tune),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Header section with stats
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome text
                  Text(
                    'Your Creative Work',
                    style: AppTypography.headline2,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Showcase your best films, clips, and showreels',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  // Stats cards
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          value: '12',
                          label: 'Projects',
                          icon: Icons.movie_outlined,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: StatCard(
                          value: '48K',
                          label: 'Total Views',
                          icon: Icons.visibility_outlined,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: StatCard(
                          value: '2.1K',
                          label: 'Likes',
                          icon: Icons.thumb_up_outlined,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Filter tabs
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.lg,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    'All',
                    'Films',
                    'Clips',
                    'Showreels',
                    'Behind-the-Scenes',
                  ]
                      .map((filter) => Padding(
                            padding: const EdgeInsets.only(right: AppSpacing.md),
                            child: ProfessionalFilterChip(
                              label: filter,
                              isSelected: selectedFilter == filter,
                              onTap: () {
                                setState(() => selectedFilter = filter);
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
          // Portfolio grid
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.lg,
                mainAxisSpacing: AppSpacing.lg,
                childAspectRatio: 0.65,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => PortfolioMediaTile(
                  title: 'Project Title ${index + 1}',
                  subtitle: 'Premium Production',
                  imageUrl:
                      'https://via.placeholder.com/300x450?text=Project${index + 1}',
                  mediaType: ['FILM', 'CLIP', 'SHOWREEL', 'BTS'][index % 4],
                  views: 1200 + (index * 450),
                  onTap: () => _showMediaDetails(context, index),
                ),
                childCount: 8,
              ),
            ),
          ),
          // Upload button section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.xxxl),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                  border: Border.all(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 48,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Upload New Work',
                      style: AppTypography.headline4.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Add films, clips, or showreels to your portfolio',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.primary.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Upload'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Extra padding
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.lg),
          ),
        ],
      ),
    );
  }

  void _showMediaDetails(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppRadii.xl),
            topRight: Radius.circular(AppRadii.xl),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Media thumbnail
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadii.lg),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary.withOpacity(0.3),
                        AppColors.secondary.withOpacity(0.3),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.play_circle_outline,
                      size: 64,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Project Title ${index + 1}',
                  style: AppTypography.headline4,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Premium Production',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                // Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '1.2K',
                          style: AppTypography.headline4,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Views',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '324',
                          style: AppTypography.headline4,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Likes',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '54',
                          style: AppTypography.headline4,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Comments',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxxl),
                // Description
                Text(
                  'Description',
                  style: AppTypography.headline4,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'A compelling narrative about artistic expression and creative excellence. This project showcases technical mastery combined with compelling storytelling.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Delete'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
