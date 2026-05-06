import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_components.dart';

/// Talent Discovery Screen - Advanced search and filtering for talent
class TalentDiscoveryScreen extends StatefulWidget {
  const TalentDiscoveryScreen({super.key});

  @override
  State<TalentDiscoveryScreen> createState() => _TalentDiscoveryScreenState();
}

class _TalentDiscoveryScreenState extends State<TalentDiscoveryScreen> {
  final searchController = TextEditingController();
  String selectedSkill = 'All';
  final List<String> skills = [
    'All',
    'Director',
    'Cinematographer',
    'Editor',
    'Producer',
    'Sound Engineer',
    'Visual Effects',
    'Animator',
  ];
  final List<String> experience = ['All', '0-2 years', '2-5 years', '5+ years'];
  final List<String> locations = [
    'All',
    'Los Angeles',
    'New York',
    'London',
    'Toronto',
    'Sydney',
  ];
  String selectedExperience = 'All';
  String selectedLocation = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Talent'),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceHover,
                borderRadius: BorderRadius.circular(AppRadii.lg),
              ),
              child: const Icon(Icons.tune),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search by name, skill...',
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          // Filters
          Expanded(
            child: ListView(
              children: [
                // Skills filter
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Skill',
                        style: AppTypography.headline4,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: skills
                              .map((skill) => Padding(
                                    padding:
                                        const EdgeInsets.only(right: AppSpacing.md),
                                    child: ProfessionalFilterChip(
                                      label: skill,
                                      isSelected: skill == selectedSkill,
                                      onTap: () {
                                        setState(() => selectedSkill = skill);
                                      },
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                // Experience filter
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Experience',
                        style: AppTypography.headline4,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: experience
                              .map((exp) => Padding(
                                    padding:
                                        const EdgeInsets.only(right: AppSpacing.md),
                                    child: ProfessionalFilterChip(
                                      label: exp,
                                      isSelected: exp == selectedExperience,
                                      onTap: () {
                                        setState(
                                            () => selectedExperience = exp);
                                      },
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                // Location filter
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location',
                        style: AppTypography.headline4,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: locations
                              .map((location) => Padding(
                                    padding:
                                        const EdgeInsets.only(right: AppSpacing.md),
                                    child: ProfessionalFilterChip(
                                      label: location,
                                      isSelected: location == selectedLocation,
                                      onTap: () {
                                        setState(
                                            () => selectedLocation = location);
                                      },
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                // Advanced filters
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'More Filters',
                        style: AppTypography.headline4,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _buildFilterOption(
                        icon: Icons.star_outline,
                        title: 'Portfolio Quality',
                        value: '4+ Stars',
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _buildFilterOption(
                        icon: Icons.star_outline,
                        title: 'Awards',
                        value: 'Award Winners',
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _buildFilterOption(
                        icon: Icons.trending_up,
                        title: 'Trending',
                        value: 'Top Rated',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                // Results section
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Results (24)',
                            style: AppTypography.headline4,
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.sort),
                            label: const Text('Sort'),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                  ),
                ),
                // Talent cards
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 6,
                    itemBuilder: (context, index) => Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadii.lg),
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppShadows.elevation2,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProfessionalAvatar(
                                name: 'Talent ${index + 1}',
                                size: 64,
                              ),
                              const SizedBox(width: AppSpacing.lg),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ['Sarah Mitchell', 'James Rodriguez', 'Emma Thompson', 'Marcus Chen', 'Lisa Anderson', 'David Kumar'][index],
                                      style: AppTypography.headline4,
                                    ),
                                    const SizedBox(height: AppSpacing.sm),
                                    Text(
                                      ['Director', 'Cinematographer', 'Editor', 'Producer', 'VFX Artist', 'Sound Engineer'][index],
                                      style: AppTypography.bodyMedium.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.md),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 16,
                                          color: AppColors.secondary,
                                        ),
                                        const SizedBox(width: AppSpacing.sm),
                                        Text(
                                          '4.${8 - index}',
                                          style: AppTypography.bodySmall,
                                        ),
                                        const SizedBox(width: AppSpacing.lg),
                                        Icon(
                                          Icons.location_on_outlined,
                                          size: 16,
                                          color: AppColors.textSecondary,
                                        ),
                                        const SizedBox(width: AppSpacing.sm),
                                        Text(
                                          ['Los Angeles', 'New York', 'London', 'Toronto', 'Sydney', 'Vancouver'][index],
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
                          Wrap(
                            spacing: AppSpacing.md,
                            runSpacing: AppSpacing.md,
                            children: [
                              ['Directing', 'Cinematography'][index % 2],
                              ['Story Development', 'Color Grading'][index % 2],
                              ['Lighting', 'Editing'][index % 2],
                            ]
                                .map((skill) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppSpacing.md,
                                        vertical: AppSpacing.sm,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryLight,
                                        borderRadius: BorderRadius.circular(
                                          AppRadii.full,
                                        ),
                                      ),
                                      child: Text(
                                        skill,
                                        style: AppTypography.labelSmall
                                            .copyWith(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {},
                                  child: const Text('View Profile'),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.lg),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Invitation sent successfully!'),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.mail_outline),
                                  label: const Text('Invite'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppRadii.lg),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  value,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
