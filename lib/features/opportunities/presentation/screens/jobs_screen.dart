import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/widgets/inputs/inputs.dart';
import '../../../../shared/widgets/chips/chips.dart';
import '../../../../shared/widgets/cards/cards.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});
  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedFilter = 0;
  final _filters = ['All', 'Director', 'DOP', 'Editor', 'Writer', 'Actor', 'VFX'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            floating: true,
            backgroundColor: AppColors.background,
            surfaceTintColor: Colors.transparent,
            title: Text('Opportunities', style: AppTypography.h1),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: TabBar(
                controller: _tabController,
                tabs: const [Tab(text: 'Browse'), Tab(text: 'Applied'), Tab(text: 'Saved')],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _BrowseTab(
              filters: _filters,
              selectedFilter: _selectedFilter,
              onFilterChanged: (i) => setState(() => _selectedFilter = i),
            ),
            _EmptyTab(icon: Iconsax.document, label: 'No applications yet'),
            _EmptyTab(icon: Iconsax.bookmark, label: 'No saved jobs'),
          ],
        ),
      ),
    );
  }
}

class _BrowseTab extends StatelessWidget {
  final List<String> filters;
  final int selectedFilter;
  final ValueChanged<int> onFilterChanged;

  const _BrowseTab({required this.filters, required this.selectedFilter, required this.onFilterChanged});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: const AppSearchBar(hint: 'Search jobs, roles...'),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => AppFilterChip(
                label: filters[i],
                isSelected: selectedFilter == i,
                onTap: () => onFilterChanged(i),
              ),
            ),
          ),
        ),
        // Featured
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _FeaturedJob(),
          ).animate().fadeIn(duration: 500.ms),
        ),
        // Jobs list
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList.separated(
            itemCount: 6,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _JobCard(index: i).animate().fadeIn(delay: Duration(milliseconds: 100 * i)),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}

class _FeaturedJob extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GradientCard(
      gradient: const LinearGradient(colors: [Color(0xFF1A3D2E), Color(0xFF1A1A26)]),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.successMuted, borderRadius: AppRadii.borderFull),
                child: Text('Featured', style: AppTypography.labelSmall.copyWith(color: AppColors.success)),
              ),
              const Spacer(),
              const Icon(Iconsax.bookmark, size: 20, color: AppColors.textSecondary),
            ],
          ),
          const SizedBox(height: 12),
          Text('Lead Cinematographer', style: AppTypography.h2),
          const SizedBox(height: 4),
          Text('Stellar Productions • Mumbai, IN', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            children: [
              SkillChip(label: 'Feature Film', color: AppColors.success),
              SkillChip(label: '₹8-12L/month', color: AppColors.accent),
              SkillChip(label: 'On-site', color: AppColors.info),
            ],
          ),
        ],
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  final int index;
  const _JobCard({required this.index});

  static const _titles = ['VFX Supervisor', 'Film Editor', 'Sound Designer', 'Script Supervisor', 'Color Grader', 'Production Mgr'];
  static const _companies = ['Pixar Studios', 'Netflix India', 'Dolby Labs', 'Warner Bros', 'DaVinci Post', 'Yash Raj Films'];

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: AppColors.surfaceElevated, borderRadius: AppRadii.borderMd),
            child: const Icon(Iconsax.building, size: 20, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_titles[index], style: AppTypography.labelLarge),
                const SizedBox(height: 2),
                Text(_companies[index], style: AppTypography.caption),
              ],
            ),
          ),
          const Icon(Iconsax.arrow_right_3, size: 16, color: AppColors.textTertiary),
        ],
      ),
    );
  }
}

class _EmptyTab extends StatelessWidget {
  final IconData icon;
  final String label;
  const _EmptyTab({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: AppColors.textTertiary),
          const SizedBox(height: 12),
          Text(label, style: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary)),
        ],
      ),
    );
  }
}
