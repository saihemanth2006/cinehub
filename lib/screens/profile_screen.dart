import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// CineHub Profile Screen - Director/Creator Profile (YouTube-style dark theme)
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            backgroundColor: AppColors.surface,
            pinned: true,
            elevation: 0,
            title: const Text('Creator Profile'),
          ),
          // Profile Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar & Basic Info
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.secondary,
                            ],
                          ),
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'AR',
                            style: AppTypography.headline2.copyWith(
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
                              'Alex Rivera',
                              style: AppTypography.headline3,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Film Director & Cinematographer',
                              style: AppTypography.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 14,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Los Angeles, CA',
                                  style: AppTypography.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StatItem(label: 'Followers', value: '2.4K'),
                      _StatItem(label: 'Projects', value: '12'),
                      _StatItem(label: 'Awards', value: '8'),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() => isFollowing = !isFollowing);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isFollowing
                                ? AppColors.surfaceAlt
                                : AppColors.primary,
                          ),
                          child: Text(
                            isFollowing ? 'Following' : 'Follow',
                            style: AppTypography.labelMedium.copyWith(
                              color: isFollowing
                                  ? AppColors.textPrimary
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          child: Text(
                            'Message',
                            style: AppTypography.labelMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Bio
                  Text(
                    'About',
                    style: AppTypography.headline4,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Award-winning director with 8+ years of experience in narrative filmmaking, documentary production, and commercial work. Passionate about telling compelling stories through innovative cinematography.',
                    style: AppTypography.bodySmall.copyWith(
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Skills
                  Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.md,
                    children: [
                      'Directing',
                      'Cinematography',
                      'Color Grading',
                      'Editing',
                      'Motion Graphics',
                    ]
                        .map((skill) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.sm,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceAlt,
                                borderRadius:
                                    BorderRadius.circular(AppRadii.full),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Text(
                                skill,
                                style: AppTypography.labelSmall,
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          // Tabs
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.surface,
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Projects'),
                  Tab(text: 'Awards'),
                  Tab(text: 'Experience'),
                ],
              ),
            ),
          ),
          // Tab Content
          SliverToBoxAdapter(
            child: SizedBox(
              height: 300,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Projects Tab
                  ListView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    children: List.generate(
                      3,
                      (i) => _ProjectCard(index: i),
                    ),
                  ),
                  // Awards Tab
                  ListView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    children: List.generate(
                      3,
                      (i) => _AwardCard(index: i),
                    ),
                  ),
                  // Experience Tab
                  ListView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    children: List.generate(
                      2,
                      (i) => _ExperienceCard(index: i),
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTypography.headline4),
        const SizedBox(height: 4),
        Text(label, style: AppTypography.bodySmall),
      ],
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final int index;

  const _ProjectCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 50,
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Project ${index + 1}',
                  style: AppTypography.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  '2023 - Present',
                  style: AppTypography.labelSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AwardCard extends StatelessWidget {
  final int index;

  const _AwardCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.star, color: Colors.white),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Best Director Award',
                  style: AppTypography.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'International Film Festival ${2020 + index}',
                  style: AppTypography.labelSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  final int index;

  const _ExperienceCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Freelance Director ${index + 1}',
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Company Name',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '2019 - Present',
            style: AppTypography.labelSmall,
          ),
        ],
      ),
    );
  }
}
