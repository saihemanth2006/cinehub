import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_components.dart';

/// Professional Profile Screen - Detailed user profile with all information
class ProfessionalProfileScreen extends StatefulWidget {
  const ProfessionalProfileScreen({super.key});

  @override
  State<ProfessionalProfileScreen> createState() =>
      _ProfessionalProfileScreenState();
}

class _ProfessionalProfileScreenState extends State<ProfessionalProfileScreen>
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
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: AppColors.surface,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primaryDark.withValues(alpha: 0.7),
                      AppColors.secondary.withValues(alpha: 0.8),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -50,
                      right: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.secondary.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -30,
                      left: -50,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadii.lg),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [AppShadows.md],
                  ),
                  child: const Icon(Icons.more_vert),
                ),
              ),
            ],
          ),
          // Profile Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar and basic info (overlapping header)
                  Transform.translate(
                    offset: const Offset(0, -60),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfessionalAvatar(
                          name: 'Alex Rivera',
                          size: 100,
                          isOnline: true,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'Alex Rivera',
                          style: AppTypography.headline2,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Independent Film Director & Cinematographer',
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 18,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Los Angeles, CA',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  // Stats
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          value: '2.4K',
                          label: 'Followers',
                          icon: Icons.people_outline,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
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
                          value: '8',
                          label: 'Awards',
                          icon: Icons.star_outline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() => isFollowing = !isFollowing);
                          },
                          icon: Icon(
                            isFollowing
                                ? Icons.check_circle
                                : Icons.add_circle_outline,
                          ),
                          label: Text(isFollowing ? 'Following' : 'Follow'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isFollowing
                                ? AppColors.surfaceAlt
                                : AppColors.primary,
                            foregroundColor: isFollowing
                                ? AppColors.textPrimary
                                : Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.chat_outlined),
                          label: const Text('Message'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  // Bio
                  Text(
                    'Bio',
                    style: AppTypography.headline4,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Award-winning director with 8+ years of experience in narrative filmmaking, documentary production, and commercial work. Passionate about telling compelling stories through innovative cinematography.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  // Skills
                  Text(
                    'Skills & Expertise',
                    style: AppTypography.headline4,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.md,
                    children: [
                      'Directing',
                      'Cinematography',
                      'Color Grading',
                      'Shot Composition',
                      'Story Development',
                      'Visual Effects',
                      'Documentary',
                      'Motion Graphics',
                    ]
                        .map((skill) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                                vertical: AppSpacing.md,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius:
                                    BorderRadius.circular(AppRadii.full),
                              ),
                              child: Text(
                                skill,
                                style: AppTypography.labelMedium.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          // Tabs
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelStyle: AppTypography.labelLarge,
                tabs: const [
                  Tab(text: 'Portfolio'),
                  Tab(text: 'Awards'),
                  Tab(text: 'Experience'),
                ],
              ),
            ),
          ),
          // Tab content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Portfolio tab
                GridView.builder(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSpacing.lg,
                    mainAxisSpacing: AppSpacing.lg,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) => PortfolioMediaTile(
                    title: 'Project ${index + 1}',
                    subtitle: '2024',
                    imageUrl:
                        'https://via.placeholder.com/300x400?text=Project${index + 1}',
                    mediaType: ['FILM', 'CLIP', 'SHOWREEL'][index % 3],
                    views: 1200 + (index * 300),
                  ),
                ),
                // Awards tab
                SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      'Best Director Award',
                      'Cinematography Excellence',
                      'Innovation in Storytelling',
                      'Technical Achievement Award',
                      'Rising Director Award',
                    ]
                        .map((award) => Container(
                              margin: const EdgeInsets.only(
                                bottom: AppSpacing.lg,
                              ),
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius:
                                    BorderRadius.circular(AppRadii.lg),
                                border: Border.all(
                                  color: AppColors.border,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryLight,
                                      borderRadius: BorderRadius.circular(
                                        AppRadii.lg,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.star,
                                      color: AppColors.secondary,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.lg),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          award,
                                          style: AppTypography.headline4,
                                        ),
                                        const SizedBox(height: AppSpacing.sm),
                                        Text(
                                          '2024',
                                          style: AppTypography.bodySmall
                                              .copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
                // Experience tab
                SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      _buildExperienceItem(
                        title: 'Independent Director',
                        company: 'Self-Employed',
                        duration: '2020 - Present',
                        description:
                            'Leading creative vision on independent film projects',
                      ),
                      _buildExperienceItem(
                        title: 'Senior Cinematographer',
                        company: 'Production House LA',
                        duration: '2018 - 2020',
                        description: 'Shot 50+ commercials and music videos',
                      ),
                      _buildExperienceItem(
                        title: 'Documentary Filmmaker',
                        company: 'Independent Productions',
                        duration: '2016 - 2018',
                        description:
                            'Produced award-winning documentary series',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceItem({
    required String title,
    required String company,
    required String duration,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.headline4,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            company,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                duration,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            description,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
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

/// Delegate for sliver persistent header
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.surface,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
