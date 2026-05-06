import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Collaboration Screen - Connect with creators (YouTube-style dark theme)
class CollaborationScreen extends StatefulWidget {
  const CollaborationScreen({super.key});

  @override
  State<CollaborationScreen> createState() => _CollaborationScreenState();
}

class _CollaborationScreenState extends State<CollaborationScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Collaborations'),
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
                    hintText: 'Search creators...',
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
          // Collaborations list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _CollaboratorCard(index: index),
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

class _CollaboratorCard extends StatefulWidget {
  final int index;

  const _CollaboratorCard({required this.index});

  @override
  State<_CollaboratorCard> createState() => _CollaboratorCardState();
}

class _CollaboratorCardState extends State<_CollaboratorCard> {
  bool isFollowing = false;

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
          children: [
            // Header
            Row(
              children: [
                // Avatar
                Container(
                  width: 50,
                  height: 50,
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
                      String.fromCharCode(65 + widget.index),
                      style: AppTypography.labelLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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
                        'Creator ${widget.index + 1}',
                        style: AppTypography.bodyLarge,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Filmmaker & Visual Artist',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
                // Action button
                GestureDetector(
                  onTap: () => setState(() => isFollowing = !isFollowing),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: isFollowing
                          ? AppColors.surfaceAlt
                          : AppColors.primary,
                      borderRadius: BorderRadius.circular(AppRadii.full),
                    ),
                    child: Text(
                      isFollowing ? 'Following' : 'Follow',
                      style: AppTypography.labelSmall.copyWith(
                        color: isFollowing
                            ? AppColors.textPrimary
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            // Skills
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                'Directing',
                'Film',
                'Editing',
              ]
                  .map((skill) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceAlt,
                          borderRadius: BorderRadius.circular(AppRadii.full),
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
    );
  }
}
