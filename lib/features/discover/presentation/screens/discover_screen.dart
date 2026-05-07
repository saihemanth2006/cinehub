import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/widgets/inputs/inputs.dart';
import '../../../../shared/widgets/chips/chips.dart';
import '../../../../shared/widgets/media/cached_avatar.dart';
import '../../../../shared/widgets/cards/cards.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  int _selectedFilter = 0;
  final _filters = ['All', 'Directors', 'Cinematographers', 'Writers', 'Editors', 'Actors', 'VFX Artists'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: AppColors.background,
            surfaceTintColor: Colors.transparent,
            title: Text('Discover Talent', style: AppTypography.h1),
          ),

          // ── Search ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
              child: const AppSearchBar(
                hint: 'Search creators, skills, locations...',
              ),
            ),
          ),

          // ── Filters ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, index) => AppFilterChip(
                  label: _filters[index],
                  isSelected: _selectedFilter == index,
                  onTap: () => setState(() => _selectedFilter = index),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),

          // ── Featured Creator ────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: _FeaturedCreatorCard(),
            ).animate().fadeIn(duration: 500.ms),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),

          // ── Creator Grid ────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: 8,
              itemBuilder: (context, index) => _CreatorCard(index: index)
                  .animate()
                  .fadeIn(delay: Duration(milliseconds: 100 * index), duration: 400.ms),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _FeaturedCreatorCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GradientCard(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF2D1B69), Color(0xFF1A1A26)],
      ),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Row(
        children: [
          const CachedAvatar(name: 'Sarah Chen', size: 64),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Featured Creator', style: AppTypography.overline.copyWith(color: AppColors.accent)),
                    const SizedBox(width: AppSpacing.sm),
                    const Icon(Iconsax.verify5, size: 16, color: AppColors.accent),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text('Sarah Chen', style: AppTypography.h2),
                Text('Award-winning Cinematographer', style: AppTypography.bodySmall),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    const SkillChip(label: 'Cinematography'),
                    const SizedBox(width: AppSpacing.xs),
                    const SkillChip(label: 'Color Grade', color: AppColors.accent),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CreatorCard extends StatelessWidget {
  final int index;
  const _CreatorCard({required this.index});

  static const _names = ['Alex Rivera', 'Mia Tanaka', 'James Wright', 'Priya Sharma', 'Omar Hassan', 'Luna Park', 'Dev Patel', 'Zara Kim'];
  static const _roles = ['Director', 'Editor', 'VFX Artist', 'Screenwriter', 'Cinematographer', 'Sound Design', 'Producer', 'Actor'];
  static const _ratings = ['4.9', '4.8', '4.7', '4.9', '4.6', '4.8', '4.7', '4.9'];

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          CachedAvatar(name: _names[index], size: 56),
          const SizedBox(height: AppSpacing.md),
          Text(_names[index], style: AppTypography.labelLarge, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.xxs),
          Text(_roles[index], style: AppTypography.caption),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Iconsax.star1, size: 14, color: AppColors.accent),
              const SizedBox(width: AppSpacing.xxs),
              Text(_ratings[index], style: AppTypography.labelMedium.copyWith(color: AppColors.accent)),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                side: const BorderSide(color: AppColors.border, width: 0.5),
                shape: RoundedRectangleBorder(borderRadius: AppRadii.borderMd),
              ),
              child: Text('View Profile', style: AppTypography.labelSmall.copyWith(color: AppColors.primary)),
            ),
          ),
        ],
      ),
    );
  }
}
