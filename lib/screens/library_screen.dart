import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Library Screen - Watch history, favorites, and playlists
class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Library'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Tabs
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                _TabButton(
                  title: 'Favorites',
                  isSelected: selectedTab == 0,
                  onTap: () => setState(() => selectedTab = 0),
                ),
                const SizedBox(width: AppSpacing.lg),
                _TabButton(
                  title: 'Watch Later',
                  isSelected: selectedTab == 1,
                  onTap: () => setState(() => selectedTab = 1),
                ),
                const SizedBox(width: AppSpacing.lg),
                _TabButton(
                  title: 'History',
                  isSelected: selectedTab == 2,
                  onTap: () => setState(() => selectedTab = 2),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: selectedTab == 0
                ? _FavoritesView()
                : selectedTab == 1
                    ? _WatchLaterView()
                    : _HistoryView(),
          ),
        ],
      ),
    );
  }
}

/// Tab button widget
class _TabButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            title,
            style: AppTypography.bodyMedium.copyWith(
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          if (isSelected) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: 40,
              height: 2,
              color: AppColors.primary,
            ),
          ]
        ],
      ),
    );
  }
}

/// Favorites view
class _FavoritesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => _LibraryItem(
        title: 'Favorite Film ${index + 1}',
        creator: 'Creator Name',
        duration: '45:30',
      ),
    );
  }
}

/// Watch Later view
class _WatchLaterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) => _LibraryItem(
        title: 'Watch Later - Film ${index + 1}',
        creator: 'Creator Name',
        duration: '${60 + index * 15}:00',
      ),
    );
  }
}

/// History view
class _HistoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (context, index) => _LibraryItem(
        title: 'Recently Watched ${index + 1}',
        creator: 'Creator Name',
        duration: '${20 + (index % 40)}:00',
        showDate: true,
      ),
    );
  }
}

/// Library item card
class _LibraryItem extends StatelessWidget {
  final String title;
  final String creator;
  final String duration;
  final bool showDate;

  const _LibraryItem({
    required this.title,
    required this.creator,
    required this.duration,
    this.showDate = false,
  });

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
          Stack(
            children: [
              Container(
                width: 100,
                height: 60,
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
              // Duration badge
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.overlay,
                    borderRadius: BorderRadius.circular(AppRadii.sm),
                  ),
                  child: Text(
                    duration,
                    style: AppTypography.labelSmall.copyWith(
                      color: Colors.white,
                      fontSize: 9,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.lg),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  creator,
                  style: AppTypography.bodySmall,
                ),
                if (showDate) ...[
                  const SizedBox(height: 2),
                  Text(
                    '2 days ago',
                    style: AppTypography.labelSmall,
                  ),
                ]
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
